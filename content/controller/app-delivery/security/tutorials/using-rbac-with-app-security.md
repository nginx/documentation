---
description: How to use Role Based Access Control with App Security.
docs: DOCS-845
title: Using RBAC with the App Security Add-On
toc: true
weight: 400
type:
- how-to
---

Role Based Access Control (RBAC) allows you to define permissions for Apps Security resources. With RBAC, you can specify which role has the permissions to create, read (and reference), update, and delete a Security Strategy or a Security Policy. You can then assign roles to specific users so that the users inherit the permissions.

For more information regarding roles, refer to [Manage Roles and Role Groups]({{< ref "/controller/platform/access-management/manage-roles.md" >}})

## Permissions for App Security

To enable security, the app component needs to reference a security strategy. The security strategy in turn references a security policy. When using RBAC with App Security, you need to configure permissions for the app component, the security strategy, and the security policy.

Resources that are deeper in the path hierarchy inherit permissions from their parents unless explicitly overwritten. For more information, refer to [Manage Roles and Role Groups]({{< ref "/controller/platform/access-management/manage-roles.md" >}}).

## Granting Permissions on App Components

The app component you want to enable WAF for must have `WRITE` permission. Additionally, all objects referenced by the app component need to have `READ` permission. In the following example, `WRITE` permission is given to the app component, and `READ` permission is given to the gateway and the location referenced by the app component:

```nginx
{
   "path": "/services/environments/env-name/apps/app-name/components/component-name",
   "access": "WRITE"
},
{
   "path": "/services/environments/env-name/gateways/gateway-name",
   "access": "READ"
},
{
   "path": "/infrastructure/locations/location-name/",
   "access": "READ"
}
```

## Granting Permissions on Security Strategies and Security Policies

A security strategy references a security policy. For more information regarding security strategies and security policies, refer to [About App Security]({{< ref "/controller/app-delivery/security/concepts/what-is-waf.md#security-strategy" >}}).

### Deny by Default

Permissions for security strategies and security policies follow the principle of *Deny by Default*: all access is blocked that has not been expressly permitted. There are a few exceptions:

- By default, all users have `READ` permission for the default strategy (/security/strategy/balanced_default).

- Users do not need permissions to reference a security policy in a security strategy.

### Security Strategies

For a role, you can grant `FULL`, `WRITE`, `READ`, or `NONE` permissions to a security strategy. Each of these options provides the following permissions to the role:

{{<bootstrap-table "table table-striped table-bordered">}}

|Permission|What you can do with this permission|
| --- | --- |
|`READ`|You can view the settings of the security strategy.<br>You can reference the security strategy for an app component.|
|`WRITE`|All that `READ` can do.<br>In addition, you can create or edit the security strategy.|
|`FULL`|All that `WRITE` can do.<br>In addition, you can delete the security strategy.|
|`NONE`|You can view the settings of a security policy.|

{{</bootstrap-table>}}


{{<note>}}When permissions are set to `NONE`:

- You **cannot** view the settings of the security strategy.
- You **cannot** reference the security strategy for an app component.
- You **cannot** create or edit the security strategy.
- You **cannot** delete the security strategy.
{{</ note>}}

### Security Policies

For a role, you can grant `FULL`, `WRITE`, `READ` or `NONE` permissions to a security policy. Each of these options provides the following permissions for the role:

{{<bootstrap-table "table table-striped table-bordered">}}

|Permission|What can you do with this permission|
|--- |--- |
|`READ`|You can view the settings of the security policy.|
|`WRITE`|All that `READ` can do.<br>In addition, you can create or edit the security policy.|
|`FULL`|All that `WRITE` can do.<br>In addition, you can delete the security policy.|
|`NONE`| No permissions.|

{{</bootstrap-table>}}

{{< note >}}You don't need to add permissions to a security policy to reference it in a security strategy.
{{< / note >}}

## Restricting Access to the Default Strategy

The default strategy (`/security/strategies/balanced_default`) is read-only and accessible to all users and roles. To restrict access to the default strategy, create a role and assign `NONE` as the permission for the default strategy, as shown in the following example:

