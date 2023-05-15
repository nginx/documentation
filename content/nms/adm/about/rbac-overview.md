---
title: RBAC
description: Learn how role-based access control (RBAC) is applied to the App Delivery Manager (ADM).
weight: 600
toc: true
draft: false
tags: ["docs"]
docs: "DOCS-000"
---

{{< custom-styles>}}

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

## Features

These are the features used by App Delivery Manager for RBAC. Each feature contains one or more objects, which must all be assigned a value before the RBAC system will grant access.

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

## Best Practices

**Getting-Started**.
* Every feature needs values set for each object contained in the feature. So all permissions should explicitly contain values set for each object.

* If a feature references a different object (for example, APP-MANAGEMENT references environments), the permissions for any object referenced should also be granted in the corresponding feature. So if a role is granted access to env1 as an environment within the APP-MANAGEMENT feature, then that role should also be granted access to env1 as an environment within the ENVIRONMENT-MANAGEMENT feature.

* All permissions within a particular feature (for example, ENVIRONMENT-MANAGEMENT) should be granted the same CRUD level of access. So if a particular permission has READ and DELETE access for ENVIRONMENT-MANAGEMENT, all permissions under ENVIRONMENT-MANAGEMENT should have the same READ and DELETE access.

## Example Roles

We recommend configuring roles to limit permissions. An example scenario is detailed below.  For more details on how to assign roles and the special considerations which need to be taken into account when using the user interface (UI) see [Setting up User Roles]({{< relref "/nms/adm/getting-started/roles.md" >}}) section of **Getting-Started**.

### Scenario

Platform Ops wants to deliver a platform, which enables a self-service app delivery model that allows developer teams to work independently to quickly deliver the value of their apps and services to the customer.

They want to enable multiple developers/teams to work on the same nginx.conf file without interfering with each other's work, which means:

* Developers can only access the environments, apps, and components that have been defined in their role.

* Developers can work independently to author different sections within a single nginx.conf file, for example, depending on how the role is configured server, locations, or upstream blocks.

### Short Description of App Delivery Manager Objects

An Environment is a logical container to group gateways and apps. This closely maps to customers' organizational boundaries.

A Gateway represents an entry point for traffic for one or more Apps. Gateway allows users to define the top-level FQDNs under which other apps in the organization reside.

An App is a logical container for components.

Web components allow users to define routing behavior for the URIs under the apps. Each component can define URIs (/sales, /sales-data, etc...) and specify which FQDNs these need to attach to via gateway references. Components also allow specifying the backend and can control the configuration for load balancing traffic to the backend servers.

### Use Case Scenario

The Platform Ops admin wants to enable teams and individuals to self-service their access to services and data so that they can work independently, and complete their jobs quickly while not interfering with the work of others or unintentionally accessing data they have not been explicitly granted access to.

The Enterprise has a single website, `https://www.example.com`. This website serves two apps at the paths`/support` and `/sales`, each of which is owned by different teams. Additionally, there is a dedicated Admin responsible for managing ingress (gateway) to apps and a Read-only role meant for auditing purposes.

### Role Configurations

Details:

* One environment - example-env
* One gateway (server block) - `www.example.com`
* Two Apps (Support and Sales), each with one web component (location blocks) (/support and /sales)
* The website uses HTTPS
* There is one instance group (ig1)
* There is one site (site1)
* Web components report analytics

#### Example-Admin Role

This is a custom role and not the built-in Admin role. This role has full access to all objects. It is used to manage the full lifecycle of all objects and data.

Permissions:

{{<bootstrap-table "table table-striped table-bordered">}}

| Feature                  | CRUD Level         | Objects                   |
| ------------------------ | ------------------ | ------------------------- |
| ENVIRONMENT-MANAGEMENT   | CRUD               | Environments: ALL         |
| GATEWAY-MANAGEMENT       | CRUD               | Environments: ALL <br /> Gateways: ALL |
| APP-MANAGEMENT           | CRUD               | Environments: ALL <br /> Apps: ALL |
| WEB-COMPONENT-MANAGEMENT | CRUD               | Environments: ALL <br /> Apps: ALL <br /> Web Components: ALL |
| SITE-MANAGEMENT          | CRUD               | Sites: ALL                |
| INSTANCE-GROUPS          | CRUD               | Instance Groups: ALL      |
| CERTS                    | CRUD               | Instance Groups: ALL <br /> Systems: ALL |
| ANALYTICS                | CRUD               | N/A                       |

