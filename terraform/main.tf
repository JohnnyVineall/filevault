# 1. Terraform and azure config
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# 2. Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Terraform Getting Started"
    Team        = "DevOps"
  }
}

# 3. Virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "FilevaultJohnnyVNet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 4.1 Storage account
resource "azurerm_storage_account" "storage" {
  name                     = "filevaultjohnnystorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# 4.2 Storage container
resource "azurerm_storage_container" "container" {
  name                  = "uploads"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# 5. Container registry
resource "azurerm_container_registry" "acr" {
  name                = "filevaultjohnnytf"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Local deployment automation stuff
resource "null_resource" "docker_push" {
  depends_on = [azurerm_container_registry.acr]

  triggers = {
    image_tag = "v1.0.2" 
  }

  provisioner "local-exec" {
    # Move up one level from 'terraform' folder, then into 'src/azure-sa'
    working_dir = "${path.module}/../src/azure-sa" 

    command = <<EOT
      az acr login --name ${azurerm_container_registry.acr.name}
      docker build --platform linux/amd64 -t ${azurerm_container_registry.acr.login_server}/filevault-app:${self.triggers.image_tag} .
      docker push ${azurerm_container_registry.acr.login_server}/filevault-app:${self.triggers.image_tag}
    EOT
  }
}

# 6. Container instance (app)
# resource "azurerm_container_group" "app" {
#   name                = "filevault-app-johnny"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   ip_address_type     = "Public"
#   dns_name_label      = "filevault-app-johnny"
#   os_type             = "Linux"

#   depends_on = [null_resource.docker_push, azurerm_storage_container.container]

#   container {
#     name   = "filevault-app-johnny"
#     image  = "${azurerm_container_registry.acr.login_server}/filevault-app:${null_resource.docker_push.triggers.image_tag}"
#     cpu    = "1"
#     memory = "1.5"

#     ports {
#       port     = 3000
#       protocol = "TCP"
#     }

#     secure_environment_variables = {
#       "AZURE_STORAGE_ACCOUNT_NAME" = azurerm_storage_account.storage.name
#       "AZURE_STORAGE_ACCOUNT_KEY"  = azurerm_storage_account.storage.primary_access_key
#       "AZURE_STORAGE_CONTAINER_NAME" = azurerm_storage_container.container.name
#     }

#   }
#   image_registry_credential {
#     server   = azurerm_container_registry.acr.login_server
#     username = azurerm_container_registry.acr.admin_username
#     password = azurerm_container_registry.acr.admin_password
#   }
# }