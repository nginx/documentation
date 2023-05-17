---
title: "Set up some Advanced Routes"
date: 2023-05-02T13:09:51-08:00
# Change draft status to false to publish doc
draft: true
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to create dynamic routes for your deployments using NGINX Management Suite API Connectivity Manager."
# Assign weights in increments of 100
weight: 110
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1218"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["tutorial"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

{{< custom-styles >}}

## Overview

This tutorial will show you how to create dynamic routes for your proxy deployments using the 'Advanced Routing' feature.
This allows routing to different backend services based on URI, HTTP method, etc.

### Intended Audience

This guide is meant for NGINX Management Suite users who can add/modify Proxy deployments and want to create dynamic route matching configurations.

### How do I publish a Proxy with Advanced Routing?

{{< include "how-to/services/publish-api.md" >}}

---

## Use Case

Jane Smith has joined Acme Co. as an API developer for the Product-Search team.
Jane will need to update the current catch-all route to more granular routes to support the new API endpoints she has added to the product.
These endpoints will take a mixture of `Query` parameters, `Path` parameters and `Header` parameters and Jane would like to route to different backend services
based on the routes and also the provided parameters.

### Workflow

In the steps that follow, we will:

- Create an API Gateway proxy to route the traffic to the backend services.
- Add Advanced Routing rules to allow granular control over the traffic based on the passed parameters.

---

## Before You Begin

To complete the instructions in this guide, you need the following:

{{<comment>}}Confirm pre-reqs and add links to topics.{{</comment>}}

- API Connectivity Manager is installed, licensed, and running
- One or more [Service workspaces]({{< relref "acm/how-to/services/publish-api.md#create-a-service-workspace" >}})
- One or more [Proxies]({{< relref "acm/how-to/services/publish-api.md" >}})

---

## Built-In Role

API Connectivity Manager comes pre-configured with an "ACM API Owner" role suitable for API Owners.

- **API Owner**: The individuals or teams who are responsible for designing, creating, and maintaining APIs.

### ACM API Owner {#acm-api-owner}

{{< include "acm/rbac/api-owner-role.md" >}}

---

## Example: Create An Advanced Route

In our Proxy configuration form (found via a Proxy Create or a Proxy Edit), we will select the `Ingress` section in the left menu bar to see the options available to configure our proxy ingress.

On that screen we will be presented with options around `basepath` and `version` and at the bottom of the screen there is an expandable panel to add an `Advanced Route`, let's click the `Add Route` link to continue.

Now, on this screen we can see config options for `Match URI`, `HTTP Method`, `Parameters` and a few others. For the purpose of this example the previous three will be the most pertinent.

In this example we will try to create a route that can take 2 `integer` ID's in the path, e.g. `/customer/123/order/1234`, we will accomplish this by filling in a few parameters as follows:

In `Match URI` we will add the following: `/customer/{customerID}/order/{orderID}`, this sets out our URI with placeholders for the path parameters `customerID` and `orderID`.

In `HTTP Method` we will choose `GET` for this config. The `HTTP Method` parameter allows us to configure which HTTP Method this route will match for, so in this case a `POST` to `/customer/123/order/1234` will not match and will return a `404` (or a `405` depending on your config).
It is also possible to route to different backend services for the same URI but with different HTTP methods. This is accomplished using the `TargetBackendServiceLabel` parameter, which will associate the config to a specific backend service and the `HTTP Method` parameter combination.

In the `Parameters` section, click the `Add Parameter` button to see some new config options:
The `Name` field is the name of the parameter in the URI, this must match the placeholder value provided in `Match URI` (in the UI the validation will show an error if there is a mismatch).
Here we need to add one entry for `customerID` and a new one for `orderID` (click the add parameter button).
The `In` field denotes where the parameter will be passed, the options are: `PATH`, `QUERY`, and `HEADER`.
`QUERY` indicates that the parameter will be passed as a query parameter, e.g. `/customer?customerID=123` and `HEADER` indicates that it will be passed as a header with the `Name` field as the header key.

For this example we will be using `PATH` parameters and we should choose that option.

`Schema Type` is used to define the type of parameter that will be passed, i.e. `STRING`, `INTEGER`, etc.
For this example we will be using `PATH`.

The `Enums` option allows for setting a limited number of options to be allowed to match on and if anything else is passed, it doesn't match.
We won't be using `Enums` for this example.

Now that we have added our route we can hit add `Add` and then on the next page `Save and Publish` and our changes will be deployed and we should now be able to resolve our new endpoint!

---
