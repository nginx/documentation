+++
authors = []
categories = ["administration guide"]
date = "2021-04-14T13:32:41+00:00"
description = "Learn how to get more from NGINX App Protect WAF with the NGINX Management Suite Security Monitoring and Instance Manager modules."
doctypes = ["task"]
draft = false
journeys = ["researching", "getting started", "using", "self service"]
personas = ["devops", "netops", "secops", "support"]
roles = ["admin", "user"]
title = "Using NGINX App Protect WAF with NGINX Management Suite"
toc = true
versions = ["4.3"]
weight = 100
docs= "DOCS-1126"

[menu]
  [menu.docs]
    parent = "NGINX App Protect WAF"
    weight = 45
+++


## Overview
NGINX Management Suite provides centralized visibility and configuration management for your NGINX App Protect WAF fleet. 

The NGINX Management Suite Security Monitoring module provides a visualization tool that lets you analyze threats, view protection insights, and identify areas for policy tuning. <br>

The NGINX Management Suite Instance Manager module provides a centralized interface where you can create, modify, and publish policies, attack signatures, and threat campaigns for NGINX App Protect WAF. You can use Instance Manager to deploy configuration updates to one, some, or all of your NGINX App Protect WAF data plane instances simultaneously.  

{{< note >}}NGINX Management Suite does not support the use of NGINX App Protect WAF with NGINX Ingress Controller.{{< /note >}}

Check out the NGINX Solution Blog to learn more about the benefits of using Instance Manager and Security Monitoring with NGINX App Protect WAF: [Why Managing WAFs at Scale Requires Centralized Visibility and Configuration Management](https://www.nginx.com/blog/why-managing-wafs-at-scale-requires-centralized-visibility-and-configuration-management/).


## Installation

To use NGINX App Protect WAF with NGINX Management Suite, complete each of the following tasks in the order shown here.

1. [Install NGINX App Protect WAF](https://docs.nginx.com/nginx-app-protect/admin-guide/install).
2. [Install NGINX Management Suite with the Security Monitoring module](https://docs.nginx.com/nginx-management-suite/admin-guides/installation/on-prem/install-guide/).   
3. [Install the NGINX Agent package](https://docs.nginx.com/nginx-management-suite/security/how-to/set-up-app-protect-instances/#agent-config) from the management plane host to each of the data plane hosts where you have NGINX App Protect installed. 

Once you have completed these steps, you can log in to the NGINX Management Suite user interface and verify that the **Security Monitoring** module is available from the Launchpad. You should be able to view the security monitoring dashboards, but no data will be displayed yet.

## Setup

Next, you will set up the data plane instances for use with the Security Monitoring module. The steps vary depending on your use case. Before you proceed, you need to decide if you want to use only the Security Monitoring module, or if you want to use Security Monitoring with Instance Manager to manage all of your NGINX App Protect WAF configurations.

### Security Monitoring Only

1. Follow the steps to configure [Security Monitoring only](https://docs.nginx.com/nginx-management-suite/security/how-to/set-up-app-protect-instances/#monitor-only) in the Security Monitoring data plane setup guide.
2. Follow the steps in [Grant Users Access to the Security Monitoring Dashboards](https://docs.nginx.com/nginx-management-suite/security/how-to/create-role-security-monitoring/) to allow other users in your organization to access the Security Monitoring Dashboards.

### Security Monitoring with Configuration Management

1. Follow the steps to configure [Security Monitoring with Configuration Management](https://docs.nginx.com/nginx-management-suite/security/how-to/set-up-app-protect-instances/#monitor-and-manage) in the Security Monitoring data plane setup guide.
2. [Install the WAF compiler on the management plane host](https://docs.nginx.com/nginx-management-suite/nim/how-to/app-protect/setup-waf-config-management/#install-the-waf-compiler). 
3. [Set up NGINX Agent for use with Configuration Management](https://docs.nginx.com/nginx-management-suite/nim/how-to/app-protect/setup-waf-config-management/#configure-nginx-agent).
4. Set up [automatic downloads of attack signatures and threat campaigns](https:/docs.nginx.com/nginx-management-suite/nim/how-to/app-protect/setup-waf-config-management/#automatically-download-latest-packages) to keep your protections up-to-date.
5. Follow the steps in [Grant Users Access to the Security Monitoring Dashboards](https://docs.nginx.com/nginx-management-suite/security/how-to/create-role-security-monitoring/) to allow other users in your organization to access the Security Monitoring Dashboards.

You should now be able to view data from your NGINX App Protect WAF instances in the Security Monitoring dashboard.

## Configuration and Instance Management

You can get familiar with the NGINX App Protect WAF features and how to use them in the [Configuration Guide]({{< relref "/configuration-guide/configuration" >}}).

NGINX App Protect WAF's out-of-box default and strict policies are included in Instance Managers WAF Policy Configuration Management feature set. You can use a built-in policy to get up and running, then fine-tune the policy to meet your application's needs.

Instance Manager does not support the following NGINX App Protect WAF features:

- Policies with external references
- Policies with modifications
- Custom signatures
- Custom log profiles; Instance Manager provides the same default log profiles as NGINX App Protect WAF.

When you want to refine your security policies, you can use Instance Manager to easily [add or update WAF configurations](https://docs.nginx.com/nginx-management-suite/nim/how-to/app-protect/setup-waf-config-management/#add-waf-config) and publish updates to your NGINX App Protect WAF instances.
