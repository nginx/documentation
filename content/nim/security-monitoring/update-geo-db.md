---
title: Update the geolocation database used in dashboards
weight: 400
toc: true
nd-content-type: how-to
nd-product: NIMNGR
nd-docs: DOCS-1108
---

## Overview

The Security Monitoring module tracks security violations on F5 WAF for NGINX instances. It uses MaxMind's GeoLite2 Free Database to provide geolocation data in analytics dashboards.

Follow these steps to update the Security Monitoring module with the latest geolocation database so your dashboards show accurate geolocation data.

---

## Before you begin

Make sure you have the following:

- F5 WAF for NGINX is set up, and the Security Monitoring dashboard is collecting security violations.

---

## Update the geolocation database

1. Create a [MaxMind](https://dev.maxmind.com/geoip/geolite2-free-geolocation-data/) account and subscribe to receive updates for the GeoLite2 database.
1. Download the GeoLite2 Country database (Edition ID: GeoLite2-Country) in GeoIP2 Binary `.mmdb` format from the [MaxMind](https://www.maxmind.com/en/accounts/current/geoip/downloads) website. The database is included in a `.gzip` file.
1. Extract the `.gzip` file to get the GeoLite2 Country database file, `GeoLite2-Country.mmdb`.
1. Copy the new `GeoLite2-Country.mmdb` file to `/usr/share/nms/geolite2/GeoLite2-Country.mmdb` on the NGINX Instance Manager control plane, replacing the existing file:

    ```shell
    sudo scp /path/to/GeoLite2-Country.mmdb {user}@{host}:/usr/share/nms/geolite2/GeoLite2-Country.mmdb
    ```

1. Restart the NGINX Instance Manager services to apply the update:

    ```shell
    sudo systemctl restart nms-ingestion
    sudo systemctl restart nms-core
    ```
