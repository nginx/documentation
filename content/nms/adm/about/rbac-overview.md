---
title: RBAC
description: Learn how role-based access control (RBAC) is applied to the App Delivery Manager (ADM).
weight: 600
toc: true
draft: false
tags: ["docs"]
docs: "DOCS-000"
---
## Permission Structure

The permission structure for Nginx Management Suite (NMS) uses a flat permission structure based on features, where permissions are assigned for each feature. Permissions are configured for a role, and then the role is assigned to users. A user can be assigned more than one role and the permissions for each role will be agglomerated together.

{{< note >}}if two or more roles specify permissions for the same feature, NMS will try to provide the least restrictive use for that feature when combining those permissions.  However, having multiple permission definitions for a particular feature is not recommended.{{< /note >}}

Each object has a corresponding feature that is used to set permissions for accessing that object. The permissions roughly correspond to the endpoints for an object. Endpoints can be referenced as the base endpoint `/<object>` or with a specific object referenced `/<object>/<uid>`. Some objects may have parent objects that they must be nested under and for these parent objects, there will be permissions for setting access within these parent objects, e.g. for apps which are nested under environments, the admin will be able to specify which environments a particular role will be able to access the apps under. This is accomplished by specifying the environment object within the app feature.

Permissions are referenced to either a specific object, by referring to the universal identifier (UID) that was assigned to the object at creation time,  or to a universal permission ALL. ALL is the wildcard permission that allows access to all relevant objects fitting that description.

{{< note >}}Giving the ALL permission is the only way to give access to objects which are not created yet.{{< /note >}}

The possible permission levels are CREATE, READ, UPDATE, and DELETE, which correspond to access for Create, Read, Update, and Delete methods respectively. If a user is found not to have permissions for the action they are taking, the backend will generally return a 403 error.

### CREATE

CREATE access gives permission to create an object and corresponds to the POST method. Since UIDs are assigned at creation time, CREATE access is only relevant for access to the base endpoint. The POST method (and hence CREATE permission) cannot be used with reference to a specific object.

{{< note >}}This requires that for a user to use the CREATE permission for an object, they must have the ALL permission for that feature.{{< /note >}}

### READ

READ access gives permission to access, but not modify the details and specifications of an object, and corresponds to the GET method. READ access is relevant to both the base endpoint and to a reference with a specific object. When referencing a specific object, permissions are checked and if the user does not have access, the server will return a 403 error, as is the case with other methods. By contrast, READ access to the base endpoint is slightly different, as the server generally returns a list of all objects that the user has access to, which will be the empty list if the user does not have access to any objects. This is the one case where the user may not receive a 403 response, despite not having permissions.

{{< note >}}READ access is disjoint from other access methods and a user can be given other accesses without READ access. However, it is strongly recommended that READ access be given when giving any other access.{{< /note >}}

### UPDATE

UPDATE access gives permission to modify the details and specifications of an object and corresponds to the PUT method. UPDATE access targets a specific object and hence only makes sense for a call with a specific object referenced.

### DELETE

DELETE access gives permission to remove an object and corresponds to the DELETE method. DELETE access targets a specific object and hence only makes sense for a call with a specific object referenced.

## **Features**

### ENVIRONMENT-MANAGEMENT

The ENVIRONMENT-MANAGEMENT feature controls access to environments and the `/environments` endpoint. Environments are a base object with no parent. Environment permissions are of the form `<envName>|<envUID>`.

#### Objects:

* Environments

### APP-MANAGEMENT

The APP-MANAGEMENT feature controls access to apps and the `/environments/<envUID>/apps` and `/apps` endpoints. Apps have environments as a parent object, and so access to environments objects within the APP-MANAGEMENT feature must be granted in order to allow access. App permissions are of the form `<envName>ǀ<appName>|<appUID>`.

#### Objects:

* Environments
* Apps

### GATEWAY-MANAGEMENT

