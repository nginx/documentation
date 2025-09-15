---
title: Glossary
weight: 900
toc: true
nd-docs: DOCS-000
url: /nginxaas/google/glossary/
type:
- reference
---

This document provides definitions for terms and acronyms commonly used in F5 NGINXaaS for Google Cloud (NGINXaaS) documentation.

{{<table>}}

| Term                | Description                                                                          |
| ------------------------ | -------------------------------------------------------------------------------------|
| GCP                      | Geographic Control Plane. The control plane that manages the NGINXaaS instances deployed in Google Cloud. |
| Network attachment       | A Google Cloud resource that enables a VM instance to connect to a VPC network. [More information](https://cloud.google.com/vpc/docs/about-network-attachments).   |
| VPC network              | A Virtual Private Cloud (VPC) network is a virtual version of a physical network, implemented within Google Cloud. It provides networking functionality for your Google Cloud resources. [More information](https://cloud.google.com/vpc/docs/vpc). |
| NGINXaas Account        | Represents a Google Cloud procurement with an active Marketplace NGINXaaS subscription, linked to a billing account. To create an account, see the signup documentation in [prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites.md" >}}). |
| User | A user is anyone who has access to an NGINXaaS Account through their Google Identity. The same Google Identity can be added to multiple NGINXaaS Accounts, but it is treated as a different user in each account. |
| Authorized Domains | The list of Google Identity domains (for example, "example.com") allowed to access an NGINXaaS Account using Google authentication. <br> - By default, an NGINXaaS Account has an empty authorized domains field, which means that anyone can log in to the account, if added as a user. <br> - Configuring this field allows you to control which organizations (based on their email domains) are allowed to log in to the NGINXaaS Account. This restricts access to only users from trusted companies or groups, and prevents unauthorized domains from accessing resources in the account. <br> - When updating authorized domains, you cannot make an update if it would prevent any existing user from logging in. This ensures that no current users are accidentally locked out of the account. |


{{</table>}}