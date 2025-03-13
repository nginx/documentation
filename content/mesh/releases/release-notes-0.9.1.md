---
title: Release Notes 0.9.1
draft: false
toc: true
description: Release information for F5 NGINX Service Mesh, a configurable, low‑latency
  infrastructure layer designed to handle a high volume of network‑based interprocess
  communication among application infrastructure services using application programming
  interfaces (APIs). Lists of new features and known issues are provided.
weight: -901
docs: DOCS-710
type:
- reference
---

## NGINX Service Mesh Version 0.9.1

<!-- vale off -->

This hotfix release resolves an issue affecting version 0.9.0 described below.

**Deploying NGINX Service Mesh v0.9.0 fails when using private registry credentials (23236)**:

  NGINX Service Mesh allows containers to be pulled from private Docker registries. If you're using a Docker registry that requires authentication,  NGINX Service Mesh v0.9.0 will fail to start. A deploy message and error similar to the following is displayed:

  ```plaintext
  Deploying NGINX Service Mesh Control Plane in namespace "<namespace>"...
  Created namespace "nginx-mesh".
  Created SpiffeID CRD.
  Waiting for SPIRE to be running...done.
  Deployed Spire.
  Deployed NATS server.
  Created traffic policy CRDs.
  Deployed Mesh API.
  Deployed Metrics API Server.
  Deployed Prometheus Server nginx-mesh/prometheus.
  Deployed Grafana nginx-mesh/grafana.
  Deployed tracing server nginx-mesh/zipkin.
  All resources created. Testing the connection to the Service Mesh API Server...
  Connection to NGINX Service Mesh API Server failed.
    Check the logs of the nginx-mesh-api container in namespace nginx-mesh for more details.
  ```

  Run `kubectl -n <namespace> get pods` (note: always provide the namespace chosen when running the `deploy` command) to show the `nginx-smi-metrics` Pod. It will display as not ready and a status other than `Running`.

  **Workaround:**

  If you're upgrading, make sure to preserve the configurations saved in the previous upgrade process.

- Remove the failed services:

    ```bash
    nginx-meshctl -n <namespace> remove
    ```

- If this occurred during an upgrade and immediate restoration of service is required before download of the 0.9.1 images, re-deploy with your prior version images. Otherwise move to next step.

    ```bash
    nginx-meshctl -n <namespace> deploy --registry-server <registry-server> --image-tag <tag>
    ```

- Download updated binaries from the [F5 Downloads](https://downloads.f5.com) site.

- Restart the upgrade/deploy process using `--image-tag 0.9.1`.
