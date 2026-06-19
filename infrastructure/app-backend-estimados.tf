# App Service Plan for Estimados on Free tier (F1)
resource "azurerm_service_plan" "api" {
  name                = "${local.project_name}-${local.environment}-asp"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1" # Free Plan (F1)

  tags = local.tags

  # Ignore tag changes to prevent unnecessary updates
  lifecycle {
    ignore_changes = [tags]
  }
}

# App Service for Estimados API
resource "azurerm_linux_web_app" "api" {
  name                = "${local.project_name}-${local.environment}-api"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.api.id
  https_only          = true

  # VNet integration is disabled on the Free tier (F1) App Service
  # virtual_network_subnet_id is omitted

  site_config {
    application_stack {
      docker_image_name        = var.docker_image
      docker_registry_url      = "https://ghcr.io"
      docker_registry_username = var.docker_registry_username
      docker_registry_password = var.docker_registry_password
    }

    # always_on must be false on F1 (Free) tier
    always_on                         = false
    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 10 # Required when health_check_path is specified
    http2_enabled                     = true
    use_32_bit_worker                 = true # Free tier standard
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT"       = "Production"
    "PORT"                         = "8080"
    "WEBSITES_PORT"                = "8080"
    "WEBSITES_INCLUDE_CLOUD_CERTS" = "true"
    
    # Storage configuration keys mapped to Key Vault secrets (matching reference structure)
    "AZURE_STORAGE_ACCOUNT"        = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=azure-storage-account-estimados)"
    "AZURE_STORAGE_ACCESS_KEY"     = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=azure-storage-access-key-estimados)"
    "AZURE_STORAGE_CONTAINER"      = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.key_vault.name};SecretName=azure-storage-container-estimados)"
  }

  # Logging configuration
  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }

  # Identity for Key Vault access
  identity {
    type = "SystemAssigned"
  }

  tags = local.tags

  # Ignore tag changes to prevent unnecessary updates
  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [
    azurerm_key_vault_secret.storage_account_name_estimados,
    azurerm_key_vault_secret.storage_access_key_estimados,
    azurerm_key_vault_secret.storage_container_estimados
  ]
}

# Key Vault access policy for App Service
resource "azurerm_key_vault_access_policy" "app_service" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.api.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]

  depends_on = [azurerm_linux_web_app.api]
}
