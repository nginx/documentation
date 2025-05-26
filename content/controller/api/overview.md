---
description: Provides information about the F5 NGINX Controller API.
docs: DOCS-343
layout: docs
title: API Overview
toc: true
weight: 10
type:
- concept
---

## Introduction

The F5 NGINX Controller API is a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) API that allows you to programmatically manage your NGINX Plus data planes.

NGINX Controller follows an "API-first" approach, which means that all NGINX Controller functionality is exclusively exposed through declarative and resource-oriented APIs. Even the user interface (user interface) uses our REST API! You'll find examples of REST request bodies in the user interface. You can rest assured that the example you see is correct, because that is the call that the user interface is going to make to apply your requested configuration.

## Encoding

All NGINX Controller API endpoints expect and return JSON-formatted data by default.
When appropriate, the API accepts and returns other media types, such as file uploads or downloads.

All JSON-formatted data is expected to be encoded using UTF-8 as described by the [IETF JSON Spec](https://tools.ietf.org/html/rfc8259).
If you do not specify a specific media type in an API call, then the API defaults to `"application/json"`. If you specify multiple acceptable media types, the first type that the API supports is chosen for the response. In the event of a request for a media type that the API doesn't support, it returns a "415 Unsupported Media Type" response.

## Object Model

The NGINX Controller API -- as well as the user interface and the product documentation -- is organized into four top-level areas:

- **Analytics**: Enables data visualization for NGINX Controller.
- **Infrastructure**: Lets you manage your NGINX Plus instances and certain aspects of the host machines on which NGINX Controller and NGINX Plus instances run.
- **Platform**: Lets you manage NGINX Controller options and configurations, including Users, Roles, Licenses, and Global Settings.
- **Services**: Lets you manage your applications and APIs.

The diagrams below demonstrate how the different objects at the Service level relate to each other:

1. All Service objects are part of an Environment.
1. Gateways and Certs can be defined at the Environment level --or-- at the Component Level. The diagram below shows an example of how traffic flows through a Gateway to an App.
1. Components are child objects that represent the back-end server(s) that host your App or API.
    {{<note>}}A Component can represent an application **or** an API. The same Component cannot be used for both App Delivery and API Management.{{</note>}}
1. Certs can be added to a Gateway or to an individual Component.

{{< img src="/ctlr/img/services-object-model-example.png" alt="Diagram showing the relationship of objects in an Environment within the Services area." >}}
{{< img src="/ctlr/img/traffic-flow-example-1.png" alt="Example traffic flow through a gateway to app components that represent a back-end application. Certs can be configured at the gateway or at the app component level." >}}

### Permissions

Access to each of these areas is determined by your User Role. Roles grant Users access to specific Environments; Role permission levels define what content you can see ("Read" access) and interact with ("Write" access). Users with Roles that contain "Full" access can interact with all areas.

The diagram below shows a sample System Administrator (or, "SysAdmin") workflow. The SysAdmin user has full administrator permissions, which allows creation of objects in all areas. In this workflow, the SysAdmin user creates an Environment; then creates a Role that has permission to interact with objects in that Environment; and, finally, creates a User. The Role grants the User access to objects in the Environment.

{{< img src="/ctlr/img/netops-workflow.png" alt="Example System Admin workflow" >}}

The diagram below shows a sample deployment workflow. In this workflow, the user - a Deployment Manager - has read and write access to objects in one specific Environment, but no access to other Environments. Within the allowed Environment, the user can create objects or select from objects that were added by a system administrator. In this workflow, the Deployment Manager creates an App and an App Component. Associated objects like Certs and Gateways can be added -- or selected from a list -- when adding the App Component. The configs for load balancing, monitoring, and URI redirects are defined as part of the App Component as well.

{{< img src="/ctlr/img/devops-workflow-simple.png" alt="Example deployment workflow" >}}

{{< see-also >}}

- [Managing Roles & Users]({{< ref "/controller/platform/access-management/manage-users.md" >}})

{{< /see-also >}}

## Authentication

The NGINX Controller API uses session cookies to authenticate requests. The session cookie is returned in response to a `GET /api/v1/platform/login` request. See the Login endpoint in the [NGINX Controller API Reference]({{< ref "/controller/api/_index.md" >}}) documentation for information about session cookie timeouts and invalidation.

{{< tip >}}
You can send a GET request to the login endpoint to find the status of the session token.
{{< /tip >}}

For example:

- Login and capture the session cookie:

  ```curl
  curl -c cookie.txt -X POST --url 'https://198.51.100.10/api/v1/platform/login' --header 'Content-Type: application/json' --data '{"credentials": {"type": "BASIC","username": "arthur@example.net","password": "<password>"}}'
  ```

- Use the session cookie to authenticate and get the session status:

  ```curl
  curl -b cookie.txt -c cookie.txt -X GET --url 'https://198.51.100.10/api/v1/platform/login'
  ```


## Resource Types

The NGINX Controller API contains two types of resources: immediately consistent and eventually consistent.

Immediately consistent resources are synchronous. For these resources, any changes you make will be applied at the time the request is received. Requests to modify state using an API write operation (POST, PUT, PATCH or DELETE) result in the transmitted data being stored by the server as state. There is no need to check for progress, success, or failure using an API read operation (GET) for these resources. The original response should communicate if the request was successful.

Eventually consistent resources are asynchronous. For these resources, any changes you request will be applied over time. Requests to modify state using an API write operation (POST, PUT, PATCH or DELETE) result in the transmitted data being stored by the server and messages or events being generated to eventually apply this state. You may check for progress, success, or failure using an API read operation (GET). The original response communicates that the data resulting in instructions was understood by the system.

## Resource Properties

All NGINX Controller API resources contain the following properties:

```json
{
  "metadata": {
  },
  "desiredState": {
  },
  "currentStatus": {
  }
}
```

The `desiredState` property is a representation of the state that you want to apply to the system. The properties within `desiredState` are the API representation of data. While changes to `desiredState` may trigger eventually consistent operations, the object itself is "immediately consistent". Consumers of the API can "read their own writes" and should always be able to retrieve the current desired state, no matter where the system is in the process of applying the state change.

The `currentStatus` property represents the current state of the system. Its purpose is to communicate the progress of achieving eventual consistency to the API consumer. As such, `currentStatus` is a read-only property.

## Versioning

The introduction of backwards-incompatible changes to the NGINX Controller API constitutes a major version change. This will be represented in the NGINX Controller API version string. For example, to use a `v2` API, you would use `https://<NGINX Controller FQDN>/api/v2`.

When any NGINX Controller component requires a version change, we will release a new version of the entire API. In other words, you won't see a mix of `v1` and `v2` objects in the same API.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
