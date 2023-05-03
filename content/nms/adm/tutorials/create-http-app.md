---
title: Use Case - HTTP Load Balancing
description: Learn how to configure HTTP load balancing between several identical customer apps.
weight: 100
toc: true
draft: false
tags: ["docs"]
docs: "DOCS-1158"
---
## Objective

The App team would like external access to their custom app which has two instances running on their internal network. The external access should use `http://www.acme-app.com`. The two instances of their app are available at the following internal IP addresses:

- http://10.146.191.198:8080
- http://10.146.191.198:8081

### Prerequisites

Several assumption have been made for this use case:

1. The platform team has set up permissions to allow the app team to create any ADM-related resource.
2. The platform team has created an instance group ([How to manage Instance Groups]({{< relref "/nms/nim/how-to/nginx/manage-instance-groups.md" >}})) `acme-ig` for the NGINX instances that will be used to route the traffic to the team's app instances (`workloads` in ADM terminology, which typically map to `upstreams` in NGINX terminology).

## Solution

In the NGINX Management Suite web interface, you access the App Delivery Manager (ADM) features by performing the following operations:

1. Log into the NMS user interface.
2. From the Launchpad, select the `App Delivery Manager` card.

### Create an Environment

The first resource you need to create, if one doesn't already exist, is an Environment resource. This can be accomplished by taking the following steps:

1. Select `Environments` from the `App Delivery Manager` list in the left-hand sidebar. The list of existing environments will then display.
2. Select `Create Environment` on the right-hand side of the list. A panel will appear that allows you to configure the environment.
3. Enter the value `Tutorial Environment` for the `Name` field. You can take the defaults for all the other fields (this exercise does not require customized templates).
4. Select `Submit` to finish creating the environment.

### Create a Gateway

The gateway will describe how traffic will be routed through an NGINX instances to get to the actual app workloads.

1. Select `Gateways` from the `App Delivery Manager` list in the left-hand sidebar. The list of existing gateways will then display.
2. Select `Create Gateway` on the right-hand side of the list. A panel will appear that allows you to configure the gateway.
3. From the `Configuration` page of `Create Gateway`, enter the gateway name as `Acme Gateway`. You can accept  defaults for the next three fields.
4. For the environment field, select the environment `Tutorial Environment` that you previously created.
5. Select `Next` to get to the `Placements` page.
6. The platform team should have created an instance group `acme-ig`. From the `Instance Group Refs` dropdown, select this group. Then click `Done`.
7. Select `Next` to get to the `Hostnames` page.
8. Enter `http://www.acme-app.com` for the `Hostname`, and then click `Done`.
9. Select `Submit` to complete the gateway (if we wanted a secure website, we would have entered a https address and specified the cert to use).

### Create an App

Similar to creating an environment, we will now create an app resource for our acme app. Follow these steps to create the app:

1. Select `Apps` from the `App Delivery Manager` list in the left-hand sidebar. The list of existing apps will then display.
2. Select `Create App` on the right-hand side of the list. A panel will appear that allows you to configure the app.
3. Enter the value `Acme App` for the `Name` field. Select `Tutorial Environment` for the `Environment` field. You can take the defaults for all the other fields.
4. Select `Submit` to finish creating the app.

### Create a Web Component

The app we just created is a wrapper that can be composed of multiple components, each potentially referencing a unique microservice. Since we are deploying a theoretically simple app, we will have only one component. To create this component, perform the following step:

1. You should be on the `App Overview` page at this point. Select the app that was just created in the list.
2. A panel will appear that allows you to view or edit  the app. Select `view`.
3. The main display will now show basic metrics for the app. We are not, at this point, interested in the metrics, but from this page we can create a component. At the top of the page, select `Web Components`.
4. The list of web components will appear, but should be empty. Select `Create Web Component` on the top right-hand side of the display. A panel will appear that allows you to configure the component. There will be several pages of configuration that will need to be performed.
5. On the first page (`Configuration`), enter the value `Acme Component` for the `Name` field.
6. The only other field that needs to be set on this page is the `Gateway Refs` field. Under this field, select `Acme Gateway`. Then click `Next` to advance to the `URIs` page.

7. Enter `/` for the URI (if you are not able to enter a value, click the pencil icon to edit the URI).
8. Click `Next` to proceed to the `Workload Groups` page. In the `Workload Group Name` field, enter `wg1`.
9. In the `Backend Workload URIs` section, enter `http://10.146.191.198:8080`for the `URI` field. Then click `Done`.
10. Select `Add Backend Workload URI` to add another workload. Enter `http://10.146.191.198:8081`for the `URI` field. Then click `Done`.
11. Click `Done` for the overall `Workload Groups` page.
12. Select the `Submit` button to complete the component configuration.

## Resulting NGINX Configuration

When you have completed the configuration from above, if all goes well it will transition into a `Configured` state. If you examine any of the instances that belong to the `acme-ig` instance group, you should see the following configuration:

```nginx
server {
    server_name www.acme-app.com;
    listen 80 ssl;
    status_zone b57757a6-ef8b-3ef0-be2a-067d66360680;
    f5_metrics_marker environment ca6aa2ef-717f-48ab-96d9-fc1b79e3ec43;
    f5_metrics_marker gateway 4b727d89-b15d-45c1-8bf3-8b6a62fda9ac;
    # Generated by web component Acme Component(e0410d7c-d6d4-442d-840f-6d7ad30b5445)
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
    server 10.146.191.198:8080;
    server 10.146.191.198:8081;
}
```
