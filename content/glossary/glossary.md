---
description: ''
title: Glossary
nd-docs: DOCS-602
weight: 1000
toc: true
nd-content-type: reference
---

This glossary defines terms used in the F5 NGINX and F5 Distributed Cloud.

## General terms

{{<bootstrap-table "table table-striped table-bordered">}}
| Term        | Definition |
|-------------|-------------|
| **Config Sync Group** / **Instance Group** | A group of NGINX systems (or instances) with identical configurations. They may also share the same certificates. However, the instances in a Config Sync Group could belong to different systems and even different clusters. Also known as an Instance Group in NGINX Instance Manager. For more information, see this explanation of [Important considerations]({{< ref "/nginx-one/nginx-configs/config-sync-groups/manage-config-sync-groups.md#important-considerations" >}}) |
| **Control Plane** | The control plane is the part of a network architecture that manages and controls the flow or data or traffic (the Data Plane). It is responsible for system-level tasks such as routing and traffic management. |
| **Data Plane** | The data plane is the part of a network architecture that carries user traffic. It handles tasks like forwarding data packets between devices and managing network communication. In the context of NGINX, the data plane is responsible for tasks such as load balancing, caching, and serving web content. |
| **Instance** | An instance is an individual system with NGINX installed. You can group the instances of your choice in a Config Sync Group. When you add an instance to NGINX One Console, you need to use a data plane key. |
| **Namespace** | In F5 Distributed Cloud, a namespace groups a tenant’s configuration objects, similar to administrative domains. Every object in a namespace must have a unique name, and each namespace must be unique to its tenant. This setup ensures isolation, preventing cross-referencing of objects between namespaces. You'll see the namespace in the NGINX One Console URL as `/namespaces/<namespace name>/`. To switch an instance between namespaces, you have to deregister an instance from an old namespace, and register it on the new namespace. |
| **NGINX Agent**                      | A lightweight software component installed on NGINX instances to enable communication with the NGINX One console. NGINX Agent also enables communication with NGINX Instance Manager.                                     |
| **Staged Configurations** | Also known as **Staged Configs**. Allows you to save "work in progress." You can create it from scratch, an Instance, another Staged Config, or a Config Sync Group. It does _not_ have to be a working configuration until you publish it to an instance or a Config Sync Group. You can even manage your **Staged Configurations** through our [API]({{< ref "/nginx-one/api/api-reference-guide/#tag/StagedConfigs" >}}). |
| **Tenant** | A tenant in F5 Distributed Cloud is an entity that owns a specific set of configuration and infrastructure. It is fundamental for isolation, meaning a tenant cannot access objects or infrastructure of other tenants. Tenants can be either individual or enterprise, with the latter allowing multiple users with role-based access control (RBAC). |
{{</bootstrap-table>}}

## Authentication and Authorization terms

{{<bootstrap-table "table table-striped table-bordered">}}
| Term        | Definition |
|-------------|-------------|
| **Access Token** | Defined in OAuth2, this (optional) short lifetime token provides access to specific user resources as defined in the scope values in the request to the authorization server (can be a JSON token as well). |
| **ID Token** | Specific to OIDC, the primary use of the token in JWT format is to provide information about the authentication operation's outcome. |
| **Identity Provider (IdP)** | A service that authenticates users and verifies their identity for client applications. |
| **JSON Web Token (JWT)** | An open standard (RFC 7519) that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. This information can be verified and trusted because it is digitally signed. |
| **Protected Resource** | A resource that is hosted by the resource server and requires an access token to be accessed. |
| **Refresh Token** | Coming from OAuth2 specs, the token is usually long-lived and may be used to obtain new access tokens. |
| **Relying Party (RP)** | A client service required to verify user identity. |
{{</bootstrap-table>}}

## Kubernetes and Ingress Controller terms

{{<bootstrap-table "table table-striped table-bordered">}}
| Term        | Definition |
|-------------|-------------|
| **Ingress** | Refers to an *Ingress Resource*, a Kubernetes API object which allows access to [Services](https://kubernetes.io/docs/concepts/services-networking/service/) within a cluster. They are managed by an [Ingress Controller]({{< ref "/nic/glossary.md#ingress-controller">}}). *Ingress* resources enable the following functionality:<br>* **Load balancing**, extended through the use of Services<br>* **Content-based routing**, using hosts and paths<br>* **TLS/SSL termination**, based on hostnames<br><br>For additional information, please read the official [Kubernetes Ingress Documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/). |
| **Ingress Controller** | Ingress Controllers are applications within a Kubernetes cluster that enable [Ingress]({{< ref "/nic/glossary.md#ingress">}}) resources to function. They are not automatically deployed with a Kubernetes cluster, and can vary in implementation based on intended use, such as load balancing algorithms for Ingress resources. [The design of NGINX Ingress Controller]({{< ref "/nic/overview/design.md">}}) explains the technical details of NGINX Ingress Controller. |
{{</bootstrap-table>}}

## F5 WAF for NGINX terminology

{{< include "nap-waf/config/common/nginx-app-protect-waf-terminology.md" >}}

## NGINX Alerts

To set up NGINX Alerts through the F5 Distributed Cloud, follow the procedure in [Set up security alerts]({{< ref "/nginx-one/secure-your-fleet/set-up-security-alerts/" >}}).

{{< include "/nginx-one/alert-labels.md" >}}


## Legal notice: Licensing agreements for NGINX products

Using NGINX One is subject to our End User Service Agreement (EUSA). For [NGINX Plus]({{< ref "/nginx" >}}), usage is governed by the End User License Agreement (EULA). Open source projects, including [NGINX Agent](https://github.com/nginx/agent) and [NGINX Open Source](https://github.com/nginx/nginx), are covered under their respective licenses. For more details on these licenses, follow the provided links.

---

## References

- [F5 Glossary](https://www.f5.com/glossary)
- [F5 Distributed Cloud: Core Concepts](https://docs.cloud.f5.com/docs/ves-concepts/core-concepts)

