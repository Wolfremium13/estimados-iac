# App Service Plan for Estimados on Basic tier (B1)
resource "azurerm_service_plan" "api" {
  name                = "${local.project_name}-${local.environment}-asp"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = local.location
  os_type             = "Linux"
  sku_name            = "B1" # Basic Plan (B1)

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
  location            = local.location
  service_plan_id     = azurerm_service_plan.api.id
  https_only          = true

  # VNet integration is supported on B1 but not configured here
  # virtual_network_subnet_id is omitted

  site_config {
    application_stack {
      docker_image_name   = var.docker_image
      docker_registry_url = "https://ghcr.io"
    }

    # always_on is enabled on Basic tier (B1)
    always_on                         = true
    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 10 # Required when health_check_path is specified
    http2_enabled                     = true
    use_32_bit_worker                 = false # Basic tier supports 64-bit workers
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT"       = "Production"
    "PORT"                         = "8080"
    "WEBSITES_PORT"                = "8080"
    "WEBSITES_INCLUDE_CLOUD_CERTS" = "true"
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
}
