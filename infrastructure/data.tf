data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_client_config" "current" {
  # This data source provides information about the current Azure client configuration
  # including tenant_id, subscription_id, and object_id of the authenticated principal
}
