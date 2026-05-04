---
title: Set up compiler resource pruning
description: Automatically remove unused compiled security resources in F5 NGINX Instance Manager to keep your system clean and efficient.
toc: true
weight: 300
f5-content-type: how-to
f5-product: NIMNGR
f5-summary: >
  Configure F5 NGINX Instance Manager to automatically remove unused compiled security resources to keep the system clean.
  Resource pruning removes compiled bundles such as policies, log profiles, and signature packages that are no longer referenced by any active deployment.
---

You can configure F5 NGINX Instance Manager to automatically remove unused compiled security resources, including:

- Compiled security policies
- Compiled security log profiles
- Attack signatures
- Bot signatures
- Threat campaigns

Only compiled bundles are removed. NGINX Instance Manager does not delete the base definitions for security policies or log profiles.

## Enable compiler resource pruning

1. Log in to the NGINX Instance Manager host using SSH.

1. Open the `/etc/nms/nms.conf` file in a text editor.

1. Update the `policy_manager` section under `integrations` to define time-to-live (TTL) values for each resource type:

    ```yaml
    integrations:
     address: unix:/var/run/nms/integrations.sock
     dqlite:
       addr: 127.0.0.1:7892
     policy_manager:
       # Time to live for attack signatures. If attack signatures exceed their TTL
       # and are not deployed to an instance or instance group, they are deleted from the database.
       # Duration units: seconds (s), minutes (m), or hours (h).
       attack_signatures_ttl: 336h

       # Time to live for compiled bundles, including compiled security policies and log profiles.
       # If a compiled bundle exceeds its TTL and is not deployed to an instance or instance group,
       # it is deleted from the database. The resource definition remains.
       compiled_bundles_ttl: 336h

       # Time to live for bot signatures. If bot signatures exceed their TTL
       # and are not deployed to an instance or instance group, they are deleted from the database.
       # Duration units: seconds (s), minutes (m), or hours (h).
       bot_signatures_ttl: 336h

       # Time to live for threat campaigns. If threat campaigns exceed their TTL
       # and are not deployed to an instance or instance group, they are deleted from the database.
       threat_campaigns_ttl: 1440h

     app_protect_security_update:
       enable: true
       interval: 6
       number_of_updates: 10
    ```

1. Save the file and close the editor.
1. {{< include "nim/waf/restart-nms-integrations.md" >}}

NGINX Instance Manager runs the pruning process at startup and every 24 hours after the `nms-integrations` service starts.