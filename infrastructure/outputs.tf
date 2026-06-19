# Networking outputs
output "virtual_network_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "app_service_subnet_id" {
  description = "ID of the App Service subnet"
  value       = azurerm_subnet.app_service.id
}

# App Service outputs
output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.api.name
}

output "app_service_url" {
  description = "URL of the Estimados application"
  value       = "https://${azurerm_linux_web_app.api.default_hostname}"
}

# Key Vault outputs
output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.key_vault.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.key_vault.vault_uri
}

# Resource Group outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = data.azurerm_resource_group.rg.location
}

# Storage outputs
output "storage_account_name" {
  description = "Name of the Storage Account for uploads"
  value       = azurerm_storage_account.storage.name
}

output "storage_container_name" {
  description = "Name of the Storage Container for uploads"
  value       = azurerm_storage_container.uploads.name
}

output "storage_account_url" {
  description = "Primary blob endpoint of the Storage Account"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

# Direct Storage URL for file access
output "storage_uploads_url" {
  description = "Direct URL for accessing uploaded files via blob storage"
  value       = "https://${azurerm_storage_account.storage.primary_blob_host}/uploads/"
}

# Deployment summary
output "deployment_summary" {
  description = "Summary of the deployed infrastructure"
  value = {
    project_name      = local.project_name
    environment       = local.environment
    app_url           = "https://${azurerm_linux_web_app.api.default_hostname}"
    key_vault         = azurerm_key_vault.key_vault.name
    app_service       = azurerm_linux_web_app.api.name
    storage_account   = azurerm_storage_account.storage.name
    storage_container = azurerm_storage_container.uploads.name
  }
}