{{</bootstrap-table>}}

<details>
<summary>JSON Roles Request</summary>

```json
{
  "metadata": {
    "displayName": "Example Admin Role",
    "name": "example-admin-role",
    "description": ""
  },
  "roleDef": {
    "permissions": [
      {
        "accessTypes": [
          "CREATE",
          "DELETE",
          "READ",
          "UPDATE"
        ],
        "feature": "ANALYTICS",
        "objects": []
      },
      {
        "accessTypes": [
          "CREATE",
          "DELETE",
          "READ",
          "UPDATE"
        ],
        "feature": "APP-MANAGEMENT",
        "objects": [
          {
            "resource": "Apps",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "All"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "CREATE",
          "DELETE",
          "READ",
          "UPDATE"
        ],
        "feature": "CERTS",
        "objects": [
          {
            "resource": "Instance Groups",
            "values": [
              "00000000-0000-0000-0000-000000000000"
            ]
          },
          {
            "resource": "Systems",
            "values": [
              "00000000-0000-0000-0000-000000000000"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "CREATE",
          "DELETE",
          "READ",
          "UPDATE"
        ],
        "feature": "ENVIRONMENT-MANAGEMENT",
        "objects": [
          {
            "resource": "Environments",
            "values": [
              "All"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "CREATE",
          "DELETE",
          "READ",
          "UPDATE"
        ],
        "feature": "GATEWAY-MANAGEMENT",
        "objects": [
          {
            "resource": "Environments",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Gateways",
            "values": [
              "All"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "CREATE",
          "DELETE",
          "READ",
          "UPDATE"
        ],
        "feature": "INSTANCE-GROUPS",
        "objects": [
          {
            "resource": "Instance Groups",
            "values": [
              "00000000-0000-0000-0000-000000000000"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "CREATE",
          "DELETE",
          "READ",
          "UPDATE"
        ],
        "feature": "SITE-MANAGEMENT",
        "objects": [
          {
            "resource": "Sites",
            "values": [
              "All"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "CREATE",
          "DELETE",
          "READ",
          "UPDATE"
        ],
        "feature": "WEB-COMPONENT-MANAGEMENT",
        "objects": [
          {
            "resource": "Apps",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Web-Components",
            "values": [
              "All"
            ]
          }
        ]
      }
    ]
  }
}
```

</details>

<details>
<summary>UI Roles Setup</summary>

Here is a step by step tutorial for setting up the Example Admin role.

First give CRUD access to ALL environments in ENVIRONMENT-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleAdminEnv.png" alt="Admin ENVIRONMENT-MANAGEMENT" width="75%">}}

Next, give CRUD access to ALL gateways under ALL environments in GATEWAY-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleAdminGateway.png" alt="Admin GATEWAY-MANAGEMENT" width="75%">}}

Next, give CRUD access to ALL apps under ALL environments in APP-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleAdminApp.png" alt="Admin APP-MANAGEMENT" width="75%">}}

Next, give CRUD access to ALL web-components under ALL apps and environments in WEB-COMPONENT-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleAdminWebcomp.png" alt="Admin WEB-COMPONENT-MANAGEMENT" width="75%">}}

Next, give CRUD access to ALL sites in SITE-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleAdminSite.png" alt="Admin SITE-MANAGEMENT" width="75%">}}

Next, give CRUD access to ALL instance groups in INSTANCE-GROUPS.
{{< img src="adm/about/rbac-screenshots/ExampleAdminInstanceManagement.png" alt="Admin INSTANCE-GROUPS" width="75%">}}

Next, give CRUD access to ALL systems and instance groups within CERTS.
{{< img src="adm/about/rbac-screenshots/ExampleAdminCerts.png" alt="Admin CERTS" width="75%">}}

Finally, give CRUD access to ANALYTICS.
{{< img src="adm/about/rbac-screenshots/ExampleAdminAnalytics.png" alt="Admin ANALYTICS" width="75%">}}

</details>

#### Gateway-Admin Role

This role has full access to manage gateway objects, but only Read access to apps and components that use it. Additionally, this role manages the certificates placed on gateways.

