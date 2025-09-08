---
title: NGINX Instance Manager
description: Track and control NGINX Open Source and NGINX Plus instances.
url: /nginx-instance-manager/
nd-landing-page: true
cascade:
  logo: "NGINX-Instance-Manager-product-icon.svg"
---

## About
[//]: # "These are Markdown comments to guide you through document structure. Remove them as you go, as well as any unnecessary sections."
[//]: # "Use underscores for _italics_, and double asterisks for **bold**."
[//]: # "Backticks are for `monospace`, used sparingly and reserved mostly for executable names - they can cause formatting problems. Avoid them in tables: use italics instead."

F5 NGINX Instance Manager gives you a centralized way to manage NGINX Open Source and NGINX Plus instances across your environment. It’s ideal for disconnected or air-gapped deployments, with no need for internet access or external cloud services. Use NGINX Instance Manager to organize and group instances, apply and version configuration files, monitor metrics and logs, and manage certificates securely and efficiently.

NGINX Instance Manager is part of NGINX One, which includes [NGINX One components](#nginx-one-components).

## Featured content
[//]: # "You can add a maximum of three cards: any extra will not display."
[//]: # "One card will take full width page: two will take half width each. Three will stack like an inverse pyramid."
[//]: # "Some examples of content could be the latest release note, the most common install path, and a popular new feature."

{{<card-section showAsCards="true" isFeaturedSection="true">}}
  {{<card title="Deploy in a disconnected environment" titleUrl="/nginx-instance-manager/disconnected" icon="unplug" isFullSize="true">}}
      Run NGINX Instance Manager in air-gapped or offline systems
    {{</card >}}
    {{<card title="Manage NGINX instances" titleUrl="/nginx-instance-manager/nginx-instances" >}}
      Add instances, group them for config reuse, and manage certificates
    {{</card>}}
    {{<card title="Manage NGINX configs" titleUrl="/nginx-instance-manager/nginx-configs" >}}
      Stage, version, and publish configs. Use templates to stay consistent.
  {{</card>}}
{{</card-section>}}

### Set up and configure NGINX Instance Manager

{{<card-section showAsCards="true" >}}
  {{<card title="Administer your platform" titleUrl="/nginx-instance-manager/admin-guide" >}}
      Add licenses, set up user access and roles, and back up your NGINX Instance Manager deployment.
    {{</card>}}
    {{<card title="Configure your system" titleUrl="/nginx-instance-manager/system-configuration/" >}}
      Set platform behavior, enable high availability, and secure traffic. Use Vault and ClickHouse if needed.
  {{</card>}}
{{</card-section>}}


### Monitor and secure your environment

{{<card-section showAsCards="true" >}}
  {{<card title="Monitor metrics and events" titleUrl="/nginx-instance-manager/monitoring/" >}}
      Track performance, system health, and changes using built-in metrics, logs, and the REST API.
    {{</card>}}
    {{<card title="Secure with NGINX App Protect WAF" titleUrl="/nginx-instance-manager/nginx-app-protect/" >}}
      Apply WAF policies and monitor activity from a centralized view.
  {{</card>}}
{{</card-section>}}


### More information

{{<card-section showAsCards="true" >}}
    {{<card title="Deploy in connected environments" titleUrl="/nginx-instance-manager/deploy/">}}
        Install NGINX Instance Manager using Docker, Kubernetes, or traditional infrastructure with internet access.
      {{</ card >}}
      {{<card title="Get to know NGINX Instance Manager" titleUrl="/nginx-instance-manager/fundamentals/">}}
        Check system requirements, explore the dashboard, and learn how to access and use the REST API.
      {{</ card >}}
      {{<card title="View release notes and updates" titleUrl="/nginx-instance-manager/releases/" icon="clock-alert">}}
        Get details on new features, bug fixes, and known issues.
    {{</card>}}
{{</card-section>}}


## NGINX One components
[//]: # "You can add any extra content for the page here, such as additional cards, diagrams or text."

{{< card-section title="Kubernetes Solutions">}}
  {{< card title="NGINX Ingress Controller" titleUrl="/nginx-ingress-controller/" brandIcon="NGINX-Ingress-Controller-product-icon.png">}}
      Kubernetes traffic management with API gateway, identity, and observability features.
    {{</ card >}}
    {{< card title="NGINX Gateway Fabric" titleUrl="/nginx-gateway-fabric/" brandIcon="NGINX-product-icon.png">}}
      Next generation Kubernetes connectivity using the Gateway API.
    {{</ card >}}
  {{</ card-section >}}
  {{< card-section title="Cloud Console Option">}}
    {{< card title="NGINX One Console" titleUrl="/nginx-one/" brandIcon="NGINX-One-product-icon.svg">}}
      Manage, monitor, and secure your NGINX fleet from a centralized web-based interface.
    {{</ card >}}
  {{</ card-section >}}
  {{< card-section title="Modern App Delivery">}}
    {{< card title="NGINX Plus" titleUrl="/nginx/" brandIcon="NGINX-Plus-product-icon-RGB.png">}}
      The all-in-one load balancer, reverse proxy, web server, content cache, and API gateway.
    {{</ card >}}
    {{< card title="NGINX Open Source" titleUrl="https://nginx.org" brandIcon="NGINX-product-icon.png">}}
      The open source all-in-one load balancer, content cache, and web server
    {{</ card >}}
  {{</ card-section >}}
  {{< card-section title="Security">}}
    {{< card title="NGINX App Protect WAF" titleUrl="/nginx-app-protect-waf" brandIcon="NGINX-App-Protect-WAF-product-icon.png">}}
      Lightweight, high-performance, advanced protection against Layer 7 attacks on your apps and APIs.
    {{</ card >}}
    {{< card title="NGINX App Protect DoS" titleUrl="/nginx-app-protect-dos" brandIcon="NGINX-App-Protect-DoS-product-icon.png">}}
      Defend, adapt, and mitigate against Layer 7 denial-of-service attacks on your apps and APIs.
  {{</ card >}}
{{</ card-section >}}
