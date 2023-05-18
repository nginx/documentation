---
title: "Release Notes"
date: 2022-07-10T12:38:24-08:00
draft: false
description: "These release notes list and describe the new features, enhancements, and resolved issues in NGINX Management Suite App Delivery Manager."
# Assign weights in increments of 100
weight: 1
url: /nginx-management-suite/adm/releases/release-notes/
toc: true
tags: [ "docs" ]
docs: "DOCS-000"
categories: ["release notes"]
---

{{<rn-styles>}}

---

## 4.0.0

May 18, 2023

### App Delivery Manager Trial Download and Installation

For early access to App Delivery Manager, follow the steps in the [prerequisites]({{< relref "/nms/installation/vm-bare-metal/prerequisites.md" >}}) section to download an NGINX Management Suite trial.

Add the NGINX Management Suite and App Delivery Manager repositories to your system:

- **CentOS, RHEL, RPM-based:**

    ```bash
    sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms.repo
    ```

- **Debian:**
        
    ```bash
    printf "deb https://pkgs.nginx.com/nms/debian `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
    printf "deb https://pkgs.nginx.com/adm/debian `lsb_release -cs` nginx-plus\n" | sudo tee -a /etc/apt/sources.list.d/nms.list
    sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
    ```

- **Ubuntu:**

    ```bash
    printf "deb https://pkgs.nginx.com/nms/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nms.list
    printf "deb https://pkgs.nginx.com/adm/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee -a /etc/apt/sources.list.d/nms.list
    sudo wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
    ```

After completing the steps in the the [prerequisites]({{< relref "/nms/installation/vm-bare-metal/prerequisites.md" >}}) section, follow the steps in the [Install or Upgrade App Delivery Manager]({{< relref "/nms/installation/vm-bare-metal/install-adm.md" >}}) guide.

### Licensing

{{< important >}}
You must not use the trial license file available from MyF5. Please use the trial file provided by your sales team instead. 
{{< /important >}}
### Limitations

Trials cannot be combined; for example, you cannot use a trial for Instance Manager and then add a trial for App Delivery Manager

After a trial expires, trials cannot be reused on the same instance.


### What's New

This release introduces the following features:

- Provides an easy-to-use graphical user interface for Application Delivery.

- Introduces [App Delivery Manager abstractions]({{< relref "/nms/adm/about/api-overview.md" >}}) for the configuration and use of NGINX Plus directives:

    - Create and manage production and non-production environments for classes of applications, business units, and development teams. [**Environments**]({{< relref "/nms/adm/about/api-overview.md#environments" >}}) are logical containers used to group Applications, and Gateways into a domain associated with common goals, resource needs, usage constraints, and access controls. Environments typically map closely to organizational boundaries. “Dev” and “prod”.
    - Create and manage [**gateways**]({{< relref "/nms/adm/about/api-overview.md#gateways" >}}), which correspond to server blocks in nginx.conf file, which represents the initial network entry point of application and/or API traffic into an NGINX instance in the traffic data path. You can share the same gateway for both application and API traffic. 
    - Create and manage [**apps**]({{< relref "/nms/adm/about/api-overview.md#apps" >}}) that are logical containers for components.
    - Create and manage [**components**]({{< relref "/nms/adm/about/api-overview.md#components" >}}) that support HTTP and TCP/UDP protocols. Web components correspond to location blocks in nginx.conf. Web i.e. HTTP components allow users to define routing behavior for the URIs under the Apps. Each component can define URIs and specify which FQDNs these need to attach to via Gateway references. Components also allow specifying the Backend and can control the configuration for load balancing traffic to the backend servers. TcpUdp components define stream server blocks. Similar to web components can attach to one or more Gateways.
    - Create and manage [**sites**]({{< relref "/nms/adm/about/api-overview.md#sites" >}}) that allow the grouping of instance-groups by a physical location. Sites provide the ability to load balance to backend servers that are geographically close to the data plane.

- Control the lifecycle of applications across groups of NGINX Plus instances.

- [Apply role-based access controls]({{< relref "/nms/adm/about/rbac-overview.md" >}}) across all App Delivery Manager features to enable users and teams to self-service app delivery needs.

- Monitor HTTP system and traffic metrics at the instance level and view aggregated and near-real-time insights into system and app traffic:
   
   - System Metrics: Average CPU and Average Memory
   - App Metrics: Network Bytes In and Network Bytes Out
   - HTTP Metrics: Total Requests, HTTP 5xx Errors, and HTTP 4xx Errors
   
- Deploy app services for [load balancing HTTP and TCP/UDP applications]({{< relref "/nms/adm/tutorials/create-http-app.md" >}}) and select the appropriate method:

    - Round Robin
    - Least Connections
    - IP Hash
    - Hash
    - Least Time
    - Random

- Unlock the full capability of NGINX [using templates]({{< relref "/nms/adm/about/template-overview.md" >}}). The following template use cases come prebuilt:

    - Enabling cache by configuring proxy_cache_path, split_clients, and map  to improve app performance
    - Add DNS for service discovery
    - Health monitoring of upstreams with health_check and match block
    - Extending listen options for HTTP/2, fastopen, sndbuf, and rcvbuf
    - Modifying headers and configuring rewrites and redirects
    - Configure advanced TLS settings to enable ciphers and protocols for requests to the proxied server

- Ability to [create custom templates]({{< relref "/nms/adm/tutorials/usecase-templates.md" >}}) to use any NGINX Plus directive.

### Known Issues

- You can find information about known issues with App Delivery Manager in the [Known Issues]({{< relref "/nms/adm/releases/known-issues.md" >}}) topic.