{{<bootstrap-table "table table-striped table-bordered">}}

| Feature                  | CRUD Level         | Objects                   |
| ------------------------ | ------------------ | ------------------------- |
| ENVIRONMENT-MANAGEMENT   | READ               | Environments: example-env |
| GATEWAY-MANAGEMENT       | CRUD               | Environments: example-env  <br /> Gateways: ALL |
| APP-MANAGEMENT           | READ               | Environments: example-env <br /> Apps: ALL |
| WEB-COMPONENT-MANAGEMENT | READ               | Environments: example-env <br /> Apps: ALL <br /> Web Components: All |
| SITE-MANAGEMENT          | READ               | Sites: site1              |
| INSTANCE-GROUPS          | READ               | Instance Groups: ig1      |
| CERTS                    | CRUD               | Instance Groups: ig1 <br /> Systems: ALL |
| ANALYTICS                | READ               | N/A                       |

{{</bootstrap-table>}}

<details>
<summary>JSON Roles Request</summary>

```json
{
  "metadata": {
    "displayName": "Example Gateway Admin",
    "name": "example-gateway-admin",
    "description": ""
  },
  "roleDef": {
    "permissions": [
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "ANALYTICS",
        "objects": []
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "APP-MANAGEMENT",
        "objects": [
          {
            "resource": "Apps",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "CREATE",
          "READ",
          "UPDATE",
          "DELETE"
        ],
        "feature": "CERTS",
        "objects": [
          {
            "resource": "Systems",
            "values": [
              "00000000-0000-0000-0000-000000000000"
            ]
          },
          {
            "resource": "Instance Groups",
            "values": [
              "<igUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "ENVIRONMENT-MANAGEMENT",
        "objects": [
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "CREATE",
          "READ",
          "UPDATE",
          "DELETE"
        ],
        "feature": "GATEWAY-MANAGEMENT",
        "objects": [
          {
            "resource": "Gateways",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "INSTANCE-GROUPS",
        "objects": [
          {
            "resource": "Instance Groups",
            "values": [
              "<igUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "SITE-MANAGEMENT",
        "objects": [
          {
            "resource": "Sites",
            "values": [
              "<siteUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "WEB-COMPONENT-MANAGEMENT",
        "objects": [
          {
            "resource": "Apps",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Web-Components",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      }
    ]
  }
}
```

</details>

<details>
<summary>UI Roles Setup</summary>

Here is a step by step tutorial for setting up the Example Admin role.

First give READ access to the example-env environment in ENVIRONMENT-MANAGEMENT.

{{< img src="adm/about/rbac-screenshots/ExampleEnvRead.png" alt="Gateway Admin ENVIRONMENT-MANAGEMENT" width="75%">}}

Next, give CRUD access to ALL gateways under the example-env environment in GATEWAY-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleAdminGateway.png" alt="Gateway Admin GATEWAY-MANAGEMENT" width="75%">}}

Next, give READ access to ALL apps under the example-env environment in APP-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleAppRead.png" alt="Gateway Admin APP-MANAGEMENT" width="75%">}}

Next, give READ access to ALL web-components within ALL apps under the example-env environment.
{{< img src="adm/about/rbac-screenshots/ExampleWebCompRead.png" alt="Gateway Admin WEB-COMPONENT-MANAGEMENT" width="75%">}}

Next, give READ access to site1 within SITE-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleSiteRead.png" alt="Gateway Admin SITE-MANAGEMENT" width="75%">}}

Next, give READ access to the ig1 instance group within INSTANCE-GROUPS.
{{< img src="adm/about/rbac-screenshots/ExampleIGRead.png" alt="Gateway Admin INSTANCE-GROUPS" width="75%">}}

Next, give CRUD access to ALL systems and the ig1 instance group within CERTS.
{{< img src="adm/about/rbac-screenshots/ExampleCertCRUD.png" alt="Gateway Admin CERTS" width="75%">}}

Finally, give READ access to ANALYTICS.
{{< img src="adm/about/rbac-screenshots/ExampleAnalyticsRead.png" alt="Gateway Admin ANALYTICS" width="75%">}}

</details>

#### Support-App Role

This role has access to the environment example-env and the gateway that serves as the ingress point for traffic to `www.example.com`. Additionally, this role has full access rights to the Support app and any referenced component, for example, /support. This role also has access to any traffic metrics for these specific objects. This role should not have access to any other app or components or their data.

