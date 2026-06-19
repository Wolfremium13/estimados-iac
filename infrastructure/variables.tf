variable "tenant_id" {
  description = "The value of the current tenant."
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "The value of the current subscription that changes depending on the environment of Azure."
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources. Changing this forces a new resource to be created."
  type        = string
}

variable "docker_image" {
  description = "The Docker image to deploy (e.g., ghcr.io/wolfremium13/es-timados-api:latest)"
  type        = string
  default     = "ghcr.io/wolfremium13/es-timados-api:latest"
}

variable "docker_registry_username" {
  description = "Username for Docker registry authentication"
  type        = string
  sensitive   = true
  default     = ""
}

variable "docker_registry_password" {
  description = "Password/Token for Docker registry authentication (GitHub PAT for ghcr.io)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "telegram_bot_token" {
  description = "Token del bot de Telegram para enviar notificaciones"
  type        = string
  sensitive   = true
}

variable "telegram_chat_id" {
  description = "ID del chat/grupo de Telegram donde enviar las alertas"
  type        = string
  sensitive   = true
}
