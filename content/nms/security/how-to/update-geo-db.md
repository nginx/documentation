---
title: "Update Geolocation Database used in Security Monitoring Dashboards"
date: 2023-01-16T14:23:27-08:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to update the Geolocation Database used in NGINX Management Suite Security Monitoring dashboards."
# Assign weights in increments of 100
weight: 200
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-1108"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "waf", "security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

{{< shortversions "1.0.0" "latest" "secvers" >}}



## Overview

You can use NGINX Management Suite Security Monitoring to monitor NGINX App Protect WAF instances. The Security Monitoring analytics dashboard uses MaxMind's GeoLite2 Free Database to provide extra Geolocation data for Security Violations.

By completing the steps in this topic, you will be able to update the Security Monitoring module to get the latest Geolocation database such that the dashboards can provide accurate data.

## Before You Begin

Complete the following prerequisites before proceeding with this guide: 

- NGINX Management Suite Security Monitoring is [installed]({{< relref "/nms/installation/vm-bare-metal/_index.md#install-nms-modules" >}}) and running. 
- NGINX App Protect is configured, and the Security Monitoring dashboard is gathering security violations

## How to update Geolocation Database

1. Create a [MaxMind](https://dev.maxmind.com/geoip/geolite2-free-geolocation-data/) account and subscribe to get the latest updates to the Geolocation database.
1. Download the GeoLite2 Country (Edition ID: GeoLite2-Country) database in a GeoIP2 Binary `.mmdb` format from the [MaxMind](https://www.maxmind.com/en/accounts/current/geoip/downloads) website. The database will be present in a `gzip` downloaded file.
1. Unzip the downloaded `gzip` file, which contains the binary data of the GeoLite2 Country database with a filename `GeoLite2-Country.mmdb`
1. Replace the `GeoLite2-Country.mmdb` present on your NGINX Management Suite's Control Plane at `/usr/share/nms/geolite2/GeoLite2-Country.mmdb` with the newly downloaded GeoLite2 Country database.

    Example:

    ```bash
    sudo scp /path/to/GeoLite2-Country.mmdb {user}@{host}:/usr/share/nms/geolite2/GeoLite2-Country.mmdb
    ```

1. Restart the NGINX Management Suite services

    ```bash
    sudo systemctl restart nms-ingestion
    sudo systemctl restart nms-core
    ```
