---
docs: DOCS-1271
title: Manage resource groups
toc: true
weight: 300
type:
- tutorial
---

## Overview

Resource groups are containers that help you manage multiple resources collectively, such as instances, instance groups, and certificates. By using resource groups, you can assign RBAC (Role-Based Access Control) permissions to multiple resources as a single entity. This provides a more flexible way of managing resources compared to [Instance Groups]({{< relref "/nim/nginx-instances/manage-instance-groups.md" >}}), where all instances share the same configuration. Resource groups don’t have this limitation and allow you to manage various resources under one group for better control.

## Before you begin

To complete the steps in this guide, ensure you have:

- A running version of [NGINX Instance Manager]({{< relref "/nim/deploy/_index.md" >}}).
- One or more registered NGINX data plane instances.

{{< include "/nim/how-to-access-api-docs.md" >}}

---

## Default systems set

By default, when NGINX instances (also called systems) register with NGINX Instance Manager, they are automatically added to a resource group called `default-systems`. This default group can be used to set base-level permissions for new instances until you organize them into more specific resource groups.

---

## Creating, updating, and deleting resource groups

### Create a resource group

#### Using the web interface

To create a resource group using the NGINX Instance Manager web interface:

1. Log in to the FQDN for your NGINX Instance Manager host.
2. In the Launchpad menu, select **Settings**.
3. From the left-side menu, select **Resource Groups**.
4. Select **Create**.
5. In the **Basic Information** form, provide the following details:
   - **Name**: Enter a unique name for the resource group.
   - **Description**: Optionally, provide a description for the resource group.
6. Select **Next**.
7. In the **Certs** form, select any certificates to include in the resource group, or leave this section blank if none are needed.
8. Select **Next**.
9. In the **Instance Groups** form, select any instance groups to include, or leave this section blank.
10. Select **Next**.
11. In the **Systems** form, select any instances you want to include in the resource group, or leave this section blank.
12. Select **Save** to create the resource group.

#### Using the API

##### HTTP request (POST)

To create a resource group using the REST API, send an HTTP `POST` request to the Resource Groups endpoint.

- **Method**: `POST`
- **Endpoint**: `/api/platform/v1/resource-groups`

##### Parameters

When creating a resource group via the API, include the following parameters:

- **name** (required): The name of the resource group.
- **description** (optional): A brief description of the resource group.
- **resources** (optional): An array of resource objects, such as instances or instance groups. Each resource object includes:
  - **module**: The module name, such as `Instance Manager`.
  - **name**: The name of the resource.
  - **object**: The type of object, for example, `Systems`.
  - **uid**: The unique identifier of the resource.

##### Example JSON request

```json
{
  "name": "my-resource-group",
  "description": "Group for managing test instances",
  "resources": [
    {
      "module": "Instance Manager",
      "name": "test-instance",
      "object": "Systems",
      "uid": "1234abcd-5678-90ef-ghij-klmnopqrstuv"
    }
  ]
}
```

---

### Modify an existing resource group

#### Using the web interface

To modify an existing resource group in the web interface:

1. Log in to the FQDN for your NGINX Instance Manager host.
2. From the Launchpad menu, select **Settings**.
3. Select **Resource Groups** from the left-side menu.
4. Choose the resource group you want to update and click **Edit**.
5. Modify the following details as needed:
   - **Name**: Update the name of the resource group.
   - **Description**: Update or add a description for the resource group.
6. Select **Next** to navigate through the following sections:
   - **Certs**: Add or remove certificates.
   - **Instance Groups**: Add or remove instance groups.
   - **Systems**: Add or remove instances.
7. Select **Save** to apply the changes.

#### Using the API

##### HTTP request (POST)

To add resources to an existing resource group, send an HTTP `POST` request to the Resource Groups endpoint.

- **Method**: `POST`
- **Endpoint**: `/api/platform/v1/resource-groups/{resourceGroupUid}/resources`

##### Parameters

Include the following parameters when adding resources:

- **module** (required): The module name, such as `Instance Manager`.
- **name** (required): The name of the resource.
- **object** (required): The type of resource object (for example `Systems`).
- **uid** (required): The unique identifier of the resource.

##### Example JSON request

