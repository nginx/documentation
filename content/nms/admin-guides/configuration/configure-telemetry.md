---
title: "Configure Telemetry"
date: 2023-06-06T15:09:35Z
draft: false
description: ""
# Assign weights in increments of 100
weight: 100
toc: true
tags: [ "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management","security", "analytics"]
doctypes: ["task"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

{{<custom-styles>}}

## Overview

To better inform our product development and assist our users be successful with the NGINX Management Suite, the platform has the ability to send limited data to F5 NGINX to help us better understand usage and adoption of the software. This document outlines what data is sent and why, how to enable or disable it, and how to configure and firewalls to allow data to be passed to F5 NGINX.

## Telemetry Data and Purpose

The NGINX management suite will send a limited number of data points to F5 for analysis. The telemetry data will be associated with the subscription ID from the license applied, but no other identifying information about the management plane, data plane, users, or anything else is included.

Telemetry data will be used to help drive and validate product development decisions ensuring the best outcomes for our users. It will also assist our Customer Success and Support teams ensure our users achieve their goals.

The below table lists the data points captured, what triggers sending them, and the purpose. Additional data points may be added in the future.

{{<bootstrap-table "table table-striped table-bordered">}}
| Data Point            | Triggering Event                            | Purpose |
|--------------------------|------------------------------------|-------|
| Install | The first time the NGINX Management Suite processes are started. | Gauge ease of installation and how long it takes for users to see value from the NGINX Management Suite. |
| Login | When a user authenticates into the NGINX Management Suite. No data about the user is sent, only that a user authenticated and when. | Understand how often users or systems are accessing the NGINX Management Suite. |
| NGINX Management Suite Process Start/Stop | When any of the NMS processes are started or stopped. | Help understand how often users are upgrading or troubleshooting issues with NGINX Management suite. Can aid F5 Support in diagnosing issues with customers. |
| Data Plane Added      | When an NGINX Agent registers with the NGINX Management Suite for the first time. No data about the specific data plane instance is sent, just that an Agent registered. | Understand how often and how many data planes added to NGINX Management Suite. This can help inform our scale and performance targets. Can aid F5 Support in diagnosing issues with customers. |
{{</bootstrap-table>}}

## Enabling and Disabling Telemetry

Once a valid license is applied to the NGINX Management Suite it will attempt to send any of the above data points to F5. It may also send data points captured recently before the license was applied. For example, if you install the NGINX Management Suite and quickly apply the license the Install data point will be sent.

Telemetry can be disabled at any time from the NGINX Management Suite web interface under Settings > License. Additionally, the feature can be disabled from the /license API endpoint. It can be re-enabled from the same places.

## Ensuring connection to F5

Users may need to take additional steps to ensure telemetry is successfully sent to F5.
Please ensure your deployment of NGINX Mangement Suite can reach outbound on the following IP address range on TCP port 443: 

159.60.126.0/25