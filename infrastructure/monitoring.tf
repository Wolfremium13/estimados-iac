# resource "azurerm_logic_app_workflow" "telegram_notifications" {
#   name                = "${local.project_name}-${local.environment}-telegram-alerts"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name

#   tags = local.tags

#   lifecycle {
#     ignore_changes = [tags]
#   }
# }

# resource "azurerm_monitor_action_group" "telegram_alerts" {
#   name                = "${local.project_name}-${local.environment}-telegram-action-group"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   short_name          = "TelegramAG"

#   logic_app_receiver {
#     name                    = "telegram-webhook"
#     resource_id             = azurerm_logic_app_workflow.telegram_notifications.id
#     callback_url            = azurerm_logic_app_trigger_http_request.telegram_webhook.callback_url
#     use_common_alert_schema = true
#   }

#   tags = local.tags

#   lifecycle {
#     ignore_changes = [tags]
#   }

#   depends_on = [azurerm_logic_app_trigger_http_request.telegram_webhook]
# }

# resource "azurerm_monitor_metric_alert" "app_service_availability" {
#   name                = "${local.project_name}-${local.environment}-app-availability-alert"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   scopes              = [azurerm_linux_web_app.api.id]
#   description         = "Alerta cuando el App Service esta con baja disponibilidad"
#   severity            = 2
#   frequency           = "PT1M"
#   window_size         = "PT5M"

#   criteria {
#     metric_namespace = "Microsoft.Web/sites"
#     metric_name      = "HealthCheckStatus"
#     aggregation      = "Average"
#     operator         = "LessThan"
#     threshold        = 1

#     dimension {
#       name     = "Instance"
#       operator = "Include"
#       values   = ["*"]
#     }
#   }

#   action {
#     action_group_id = azurerm_monitor_action_group.telegram_alerts.id
#   }

#   tags = local.tags

#   lifecycle {
#     ignore_changes = [tags]
#   }
# }

# resource "azurerm_monitor_metric_alert" "app_service_cpu" {
#   name                = "${local.project_name}-${local.environment}-app-cpu-alert"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   scopes              = [azurerm_service_plan.api.id]
#   description         = "Alerta cuando el CPU del App Service es muy alto"
#   severity            = 3
#   frequency           = "PT1M"
#   window_size         = "PT5M"

#   criteria {
#     metric_namespace = "Microsoft.Web/serverfarms"
#     metric_name      = "CpuPercentage"
#     aggregation      = "Average"
#     operator         = "GreaterThan"
#     threshold        = 90
#   }

#   action {
#     action_group_id = azurerm_monitor_action_group.telegram_alerts.id
#   }

#   tags = local.tags

#   lifecycle {
#     ignore_changes = [tags]
#   }
# }

# resource "azurerm_monitor_metric_alert" "app_service_memory" {
#   name                = "${local.project_name}-${local.environment}-app-memory-alert"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   scopes              = [azurerm_service_plan.api.id]
#   description         = "Alerta cuando la memoria del App Service es muy alta"
#   severity            = 3
#   frequency           = "PT1M"
#   window_size         = "PT5M"

#   criteria {
#     metric_namespace = "Microsoft.Web/serverfarms"
#     metric_name      = "MemoryPercentage"
#     aggregation      = "Average"
#     operator         = "GreaterThan"
#     threshold        = 90
#   }

#   action {
#     action_group_id = azurerm_monitor_action_group.telegram_alerts.id
#   }

#   tags = local.tags

#   lifecycle {
#     ignore_changes = [tags]
#   }
# }

# resource "azurerm_monitor_metric_alert" "app_service_http_errors" {
#   name                = "${local.project_name}-${local.environment}-app-http5xx-alert"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   scopes              = [azurerm_linux_web_app.api.id]
#   description         = "Alerta cuando hay muchos errores HTTP 5xx en el App Service"
#   severity            = 2
#   frequency           = "PT1M"
#   window_size         = "PT5M"

#   criteria {
#     metric_namespace = "Microsoft.Web/sites"
#     metric_name      = "Http5xx"
#     aggregation      = "Total"
#     operator         = "GreaterThan"
#     threshold        = 5
#   }

#   action {
#     action_group_id = azurerm_monitor_action_group.telegram_alerts.id
#   }

#   tags = local.tags

#   lifecycle {
#     ignore_changes = [tags]
#   }
# }

# resource "azurerm_logic_app_trigger_http_request" "telegram_webhook" {
#   name         = "telegram-webhook-trigger"
#   logic_app_id = azurerm_logic_app_workflow.telegram_notifications.id

#   schema = jsonencode({
#     type                 = "object"
#     additionalProperties = true
#   })
# }

# resource "azurerm_logic_app_action_http" "send_telegram_message" {
#   name         = "send-telegram-message"
#   logic_app_id = azurerm_logic_app_workflow.telegram_notifications.id

#   method = "POST"
#   uri    = "https://api.telegram.org/bot${var.telegram_bot_token}/sendMessage"

#   headers = {
#     "Content-Type" = "application/json"
#   }

#   body = jsonencode({
#     chat_id = var.telegram_chat_id
#     text    = "=== AZURE MONITORING ALERT ===\n\nAlert Rule: @{if(empty(triggerBody()?['data']?['essentials']?['alertRule']), 'Test Alert', triggerBody()?['data']?['essentials']?['alertRule'])}\nSeverity: @{if(empty(triggerBody()?['data']?['essentials']?['severity']), 'Test', triggerBody()?['data']?['essentials']?['severity'])}\nCondition: @{if(empty(triggerBody()?['data']?['essentials']?['monitorCondition']), 'Test', triggerBody()?['data']?['essentials']?['monitorCondition'])}\nTime: @{if(empty(triggerBody()?['data']?['essentials']?['firedDateTime']), utcNow(), triggerBody()?['data']?['essentials']?['firedDateTime'])}\nAlert ID: @{if(empty(triggerBody()?['data']?['essentials']?['alertId']), 'N/A', triggerBody()?['data']?['essentials']?['alertId'])}\n\n--- DETAILS ---\nSignal Type: @{if(empty(triggerBody()?['data']?['essentials']?['signalType']), 'N/A', triggerBody()?['data']?['essentials']?['signalType'])}\nResource: @{if(empty(triggerBody()?['data']?['essentials']?['alertTargetIDs']), 'N/A', first(triggerBody()?['data']?['essentials']?['alertTargetIDs']))}\n\nPlease review the application status immediately."
#   })

#   depends_on = [azurerm_logic_app_trigger_http_request.telegram_webhook]
# }
