# Docker Deployment Configuration

This document explains how the infrastructure is configured to deploy Docker images from GitHub Container Registry (ghcr.io) instead of building the application on the server.

## Overview

The deployment system uses:
- **Docker Images**: Pre-built containers from GitHub Container Registry
- **Azure App Service**: Linux container hosting (Free F1 Plan)
- **Azure Key Vault**: Secure credential storage
- **GitHub Actions**: Automated deployment with secrets management

## Architecture

```
GitHub Container Registry (ghcr.io)
    ↓
Azure App Service (Linux Container)
    ↓
Azure Key Vault (Credentials)
```

## Configuration

### Docker Image
- **Registry**: `ghcr.io`
- **Default Image**: `ghcr.io/wolfremium13/es-timados-api:latest`
- **Tag**: Configurable via `production.tfvars`

### Environment Variables
The container receives all environment variables needed:
- Storage connection settings (retrieved from Key Vault via App Settings references)
- Application settings (ASPNETCORE_ENVIRONMENT, PORT, etc.)

### Authentication
For private repositories, the system uses:
- **Username**: GitHub username (`DOCKER_REGISTRY_SERVER_USERNAME` secret)
- **Password**: GitHub Personal Access Token (`DOCKER_REGISTRY_PASSWORD` secret)
- **Storage**: Securely stored in Azure Key Vault and referenced by the Web App configuration.

## Setup Process

### 1. Create GitHub Personal Access Token (PAT)

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Create a new token with permissions:
   - `read:packages` ✅ (required)
3. Copy the token (starts with `ghp_`)

### 2. Configure GitHub Repository Secrets

In your repository settings, add these secrets:

**DOCKER_REGISTRY_SERVER_USERNAME**
```
your-github-username
```

**DOCKER_REGISTRY_PASSWORD**
```
ghp_xxxxxxxxxxxxxxxxxxxx
```

### 3. Update Docker Image Version

Edit `infrastructure/production.tfvars` if you want to deploy a specific version:
```hcl
docker_image = "ghcr.io/wolfremium13/es-timados-api:v1.0.0"
```

### 4. Deploy via GitHub Actions

1. Go to **Actions** → **es-timados - IAC (PROD)**
2. Click **Run workflow**
3. Select **apply** and type **CONFIRM**
4. The system will automatically use the GitHub secrets for authentication during apply.

## Deployment Flow

1. **GitHub Actions** retrieves Docker registry credentials from repository secrets and sets them as environment variables during Terraform apply.
2. **Terraform** updates Azure App Service with the credentials.
3. **Azure App Service** pulls the Docker image using the stored credentials.
4. **Container** starts with all environment variables configured.
5. **Application** starts and is ready to serve requests.

## Benefits

- ✅ **No Server Build**: Images are pre-built and tested in CI pipelines.
- ✅ **Faster Deployment**: No compilation time on Azure.
- ✅ **Version Control**: Exact image versions are deployed.
- ✅ **Consistency**: Same image works locally and in production.
- ✅ **Security**: Credentials stored securely in Azure Key Vault.
- ✅ **Rollback**: Easy to revert to previous image versions.

## Troubleshooting

### Authentication Issues
- Verify GitHub PAT has correct permissions (`read:packages`).
- Check that secrets are correctly set in the GitHub repository.
- Ensure the PAT hasn't expired.

### Image Pull Issues
- Verify the image exists in the registry.
- Check image tag spelling and case sensitivity in `production.tfvars`.

### Application Issues
- Check App Service logs for container startup issues.
- Verify the Web App ports: our container runs on port `8080` (configured via `WEBSITES_PORT=8080` in App Settings).
