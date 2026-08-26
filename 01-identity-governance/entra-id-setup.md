\# Microsoft Entra ID Tenant Setup



\## Project Overview



This lab documents the configuration of a Microsoft Entra ID environment used for hands-on Azure identity, governance, security, and administration practice.



The objective was to move from relying on an external Microsoft account for tenant administration to a more enterprise-oriented design using dedicated cloud-native administrative identities.



\## Environment



\- Microsoft Azure

\- Microsoft Entra ID Free

\- PowerShell 7

\- Microsoft Graph PowerShell SDK

\- Azure Cloud Shell

\- Git and GitHub



\## Objectives



The primary objectives of this lab were to:



\- Review the existing Microsoft Entra tenant

\- Identify existing users and administrative identities

\- Create cloud-native Entra users

\- Establish a dedicated tenant administrator

\- Assign Microsoft Entra directory roles

\- Verify administrative role assignments

\- Implement least-privilege account separation

\- Prepare the environment for MFA and additional security controls

\- Document the configuration using GitHub



\## Identity Design



The tenant uses separate identities for different administrative and testing purposes.



| Account Purpose | Intended Use |

|---|---|

| Tenant Administrator | Dedicated Microsoft Entra administration |

| Cloud Administrator | Azure infrastructure administration |

| Finance Reader | Least-privilege access testing |

| App Owner | Application and service principal testing |

| Personal Microsoft Account | External/backup administrative access |



This separation reduces dependence on a single identity and provides a better environment for practicing role-based access control and least privilege.



\## Microsoft Graph PowerShell



Microsoft Graph PowerShell was used to manage Entra users and directory roles.



Example connection:



```powershell

$TenantId = (Get-AzContext).Tenant.Id



Connect-MgGraph `

&#x20;   -TenantId $TenantId `

&#x20;   -Scopes `

&#x20;       "User.ReadWrite.All",

&#x20;       "Directory.Read.All",

&#x20;       "RoleManagement.ReadWrite.Directory"

