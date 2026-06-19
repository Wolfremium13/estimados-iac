# Telegram Monitoring Alerts Configuration

This document explains how to configure monitoring alerts to receive Telegram notifications when the Estimados App Service experiences health or resource issues.

## Prerequisites

### 1. Create a Telegram Bot

1. Open Telegram and search for `@BotFather`.
2. Send the command `/newbot`.
3. Follow the instructions to name your bot.
4. Save the **bot token** provided by BotFather.

### 2. Get the Chat/Group ID

#### Method 1: Using getUpdates API (Recommended)

**For a private group:**
1. Add your bot to the private group.
2. Make the bot an admin (temporarily) or ensure it can read messages.
3. Send any message in the group (the bot needs to "see" a message).
4. Go to `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
5. Look for the `chat.id` in the JSON response (will be negative for groups).

**For a private chat:**
1. Send a message to your bot directly.
2. Go to `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
3. Look for the `chat.id` in the JSON response (will be positive for private chats).

#### Method 2: Using @RawDataBot

1. Add @RawDataBot to your group temporarily.
2. Send any message in the group.
3. @RawDataBot will reply with the raw data including the chat ID.
4. Remove @RawDataBot after getting the ID.

## Variable Configuration

The Telegram variables are configured as GitHub secrets for security. You need to add the following secrets to your GitHub repository:

### GitHub Secrets Setup

1. Go to your GitHub repository.
2. Navigate to **Settings** → **Secrets and variables** → **Actions**.
3. Add the following repository secrets:

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `TELEGRAM_BOT_TOKEN` | Bot token from BotFather | `1234567890:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX` |
| `TELEGRAM_CHAT_ID` | Chat/Group ID where alerts will be sent | `-1001234567890` (negative for groups) |

## Configured Alert Types

### App Service (Estimados API)
- **Availability**: Triggers when the health check (`/health`) fails.
- **High CPU**: Triggers when CPU exceeds 90%.
- **High Memory**: Triggers when memory exceeds 90%.
- **HTTP 5xx Errors**: Triggers when there are more than 5 5xx errors in 5 minutes.

## Notification Format

The notifications you'll receive in Telegram will look like this:

```
=== AZURE MONITORING ALERT ===

Alert Rule: [alert-rule-name]
Severity: [1-4]
Condition: [Fired/Resolved]
Time: [timestamp]
Alert ID: [alert-id]

--- DETAILS ---
Signal Type: Metric
Resource: [App-Service-ID]

Please review the application status immediately.
```

## Applying Changes

To deploy the alert rules:

1. **Add the GitHub secrets** as described in the Variable Configuration section.
2. **Run the GitHub Actions workflow**:
   - Go to **Actions** → **es-timados - IAC (PROD)**.
   - Click **Run workflow**.
   - Select **plan** to review changes first.
   - Select **apply** and type **CONFIRM** to deploy.

The Telegram configuration will be automatically injected as environment variables during the Terraform execution.

## Customization

You can modify alert thresholds by editing the `threshold` values in the `monitoring.tf` file:

- **CPU**: Currently configured at 90%
- **Memory**: Currently configured at 90%
- **HTTP Errors**: Currently configured at 5 errors in 5 minutes
