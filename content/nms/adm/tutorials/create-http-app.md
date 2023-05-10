---
title: Configure HTTP Load Balancing
description: Learn how to configure HTTP load balancing traffic to several instances of an app.
weight: 100
toc: true
draft: false
tags: ["docs"]
docs: "DOCS-1158"
---
## Objective

The App team wants to provide external access to their custom app which has two instances running on their internal network. External access will be provided from http://www.example.com. The two instances of their app are available at the following internal IP addresses:

- http://198.51.100.0:8080
- http://198.51.100.0:8081

### Prerequisites

The environment has been set up as follows for this use case:

- The Platform team has set up NGINX Management Suite permissions to allow the App team to create any App Delivery Manager related resource.
- The Platform team has [created an instance group]({{< relref "/nim/how-to/nginx/manage-instance-groups.md" >}}), **example-ig**, for the NGINX instances that will be used to route the traffic to the team's app instances (workloads, in App Delivery Manager terminology, which typically map to upstreams in NGINX terminology).

## Solution

### How to Access the User Interface

{{< include "adm/tutorials/access-adm-ui" >}}

### Create an Environment

If you haven't already, create an Environment resource by following these steps:

1. Select **Environments** on the **App Delivery Manager** section of the sidebar. The list of existing environments will be displayed.
1. Select **Create Environment**. In the *Create Environment* drawer, type **Tutorial Environment** in the **Name** field. You can leave the default values for all the other fields (Note: This tutorial does not require customized templates).
1. Select **Submit** to create the environment.

### Create a Gateway

The gateway will describe how traffic will be routed through NGINX instances to get to the actual app workloads.

1. Select **Gateways** on the sidebar. The list of existing gateways will be displayed.
1. Select **Create Gateway**. In the *Configuration* section of the *Create Gateway* drawer type **Example Gateway** in the **Name** field.
1. Select **Tutorial Environment** in the **Environment** list.
1. Select **Next** to go to the *Placements* section.
1. In the **Instance Group Refs** list, select **example-ig** (Which was created by the Platform team as part of the prerequisites), then select **Done**.
1. Select **Next** to continue to the *Hostnames* page.
1. Type `http://www.example.com` in the **Hostname** field, and then Select **Done**.
1. Select **Submit** to create the gateway (**Note:** To create a secure website, you would need to type an HTTPS address and specify the cert to use).

### Create an App

Follow these steps to create the app:

1. Select **Apps** on the sidebar. The list of existing apps will be displayed.
1. Select **Create App**.
1. In the *Create App* drawer, type **Example App** in the **Name** field. 
1. Select **Tutorial Environment** in the **Environment** list. You can leave the default values for all the other fields.
1. Select **Submit** to create the app.

### Create a Web Component

The app we just created is a wrapper that can be composed of multiple components, each potentially referencing a unique microservice. For our tutorial, we are deploying a simple app with only one component. To create this component, take the following steps:

1. If you are not on *Apps Overview* page already, select **Apps** on the sidebar. The list of existing apps will be displayed.
1. On the *Overview* page, in the *Name* column, select the **Example App** link in the list of apps.
1. At the top of the page, select **Web Components**.
1. On the *Web Components* page, select **Create Web Component**. 
1. On the *Configuration* section of the *Create Web Component* drawer, type **Example Component** in the **Name** field.
1. In the **Gateway Refs field** list, select **Example Gateway**. 
1. Select **Next** to advance to the *URIs* page.
1. Type **/** in the **URI** field (If you are not able to type a value, select the pencil icon to edit the URI).
1. Select **Next** to continue to the *Workload Groups* page. 
1. Select the **Add Workload Group** button.
1. Type **wg1** in the **Workload Group Name** field.
1. In the **Backend Workload URIs** section, type `http://198.51.100.0:8080` in the **URI** field. Select **Done**.
1. Select **Add Backend Workload URI** to add another workload. Type `http://198.51.100.0:8081` in the **URI** field. Then select **Done**.
1. In the *Workload Groups* page, select **Done**.
1. Select **Submit** to complete the component configuration.

## Resulting NGINX Configuration

After completing the steps above, the web component will transition into a "Configured" state. If you examine any of the instances that belong to the `example-ig` instance group, you will see a configuration similar to the following:

```nginx
server {
    server_name www.example.com;
    listen 80 reuseport;
    status_zone b57757a6-ef8b-3ef0-be2a-067d66360680;
    f5_metrics_marker environment ca6aa2ef-717f-48ab-96d9-fc1b79e3ec43;
    f5_metrics_marker gateway 4b727d89-b15d-45c1-8bf3-8b6a62fda9ac;
    # Generated by web component Example Component(e0410d7c-d6d4-442d-840f-6d7ad30b5445)
    location / {
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host
        proxy_set_header Connection "";
        proxy_http_version 1.1;
        proxy_pass http://wg1_http_e0410d7c-d6d4-442d-840f-6d7ad30b5445;
        # metrics
        f5_metrics_marker app e2f3d17d-929a-4ee0-90b2-55fd96f66dfe;
        f5_metrics_marker component e0410d7c-d6d4-442d-840f-6d7ad30b5445;
    }
}
upstream wg1_http_e0410d7c-d6d4-442d-840f-6d7ad30b5445 {
    zone wg1_e0410d7c-d6d4-442d-840f-6d7ad30b5445 1280K;
    server 198.51.100.0:8080;
    server 198.51.100.0:8081;
}
```