```json
{
  "module": "Instance Manager",
  "name": "new-instance",
  "object": "Systems",
  "uid": "1a2b3c4d-5678-90ef-ghij-klmnopqrst"
}
```

---

### Remove resources from a resource group

#### Using the web interface

To remove resources from a resource group:

1. Log in to the FQDN for your NGINX Instance Manager host.
2. In the Launchpad menu, select **Settings**.
3. Choose **Resource Groups** from the left-side menu.
4. Select the resource group you want to modify and click **Edit**.
5. In each section (Certs, Instance Groups, Systems), uncheck the resources you want to remove.
6. Select **Save** to apply the changes.

#### Using the API

##### HTTP request (DELETE)

To remove a resource from a resource group via the REST API, send an HTTP `DELETE` request.

- **Method**: `DELETE`
- **Endpoint**: `/api/platform/v1/resource-groups/{resourceGroupUid}/resources/{resourceUid}?moduleName=Instance Manager`

##### Example request

```bash
DELETE https://<NIM_FQDN>/api/platform/v1/resource-groups/{resourceGroupUid}/resources/{resourceUid}?moduleName=Instance Manager
```

---

### Delete a resource group

#### Using the web interface

To delete a resource group:

1. Log in to the FQDN for your NGINX Instance Manager host.
2. From the Launchpad menu, select **Settings**.
3. Select **Resource Groups** from the left-side menu.
4. Choose the resource group you want to delete and click **Delete**.

#### Using the API

##### HTTP request (DELETE)

To delete a resource group via the REST API, send an HTTP `DELETE` request.

- **Method**: `DELETE`
- **Endpoint**: `/api/platform/v1/resource-groups/{resourceGroupUid}`

##### Example request

```bash
DELETE https://<NIM_FQDN>/api/platform/v1/resource-groups/{resourceGroupUid}
```

---

## Viewing resource groups

### View a list of resource groups

#### Using the web interface

To view a list of resource groups:

1. Log in to the FQDN for your NGINX Instance Manager host.
2. From the Launchpad menu, select **Settings**.
3. In the left-side menu, select **Resource Groups** to see a list of existing groups.

#### Using the API

##### HTTP request (GET)

To retrieve a list of resource groups without resource details:

- **Method**: `GET`
- **Endpoint**: `/api/platform/v1/resource-groups?showDetails=false`

To retrieve a list of resource groups with resource details:

- **Method**: `GET`
- **Endpoint**: `/api/platform/v1/resource-groups?showDetails=true`

##### Example request (showing resource details)

```bash
GET https://<NIM_FQDN>/api/platform/v1/resource-groups?showDetails=true
```

---

## Putting it all together

### Example: Managing test environment resources

This example demonstrates how to manage resources in a test environment by creating a resource group, defining a role for resource management, and assigning that role to a user.

#### Step 1: Create the **test-env-resources** resource group

1. Log in to the FQDN for your NGINX Instance Manager host.
2. In the Launchpad menu, select **Settings**.
3. From the left-side menu, select **Resource Groups**.
4. Select **Create**.
5. Provide the following details:
   - **Name**: Enter `test-env-resources`.
   - **Description**: Enter `Test Environment Resources`.
6. Add any relevant certificates, instance groups, or systems to the group.
7. Select **Save**.

#### Step 2: Create the **test-env-admin** role

1. In the Launchpad menu, select **Settings**.
2. From the left-side menu, select **Roles**.
3. Select **Create**.
4. Provide the following details:
   - **Name**: Enter `test-env-admin`.
   - **Description**: Enter `Test Environment Admin`.
5. Add permissions for the role:
   - **Certs**: Read access for all certs.
   - **Instance-Groups**: Read access for all instance groups.
   - **Instance-Management**: Read access for all systems.
   - **Resource Groups**: Full access (Create, Read, Update, Delete) for the `test-env-resources` group.
6. Select **Save**.

#### Step 3: Assign the **test-env-admin** role to a user

1. From the left-side menu, select **Users**.
2. Choose the user you want to assign the role to (for example, `john-doe`).
3. Select **Edit User**.
4. In the **Roles** list, select the `test-env-admin` role.
5. Select **Save**.
