# Microsoft Entra ID Tenant Setup

## Project Overview

This lab documents the configuration of a Microsoft Entra ID environment used as the identity foundation for a broader Microsoft Azure engineering portfolio.

The project focused on moving away from dependence on a personal Microsoft account for day-to-day tenant administration and toward a more enterprise-oriented design using dedicated cloud-native administrative identities.

The lab also provided hands-on experience with Microsoft Graph PowerShell, privileged-role administration, least-privilege design, troubleshooting, and secure public documentation.

---

## Environment

The lab uses:

- Microsoft Azure
- Microsoft Entra ID
- Microsoft Graph
- Microsoft Graph PowerShell SDK
- Azure Cloud Shell
- PowerShell 7
- Git
- GitHub

The environment is maintained as a dedicated learning and engineering lab.

Sensitive identifiers such as tenant IDs, object IDs, subscription IDs, and personal account information are intentionally excluded from public documentation.

---

## Objectives

The primary objectives were to:

- Review the existing Microsoft Entra tenant
- Identify existing users and privileged identities
- Create dedicated cloud-native administrative accounts
- Separate administrative identities from normal-use identities
- Assign Microsoft Entra directory roles
- Verify directory-role assignments
- Use Microsoft Graph PowerShell for identity administration
- Apply baseline identity-security controls
- Troubleshoot authorization and role-assignment issues
- Document the resulting environment with sanitized evidence

---

## Identity Design

The lab uses separate identities for different administrative and testing purposes.

| Identity Type | Purpose |
|---|---|
| Tenant Administrator | Dedicated Microsoft Entra administration |
| Cloud Administrator | Azure infrastructure administration |
| Finance Reader | Least-privilege testing |
| App Owner | Application and service-principal testing |
| External Account | Backup administrative access |

This design supports separation of duties and provides an environment for testing both privileged and limited-access scenarios.

The dedicated Tenant Administrator identity is used for Microsoft Entra administration rather than relying exclusively on an external personal Microsoft account.

---

## Microsoft Entra Roles vs Azure RBAC

This project focuses on **Microsoft Entra directory roles**.

These roles control administrative access to Microsoft Entra ID itself.

Examples include:

- Global Administrator
- User Administrator
- Application Administrator
- Security Administrator

This is different from **Azure Role-Based Access Control (Azure RBAC)**, which controls access to Azure resources such as:

- Subscriptions
- Resource groups
- Virtual machines
- Storage accounts
- Virtual networks

Azure RBAC is addressed separately in the next portfolio project.

---

## Microsoft Graph PowerShell

Microsoft Graph PowerShell was used to administer Microsoft Entra users and directory roles.

### Connect to Microsoft Graph

A typical Graph connection for user and directory-role administration is:

```powershell
$Scopes = @(
    "User.ReadWrite.All",
    "Directory.Read.All",
    "RoleManagement.ReadWrite.Directory"
)

Connect-MgGraph -Scopes $Scopes
```

When working with a specific tenant, a tenant ID can also be provided:

```powershell
Connect-MgGraph `
    -TenantId $TenantId `
    -Scopes $Scopes
```

After connecting, the active Microsoft Graph context can be reviewed with:

```powershell
Get-MgContext
```

This helps confirm:

- Signed-in identity
- Tenant context
- Granted Graph scopes

---

## Creating Cloud-Native Users

Cloud-native Microsoft Entra identities were created for administrative and testing purposes.

The portfolio includes a reusable PowerShell script:

[`create-entra-users.ps1`](powershell/create-entra-users.ps1)

The script:

- Connects to Microsoft Graph
- Checks whether each target user already exists
- Prompts securely for a temporary password
- Requires password change at first sign-in
- Avoids storing credentials in source code
- Displays a summary of provisioning results

Example user-creation logic:

```powershell
$PasswordProfile = @{
    Password                      = $TemporaryPassword
    ForceChangePasswordNextSignIn = $true
}

New-MgUser `
    -AccountEnabled:$true `
    -DisplayName $DisplayName `
    -MailNickname $Alias `
    -UserPrincipalName $UserPrincipalName `
    -PasswordProfile $PasswordProfile
```

Temporary passwords are entered interactively rather than hard-coded into the repository.

---

## Dedicated Tenant Administrator

A cloud-native Tenant Administrator account was established for privileged Microsoft Entra administration.

The purpose of this identity is to:

- Separate administrative access from normal account use
- Reduce dependence on an external personal Microsoft account
- Provide a dedicated privileged identity for tenant management
- Support future identity-security hardening

The account was verified as a native Microsoft Entra identity and used successfully for administrative access to the tenant.

---

## Directory Role Assignment

Microsoft Graph PowerShell was used to work with Microsoft Entra directory roles.

The portfolio includes:

[`assign-directory-roles.ps1`](powershell/assign-directory-roles.ps1)

The script:

1. Resolves the target user
2. Resolves the requested directory-role definition
3. Checks whether the role is already assigned
4. Creates the assignment only when necessary

Example role-resolution logic:

```powershell
$RoleDefinition =
    Get-MgRoleManagementDirectoryRoleDefinition `
        -Filter "displayName eq '$RoleName'"
```

A directory-wide assignment can then use:

```powershell
New-MgRoleManagementDirectoryRoleAssignment `
    -PrincipalId $TargetUser.Id `
    -RoleDefinitionId $RoleDefinition.Id `
    -DirectoryScopeId "/"
