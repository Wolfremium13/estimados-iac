locals {
  environment  = "production"
  project_name = "es-timados"
  tags = {
    "Project"        = "Estimados"
    "Environment"    = "Production"
    "Implementation" = "IAC"
    "Creation Date"  = formatdate("YYYY-MM-DD", timestamp())
  }
}
