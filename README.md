# Identity & Governance

This section documents hands-on Microsoft Entra ID identity and governance work performed in a dedicated Azure lab environment.

The goal is to demonstrate practical administration skills including user provisioning, privileged-role management, least-privilege design, Microsoft Graph PowerShell, authentication security, and identity troubleshooting.

## Current Lab

### Microsoft Entra ID Tenant Setup

The first project establishes the identity foundation for the Azure lab.

Work completed includes:

- Reviewed the existing Microsoft Entra tenant
- Created cloud-native Entra identities
- Established a dedicated tenant administrator
- Assigned and verified Microsoft Entra directory roles
- Separated administrative and normal identities
- Used Microsoft Graph PowerShell for identity administration
- Troubleshot Graph authorization and role-assignment issues
- Prepared privileged identities for MFA and additional security controls

[View the full Entra ID setup case study](entra-id-setup.md)

## PowerShell Automation

Reusable PowerShell scripts developed during this project:

### Create Entra Users

[`create-entra-users.ps1`](powershell/create-entra-users.ps1)

Creates cloud-native Microsoft Entra users while checking for existing accounts and requiring secure temporary-password handling.

### Assign Directory Roles

[`assign-directory-roles.ps1`](powershell/assign-directory-roles.ps1)

Assigns Microsoft Entra directory roles to users while checking for existing assignments.

### Verify Directory Roles

[`verify-directory-roles.ps1`](powershell/verify-directory-roles.ps1)

Retrieves and validates Microsoft Entra directory-role assignments and resolves role IDs into readable role names.

## Identity Design

The lab separates identities based on administrative purpose.

| Identity Type | Purpose |
|---|---|
| Tenant Administrator | Dedicated Microsoft Entra administration |
| Cloud Administrator | Azure infrastructure administration |
| Finance Reader | Least-privilege testing |
| App Owner | Application and service-principal testing |
| External Account | Backup administrative access |

This structure is intended to support least privilege and separation of duties.

## Technologies

- Microsoft Azure
- Microsoft Entra ID
- Microsoft Graph
- Microsoft Graph PowerShell SDK
- Azure Cloud Shell
- PowerShell 7
- Git
- GitHub

## Security Practices

The lab incorporates:

- Dedicated privileged identities
- Separation of administrative and everyday accounts
- Least-privilege testing
- MFA for privileged accounts
- Role verification before privilege changes
- Sanitized public documentation
- No credentials or secrets stored in source code

## Screenshots

Supporting screenshots are stored in:

```text
screenshots/