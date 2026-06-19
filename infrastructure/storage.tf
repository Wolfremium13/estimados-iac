resource "azurerm_storage_account" "storage" {
  name                            = "eststorage${substr(md5("${local.project_name}-${local.environment}"), 0, 11)}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = true
  min_tls_version                 = "TLS1_2"

  blob_properties {
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["DELETE", "GET", "HEAD", "MERGE", "POST", "OPTIONS", "PUT"]
      allowed_origins    = ["*"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }

    delete_retention_policy {
      days = 1
    }

    versioning_enabled = false
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "blob"
}

resource "azurerm_key_vault_secret" "storage_account_name_estimados" {
  name         = "azure-storage-account-estimados"
  value        = azurerm_storage_account.storage.name
  key_vault_id = azurerm_key_vault.key_vault.id

  depends_on = [azurerm_key_vault_access_policy.current_user_access_policy]
}

resource "azurerm_key_vault_secret" "storage_access_key_estimados" {
  name         = "azure-storage-access-key-estimados"
  value        = azurerm_storage_account.storage.primary_access_key
  key_vault_id = azurerm_key_vault.key_vault.id

  depends_on = [azurerm_key_vault_access_policy.current_user_access_policy]
}

resource "azurerm_key_vault_secret" "storage_container_estimados" {
  name         = "azure-storage-container-estimados"
  value        = azurerm_storage_container.uploads.name
  key_vault_id = azurerm_key_vault.key_vault.id

  depends_on = [azurerm_key_vault_access_policy.current_user_access_policy]
}
