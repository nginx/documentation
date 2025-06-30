---
description: Learn how to create dynamic routes for your deployments using F5 NGINX
  Management Suite API Connectivity Manager.
nd-docs: DOCS-1218
title: Set Up Advanced Routing
toc: true
weight: 110
type:
- tutorial
---

## Overview

This tutorial will show you how to create dynamic routes for your proxy deployments using the 'Advanced Routing' feature.
This allows routing to different backend services based on URI, HTTP method, etc.

### Intended Audience

This guide is meant for NGINX Management Suite users who can add/modify Proxy deployments and want to create dynamic route matching configurations.

### How do I publish a Proxy with Advanced Routing?

Follow the steps on the [Publish an HTTP API]({{< ref "/nms/acm/how-to/services/publish-api.md" >}}) section to publish a proxy.

---

## Use Case

Jane Smith has started a new job as an API developer for the Product-Search team in a hardware manufacturing company.
Jane needs to change the current catch-all route to more granular routes to support the new API endpoints she has added to the product.
These endpoints will take a mixture of `Query`, `Path`,  and `Header` parameters. Jane would like to interact with different backend services based on the routes and parameters provided.

### Workflow

In the steps that follow, we will:

- Create an API Gateway proxy to route the traffic to the backend services.
- Add Advanced Routing rules to allow granular control over the traffic based on the passed parameters.

---

## Before You Begin

To complete the instructions in this guide, you need the following:

- [API Connectivity Manager is installed]({{< ref "/nms/acm/how-to/install-acm.md" >}}), [licensed]({{< ref "/nim/admin-guide/add-license.md" >}}), and running
- One or more [Service workspaces]({{< ref "/nms/acm/how-to/services/publish-api.md#create-a-service-workspace" >}})
- One or more [Proxies]({{< ref "/nms/acm/how-to/services/publish-api.md" >}})

---

## Built-In Role

API Connectivity Manager comes pre-configured with an [ACM API Owner]({{< ref "/nms/acm/tutorials/rbac-api-owners.md" >}}) role suitable for API Owners (The individuals or teams who are responsible for designing, creating, and maintaining APIs).

---

## Example: Create An Advanced Route

In our Proxy configuration form (found via a Proxy Create or a Proxy Edit), we will select the `Ingress` section in the left menu to see the options available to configure our proxy ingress.

Select the **Next** button. On the next screen, we have the options related to `basepath` and `version`. At the bottom of this section, there is an expandable panel to add an `Advanced Route`; select the `Add Route` link to continue.

This section shows several configuration options. For the purpose of this example, we will focus on the following:

- `Match URI`
- `HTTP Method`
- `Parameters`

We are going to create a route that can take two `integer` IDs in the path; for example, `/customer/123/order/1234`. We are going to do this by adding the following parameters:

In the `Match URI` field add the following value: `/customer/{customerID}/order/{orderID}`. This configures our URI with placeholders for the path parameters `customerID` and `orderID`.

Expand the `HTTP Method` menu, and select `GET` for this config. The `HTTP Method` parameter allows us to configure which HTTP Method this route will match for. So in this case, a `POST` to `/customer/123/order/1234` will not match and will return a `404` (or a `405` depending on your config).
You can route to different backend services for the same URI but different HTTP methods using the `TargetBackendServiceLabel` parameter, which will associate the config to a specific backend service and the `HTTP Method` parameter combination.

In the `Parameters` section, select the `Add Parameter` button to see some new config options:

- `Name` is the name of the parameter in the URI; this must match the placeholder value provided in `Match URI` (in the web interface, the validation will show an error if there is a mismatch).
We need to add one entry for `customerID` and another for `orderID` by selecting the `Add Parameter` button again.

The `In` field indicates where the parameter will be passed; the options are `PATH`, `QUERY`, and `HEADER`.

- `PATH` indicates that the parameter will be passed as a path parameter, for example, `/customer/{id}}`.
- `QUERY` indicates that the parameter will be passed as a query parameter, for example, `/customer?customerID=123`.
- `HEADER` indicates that it will be passed as a header with the `Name` field as the header key.

For this example, we will use `PATH` parameters.

`Schema Type` defines the type of parameter that will be passed, for example, `STRING`, `INTEGER`,  and others which are supplied in a dropdown through the UI or in the API documentation if using the API.
For this example, we will be using `INTEGER`.

The `Enums` option lets you limit the number of options to be allowed to match on; if anything else is passed, it doesn't match.
We won't be using `Enums` for this example.

Now that we have added our route, we can select `Add` and `Save and Publish` on the next page. Our changes will be deployed, and we should now be able to resolve our new endpoint!

---
