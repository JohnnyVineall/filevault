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