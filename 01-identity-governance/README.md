# Identity & Governance

This project documents hands-on Microsoft Entra ID identity and governance work performed in a dedicated Azure lab environment.

The goal is to demonstrate practical administration skills including user provisioning, privileged-role management, least-privilege design, Microsoft Graph PowerShell, authentication security, and identity troubleshooting.

---

## Project Overview

The lab establishes the identity foundation for the broader Azure engineering environment.

Key objectives include:

- Review and organize Microsoft Entra identities
- Create cloud-native administrative accounts
- Separate privileged and standard identities
- Assign and verify Microsoft Entra directory roles
- Use Microsoft Graph PowerShell for identity administration
- Apply baseline identity security controls
- Troubleshoot role and authorization issues
- Document the environment with sanitized evidence

---

## Work Completed

- Reviewed the existing Microsoft Entra tenant
- Created cloud-native Entra identities
- Established a dedicated Tenant Administrator account
- Separated administrative and testing identities
- Assigned and verified Microsoft Entra directory roles
- Used Microsoft Graph PowerShell for user and role administration
- Created reusable PowerShell automation
- Implemented Microsoft Entra Security Defaults
- Documented troubleshooting and permission issues
- Created sanitized screenshots for public GitHub documentation

MFA registration for the dedicated privileged administrator remains a planned security-hardening task.

---

## Identity Design

The lab separates identities according to administrative purpose.

| Identity Type | Purpose |
|---|---|
| Tenant Administrator | Dedicated Microsoft Entra administration |
| Cloud Administrator | Azure infrastructure administration |
| Finance Reader | Least-privilege access testing |
| App Owner | Application and service-principal testing |
| External Account | Backup administrative access |

This structure supports separation of duties and provides a practical environment for testing least-privilege access.

---

## PowerShell Automation

Reusable PowerShell scripts were developed as part of the project.

### Create Entra Users

[`create-entra-users.ps1`](powershell/create-entra-users.ps1)

Creates cloud-native Microsoft Entra users while:

- Checking whether each account already exists
- Prompting securely for temporary passwords
- Requiring password change at first sign-in
- Avoiding credentials stored in source code

### Assign Directory Roles

[`assign-directory-roles.ps1`](powershell/assign-directory-roles.ps1)

Assigns Microsoft Entra directory roles while:

- Resolving the target user
- Resolving the requested role definition
- Checking for an existing assignment
- Avoiding duplicate role assignments

### Verify Directory Roles

[`verify-directory-roles.ps1`](powershell/verify-directory-roles.ps1)

Retrieves Microsoft Entra role assignments and displays:

- User identity
- Directory role name
- Assignment scope
- Role verification results

---

## Technologies Used

- Microsoft Azure
- Microsoft Entra ID
- Microsoft Graph
- Microsoft Graph PowerShell SDK
- Azure Cloud Shell
- PowerShell 7
- Git
- GitHub

---

## Security Practices

The lab incorporates the following practices:

- Dedicated privileged identities
- Separation of administrative and everyday accounts
- Least-privilege access design
- Role verification before privilege changes
- Microsoft Entra Security Defaults
- Secure password prompting in PowerShell
- No credentials or secrets stored in source code
- Sanitized screenshots for public documentation

MFA registration is planned as a separate hardening step and is not yet represented as completed evidence.

---

## Troubleshooting Experience

This project included several real-world troubleshooting scenarios.

### Invalid Object or Role Identifiers

A role-assignment attempt initially failed because the target user object had not been resolved correctly before the assignment operation.

Resolution:

- Re-query the user
- Validate the returned object
- Confirm the object ID exists before performing role operations

### Existing Role Assignment

A role-assignment request returned a conflict because the role was already assigned.

Resolution:

- Check for existing role assignments before creating a new one
- Treat duplicate assignments as a validation condition rather than a failure

### Microsoft Graph Authorization

A password-profile update initially failed because the active Microsoft Graph session did not include sufficient delegated permissions.

Resolution:

- Reconnect to Microsoft Graph with the required scope
- Confirm the signed-in identity has sufficient Entra administrative privileges
- Re-run the operation only after validating permissions

These issues reinforced the importance of object validation, permission awareness, and idempotent automation.

---

## Configuration Evidence

### Entra Tenant Overview

The lab uses a dedicated Microsoft Entra tenant for identity and access management.

![Microsoft Entra tenant overview](screenshots/01-entra-tenant-overview.png)

### Lab Identities

Separate identities are used for administration, application ownership, and least-privilege testing.

![Microsoft Entra users](screenshots/02-entra-users.png)

### Global Administrator Assignment

A dedicated cloud-native Tenant Administrator account is assigned the Global Administrator directory role.

![Global Administrator role assignment](screenshots/03-global-admin-role.png)

### Native Administrative Session

The dedicated administrative identity is used for Microsoft Entra administration rather than relying exclusively on a personal Microsoft account.

![Native Entra administrator session](screenshots/04-native-admin-login.png)

### Security Defaults

Microsoft Entra Security Defaults provide the baseline identity-security configuration for the lab tenant.

![Microsoft Entra Security Defaults](screenshots/06-security-defaults.png)

> MFA registration for the dedicated administrative account is a planned security-hardening task and will be documented separately when completed.

---

## Skills Demonstrated

This project demonstrates practical experience with:

- Microsoft Entra ID administration
- Cloud identity provisioning
- Privileged-role management
- Least-privilege design
- Separation of duties
- Microsoft Graph PowerShell
- PowerShell automation
- Role-assignment verification
- Authentication and authorization troubleshooting
- Secure public technical documentation
- Git and GitHub workflow

---

## Related Documentation

[View the detailed Microsoft Entra ID setup case study](entra-id-setup.md)

---

## Next Step

The next project focuses on Azure role-based access control.

[Continue to Azure RBAC](../02-rbac/)

The RBAC lab will demonstrate:

- Azure built-in roles
- Subscription and resource-group scope
- Role assignments
- Least-privilege access
- The difference between Microsoft Entra directory roles and Azure RBAC roles
- PowerShell-based RBAC verification
