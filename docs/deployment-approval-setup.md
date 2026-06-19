# Manual Deployment Control for GitHub Free Accounts

This solution provides manual deployment control without requiring GitHub Team/Enterprise features, making it compatible with free GitHub accounts and private repositories.

## How It Works

Instead of using environment protection rules (which require paid plans), this workflow uses **manual workflow dispatch with input validation** to control deployments.

## Workflow Actions Available

### 1. **Plan Action** 📋
- **Purpose**: Review infrastructure changes before applying.
- **Usage**: Always run this first to see what will change.
- **Safe**: Never modifies infrastructure.

### 2. **Apply Action** 🚀  
- **Purpose**: Deploy the planned infrastructure changes.
- **Usage**: Only run after reviewing the plan.
- **Requires**: Typing "CONFIRM" exactly to proceed.

## How to Use the Workflow

### Step 1: Plan Your Changes 📋

1. **Go to Actions tab** in your GitHub repository.
2. **Select "es-timados - IAC (PROD)"** workflow.
3. **Click "Run workflow"**.
4. **Select "plan"** from the action dropdown.
5. **Click "Run workflow"** to start.

The workflow will:
- Execute `terraform plan`.
- Show you exactly what will change.
- Display a detailed summary.
- Save the plan for later use.

### Step 2: Review the Plan 👁️

After the plan completes:
- **Check the Step Summary** for changes overview.
- **Review terraform plan output** to understand impacts.
- **Verify** the changes match your expectations.

### Step 3: Apply Changes (If Approved) 🚀

If you're satisfied with the plan:

1. **Go to Actions tab** again.
2. **Select "es-timados - IAC (PROD)"** workflow.
3. **Click "Run workflow"**.
4. **Select "apply"** from the action dropdown.
5. **Type "CONFIRM"** exactly in the confirmation field.
6. **Click "Run workflow"** to deploy.

## How the Enhanced Workflow Works

### Workflow Flow:

1. **Manual Trigger**: User selects action (plan or apply) via GitHub UI.
2. **Plan Job**: Always runs for both actions.
   - Executes `terraform plan`.
   - Shows detailed summary.
   - Saves plan for application.
3. **Validation Job**: Only for apply actions.
   - Validates confirmation text.
   - Prevents accidental deployments.
4. **Apply Job**: Only after successful validation.
   - Executes `terraform apply`.
   - Reports deployment status.

## Example Workflow Run

### Planning Phase:
```
1. User selects "plan" → Workflow shows planned changes
2. User reviews output → Decides if changes are correct
```

### Deployment Phase:
```
1. User selects "apply" + types "CONFIRM"
2. Workflow validates confirmation
3. Terraform apply executes
4. Deployment completes with status report
```

## Error Scenarios

### ❌ Wrong Confirmation Text
- **Input**: Anything other than `CONFIRM`
- **Result**: Workflow stops with a clear error message.
- **Action**: Re-run with the correct confirmation.

### ❌ No Changes to Apply
- **Scenario**: Running apply when plan shows no changes.
- **Result**: Apply job is skipped automatically.
- **Message**: "No changes detected - infrastructure is up to date."
