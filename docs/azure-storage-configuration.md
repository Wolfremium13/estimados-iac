# Azure Storage Configuration for Estimados

This document explains how Azure Blob Storage is configured for the Estimados application in the IAC project.

## Overview

The infrastructure automatically provisions and configures Azure Blob Storage to handle storage needs. This setup provides a scalable, secure, and cost-effective solution for storing and serving files.

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  Estimados App  │───▶│   Azure Key      │───▶│  Azure Storage  │
│  (App Service)  │    │   Vault          │    │   Account       │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │                          │
                                ▼                          ▼
                       ┌──────────────┐           ┌─────────────┐
                       │  Credentials │           │   Uploads   │
                       │   Storage    │           │  Container  │
                       └──────────────┘           └─────────────┘
```

## Configuration Details

### Storage Account

| Property | Value | Description |
|----------|-------|-------------|
| **Name** | `eststorage{hash}` | Auto-generated name with unique hash suffix (max 24 chars) |
| **Location** | East US | Same region as other resources |
| **Performance Tier** | Standard | Cost-effective for most workloads |
| **Replication** | LRS (Locally Redundant) | Basic redundancy within datacenter |
| **Access Tier** | Hot | Optimized for frequent access |
| **Public Access** | Enabled | Allows direct URL access to uploaded files |
| **Minimum TLS** | 1.2 | Enhanced security |

### Blob Container

| Property | Value | Description |
|----------|-------|-------------|
| **Name** | `uploads` | Container for file storage |
| **Access Level** | Blob | Public read access to individual blobs |
| **Versioning** | Disabled | Simplified storage management |
| **Soft Delete** | 1 day retention | Brief recovery window for deleted files |

### CORS Configuration

| Setting | Value | Purpose |
|---------|-------|---------|
| **Allowed Origins** | `*` | Allow access from any origin |
| **Allowed Methods** | `GET, POST, PUT, DELETE, HEAD, OPTIONS, MERGE` | Full CRUD operations |
| **Allowed Headers** | `*` | All headers permitted |
| **Exposed Headers** | `*` | All response headers accessible |
| **Max Age** | 3600 seconds | Cache preflight requests for 1 hour |

## Security Configuration

### Key Vault Integration

The following secrets are automatically stored in Azure Key Vault:

| Secret Name | Description | Usage |
|-------------|-------------|-------|
| `azure-storage-account-estimados` | Storage account name | Application connection configuration |
| `azure-storage-access-key-estimados` | Primary access key | Authentication for storage operations |
| `azure-storage-container-estimados` | Container name (`uploads`) | Specifies storage container |

### Access Control

- **Managed Identity**: App Service uses system-assigned managed identity to access Key Vault.
- **Access Policy**: Restricted to GET/LIST permissions for secrets only.
- **Network Security**: Storage account allows public access for blob URLs.
- **Authentication**: Access keys secured in Key Vault, not exposed in application code.

## Application Integration

The infrastructure makes these secrets available via Key Vault references. In the application settings, you can read them as environment variables or using standard configuration providers.

### File Access URLs

Uploaded files are accessible via direct URLs:

```
https://{storage-account-name}.blob.core.windows.net/uploads/{file-path}
```

Example:
```
https://eststorage1a2b3c4d.blob.core.windows.net/uploads/some-file.pdf
```

## Cost Info

- **Storage Capacity**: Standard Hot tier storage is extremely cost-effective.
- **Key Vault operations**: Accessing secrets has negligible cost (less than $0.03 per 10K operations).
- **Soft Delete**: Minimal cost for 1-day retention of deleted blobs.
