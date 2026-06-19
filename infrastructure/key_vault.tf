resource "azurerm_key_vault" "key_vault" {
  name                            = "kv-${local.project_name}"
  resource_group_name             = var.resource_group_name
  location                        = data.azurerm_resource_group.rg.location
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  sku_name                        = "standard"
  tenant_id                       = data.azurerm_client_config.current.tenant_id

  tags = local.tags

  lifecycle {
    ignore_changes = [tags["Creation Date"]]
  }
}

resource "azurerm_key_vault_access_policy" "current_user_access_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge", "Backup", "Recover", "Restore"
  ]
}
