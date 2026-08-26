<#
.SYNOPSIS
    Assigns a Microsoft Entra directory role to a user.

.DESCRIPTION
    Uses Microsoft Graph PowerShell to assign an Entra directory role
    such as Global Administrator to a cloud identity.

    The script:
    - Connects to Microsoft Graph
    - Resolves the target user
    - Resolves the directory role definition
    - Checks whether the role is already assigned
    - Creates the assignment only when needed

.NOTES
    Portfolio Lab: Azure Identity & Governance

    Required Microsoft Graph permissions:
        Directory.Read.All
        RoleManagement.ReadWrite.Directory

    The authenticated account must also hold an Entra role that permits
    directory-role administration.
#>

[CmdletBinding()]
param (

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$UserPrincipalName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$RoleName,

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
    "RoleManagement.ReadWrite.Directory"
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
# Resolve directory role
# ------------------------------------------------------------

Write-Host ""
Write-Host "Resolving directory role: $RoleName" -ForegroundColor Cyan

$RoleDefinition =
    Get-MgRoleManagementDirectoryRoleDefinition `
        -Filter "displayName eq '$RoleName'"

if (-not $RoleDefinition) {

    Write-Error "Directory role not found: $RoleName"
    exit 1
}

Write-Host "Role found: $($RoleDefinition.DisplayName)" -ForegroundColor Green

# ------------------------------------------------------------
# Check existing assignments
# ------------------------------------------------------------

$ExistingAssignment =
    Get-MgRoleManagementDirectoryRoleAssignment -All |
        Where-Object {
            $_.PrincipalId -eq $TargetUser.Id -and
            $_.RoleDefinitionId -eq $RoleDefinition.Id -and
            $_.DirectoryScopeId -eq "/"
        }

if ($ExistingAssignment) {

    Write-Host ""
    Write-Host "Role is already assigned. No changes required." `
        -ForegroundColor Yellow

    [PSCustomObject]@{
        User  = $TargetUser.UserPrincipalName
        Role  = $RoleDefinition.DisplayName
        Scope = "/"
        Status = "Already Assigned"
    }

    exit 0
}

# ------------------------------------------------------------
# Assign role
# ------------------------------------------------------------

Write-Host ""
Write-Host "Assigning role..." -ForegroundColor Cyan

try {

    New-MgRoleManagementDirectoryRoleAssignment `
        -PrincipalId $TargetUser.Id `
        -RoleDefinitionId $RoleDefinition.Id `
        -DirectoryScopeId "/"

    Write-Host "Role assigned successfully." -ForegroundColor Green

}
catch {

    Write-Host "Role assignment failed." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# ------------------------------------------------------------
# Result
# ------------------------------------------------------------

Write-Host ""

[PSCustomObject]@{
    User   = $TargetUser.UserPrincipalName
    Role   = $RoleDefinition.DisplayName
    Scope  = "/"
    Status = "Assigned"
} | Format-Table -AutoSize