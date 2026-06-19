# Register All Providers

This document provides instructions for registering all necessary Azure Resource Providers for your Terraform project.

## Why Register Resource Providers?
Azure Resource Providers must be registered before you can create resources in Azure. This is a one-time setup step that ensures your Terraform scripts can deploy resources without permission errors.

```bash
az provider register --namespace Microsoft.DocumentDB
az provider register --namespace Microsoft.Search
az provider register --namespace Microsoft.HealthcareApis
az provider register --namespace Microsoft.PolicyInsights
az provider register --namespace Microsoft.GuestConfiguration
az provider register --namespace Microsoft.Sql
az provider register --namespace Microsoft.DataFactory
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.BotService
az provider register --namespace Microsoft.NotificationHubs
az provider register --namespace Microsoft.AppConfiguration
az provider register --namespace Microsoft.Relay
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.AVS
az provider register --namespace Microsoft.Management
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.Automation
az provider register --namespace Microsoft.MachineLearningServices
az provider register --namespace Microsoft.Logic
az provider register --namespace Microsoft.EventGrid
az provider register --namespace Microsoft.Cache
az provider register --namespace Microsoft.ContainerInstance
az provider register --namespace Microsoft.DesktopVirtualization
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.HDInsight
az provider register --namespace Microsoft.ManagedServices
az provider register --namespace Microsoft.DataLakeStore
az provider register --namespace Microsoft.ServiceBus
az provider register --namespace Microsoft.ServiceFabric
az provider register --namespace Microsoft.Web
az provider register --namespace Microsoft.RecoveryServices
az provider register --namespace Microsoft.EventHub
az provider register --namespace Microsoft.KeyVault
az provider register --namespace Microsoft.DataProtection
az provider register --namespace Microsoft.DataLakeAnalytics
az provider register --namespace Microsoft.Maintenance
az provider register --namespace Microsoft.Devices
az provider register --namespace Microsoft.SecurityInsights
az provider register --namespace Microsoft.AppPlatform
az provider register --namespace Microsoft.Maps
az provider register --namespace Microsoft.CustomProviders
az provider register --namespace Microsoft.DataMigration
az provider register --namespace Microsoft.ApiManagement
az provider register --namespace Microsoft.DBforMariaDB
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.CognitiveServices
az provider register --namespace Microsoft.ContainerRegistry
az provider register --namespace Microsoft.DBforMySQL
az provider register --namespace Microsoft.Databricks
az provider register --namespace Microsoft.StreamAnalytics
az provider register --namespace Microsoft.DBforPostgreSQL
az provider register --namespace microsoft.insights
\az provider register --namespace Microsoft.SignalRService
az provider register --namespace Microsoft.MixedReality
az provider register --namespace Microsoft.PowerBIDedicated
az provider register --namespace Microsoft.Kusto
az provider register --namespace Microsoft.DevTestLab
az provider register --namespace Microsoft.Security
az provider register --namespace Microsoft.ManagedIdentity
```

In order to check the registration status of these providers, you can use the following command:

```bash
az provider list --query "[?registrationState=='Registered'].namespace" -o table
```
