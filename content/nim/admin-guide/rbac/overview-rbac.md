---
title: "Overview: RBAC"
weight: 1
toc: true
type: concept
product: nim
docs: DOCS-919
---

## Overview

{{< include "security/rbac-intro.md" >}}

The following are essential concepts related to RBAC:

- **Users**: Users are individual accounts identified by a username and credentials. You have the option to create users within F5 NGINX Instance Manager using basic authentication or to integrate with an external identity provider using OpenID Connect (OIDC).
- **Roles**: Roles are sets of permissions linked to one or more features. Each role specifies the actions that are allowed for each feature, such as creating, reading, updating, or deleting. The pre-defined `admin` role grants full access to all features.

   Users can have multiple roles simultaneously. In such cases, the permissions granted by each role are combined, providing an additive effect. For instance, a user with two roles, one granting read access to all NGINX instances and the other allowing create, update, and delete access to a specific instance, will be able to read all instances while having the ability to create, update, or delete only the designated instance for which they have permission.

- **Groups**: Groups are collections of users. They are used only when integrating with external identity providers. Users from these providers can't be assigned roles directly within NGINX Instance Manager but inherit roles through membership in groups.
- **Features**: In NGINX Instance Manager, features refer to distinct functional components or capabilities that let users perform a variety of tasks and access related resources. The sections below outline the features available for NGINX Instance Manager.
- **Resource Object**: These are specific elements within a feature that can be targeted for precise access control. Essentially, a resource object is a finer-grained component within a feature that you can control access to. For example, if you are working with the Instance Management feature, you have the option to apply access control to specific entities like Resource Groups and/or Systems. This allows for more nuanced management of permissions within NGINX Instance Manager.

## Features {#features}

NGINX Instance Manager provides a range of capabilities called features, which system administrators can manage using role-based access control (RBAC). The availability of some features depends on your license. For more information on licensing, see the [Add a license]({{< ref "/nim/admin-guide/add-license.md" >}}) topic.

### NGINX Instance Manager features

#### Unlicensed

- **NGINX Plus Counting**: View the number of registered NGINX Plus instances and track Kubernetes usage.
- **Licensing**: View and manage licenses.
- **Resource Groups**: Create, configure, and manage resource groups.
- **User Management**: Create, configure, and manage roles, users, and user groups.

#### Licensed

- **Analytics**: Access analytics endpoints, including metrics, catalogs, and events.
- **Certificates**: View and manage certificates for NGINX instances, with resources like Certs, Instance Groups, Resource Groups, and Systems.
- **Instance Groups**: Create, configure, and manage NGINX instance groups.
- **Instance Management**: View and manage NGINX instances within Resource Groups and Systems.
- **Scan**: Perform scans for NGINX instances.
- **Security Policies**: View and manage security policies for NGINX instances, which depend on Instance Management and Instance Groups for publishing.
- **Staged Configurations**: View, create, update, and delete staged NGINX configurations for Instance Groups, Resource Groups, and Systems.
- **Templates**: View, create, update, and delete NGINX config templates for Instance Groups, Resource Groups, Systems, and Templates.
- **Template Submissions**: Manage NGINX config template submissions, including viewing, creating, updating, and deleting submissions for Instance Groups, Resource Groups, Systems, Templates, and Template Submissions.

### Endpoints

To explore the API endpoints for NGINX Instance Manager, visit:

- **API Endpoints**: `https://<NGINX_INSTANCE_MANAGER_FQDN>/ui/docs`.

Replace `<NGINX_INSTANCE_MANAGER_FQDN>` with the fully qualified domain name (FQDN) of your NGINX Instance Manager host.