{{<bootstrap-table "table table-striped table-bordered">}}

| Feature                  | CRUD Level         | Objects                   |
| ------------------------ | ------------------ | ------------------------- |
| ENVIRONMENT-MANAGEMENT   | READ               | Environments: example-env |
| GATEWAY-MANAGEMENT       | READ               | Environments: example-env  <br /> Gateways: example.com |
| APP-MANAGEMENT           | CRUD               | Environments: example-env <br /> Apps: Support |
| WEB-COMPONENT-MANAGEMENT | CRUD               | Environments: example-env <br /> Apps: Support <br /> Web Components: All |
| SITE-MANAGEMENT          | READ               | Sites: site1              |
| INSTANCE-GROUPS          | READ               | Instance Groups: ig1      |
| CERTS                    | None               | None                      |
| ANALYTICS                | READ               | N/A                       |

{{</bootstrap-table>}}

<details>
<summary>JSON Roles Request</summary>

```json
{
  "metadata": {
    "displayName": "Support App Role",
    "name": "support-app-role",
    "description": ""
  },
  "roleDef": {
    "permissions": [
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "ANALYTICS",
        "objects": []
      },
      {
        "accessTypes": [
          "CREATE",
          "READ",
          "UPDATE",
          "DELETE"
        ],
        "feature": "APP-MANAGEMENT",
        "objects": [
          {
            "resource": "Apps",
            "values": [
              "<supportUID>"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "ENVIRONMENT-MANAGEMENT",
        "objects": [
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "GATEWAY-MANAGEMENT",
        "objects": [
          {
            "resource": "Gateways",
            "values": [
              "<examplecomUID>"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "INSTANCE-GROUPS",
        "objects": [
          {
            "resource": "Instance Groups",
            "values": [
              "<igUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "SITE-MANAGEMENT",
        "objects": [
          {
            "resource": "Sites",
            "values": [
              "<siteUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "CREATE",
          "READ",
          "UPDATE",
          "DELETE"
        ],
        "feature": "WEB-COMPONENT-MANAGEMENT",
        "objects": [
          {
            "resource": "Apps",
            "values": [
              "<supportUID>"
            ]
          },
          {
            "resource": "Web-Components",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      }
    ]
  }
}
```

</details>

<details>
<summary>UI Roles Setup</summary>

Here is a step by step tutorial for setting up the Support App role.

First give READ access to the example-env environment in ENVIRONMENT-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleEnvRead.png" alt="Support ENVIRONMENT-MANAGEMENT" width="75%">}}

Next, give READ access to the example-com gateway under the example-env environment in GATEWAY-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleGatewayRead.png" alt="Support GATEWAY-MANAGEMENT" width="75%">}}

Next, give CRUD access to the Support app within the example-env environment in APP-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleSupportAppCRUD.png" alt="Support APP-MANAGEMENT" width="75%">}}

Next, give CRUD access to ALL web-components within the Support app under the example-env environment in WEB-COMPONENT-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleSupportWebCompCRUD.png" alt="Support WEB-COMPONENT-MANAGEMENT" width="75%">}}

Next, give READ access to site1 within SITE-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleSiteRead.png" alt="Support SITE-MANAGEMENT" width="75%">}}

Next, give READ access to the ig1 instance group within INSTANCE-GROUPS.
{{< img src="adm/about/rbac-screenshots/ExampleIGRead.png" alt="Support INSTANCE-GROUPS" width="75%">}}

Finally, give READ access to ANALYTICS.
{{< img src="adm/about/rbac-screenshots/ExampleAnalyticsRead.png" alt="Support ANALYTICS" width="75%">}}

</details>

#### Sales-App Role

This role has access to the environment example-env and the gateway that serves as the ingress point for traffic to `www.example.com`. Additionally, this role has full access rights to the Sales app and any referenced component, for example, /sales. Additionally, this role has access to any traffic metrics for these specific objects. This role should not have access to any other app or components or their data.

{{<bootstrap-table "table table-striped table-bordered">}}

