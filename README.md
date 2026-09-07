# Azure Engineering Portfolio

Hands-on Microsoft Azure engineering portfolio focused on identity, governance, role-based access control, networking, compute, storage, monitoring, security, and PowerShell automation.

This repository documents practical Azure labs built in a dedicated Microsoft Azure environment. The goal is to demonstrate real administration, troubleshooting, security, automation, and documentation skills rather than simply completing tutorials.

---

## Portfolio Status

| Area | Status | Focus |
|---|---|---|
| [Identity & Governance](01-identity-governance/) | In Progress | Microsoft Entra ID, users, directory roles, Graph PowerShell, Security Defaults |
| [Azure RBAC](02-rbac/) | Next | Azure role assignments, scopes, least privilege |
| [Networking](03-networking/) | Planned | VNets, subnets, NSGs, DNS, routing |
| [Compute](04-compute/) | Planned | Virtual machines, administration, availability |
| [Storage](05-storage/) | Planned | Storage accounts, redundancy, access control |
| [Monitoring](06-monitoring/) | Planned | Azure Monitor, Log Analytics, alerts |
| [Security](07-security/) | Planned | Defender for Cloud, Key Vault, identity security |

---

## Current Project

### Microsoft Entra ID — Identity & Governance

The first phase of the lab establishes the identity and administrative foundation for the Azure environment.

Work completed includes:

- Created cloud-native Microsoft Entra identities
- Established a dedicated tenant administrator
- Separated privileged and standard identities
- Assigned and verified Microsoft Entra directory roles
- Used Microsoft Graph PowerShell for identity administration
- Automated user creation and directory-role management
- Implemented Microsoft Entra Security Defaults
- Documented troubleshooting and authorization issues
- Created sanitized configuration evidence for GitHub

MFA registration for the dedicated privileged administrator remains a planned security-hardening task.

[View the Identity & Governance project](01-identity-governance/)

---

## PowerShell Automation

The portfolio includes reusable PowerShell automation for Microsoft Entra administration.

Current scripts include:

- [`create-entra-users.ps1`](01-identity-governance/powershell/create-entra-users.ps1)
- [`assign-directory-roles.ps1`](01-identity-governance/powershell/assign-directory-roles.ps1)
- [`verify-directory-roles.ps1`](01-identity-governance/powershell/verify-directory-roles.ps1)

The scripts demonstrate:

- Microsoft Graph authentication
- Secure user provisioning
- Existing-object validation
- Directory-role assignment
- Role verification
- Error handling
- Least-privilege administration concepts

---

## Technologies

- Microsoft Azure
- Microsoft Entra ID
- Microsoft Graph
- Microsoft Graph PowerShell SDK
- Azure Cloud Shell
- PowerShell 7
- Git
- GitHub
- Windows
- Linux

---

## Repository Structure

```text
azure-learning/
├── 01-identity-governance/
│   ├── powershell/
│   ├── screenshots/
│   ├── entra-id-setup.md
│   └── README.md
│
├── 02-rbac/
│   └── README.md
│
├── 03-networking/
│   └── README.md
│
├── 04-compute/
│   └── README.md
│
├── 05-storage/
│   └── README.md
│
├── 06-monitoring/
│   └── README.md
│
├── 07-security/
│   └── README.md
│
└── README.md
