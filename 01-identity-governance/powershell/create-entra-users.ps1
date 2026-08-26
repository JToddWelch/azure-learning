<#
.SYNOPSIS
    Creates Microsoft Entra ID lab users with Microsoft Graph PowerShell.

.DESCRIPTION
    Creates cloud-native Microsoft Entra ID users for an Azure lab environment.

    The script:
    - Connects to Microsoft Graph
    - Checks whether each user already exists
    - Prompts securely for a temporary password
    - Requires password change at first sign-in
    - Avoids storing passwords in source code

.NOTES
    Portfolio Lab: Azure Identity & Governance
    Required Graph permission:
        User.ReadWrite.All
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$TenantDomain,

    [Parameter(Mandatory = $false)]
    [string]$TenantId
)

$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# Verify Microsoft Graph modules
# ------------------------------------------------------------

$RequiredModules = @(
    "Microsoft.Graph.Authentication",
    "Microsoft.Graph.Users"
)

foreach ($Module in $RequiredModules) {

    if (-not (Get-Module -ListAvailable -Name $Module)) {
        Write-Host "Installing $Module..." -ForegroundColor Yellow

        Install-Module `
            -Name $Module `
            -Scope CurrentUser `
            -Force `
            -AllowClobber
    }

    Import-Module $Module
}

# ------------------------------------------------------------
# Connect to Microsoft Graph
# ------------------------------------------------------------

Write-Host ""
Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan

if ($TenantId) {

    Connect-MgGraph `
        -TenantId $TenantId `
        -Scopes "User.ReadWrite.All"

}
else {

    Connect-MgGraph `
        -Scopes "User.ReadWrite.All"
}

$GraphContext = Get-MgContext

Write-Host ""
Write-Host "Connected Account : $($GraphContext.Account)" -ForegroundColor Green
Write-Host "Tenant ID         : $($GraphContext.TenantId)" -ForegroundColor Green

# ------------------------------------------------------------
# Define lab identities
# ------------------------------------------------------------

$UsersToCreate = @(

    @{
        DisplayName = "Tenant Administrator"
        Alias       = "admin"
        Purpose     = "Dedicated Microsoft Entra administration"
    },

    @{
        DisplayName = "Cloud Administrator"
        Alias       = "cloudadmin"
        Purpose     = "Azure infrastructure administration"
    },

    @{
        DisplayName = "Finance Reader"
        Alias       = "finance-reader"
        Purpose     = "Least-privilege access testing"
    }
)

# ------------------------------------------------------------
# Create users
# ------------------------------------------------------------

$Results = @()

foreach ($UserInfo in $UsersToCreate) {

    $UserPrincipalName =
        "$($UserInfo.Alias)@$TenantDomain"

    Write-Host ""
    Write-Host "Processing $UserPrincipalName..." -ForegroundColor Cyan

    # Check whether account already exists
    try {

        $ExistingUser =
            Get-MgUser `
                -UserId $UserPrincipalName `
                -ErrorAction Stop

        Write-Host "User already exists. Skipping." -ForegroundColor Yellow

        $Results += [PSCustomObject]@{
            DisplayName       = $ExistingUser.DisplayName
            UserPrincipalName = $ExistingUser.UserPrincipalName
            Status            = "Already Exists"
            Purpose           = $UserInfo.Purpose
        }

        continue
    }
    catch {
        # A lookup failure is expected when the user does not exist.
    }

    # Prompt securely for a temporary password
    $TemporaryPassword =
        Read-Host `
            "Enter temporary password for $UserPrincipalName" `
            -MaskInput

    $PasswordProfile = @{
        Password                      = $TemporaryPassword
        ForceChangePasswordNextSignIn = $true
    }

    try {

        $NewUser =
            New-MgUser `
                -AccountEnabled:$true `
                -DisplayName $UserInfo.DisplayName `
                -MailNickname $UserInfo.Alias `
                -UserPrincipalName $UserPrincipalName `
                -PasswordProfile $PasswordProfile

        Write-Host "User created successfully." -ForegroundColor Green

        $Results += [PSCustomObject]@{
            DisplayName       = $NewUser.DisplayName
            UserPrincipalName = $NewUser.UserPrincipalName
            Status            = "Created"
            Purpose           = $UserInfo.Purpose
        }
    }
    catch {

        Write-Host "Failed to create $UserPrincipalName" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red

        $Results += [PSCustomObject]@{
            DisplayName       = $UserInfo.DisplayName
            UserPrincipalName = $UserPrincipalName
            Status            = "Failed"
            Purpose           = $UserInfo.Purpose
        }
    }
}

# ------------------------------------------------------------
# Results
# ------------------------------------------------------------

Write-Host ""
Write-Host "Entra User Creation Results" -ForegroundColor Cyan
Write-Host "---------------------------" -ForegroundColor Cyan

$Results |
    Format-Table `
        DisplayName,
        UserPrincipalName,
        Status,
        Purpose `
        -AutoSize

Write-Host ""
Write-Host "Completed." -ForegroundColor Green