| Feature                  | CRUD Level         | Objects                   |
| ------------------------ | ------------------ | ------------------------- |
| ENVIRONMENT-MANAGEMENT   | READ               | Environments: example-env |
| GATEWAY-MANAGEMENT       | READ               | Environments: example-env  <br /> Gateways: example.com |
| APP-MANAGEMENT           | CRUD               | Environments: example-env <br /> Apps: Sales |
| WEB-COMPONENT-MANAGEMENT | CRUD               | Environments: example-env <br /> Apps: Sales <br /> Web Components: All |
| SITE-MANAGEMENT          | READ               | Sites: site1              |
| INSTANCE-GROUPS          | READ               | Instance Groups: ig1      |
| CERTS                    | None               | None                      |
| ANALYTICS                | READ               | N/A                       |

{{</bootstrap-table>}}

<details>
<summary>JSON Roles Request</summary>

```json
{
  "metadata": {
    "displayName": "Sales App Role",
    "name": "sales-app-role",
    "description": ""
  },
  "roleDef": {
    "permissions": [
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "ANALYTICS",
        "objects": []
      },
      {
        "accessTypes": [
          "CREATE",
          "READ",
          "UPDATE",
          "DELETE"
        ],
        "feature": "APP-MANAGEMENT",
        "objects": [
          {
            "resource": "Apps",
            "values": [
              "<salesUID>"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "ENVIRONMENT-MANAGEMENT",
        "objects": [
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "GATEWAY-MANAGEMENT",
        "objects": [
          {
            "resource": "Gateways",
            "values": [
              "<examplecomUID>"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "INSTANCE-GROUPS",
        "objects": [
          {
            "resource": "Instance Groups",
            "values": [
              "<igUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "SITE-MANAGEMENT",
        "objects": [
          {
            "resource": "Sites",
            "values": [
              "<siteUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "CREATE",
          "READ",
          "UPDATE",
          "DELETE"
        ],
        "feature": "WEB-COMPONENT-MANAGEMENT",
        "objects": [
          {
            "resource": "Apps",
            "values": [
              "<salesUID>"
            ]
          },
          {
            "resource": "Web-Components",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      }
    ]
  }
}
```

</details>

<details>
<summary>UI Roles Setup</summary>

Here is a step by step tutorial for setting up the Sales App role.

First give READ access to the example-env environment in ENVIRONMENT-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleEnvRead.png" alt="Sales ENVIRONMENT-MANAGEMENT" width="75%">}}

Next, give READ access to the example-com gateway under the example-env environment in GATEWAY-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleGatewayRead.png" alt="Sales GATEWAY-MANAGEMENT" width="75%">}}

Next, give CRUD access to the Sales app within the example-env environment in APP-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleSalesAppCRUD.png" alt="Sales APP-MANAGEMENT" width="75%">}}

Next, give CRUD access to ALL web-components within the Sales app under the example-env environment in WEB-COMPONENT-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleSalesWebCompCRUD.png" alt="Sales WEB-COMPONENT-MANAGEMENT" width="75%">}}

Next, give READ access to site1 within SITE-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleSiteRead.png" alt="Sales SITE-MANAGEMENT" width="75%">}}

Next, give READ access to the ig1 instance group within INSTANCE-GROUPS.
{{< img src="adm/about/rbac-screenshots/ExampleIGRead.png" alt="Sales INSTANCE-GROUPS" width="75%">}}

Finally, give READ access to ANALYTICS.
{{< img src="adm/about/rbac-screenshots/ExampleAnalyticsRead.png" alt="Sales ANALYTICS" width="75%">}}

</details>

#### Read-Only

This role has Read-only access to all objects and data related to example-env.

{{<bootstrap-table "table table-striped table-bordered">}}

| Feature                  | CRUD Level         | Objects                   |
| ------------------------ | ------------------ | ------------------------- |
| ENVIRONMENT-MANAGEMENT   | READ               | Environments: example-env |
| GATEWAY-MANAGEMENT       | READ               | Environments: example-env  <br /> Gateways: ALL |
| APP-MANAGEMENT           | READ               | Environments: example-env <br /> Apps: ALL |
| WEB-COMPONENT-MANAGEMENT | READ               | Environments: example-env <br /> Apps: ALL <br /> Web Components: All |
| SITE-MANAGEMENT          | READ               | Sites: site1              |
| INSTANCE-GROUPS          | READ               | Instance Groups: ig1      |
| CERTS                    | READ               | Instance Groups: ig1 <br /> Systems: ALL |
| ANALYTICS                | READ               | N/A                       |

