---
title: Create a license Secret
description: "Create and configure a Kubernetes Secret containing the JWT license for F5 NGINX Ingress Controller."
keywords: "NGINX Ingress Controller, license, JWT, Kubernetes Secret, telemetry, subscription"
toc: true
weight: 300
nd-content-type: how-to
nd-product: INGRESS
nd-docs: DOCS-1860
---

## Overview

F5 NGINX Ingress Controller requires a valid JWT to download the container image from the F5 registry. From version 4.0.0, this JWT is also required to run NGINX Plus.

The JWT validates your subscription and reports telemetry data. For internet-connected environments, telemetry is sent automatically to the F5 licensing endpoint. In offline environments, telemetry is routed through [NGINX Instance Manager]({{< ref "/nim/" >}}). By default, usage is reported every hour and whenever NGINX is reloaded.

{{< call-out "note" >}} Read the [subscription licenses topic]({{< ref "/solutions/about-subscription-licenses.md#for-internet-connected-environments" >}}) for a list of IPs associated with F5's licensing endpoint (`product.connect.nginx.com`). {{< /call-out >}}

## Set up your NGINX Plus license

### Download the JWT

{{< include "/nic/installation/download-jwt.md" >}}

### Create the Secret

The JWT needs to be configured before deploying NGINX Ingress Controller. 

It must be stored in a Kubernetes Secret of type `nginx.com/license` in the same namespace as your NGINX Ingress Controller pod(s).

Create the Secret with the following command:

```shell
kubectl create secret generic license-token --from-file=license.jwt=<path-to-your-jwt> --type=nginx.com/license -n <your-namespace>
```

Once created, you can download the `.jwt` file.

{{< include "/nic/installation/jwt-password-note.md" >}}

### Update the Secret

If you've already deployed NGINX Ingress Controller and need to rotate or renew the JWT (for example, when the existing token is about to expire or has been replaced), update the existing Secret in place.

First, take your new JWT license token, and save it to your existing `license.jwt` file.

Next, use the following command to generate the updated Secret manifest and apply it:

```shell
kubectl create secret generic license-token \
--save-config \
--dry-run=client \
--from-file=license.jwt=<new-jwt-file-path> \
--type=nginx.com/license \
-o yaml | \
kubectl apply -f -
```

Notes:
- Replace `license.jwt` on the `--from-file` flag with the path to your renewed JWT file if it's not in the current directory.
- If your Secret resides in a specific namespace, include `-n <your-namespace>` on the `kubectl create secret` command so the generated YAML contains the correct namespace.
- Ensure the Secret name (`license-token` by default) matches the name referenced by your Helm values or Management ConfigMap.
- After the Secret is updated, the mounted Secret volume in the Pod is refreshed automatically by Kubernetes. NGINX Plus applies the updated license automatically. If you do not see the update take effect after a short period, restart the Ingress Controller Pod(s) to force a re-read of the Secret.

### Add the license Secret to your deployment

If using a name other than the default `license-token`, provide the name of this Secret when installing NGINX Ingress Controller:

{{<tabs name="plus-secret-install">}}

{{%tab name="Helm"%}}

Specify the Secret name using the `controller.mgmt.licenseTokenSecretName` Helm value.

For detailed guidance on creating the Management block with Helm, refer to the [Helm installation topics]({{< ref "/nic/install/helm/" >}}).

{{% /tab %}}

{{%tab name="Manifests"%}}

Specify the Secret name in the `license-token-secret-name` Management ConfigMap key.

For detailed guidance on creating the Management ConfigMap, refer to the [Management ConfigMap Resource Documentation]({{< ref "/nic/configuration/global-configuration/mgmt-configmap-resource/" >}}).

{{% /tab %}}

{{</tabs>}}

If you are reporting to the default licensing endpoint, then you can now proceed with [installing NGINX Ingress Controller]({{< ref "/nic/install/" >}}). Otherwise, follow the steps below to configure reporting to NGINX Instance Manager

### Create report for NGINX Instance Manager {#nim}

If you are deploying NGINX Ingress Controller in an "air-gapped" environment you will need to report to [NGINX Instance Manager]({{< ref "/nim/" >}}) instead of the default licensing endpoint.

First, you must specify the endpoint of your NGINX Instance Manager.

{{<tabs name="nim-endpoint">}}

{{%tab name="Helm"%}}

Specify the endpoint using the `controller.mgmt.usageReport.endpoint` helm value.

{{% /tab %}}

{{%tab name="Manifests"%}}

Specify the endpoint in the `usage-report-endpoint` Management ConfigMap key.

{{% /tab %}}

{{</tabs>}}

#### Configure SSL certificates and SSL trusted certificates {#nim-cert}

To configure SSL certificates or SSL trusted certificates, extra steps are necessary.

To use Client Auth with NGINX Instance Manager, first create a Secret of type `kubernetes.io/tls` in the same namespace as the NGINX Ingress Controller pods.

```shell
kubectl create secret tls ssl-certificate --cert=<path-to-your-client.pem> --key=<path-to-your-client.key> -n <Your Namespace>
```

To provide a SSL trusted certificate, and an optional Certificate Revocation List, create a Secret of type `nginx.org/ca` in the Namespace that the NIC Pod(s) are in.

```shell
kubectl create secret generic ssl-trusted-certificate \
   --from-file=ca.crt=<path-to-your-ca.crt> \
   --from-file=ca.crl=<path-to-your-ca.crl> \ # optional
   --type=nginx.org/ca
```

Providing an optional CRL (certificate revocation list) will configure the [`ssl_crl`](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_crl) directive.

{{<tabs name="nim-secret-install">}}

{{%tab name="Helm"%}}

Specify the SSL certificate Secret name using the `controller.mgmt.sslCertificateSecretName` Helm value.

Specify the SSL trusted certificate Secret name using the `controller.mgmt.sslTrustedCertificateSecretName` Helm value.

{{% /tab %}}

{{%tab name="Manifests"%}}

Specify the SSL certificate Secret name in the `ssl-certificate-secret-name` management ConfigMap key.

Specify the SSL trusted certificate Secret name in the `ssl-trusted-certificate-secret-name` management ConfigMap key.

{{% /tab %}}

{{</tabs>}}

Once these Secrets are created and configured, you can now [install NGINX Ingress Controller ]({{< ref "/nic/install/" >}}).

## What’s reported and how it’s protected {#telemetry}

NGINX Plus reports the following data every hour by default:

- **NGINX version and status**: The version of NGINX Plus running on the instance.
- **Instance UUID**: A unique identifier for each NGINX Plus instance.
- **Traffic data**:
  - **Bytes received from and sent to clients**: HTTP and stream traffic volume between clients and NGINX Plus.
  - **Bytes received from and sent to upstreams**: HTTP and stream traffic volume between NGINX Plus and upstream servers.
  - **Client connections**: The number of accepted client connections (HTTP and stream traffic).
  - **Requests handled**: The total number of HTTP requests processed.
- **NGINX uptime**: The number of reloads and worker connections during uptime.
- **Usage report timestamps**: Start and end times for each usage report.
- **Kubernetes node details**: Information about Kubernetes nodes.

### Security and privacy of reported data

All communication between your NGINX Plus instances, NGINX Instance Manager, and F5’s licensing endpoint (`product.connect.nginx.com`) is protected using **SSL/TLS** encryption.

Only **operational metrics** are reported — no **personally identifiable information (PII)** or **sensitive customer data** is transmitted.
