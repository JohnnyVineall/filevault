# Configure the Azure provider
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

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Terraform Getting Started"
    Team        = "DevOps"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "FilevaultJohnnyVNet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_storage_account" "storage" {
  name                     = "filevaultjohnnystorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "uploads"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_container_group" "app" {
  name                = "filevault-app-johnny"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  dns_name_label      = "filevault-app-johnny"
  os_type             = "Linux"

  container {
    name   = "filevault-app-johnny"
    image  = "filevaultjohnnytf.azurecr.io/filevault-app:v1"
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }

    secure_environment_variables = {
      "AZURE_STORAGE_ACCOUNT_NAME" = azurerm_storage_account.storage.name
      "AZURE_STORAGE_ACCOUNT_KEY"  = azurerm_storage_account.storage.primary_access_key
    }

  }
  image_registry_credential {
    server   = "filevaultjohnnytf.azurecr.io"
    username = "filevaultjohnnytf"
    password = var.acr_password
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "filevaultjohnnytf"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}