The GATEWAY-MANAGEMENT feature controls access to gateways and the `/environments/<envUID>/gateways` and `/gateways` endpoints. Gateways have environments as a parent object, and so access to environments objects within the GATEWAY-MANAGEMENT feature must be granted in order to allow access. Gateway permissions are of the form `<envName>ǀ<gatewayName>|<gatewayUID>`.

#### Objects:

* Environments
* Gateways

### SITE-MANAGEMENT

The SITE-MANAGEMENT feature controls access to environments and the `/sites` endpoint. Sites are a base object with no parent. Sites permissions are of the form `<siteName>|<siteUID>`.

#### Objects:

* Sites

### WEB-COMPONENT-MANAGEMENT

The WEB-COMPONENT-MANAGEMENT feature controls access to web components and the `/environments/<envUID>/apps/<appUID>/web-components` endpoint. Web components have environments and apps as parent objects, so access to the environments and apps objects within the WEB-COMPONENT-MANAGEMENT feature must be granted to allow access.

#### Objects:

* Environments
* Apps
* Web-Components

### TCPUDP-COMPONENT-MANAGEMENT

The TCPUDP-COMPONENT-MANAGEMENT feature controls access to TCP/UDP components and the `/environments/<envUID>/apps/<appUID>/tcpudp-components` endpoint. TCP/UDP components have environments and apps as parent objects, so access to the environments and apps objects within the TCP-COMPONENT-MANAGEMENT feature must be granted to allow access.

#### Objects:

* Environments
* Apps
* TCP-Components

{{< note >}} If a feature does not have an object listed, there is currently no enforcement or RBAC control over features based on that object, eg: Web components cannot be filtered based on the gateways they reference.{{< /note >}}

## **Examples**

Some examples of roles are described below.  For more details on how to assign roles and the special considerations which need to be taken into account when using the user interface (UI) see [Setting up User Roles]({{< relref "adm/getting-started/roles.md" >}}) section of **Getting-Started**.

#### Local App Manager

An app manager will often be given an environment under which they manage all resources. The permissions to configure this permission are of this form, where the environment is given the name `env1` and has UID `f114ff25-0708-46f5-8f7c-efe8d564ec25`.

* ENVIRONMENT-MANAGEMENT - READ
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
* APP-MANAGEMENT - CREATE, READ, UPDATE, DELETE
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
  * Apps - `All`
* GATEWAY-MANAGEMENT - CREATE, READ, UPDATE, DELETE
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
  * Gateways - `All`
* WEB-COMPONENT-MANAGEMENT - CREATE, READ, UPDATE, DELETE
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
  * Apps - `All`
  * Web-Components - `All`
* TCP-COMPONENT-MANAGEMENT - CREATE, READ, UPDATE, DELETE
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
  * Apps - `All`
  * TCP-Components - `All`

This permission allows a user to manage all ADM resources under the given environment `env1`

#### Guest User

A guest user may only need to read a few specific resources. For example, the guest user may need to read a specific app (`app1` with UID `3dd1eae2-11b4-47b2-be90-e421160601b6`), gateway (`gateway1` with UID `3b3b9ab3-b6c4-441c-b1ad-26ea7b6875ac`), and three web components (`webcomp1` with UID `f7039d7a-085e-46fe-aa5e-1125c13e1fd8`, `webcomp2` with UID `619370ab-b814-452f-8b3f-6bd3434aae9d`, `webcomp3` with UID `41b94747-585c-41ec-a4e2-f301dd658889`), where all resources are under `env1` and the web-components are under `app1`. The following permission would allow only read access to these resources.

* ENVIRONMENT-MANAGEMENT - READ
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
* APP-MANAGEMENT - READ
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
  * Apps - `env1ǀapp1|3dd1eae2-11b4-47b2-be90-e421160601b6`
