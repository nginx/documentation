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

| Term                        | Description                                                                          |
| ------------------------    | -------------------------------------------------------------------------------------|
| Authorized Domains          |  The list of domains allowed to authenticate into the NGINXaaS Account using Google authentication. <br>- This can be used to restrict access to Google identities within your Google Cloud Organization or Google Workspace, or other known, trusted Workspaces. For example, your Google Cloud Organization may have users created under the `example.com` domain. By setting the Authorized Domains in your NGINXaaS Account to only allow `example.com`, users attempting to log in with the same email associated with `alternative.net` Google Workspace would not be authenticated. |
| GC (Geographical Controller)| Geographical Controller (GC) is a control plane that serves users in a given geographical boundary while taking into account concerns relating to data residency and localization. Example: A US geographical controller serves US customers. We currently have presence in two Geographies: **US** and **EU**. |
| NGINXaas Account            | Represents a Google Cloud procurement with an active Marketplace NGINXaaS subscription, linked to a billing account. To create an account, see the signup documentation in [prerequisites]({{< ref "/nginxaas-google/getting-started/prerequisites.md" >}}). |
| NGINXaaS User | NGINXaaS Users are granted access to all resources in the NGINXaaS Account. User authentication is performed securely via Google Cloud, requiring a matching identity. Individuals can be added as users to multiple NGINXaaS Accounts, and can switch between them using the steps documented below. |
| Network attachment          | A Google Cloud resource that enables a VM instance to connect to a VPC network. [More information](https://cloud.google.com/vpc/docs/about-network-attachments).   |
| VPC network                 | A Virtual Private Cloud (VPC) network is a virtual version of a physical network, implemented within Google Cloud. It provides networking functionality for your Google Cloud resources. [More information](https://cloud.google.com/vpc/docs/vpc). |



{{</table>}}