output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "storage_primary_key" {
  value     = azurerm_storage_account.storage.primary_access_key
  sensitive = true
}

# output "app_url" {
#   value = "http://${azurerm_container_group.app.fqdn}:3000"
# }

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_account_key" {
  value     = azurerm_storage_account.storage.primary_access_key
  sensitive = true
}

output "container_name" {
  value = azurerm_storage_container.container.name
}