* GATEWAY-MANAGEMENT - READ
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
  * Gateways - `env1ǀgateway1|3b3b9ab3-b6c4-441c-b1ad-26ea7b6875ac`
* WEB-COMPONENT-MANAGEMENT - READ
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
  * Apps - `env1ǀapp1|3dd1eae2-11b4-47b2-be90-e421160601b6`
  * Web-Components - `env1ǀapp1ǀwebcomp1|f7039d7a-085e-46fe-aa5e-1125c13e1fd8`, `env1ǀapp1ǀwebcomp2|619370ab-b814-452f-8b3f-6bd3434aae9d`, `env1ǀapp1ǀwebcomp3|41b94747-585c-41ec-a4e2-f301dd658889`

When adding these permissions, this gives READ access to just the resources listed.

#### App Developer

An app developer may need edit access over a few resources in order to deploy their apps, but should not have access to anything else. For example, they should have the ability to edit a specific app (`app1` with UID `3dd1eae2-11b4-47b2-be90-e421160601b6`) and two web-components (`webcomp1` with UID `f7039d7a-085e-46fe-aa5e-1125c13e1fd8`, `webcomp2` with UID `619370ab-b814-452f-8b3f-6bd3434aae9d`) as well as reading a specific gateway (`gateway1` with UID `3b3b9ab3-b6c4-441c-b1ad-26ea7b6875ac`). The following permissions would allow this

* ENVIRONMENT-MANAGEMENT - READ
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
* APP-MANAGEMENT - READ, UPDATE
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
  * Apps - `env1ǀapp1|3dd1eae2-11b4-47b2-be90-e421160601b6`
* GATEWAY-MANAGEMENT - READ
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
  * Gateways - `env1ǀgateway1|3b3b9ab3-b6c4-441c-b1ad-26ea7b6875ac`
* WEB-COMPONENT-MANAGEMENT - READ, UPDATE
  * Environments - `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`
  * Apps - `env1ǀapp1|3dd1eae2-11b4-47b2-be90-e421160601b6`
  * Web-Components - `env1ǀapp1ǀwebcomp1|f7039d7a-085e-46fe-aa5e-1125c13e1fd8`, `env1ǀapp1ǀwebcomp2|619370ab-b814-452f-8b3f-6bd3434aae9d`

For more details on  xxxxx to be continued!

## FAQ

1. I set the object permissions, but whenever the user tries to access the object, they get a 403 error code. What should I do?
   1. First, check that appropriate permissions exist for all parent objects (e.g. environments). A common mistake is to just set permissions for the object itself without giving permissions for the parent object. Also, if the permissions were changed recently, you may need to wait up to ten minutes or restart the ADM service in order for the permission cache to update and reflect the new permissions.
2. I changed the name of an object, but the permissions don’t seem to be updating to reflect the name change. Is this a problem?
   1. No, permissions are based on the UID of the object, so the permissions will correctly handle the object regardless of how the name changes. However, if there is a need to make the permissions update to match the name, edit the adc.conf to set `send_rbac_data=true` then restart the ADM module and this will resend all permissions and update the values. (It is recommended to set the `send_rbac_data=false` parameter back to false after completing this step).
3. A user has CREATE permissions for a specific object (e.g. CREATE permissions for `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`). Why aren’t they able to create objects?
   1. Permissions for specific objects are only relevant for targeting objects with that specific UID. So setting CREATE permission for a specific object would only allow the user to create an object with that specific UID, which is not valid. In order to allow a user to successfully create, they must have `ALL` permission for that object. It is recommended that permissions on parent objects be restricted if it is desired for a user to create objects while not having full access.
4. Why does a GET request sometimes return 200 when a user does not have permissions, when all other requests return a 403?
   1. The behavior of the READ permission on a request to the base endpoint is a little bit different than other requests. Instead of always returning a 403, we filter out any objects that the user does not have access to and return a 200. When the user does not have any access, this can result in an empty list with a 200 return code.