`PUT https://{{host}}/api/v1/platform/roles/defaultStrategy-none`

```nginx
{
    "metadata": {
        "name": "defaultStrategy-none",
        "displayName": "Default Security Strategy - No Access",
        "description": "This role deny users access to the Default Security Strategy"
    },
    "desiredState": {
        "permissions": [
            {
                "path": "/security/strategies/balanced_default",
                "access": "NONE"
            }
        ]
    }
}
```

## Permissions for Predefined Roles

The following table lists the permissions for F5 NGINX Controller’s predefined roles:

{{<bootstrap-table "table table-striped table-bordered">}}

|Predefined Role|Permission|Details|
|--- |--- |--- |
|`admin`|`FULL`|`FULL` permissions for all security strategies and security policies on all environments.|
|`user`|`WRITE`|`WRITE` permissions for all security strategies and security policies on all environments.|
|`guest`|`READ`|`READ` permissions for all security strategies and security policies on all environments.|

{{</bootstrap-table>}}

## RBAC for AppSec Scenario Example

In the following example, we create a role called `devops-role` that we assign to the user `David`. This role gives David the permissions he needs to add WAF to the app component `checkout-component` by referencing the security strategy `sensitive-app-strategy`.

1. An `admin` user creates the role `devops-role`:

    `PUT @ /platform/roles/devops-role`

    ```nginx
    {
      "metadata": {
          "name": "devops-role",
          "displayName": "devops-role",
          "description": "Role for DevOps"
      },
      "desiredState": {
          "permissions": [
              {
                  "path": "/services/environments/env-name/apps/app-name/components/checkout-component",
                  "access": "WRITE"
              },
              {
                  "path": "/services/environments/env-name/gateways/gateway-name",
                  "access": "READ"
              },
              {
                  "path": "/infrastructure/locations/location-name/",
                  "access": "READ"
              },
              {
                  "path": "/security/strategies/sensitive-app-strategy",
                  "access": "READ"
              }
          ]
      }
    }
    ```

2. An `admin` user assigns the `devops-role` role to a user called `David`:

    `PATCH @ /platform/users/david@secured-org.com`

    ```nginx
    {
      "desiredState": {
          "firstName": "david",
          "lastName": "david",
          "email": "david@secured-org.test",
          "roles": [
              {
                  "ref": "/platform/roles/devops-role"
              }
          ]
      },
      "metadata": {
          "name": "david@secured-org.test",
          "tags": [
              "david"
          ]
      }
    }
    ```

3. The user `David` enables WAF on `checkout-component` by referencing `sensitive-app-strategy`:

    `PUT @ /services/environments/env-name/apps/app-name/components/checkout-component`

    ```nginx
    {
      "metadata": {
        "name": "checkout-component",
        "displayName": "checkout-component",
        "tags": []
      },
      "desiredState": {
        "backend": {
          "ntlmAuthentication": "DISABLED",
          "preserveHostHeader": "DISABLED",
          "workloadGroups": {
            "wg": {
              "locationRefs": [
                {
                  "ref": "/infrastructure/locations/location-name"
                }
              ],
              "loadBalancingMethod": {
                "type": "ROUND_ROBIN"
              },
              "uris": {
                "http://192.0.2.0:8080": {
                  "isBackup": false,
                  "isDown": false,
                  "isDrain": false
                },
                "http://192.0.2.1:8080": {
                  "isBackup": false,
                  "isDown": false,
                  "isDrain": false
                }
              }
            }
          }
        },
        "ingress": {
          "gatewayRefs": [
            {
              "ref": "/services/environments/env-name/gateways/gateway-name"
            }
          ],
          "uris": {
            "/checkout": {}
          },
          "clientMaxBodySize": "10m"
        },
        "logging": {
          "accessLog": {
            "state": "DISABLED"
          },
          "errorLog": "DISABLED"
        },
        "security": {
          "strategyRef": {
            "ref": "/security/strategies/sensitive-app-strategy"
          },
          "waf": {
            "isEnabled": true
          }
        }
      }
    }
    ```
