<#
.SYNOPSIS
    Verifies Microsoft Entra directory-role assignments for a user.

.DESCRIPTION
    Uses Microsoft Graph PowerShell to retrieve and display the
    Microsoft Entra directory roles assigned to a specified user.

    The script:
    - Connects to Microsoft Graph
    - Resolves the target Entra user
    - Retrieves directory-role assignments
    - Resolves role-definition IDs into readable role names
    - Displays role name and assignment scope

.NOTES
    Portfolio Lab: Azure Identity & Governance

    Required Microsoft Graph permissions:
        Directory.Read.All
        RoleManagement.Read.Directory
#>

[CmdletBinding()]
param (

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$UserPrincipalName,

    [Parameter(Mandatory = $false)]
    [string]$TenantId
)

$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# Verify Microsoft Graph modules
# ------------------------------------------------------------

$RequiredModules = @(
    "Microsoft.Graph.Authentication",
    "Microsoft.Graph.Users",
    "Microsoft.Graph.Identity.Governance"
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

$Scopes = @(
    "Directory.Read.All",
    "RoleManagement.Read.Directory"
)

if ($TenantId) {

    Connect-MgGraph `
        -TenantId $TenantId `
        -Scopes $Scopes
}
else {

    Connect-MgGraph `
        -Scopes $Scopes
}

$GraphContext = Get-MgContext

Write-Host ""
Write-Host "Connected Account : $($GraphContext.Account)" -ForegroundColor Green
Write-Host "Tenant ID         : $($GraphContext.TenantId)" -ForegroundColor Green

# ------------------------------------------------------------
# Resolve target user
# ------------------------------------------------------------

Write-Host ""
Write-Host "Resolving user: $UserPrincipalName" -ForegroundColor Cyan

try {

    $TargetUser =
        Get-MgUser `
            -UserId $UserPrincipalName `
            -ErrorAction Stop
}
catch {

    Write-Error "Unable to locate user: $UserPrincipalName"
    exit 1
}

Write-Host "User found: $($TargetUser.DisplayName)" -ForegroundColor Green

# ------------------------------------------------------------
# Retrieve role assignments
# ------------------------------------------------------------

Write-Host ""
Write-Host "Retrieving directory-role assignments..." -ForegroundColor Cyan

$Assignments =
    Get-MgRoleManagementDirectoryRoleAssignment -All |
        Where-Object {
            $_.PrincipalId -eq $TargetUser.Id
        }

if (-not $Assignments) {

    Write-Host ""
    Write-Host "No Microsoft Entra directory roles are assigned to this user." `
        -ForegroundColor Yellow

    exit 0
}

# ------------------------------------------------------------
# Resolve role names
# ------------------------------------------------------------

$Results = foreach ($Assignment in $Assignments) {

    try {

        $RoleDefinition =
            Get-MgRoleManagementDirectoryRoleDefinition `
                -UnifiedRoleDefinitionId $Assignment.RoleDefinitionId

        [PSCustomObject]@{
            DisplayName       = $TargetUser.DisplayName
            UserPrincipalName = $TargetUser.UserPrincipalName
            Role              = $RoleDefinition.DisplayName
            Scope             = $Assignment.DirectoryScopeId
            AssignmentId      = $Assignment.Id
        }
    }
    catch {

        [PSCustomObject]@{
            DisplayName       = $TargetUser.DisplayName
            UserPrincipalName = $TargetUser.UserPrincipalName
            Role              = "Unable to resolve role"
            Scope             = $Assignment.DirectoryScopeId
            AssignmentId      = $Assignment.Id
        }
    }
}

# ------------------------------------------------------------
# Results
# ------------------------------------------------------------

Write-Host ""
Write-Host "Microsoft Entra Directory Roles" -ForegroundColor Cyan
Write-Host "-------------------------------" -ForegroundColor Cyan

$Results |
    Sort-Object Role |
    Format-Table `
        DisplayName,
        UserPrincipalName,
        Role,
        Scope `
        -AutoSize

Write-Host ""
Write-Host "Verification complete." -ForegroundColor Green