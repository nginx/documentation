---
# We use sentence case and present imperative tone
title: "Check the health of NGINX Instance Manager"
linkTitle: "Perform a system health check"
# Weights are assigned in increments of 100: determines sorting order
weight: 800
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# NAGENT, NAZURE, NGOOGL, FABRIC, INGRESS, NIMNGR, NONECO, NGPLUS, SOLUTI, F5WAFN, F5DOSN, MISCEL
nd-product: NIMNGR
---

## Overview

You can check the health of each NGINX Instance Manager module individually, or run a script that checks all modules at once. This guide explains both methods.

{{< call-out "note" "New in 2.21.1" >}}
Health monitoring is available in NGINX Instance Manager 2.21.1 and later.

You can use the script as-is or customize it to fit your environment, security needs, and monitoring tools.
{{< /call-out >}}

### Choosing a health check method

- Use the **health check endpoint** to get detailed status information for each module simultaneously.
- Use **individual endpoints** if you want detailed monitoring or alerting per module.
- Use the **aggregator script** for a quick overall status check.
- Combine both approaches for a complete view of system health.

### Before you begin

- Make sure you're running version 2.21.1 or later.
- You'll need access to the system where NGINX Instance Manager is installed.

---

## Option 1: Query the health check endpoint

Each NGINX Instance Manager module exposes a health endpoint that returns basic status information. The health check endpoint provides a summary of the overall health of the NGINX Instance Manager system. It provides the status of all the modules in a single response.

**Endpoint:** `/api/platform/v1/health`

### Example responses

Healthy system (Status 200):

```json
{
   "services": {
      "core": "healthy",
      "dpm": "healthy",
      "ingestion": "healthy",
      "integrations": "healthy",
      "secmon": "healthy"
   },
   "status": "healthy",
   "timestamp": "2026-01-29T10:49:07Z"
}
```

Unhealthy system (Status 502/503/400, and others):

```json
{
   "services": {
      "core": "healthy",
      "dpm": "unhealthy",
      "ingestion": "healthy",
      "integrations": "healthy",
      "secmon": "healthy"
   },
   "status": "unhealthy",
   "timestamp": "2026-01-29T10:49:07Z"
}
```

```json
{
"code": 502,
"message": "Upstream Unavailable"
}
```

## Option 2: Check individual module health

NGINX Instance Manager provides individual health check endpoints for each module. These are not part of the public NGINX Instance Manager REST API. Instead, they are internal liveness probes designed for use in automation, monitoring, and health check scripts.

No authentication is required to access these endpoints.

### Endpoints

| Module       | Endpoint                     | Purpose                                                   |
| ------------ | ---------------------------- | --------------------------------------------------------- |
| Core         | `/api/liveness/core`         | Reports health of the core management service             |
| DPM          | `/api/liveness/dpm`          | Checks status of the Data Plane Manager                   |
| Ingestion    | `/api/liveness/ingestion`    | Confirms the data ingestion and telemetry service is live |
| Integrations | `/api/liveness/integrations` | Verifies the integrations service is available            |
| Secmon       | `/api/liveness/secmon`       | Reports on the security monitoring module                 |

These endpoints return `200 OK` when healthy, or a `4xx` or `5xx` status code when there’s a problem.

### Example commands

Replace `your-nim-host` with the hostname or IP address for your NGINX Instance Manager system.

```shell
curl -k https://your-nim-host/api/liveness/core
curl -k https://your-nim-host/api/liveness/dpm
curl -k https://your-nim-host/api/liveness/integrations
curl -k https://your-nim-host/api/liveness/secmon
curl -k https://your-nim-host/api/liveness/ingestion
```

---

## Option 3: Use the health aggregator script

Use the built-in script to check the status of all modules at once. This script is helpful for basic monitoring.

### Location

The script is installed at:

```shell
/etc/nms/scripts/health-aggregator.sh
```

### Make sure the script is executable

Before you run the script, check that it has execute permissions. If needed, use the following command:

```shell
sudo chmod +x /etc/nms/scripts/health-aggregator.sh
```

You only need to do this once.

### Run the script

#### Use the default (localhost)

```shell
./health-aggregator.sh
```

#### Run the script with a custom host

To check a specific NGINX Instance Manager host, set the `API_BASE` variable. Replace `your-nim-host` with the hostname or IP address for your NGINX Instance Manager system.

```shell
API_BASE="https://your-nim-host" ./health-aggregator.sh
```

---

## Script output

#### Healthy system

```text
Status: healthy
```

#### Unhealthy system

```text
Status: unhealthy (Endpoint https://your-nim-host/api/liveness/ingestion returned HTTP 502)
```

If a module is unhealthy, the message shows which endpoint failed and its HTTP status code.