{{</bootstrap-table>}}

<details>
<summary>JSON Roles Request</summary>

```json
{
  "metadata": {
    "displayName": "Read Only Access",
    "name": "read-only-access",
    "description": ""
  },
  "roleDef": {
    "permissions": [
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "ANALYTICS",
        "objects": []
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "APP-MANAGEMENT",
        "objects": [
          {
            "resource": "Apps",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "CERTS",
        "objects": [
          {
            "resource": "Systems",
            "values": [
              "00000000-0000-0000-0000-000000000000"
            ]
          },
          {
            "resource": "Instance Groups",
            "values": [
              "<igUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "ENVIRONMENT-MANAGEMENT",
        "objects": [
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "GATEWAY-MANAGEMENT",
        "objects": [
          {
            "resource": "Gateways",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "INSTANCE-GROUPS",
        "objects": [
          {
            "resource": "Instance Groups",
            "values": [
              "<igUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "SITE-MANAGEMENT",
        "objects": [
          {
            "resource": "Sites",
            "values": [
              "<siteUID>"
            ]
          }
        ]
      },
      {
        "accessTypes": [
          "READ"
        ],
        "feature": "WEB-COMPONENT-MANAGEMENT",
        "objects": [
          {
            "resource": "Apps",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Web-Components",
            "values": [
              "All"
            ]
          },
          {
            "resource": "Environments",
            "values": [
              "<envUID>"
            ]
          }
        ]
      }
    ]
  }
}
```

</details>

<details>
<summary>UI Roles Setup</summary>

Here is a step by step tutorial for setting up the Read Only role.

First give READ access to the example-env environment in ENVIRONMENT-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleEnvRead.png" alt="Read Only ENVIRONMENT-MANAGEMENT" width="75%">}}

Next, give READ access to ALL gateways under the example-env environment in GATEWAY-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleGatewayRead.png" alt="Read Only GATEWAY-MANAGEMENT" width="75%">}}

Next, give READ access to ALL apps within the example-env environment in APP-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleAppRead.png" alt="Read Only APP-MANAGEMENT" width="75%">}}

Next, give READ access to ALL web-components within ALL apps under the example-env environment.
{{< img src="adm/about/rbac-screenshots/ExampleWebCompRead.png" alt="Read Only WEB-COMPONENT-MANAGEMENT" width="75%">}}

Next, give READ access to site1 within SITE-MANAGEMENT.
{{< img src="adm/about/rbac-screenshots/ExampleSiteRead.png" alt="Read Only SITE-MANAGEMENT" width="75%">}}

Next, give READ access to the ig1 instance group within INSTANCE-GROUPS.
{{< img src="adm/about/rbac-screenshots/ExampleIGRead.png" alt="Read Only INSTANCE-GROUPS" width="75%">}}

Next, give READ access to ALL systems and the ig1 instance group within CERTS.
{{< img src="adm/about/rbac-screenshots/ExampleCertsRead.png" alt="Read Only CERTS" width="75%">}}

Finally, give READ access to ANALYTICS.
{{< img src="adm/about/rbac-screenshots/ExampleAnalyticsRead.png" alt="Read Only ANALYTICS" width="75%">}}

</details>

### Full Access Table

{{<bootstrap-table "table table-striped table-bordered">}}