```

The `/` directory scope represents tenant-wide directory scope.

---

## Role Verification

Role assignments were verified after configuration rather than assuming an assignment succeeded.

The portfolio includes:

[`verify-directory-roles.ps1`](powershell/verify-directory-roles.ps1)

The script:

- Resolves the target user
- Retrieves directory-role assignments
- Resolves role-definition IDs into readable names
- Displays the assignment scope

This provides a repeatable method for validating Microsoft Entra administrative access.

---

## Troubleshooting

Several real-world issues occurred during the project.

### Invalid GUID / Missing User Object

An early role-assignment attempt failed because the variable expected to contain the target user's object ID was not populated correctly.

The assignment operation therefore received an invalid or empty identifier.

#### Resolution

The target user was explicitly queried again before performing the role assignment.

The lesson was to validate dependent objects before passing their IDs into administrative commands.

---

### Existing Role Assignment

A later role-assignment attempt returned a conflict because the requested directory role was already assigned.

This was not a permissions failure. The desired state already existed.

#### Resolution

The automation was updated to check for an existing assignment before creating a new one.

This makes the operation more idempotent and avoids treating an already-correct configuration as an error.

---

### Insufficient Microsoft Graph Permissions

A password-profile operation initially returned an authorization error.

The active Graph session did not include the delegated permission required for that operation.

#### Resolution

The Microsoft Graph session was re-established with the required scope and the signed-in identity's administrative privileges were verified before retrying the operation.

This reinforced the distinction between:

- Microsoft Entra administrative roles
- Microsoft Graph delegated permissions

Both can affect whether an administrative operation succeeds.

---

## Security Decisions

The lab incorporates several identity-security practices.

### Dedicated Privileged Identity

A separate cloud-native account is used for Microsoft Entra administration.

### Separation of Duties

Administrative, application, finance-testing, and backup identities have separate purposes.

### Least Privilege

Limited-access identities are included so future labs can test what users can and cannot perform at different privilege levels.

### Security Defaults

Microsoft Entra Security Defaults are used as the baseline identity-security configuration for the lab.

### Secure Password Handling

Temporary passwords are requested interactively and are not stored in GitHub.

### Public Documentation Hygiene

Screenshots and documentation are sanitized before publication.

Public evidence does not intentionally expose:

- Tenant IDs
- Subscription IDs
- Object IDs
- Passwords
- Authentication tokens
- Recovery codes
- MFA QR codes
- Client secrets

---

## MFA Status

MFA registration for the dedicated privileged administrator is a planned security-hardening task.

It is **not currently documented as completed evidence** in this portfolio.

This distinction is intentional so the repository only claims security controls that have been verified and documented.

---

## Configuration Evidence

### Microsoft Entra Tenant

![Microsoft Entra tenant overview](screenshots/01-entra-tenant-overview.png)

The tenant overview demonstrates the dedicated Microsoft Entra lab environment.

---

### Lab Identities

![Microsoft Entra users](screenshots/02-entra-users.png)

The user configuration demonstrates separation between administrative, application, finance-testing, and other identities.

---

### Global Administrator Role

![Global Administrator role assignment](screenshots/03-global-admin-role.png)

The role-assignment evidence demonstrates the dedicated Tenant Administrator identity holding the required Microsoft Entra directory role.

---

### Native Administrative Session

![Native Entra administrator session](screenshots/04-native-admin-login.png)

This demonstrates successful use of the dedicated cloud-native administrative identity.

---

### Security Baseline

![Microsoft Entra Security Defaults](screenshots/06-security-defaults.png)

Security Defaults provide the baseline authentication-security configuration for the lab.

---

## PowerShell Portfolio

The Microsoft Entra work produced three reusable scripts:

| Script | Purpose |
|---|---|
| [`create-entra-users.ps1`](powershell/create-entra-users.ps1) | Creates cloud-native Entra identities |
| [`assign-directory-roles.ps1`](powershell/assign-directory-roles.ps1) | Assigns Microsoft Entra directory roles |
| [`verify-directory-roles.ps1`](powershell/verify-directory-roles.ps1) | Verifies role assignments and scopes |

These scripts are designed to demonstrate both Azure identity knowledge and practical PowerShell administration.

---

## Skills Demonstrated

This project demonstrates experience with:

- Microsoft Entra ID
- Identity provisioning
- Privileged identity administration
- Microsoft Entra directory roles
- Microsoft Graph PowerShell
- Graph delegated permissions
- PowerShell automation
- Separation of duties
- Least-privilege design
- Administrative troubleshooting
- Role-assignment verification
- Secure credential handling
- Git and GitHub
- Technical documentation

---

## Lessons Learned

Several engineering principles emerged from the project:

1. **Verify identity context before making privileged changes.**
2. **Validate object IDs before using them in automation.**
3. **Check current state before creating new assignments.**
4. **Microsoft Entra roles and Microsoft Graph permissions solve different authorization problems.**
5. **Administrative automation should be repeatable and safe to re-run.**
6. **Public technical documentation should demonstrate capability without exposing environment-sensitive data.**

---

## Next Step

With the Microsoft Entra identity foundation established, the next project moves from **directory-level authorization** to **Azure resource authorization**.

The next lab will focus on:

- Azure RBAC
- Built-in Azure roles
- Subscription scope
- Resource-group scope
- Role inheritance
- Least-privilege access
- Azure PowerShell role assignments
- Verification of effective access

[Continue to Azure RBAC](../02-rbac/)

---

[Back to Identity & Governance](README.md)  
[Back to Azure Engineering Portfolio](../README.md)
