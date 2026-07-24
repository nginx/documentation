---
title: Glossary
weight: 900
toc: true
f5-docs: DOCS-000
url: /nginxaas/glossary/
f5-content-type: reference
f5-product: F5 NGINXaaS
contentVars:
  product: NGINXaaS
---

This document provides definitions for terms and acronyms commonly used in F5 ${product} documentation.

{{<table>}}

| Term                        | Description                                                                          |
| ------------------------    | -------------------------------------------------------------------------------------|
| Authorized Domains          |  The list of domains allowed to authenticate into the NGINXaaS Account using Google social authentication. <br>- This can be used to restrict access to Google identities within your Google Cloud Organization or Google Workspace, or other known, trusted Workspaces. For example, your Google Cloud Organization may have users created under the `example.com` domain. By setting the Authorized Domains in your NGINXaaS Organization to only allow `example.com`, users attempting to log in with the same email associated with `alternative.net` Google Workspace would not be authenticated. |
| Geographical Controller (GC)| Geographical Controller (GC) is a control plane that serves users in a given geographical boundary while taking into account concerns relating to data residency and localization. Example: A US geographical controller serves US customers. |
| NGINXaaS Organization       | The account that hosts your NGINXaaS configurations and deployments. An Organization can be linked to marketplace subscriptions for each cloud provider you want to deploy into, and can have unlimited users added for collaboration on your NGINXaaS resources. |
| NGINXaaS User | NGINXaaS Users are granted access to all resources in the NGINXaaS Organization. User authentication is performed securely via Google Cloud, requiring a matching identity. Individuals can be added as users to multiple NGINXaaS Organizations, and can switch between them. |
| Network attachment          | A Google Cloud resource that connects your NGINXaaS for Google Cloud deployment to upstream applications in your VPC network. [More information](https://cloud.google.com/vpc/docs/about-network-attachments).   |

{{</table>}}