|Product | Feature                  | Example Admin      | Gateway-Admin     | Support-App    | Sales-App       | Read-Only        |
| ------ | ------------------------ | ------------------ | ----------------- | -------------- | --------------- | ---------------- |
| ADM    | ENVIRONMENT-MANAGEMENT   | CRUD <br /> Environments: ALL | READ <br /> Environments: example-env | READ <br /> Environments: example-env | READ <br /> Environments: example-env | READ <br /> Environments: example-env |
| ADM    | GATEWAY-MANAGEMENT       | CRUD <br /> Environments: ALL <br /> Gateways: ALL | CRUD <br /> Environments: example-env <br /> Gateways: ALL | READ <br /> Environments: example-env <br /> Gateways: example.com | READ <br /> Environments: example-env <br /> Gateways: example.com | READ <br /> Environments: example-env <br /> Gateways: ALL |
| ADM    | APP-MANAGEMENT           | CRUD <br /> Environments: ALL  <br /> Apps: ALL | READ <br /> Environments: example-env  <br /> Apps: ALL | CRUD <br /> Environments: example-env  <br /> Apps: Support | CRUD <br /> Environments: example-env  <br /> Apps: Sales | READ <br /> Environments: example-env  <br /> Apps: ALL |
| ADM    | WEB-COMPONENT-MANAGEMENT | CRUD <br /> Environments: ALL  <br /> Apps: ALL <br /> Web Components: ALL | READ <br /> Environments: example-env  <br /> Apps: ALL <br /> Web Components: ALL | CRUD <br /> Environments: example-env  <br /> Apps: Support <br /> Web Components: ALL | CRUD <br /> Environments: example-env  <br /> Apps: Sales <br /> Web Components: ALL | READ <br /> Environments: example-env  <br /> Apps: ALL <br /> Web Components: ALL |
| ADM    | SITE-MANAGEMENT          | CRUD <br /> Sites: ALL | READ <br /> Sites: site1 | READ <br /> Sites: site1 | READ <br /> Sites: site1 | READ <br /> Sites: site1 |
| IM     | INSTANCE-GROUPS          | CRUD <br /> Instance Groups: ALL | READ <br /> Instance Groups: ig1 | READ <br /> Instance Groups: ig1 | READ <br /> Instance Groups: ig1 | READ <br /> Instance Groups: ig1 |
| IM     | CERTS                    | CRUD <br /> Instance Groups: ALL <br /> Systems: ALL | CRUD <br /> Instance Groups: ig1 <br /> Systems: ALL | None | None | READ <br /> Instance Groups: ig1 <br /> Systems: ALL |
| IM     | ANALYTICS                | CRUD | READ | READ | READ | READ |

{{</bootstrap-table>}}

## Combination Rules

NGINX Management Suite has several permission combination methods, which can be confusing if a user is unaware of them. This document details how RBAC information is combined for this purpose.

{{< note >}} These combination rules document the current behavior, but this behavior is not officially supported and is subject to change. We recommend setting up the roles according to the best practices, which will alleviate much of the confusion around them. {{< /note >}}

### Multiple Permissions on the Same Object are Additive

If a role has multiple permissions for the same feature, the resulting permissions is additive; the user will get access to all objects listed.

In particular, if permissions with "Objects: None" are created along with another permission that sets objects, the resulting access will be all of the allowed objects.

### There can be only one CRUD value for each feature

For a given feature (for example, ENVIRONMENT-MANAGEMENT), there can be only one CRUD level. In particular, the levels will be merged together, so all allowed objects will get the CRUD levels for any object.

#### Example 1

A role gives READ access to env1 and READ, UPDATE, DELETE access to env2. NGINX Management Suite will combine these two permissions, resulting in READ, UPDATE, DELETE access to both env1 and env2.

#### Example 2

A role gives READ access for the All environments object, and CREATE, READ, UPDATE, DELETE access to env1. NGINX Management Suite combines these permissions, resulting in CREATE, READ, UPDATE, DELETE access to All environments (including env1).

### Assigning access to an object in a different feature, adds access to that object within the parent feature

Several features have other objects as part of their permissions schema (for example, the APP-MANAGEMENT permission contains the Environments object). When access is given to that object as part of another feature, the object is added to the relevant feature at the level of the existing permissions.

#### Example 1

A role gives READ access to env1 within the ENVIRONMENT-MANAGEMENT feature. The role also gives READ access to env2 within the APP-MANAGEMENT feature. NGINX Management Suite will combine the permissions and grant READ access in the ENVIRONMENT-MANAGEMENT feature to both env1 and env2.

#### Example 2

A role gives READ and UPDATE access to env1 within the ENVIRONMENT-MANAGEMENT feature. The role also gives READ access to env2 within the APP-MANAGEMENT feature. NGINX Management Suite will combine the permissions and grant READ and UPDATE access within the ENVIRONMENT-MANAGEMENT feature to both env1 and env2. Note that the combination of permissions will not affect the APP-MANAGEMENT feature.

#### Example 3

A role gives READ access to env1 within the ENVIRONMENT-MANAGEMENT feature. The role also gives full CREATE, READ, UPDATE, DELETE access to env2 within the APP-MANAGEMENT feature. NGINX Management Suite will combine permissions and grant READ access in the ENVIRONMENT-MANAGEMENT feature to both env1 and env2. Note that this combination does not affect the APP-MANAGEMENT feature.

