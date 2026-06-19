locals {
  environment  = "production"
  project_name = "es-timados"
  location     = var.location != null ? var.location : data.azurerm_resource_group.rg.location
  tags = {
    "Project"        = "Estimados"
    "Environment"    = "Production"
    "Implementation" = "IAC"
    "Creation Date"  = formatdate("YYYY-MM-DD", timestamp())
  }
}
