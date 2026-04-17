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

Update the Security Monitoring module with the latest geolocation database to keep dashboards accurate.

---

## Before you begin

Before you begin, make sure F5 WAF for NGINX is configured and the Security Monitoring dashboard is collecting security violations.

---

## Update the geolocation database

1. Create a [MaxMind](https://dev.maxmind.com/geoip/geolite2-free-geolocation-data/) account and subscribe to receive updates for the GeoLite2 database.
1. Download the GeoLite2 Country database (Edition ID: GeoLite2-Country) in GeoIP2 Binary `.mmdb` format from the [MaxMind](https://www.maxmind.com/en/accounts/current/geoip/downloads) website. The database is included in a `.gzip` file.
1. Extract the `.gzip` file to access the GeoLite2 Country database file, named `GeoLite2-Country.mmdb`.
1. Replace the existing `GeoLite2-Country.mmdb` file on the NGINX Instance Manager control plane at `/usr/share/nms/geolite2/GeoLite2-Country.mmdb` with the new database:

    ```shell
    sudo scp /path/to/GeoLite2-Country.mmdb {user}@{host}:/usr/share/nms/geolite2/GeoLite2-Country.mmdb
    ```

1. Restart the NGINX Instance Manager services to apply the update:

    ```shell
    sudo systemctl restart nms-ingestion
    sudo systemctl restart nms-core
    ```
