# Estimados IAC (Infrastructure as Code)

This repository contains the Terraform configuration and GitHub Actions workflows for deploying the **Estimados** API infrastructure on Microsoft Azure.

## Requirements

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://www.terraform.io/downloads.html)

## Deployment

- Read the detailed manual deployment control documentation [here](./docs/deployment-approval-setup.md).

## Architecture & Components

The infrastructure consists of:
- **Azure App Service (Linux)**: Hosts the ASP.NET Core API using a pre-built Docker image.
- **Azure Key Vault**: Securely manages secrets (such as storage credentials) and injects them safely.
- **Azure Storage Account**: Dedicated storage account and blob container (`uploads`) for storage needs.
- **Telegram Monitoring Alerts**: Alerts configured via Logic Apps to notify a Telegram chat about App Service CPU/Memory limits, availability, or HTTP 5xx errors.

Detailed configuration guides:
- 📖 **[Docker Deployment Guide](./docs/docker-deployment.md)** - Details on configuring private container registry access and image versions.
- 📁 **[Azure Storage Configuration](./docs/azure-storage-configuration.md)** - Details on how storage and Key Vault integration is set up.
- 🔔 **[Telegram Monitoring Alerts](./docs/telegram-monitoring-setup.md)** - Guide to creating a bot and obtaining Chat IDs for alert delivery.

---

## Setup on Azure Before Running

Follow these steps to prepare your Azure environment for Terraform state storage and authentication:

1. **Log in to Azure CLI:**
   ```bash
   az login
   ```

2. **Create the Resource Group:**
   ```bash
   az group create --name es-timados-rg --location northeurope
   ```

3. **Create the Storage Account for Terraform State:**
   ```bash
   az storage account create --name estimadosiac --resource-group es-timados-rg --location northeurope --sku Standard_LRS
   ```

4. **Create the Blob Container for the State File:**
   ```bash
   az storage container create --name tfstate --account-name estimadosiac
   ```

5. **Create a Service Principal for GitHub Actions:**
   Run the following command (replace `<subscription-id>` with your Azure subscription ID):
   ```bash
   az ad sp create-for-rbac --name "es-timados-sp" --role Contributor --scopes /subscriptions/feaebcc1-54dd-45e9-a65d-e07fd2aabdbf/resourceGroups/es-timados-rg --sdk-auth
   ```
   > **Note:** Save the JSON output from this command. It is used to authenticate GitHub Actions to Azure.

---

## Setup on GitHub Before Running

1. Create a new GitHub repository or use the current one.
2. In your GitHub repository, navigate to **Settings** → **Secrets and variables** → **Actions**.
3. Create the following **Repository Secrets**:

| Secret Name | Description | Example/Format |
|-------------|-------------|----------------|
| `AZURE_CREDENTIALS` | The JSON output from the service principal creation step. | `{"clientId": "...", "clientSecret": "...", ...}` |
| `TELEGRAM_BOT_TOKEN` | Bot token provided by `@BotFather`. | `1234567890:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX` |
| `TELEGRAM_CHAT_ID` | Telegram chat or group ID where alerts will be delivered. | `-1001234567890` (negative for groups) |

---

## Troubleshooting

### Terraform State Lock Error
If a previous workflow run fails or is cancelled abruptly, you may see:
```
Error: Error acquiring the state lock
Error message: state blob is already locked
```
- **Option 1 (Recommended):** Wait 15-20 minutes for the lease to automatically expire on Azure storage.
- **Option 2:** Force unlock by running `terraform force-unlock <Lock-ID>` from an authenticated local environment.

### Azure Resource Provider Registration Error
If Terraform fails with a `403` error trying to register resource providers:
```
authorization failed: registering resource provider "Microsoft.KeyVault": unexpected status 403
```
- The project has resource provider registration disabled automatically (`resource_provider_registrations = "none"` in `provider.tf`).
- You can register providers manually using an admin account:
  ```bash
  az provider register --namespace Microsoft.KeyVault
  ```
  Check the registration guide: [Register All Providers](./docs/register-all-providers.md).