### Customer Cases

Here are a few examples of possible customer cases to demonstrate what is possible and what is not possible with this RBAC system

#### Case 1: Separate Prod and Dev roles

**A customer has two environments, Prod and Dev, and wants to separate roles that are allowed to edit objects in each of these environments. Can they do this?**

Yes. By selecting only the Prod environment object in each permission feature when creating the role for Prod users and selecting only the Dev environment in each permission feature when creating the role for the Dev users, the customer can get this separation of permissions. As long as users are only assigned only one Prod or Dev role, they will not have access to objects in both environments.

{{<bootstrap-table "table table-striped table-bordered">}}

| Users Role       | Access to Prod environments | Access to Dev environments |
| ---------------- | --------------------------- | ------------------- |
| Prod role        | READ, UPDATE                | None                |
| Dev role         | None                        | READ, UPDATE              |
| Both Prod and Dev roles | READ, UPDATE         | READ, UPDATE |

{{</bootstrap-table>}}

#### Case 2: Separate Prod role, Dev role with only read access to Prod

**A customer has two environments, Prod and Dev, and wants separate roles which are allowed to edit objects in each of these environments. In addition, the customer wants to allow the users that can edit objects in the Dev environment to see (but not edit) objects in the Prod environment. Can they do this?**

This is currently not possible with the current RBAC implementation. Since giving edit access to the Dev environment objects would give at least UPDATE access to those features, the combination rules would also give UPDATE access to those features within the Prod environment. So, the customer would need to decide between allowing the user to edit objects in the Prod environment or not allowing the user to see objects in the Prod environment.

{{<bootstrap-table "table table-striped table-bordered">}}

| Users Role          | Access to Prod environments | Access to Dev environments |
| ------------------- | --------------------------- | -------------------------- |
| Prod Read-Only role | READ                        | None                       |
| Dev role            | None                        | READ, UPDATE               |
| Both Prod Read-Only and Dev roles | READ, UPDATE  | READ, UPDATE               |

{{</bootstrap-table>}}

#### Case 3: Dev role, user can edit Apps and Web Components, but only read Gateways

**Within the customer’s Dev environment, they want a role where a user can edit Apps and Web Components, but only read Gateways. Can they do this?**

Yes, since combination only occurs between the same features, the customer can assign READ and UPDATE to APP-MANAGEMENT and WEB-COMPONENT-MANAGEMENT and only READ access to GATEWAY-MANAGEMENT without any subsequent combination.

## FAQ

1. I set the object permissions, but whenever the user tries to access the object, they get a 403 error code. What should I do?
   1. First, check that appropriate permissions exist for all parent objects (e.g. environments). A common mistake is to just set permissions for the object itself without giving permissions for the parent object. Also, if the permissions were changed recently, you may need to wait up to ten minutes or restart the ADM service in order for the permission cache to update and reflect the new permissions.
2. I changed the name of an object, but the permissions don’t seem to be updating to reflect the name change. Is this a problem?
   1. No, permissions are based on the UID of the object, so the permissions will correctly handle the object regardless of how the name changes. However, if there is a need to make the permissions update to match the name, edit the adc.conf to set `send_rbac_data=true` then restart the ADM module and this will resend all permissions and update the values. (It is recommended to set the `send_rbac_data=false` parameter back to false after completing this step).
3. A user has CREATE permissions for a specific object (e.g. CREATE permissions for `env1|f114ff25-0708-46f5-8f7c-efe8d564ec25`). Why aren’t they able to create objects?
   1. Permissions for specific objects are only relevant for targeting objects with that specific UID. So setting CREATE permission for a specific object would only allow the user to create an object with that specific UID, which is not valid. In order to allow a user to successfully create, they must have `ALL` permission for that object. It is recommended that permissions on parent objects be restricted if it is desired for a user to create objects while not having full access.
4. Why does a GET request sometimes return 200 when a user does not have permissions, when all other requests return a 403?
   1. The behavior of the READ permission on a request to the base endpoint is a little bit different than other requests. Instead of always returning a 403, we filter out any objects that the user does not have access to and return a 200. When the user does not have any access, this can result in an empty list with a 200 return code.
