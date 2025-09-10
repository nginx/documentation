---
title: Secure Mesh Traffic using mTLS
toc: true
description: Learn about the mTLS options available in F5 NGINX Service Mesh.
weight: 30
nd-docs: DOCS-696
type:
- how-to
---

## Overview

TLS authentication is ubiquitous. Because of the baseline level of security TLS provides the client when connecting to an unknown host, and the low barrier to entry created by the advent of services like Let's Encrypt, TLS has become table stakes for any moderately reputable website. In a microservices, multi-tenant Kubernetes environment, it is no longer sufficient for a client to authenticate a server's signature. Clients may be compromised, and in a tightly controlled environment such as a service mesh, it is paramount that clients get vetted to ensure they should be making requests to any particular server. F5 NGINX Service Mesh does this authentication through mTLS, and provides the ability to define [Access Control policies]( {{< ref "/mesh/guides/smi-traffic-policies.md#access-control" >}}) for the additional authorization piece needed to properly grant access to an incoming request from a given client. This document details the steps required to enable mTLS in your cluster using NGINX Service Mesh.

{{< call-out "important" >}}
NGINX Service Mesh does not support mTLS communication with UDP at this time. UDP datagrams are currently proxied over plaintext.
{{< /call-out >}}

Within the mTLS umbrella, NGINX Service Mesh allows for some level of configurability. This allows the flexibility to better support testing, development, and production environments. The options available are:

- `off`: Disables mTLS between injected pods, and allows communication from any source or destination over plaintext. Suitable only for development environments.

- `permissive` (default): Enables mTLS communication between injected pods, but also allows plaintext communication where mTLS cannot be established. While this provides flexibility in communicating to services outside of the mesh, it also means pods remain open for potential bad actors from unverified sources to gain access to an internal endpoint.

  Permissive mode can be appealing when first experimenting with NGINX Service Mesh because of the ease of setup in deploying your application, but we strongly suggest that you move to mTLS `strict` mode when evaluating NGINX Service Mesh for production scenarios.

- `strict`: Production ready. All traffic between pods is encrypted, and only traffic destined for injected pods is supported. All other outgoing and incoming traffic is denied at the sidecar. See [Sidecar Proxy Injection]( {{< ref "/mesh/guides/inject-sidecar-proxy" >}}) for more information on properly injecting your applications for use within the mesh.

  If you need to route traffic to a non-meshed service in a `strict` environment, see our guide on [using the NGINX Ingress Controller for egress traffic]( {{< ref "/mesh/tutorials/kic/egress-walkthrough.md" >}} ). This can be useful when migrating legacy applications. Also, see [Deploy with NGINX Plus Ingress Controller]( {{< ref "/mesh/tutorials/kic/deploy-with-kic.md" >}}) for information on how to get external traffic routed securely to resources managed by NGINX Service Mesh.

  {{< call-out "important" >}}
Due to how tracing is set up within NGINX Service Mesh, mTLS `strict` mode does not support tracing originating from the application itself. Each mesh sidecar automatically logs request information and aggregates that information in the configured tracing application. See [Monitoring and Tracing]( {{< ref "/mesh/guides/monitoring-and-tracing.md" >}} ) for more information on how tracing is set up within NGINX Service Mesh.
  {{< /call-out >}}

All Kubernetes Resources that use the NGINX Service Mesh sidecar proxy inherit their mTLS settings from the global configuration.
You can override the global setting for individual Resources if needed. Refer to [Change the mTLS Settings for a Resource](#change-the-mtls-setting-for-a-resource) for instructions.

## Usage

### Enable mTLS

When deploying NGINX Service Mesh with mTLS enabled, you can opt to use `permissive` or `strict` mode. The default setting for mTLS is `permissive`.

{{< call-out "caution"  >}}
Using permissive mode is not recommended for production deployments.
{{< /call-out >}}

To enable mTLS, specify the `--mtls-mode` flag with the desired setting when deploying NGINX Service Mesh. For example:

```bash
nginx-meshctl deploy ... --mtls-mode strict
```

### Deploy Using an Upstream Root CA

By default, deployments with mTLS enabled use a self-signed root certificate. For testing and evaluation purposes this is acceptable, but for production deployments you should use a proper Public Key Infrastructure (PKI).

SPIRE uses a mechanism called "Upstream Authority" to interface with PKI systems. In order to use an upstream authority, a user must provide the proper configuration and credentials so that SPIRE may interface with the upstream and obtain the pertinent certificates.

In order to use a proper PKI, you must first choose one of the upstream authorities NGINX Service Mesh supports:

- [disk](https://github.com/spiffe/spire/blob/v1.0.0/doc/plugin_server_upstreamauthority_disk.md): Requires certificates and private key be on disk.
  - Template: {{< icon "download" >}} {{< link "/examples/upstream-ca/disk.yaml" "disk.yaml" >}}

  - The minimal configuration to successfully deploy the mesh using the `disk` upstream authority looks like this:

    ```yaml
    apiVersion: v1
    upstreamAuthority: disk
    config:
        cert_file_path: /path/to/rootCA.crt
        key_file_path: /path/to/rootCA.key
    ```

- [aws_pca](https://github.com/spiffe/spire/blob/v1.0.0/doc/plugin_server_upstreamauthority_aws_pca.md): Uses [Amazon Certificate Manager Private Certificate Authority (ACM PCA)](https://docs.aws.amazon.com/acm-pca/latest/userguide/PcaWelcome.html) to manage certificates.
  - Template: {{< icon "download" >}} {{< link "/examples/upstream-ca/aws_pca.yaml" "aws_pca.yaml" >}}

  - Here is the minimal configuration to deploy the mesh using the `aws_pca` upstream authority:

    ```yaml
    apiVersion: "v1"
    upstreamAuthority: "aws_pca"
    config:
        region: "us-west-2"
        certificate_authority_arn: "arn:aws:acm-pca::123456789012:certificate-authority/test"
    ```

  {{< call-out "important" >}}
  This configuration assumes that the SPIRE server has access to your certificate authority in ACM PCA. See below for details on how to configure access.
  {{< /call-out >}}

    In order to use the `aws_pca` plugin, you need to give the SPIRE server access to your ACM PCA certificate authority.

    If you'd like NGINX Service Mesh to configure authentication on your behalf, you must specify your AWS Access Key ID and AWS Secret Key in the `aws_pca` config file. NGINX Service Mesh will create an AWS shared credentials file with these credentials, encode and store this file in a Kubernetes Secret, and then mount the secret to `~/.aws/credentials` on the SPIRE server Pod(s).

    If you would like the SPIRE server to use an IAM role to access your certificate authority, make sure your role contains the policy described in the [SPIRE `aws_pca` documentation](https://github.com/spiffe/spire/blob/v1.0.0/doc/plugin_server_upstreamauthority_aws_pca.md), and do one of the following:
  - Attach the IAM role to your EC2 instances where NGINX Service Mesh is running.
  - Tell SPIRE to assume the IAM role by specifying the role ARN in the `assume_role_arn` field in the `aws_pca` config file.

  {{< call-out "note" >}}
  The SPIRE server will need permission to assume this IAM role. Either attach an IAM role to the EC2 instance with the capability to assume the ACM PCA IAM role, or provide your AWS credentials in the `aws_pca` config file.
  {{< /call-out >}}

- [awssecret](https://github.com/spiffe/spire/blob/v1.0.0/doc/plugin_server_upstreamauthority_awssecret.md): Loads CA credentials from AWS SecretsManager.
  - Template: {{< icon "download" >}} {{< link "/examples/upstream-ca/awssecret.yaml" "awssecret.yaml" >}}

  - Here is the minimal configuration to deploy the mesh using the `awssecret` upstream authority:

    ```yaml
    apiVersion: "v1"
    upstreamAuthority: "awssecret"
    config:
        region: "us-west-2"
        cert_file_arn: "arn:aws:acm-pca::123456789012:certificate-authority/test"
        key_file_arn: "arn:aws:acm-pca::123456789012:certificate-authority/test-key"
    ```

  {{< call-out "important" >}}
  AWS credentials may be necessary depending on your situation. View the [SPIRE guide](https://github.com/spiffe/spire/blob/v1.0.0/doc/plugin_server_upstreamauthority_awssecret.md).
  {{< /call-out >}}

- [vault](https://github.com/spiffe/spire/blob/v0.12.3/doc/plugin_server_upstreamauthority_vault.md): Uses Vault PKI Engine to manage certificates.
  - Template: {{< icon "download" >}} {{< link "/examples/upstream-ca/vault.yaml" "vault.yaml" >}}

- [cert-manager](https://github.com/spiffe/spire/blob/v1.0.0/doc/plugin_server_upstreamauthority_cert_manager.md): Uses an instance of `cert-manager` running in Kubernetes to request intermediate signing certificates for SPIRE server.
  - Template: {{< icon "download" >}} {{< link "/examples/upstream-ca/cert-manager.yaml" "cert-manager.yaml" >}}

  - Here is the minimal configuration to deploy the mesh using the `cert-manager` upstream authority:

    ```yaml
    apiVersion: "v1"
    upstreamAuthority: "cert-manager"
    config:
      namespace: "my-cert-namespace"
      issuer_name: "my-spire-issuer-name"
    ```

For a production deployment, you should provide the following:

- `rootCA.crt` - A root CA certificate
- `rootCA.key` - A root CA certificate key
- `intermediateCA.crt` - An intermediate CA certificate (optional)
- `intermediateCA.key` - An intermediate CA certificate key (optional)

For a production deployment, you should use an intermediate CA certificate instead of using the root CA certificate directly. In this case, you would specify the root CA certificate using the appropriate option for the upstream authority:

- disk: `bundle_file_path`
- aws_pca: `supplemental_bundle_path`

This keeps the root CA key secure because it adds the certificate, not the key itself, to the chain. The upstream bundle may contain multiple intermediate certificates, all the way up to the root CA.

For example, a production deployment using the `disk` upstream authority will look something like this:

```yaml
apiVersion: "v1"
upstreamAuthority: "disk"
config:
    cert_file_path: "/path/to/intermediateCA.crt"
    key_file_path: "/path/to/intermediateCA.key"
    bundle_file_path: "/path/to/rootCA.crt"
```

To deploy using one of these upstream authorities, you must specify the `--mtls-upstream-ca-conf` flag:

```bash
nginx-meshctl deploy ... --mtls-upstream-ca-conf /path/to/upstream_authority.yaml
```

To find out more about how `nginx-meshctl` interprets the upstream authority configuration, refer to the [Upstream CA Validation JSON schema](https://github.com/nginxinc/nginx-service-mesh/blob/main/api/upstream-ca-validation.json)

#### Pathlen

x509 certificates have a [pathlen field](https://www.rfc-editor.org/rfc/rfc5280#section-4.2.1.9) that is used to limit the number of intermediate certificates in between the current certificate and the final endpoint certificate, not including the endpoint certificate.

SPIRE creates a certificate for itself using the intermediate certificate passed in using the arguments defined above, so the `pathlen` must be either set to 1 or unset. For the root certificate, the pathlen must be at least 2, or unset.

### Choose a SPIRE Key Manager Plugin

SPIRE maintains a set of keys to sign certificates. NGINX Service Mesh supports two methods of storing those keys: `disk` and `memory`.

- `disk` (default): Signing keys are kept on disk and recoverable in the case of a SPIRE server restart, but keys are vulnerable due to being kept on disk.

  {{< call-out "note" >}}
  The `disk` key manager plugin only maintains the integrity of the SPIRE CA if persistent storage is being used. For most environments, persistent storage will be deployed by default. See [Persistent Storage]( {{< ref "/mesh/get-started/platform-setup/persistent-storage.md" >}} ) setup page for more information on configuring persistent storage in your environment.
  {{< /call-out >}}

- `memory`: Maintains the set of signing keys in memory and out of reach from bad actors should they gain access to your SPIRE server, but keys are lost on SPIRE server restart.

  We recommend that you only use the `memory` key manager plugin when you are using an upstream CA. Otherwise, when the SPIRE Server restarts due to a failure, all agents must be manually restarted and all workload certificates must be re-minted and re-distributed - causing unnecessary load on your resources and a potential disruption to workload communication.

There are benefits and drawbacks to both key manager plugins, but we recommend using the `memory` key manager alongside an upstream CA for a more secure production experience. When paired with an upstream CA, the drawbacks of the `memory` key manager can be eliminated. For more information on productionizing your deployment, see our [Production Tuning]( {{< ref "/mesh/guides/production-tuning.md" >}}) guide.

### Change the mTLS Setting for a Resource

NGINX Service Mesh provides you the ability to modify the global mTLS setting on a per-resource basis. This allows you to patch individual resources with mTLS `strict` mode as you begin to properly secure your application.

When configuring mTLS for resources, if your global mTLS mode is `strict`, you will not be able to modify the mode on a per resource basis. The reason for this is that we want to push users towards the most secure deployment possible when evaluating mTLS `strict` mode and production. Also if an admin configures `strict` mTLS mode globally, it will prevent the Application Developer persona from modifying NGINX Service Mesh's security settings on an ad hoc basis and potentially introducing security holes. We do provide the ability to communicate with non-meshed services using the [NGINX Ingress Controller for egress traffic]( {{< ref "/mesh/tutorials/kic/egress-walkthrough.md" >}} ). If not all of your application components are ready for `strict` mode, we encourage the use of `permissive` mode and a non-production environment.

{{< call-out "important" >}}
If the global mTLS value is set to `strict`, then the annotation value will be ignored.
{{< /call-out >}}

To override the global mTLS setting for a specific resource, add an annotation to the resource's PodTemplateSpec. For example:

```yaml
config.nsm.nginx.com/mtls-mode: "strict"
```

### Disable mTLS

To disable mTLS globally, specify the `--mtls-mode off` flag when deploying NGINX Service Mesh. For example:

```bash
nginx-meshctl deploy ... --mtls-mode off
```

To disable mTLS for a specific resource, add the following annotation to the resource's PodTemplateSpec:

```yaml
config.nsm.nginx.com/mtls-mode: "off"
```

{{< call-out "note" >}}
Refer to [NGINX Service Mesh Annotations]( {{< ref "/mesh/get-started/install/configuration.md#pod-annotations" >}}) for more information.
{{< /call-out >}}

{{< call-out "note" >}}
[How to update mTLS settings after deployment.](#update-mtls-settings-after-deployment)
{{< /call-out>}}

## Verify Deployment

NGINX Service Mesh deploys additional pods in the configured control plane namespace (default `nginx-mesh`) for the SPIRE Server and Agent.

To verify deployment, check whether or not the SPIRE Pods are running. You should have a single Server Pod and an Agent Pod for each Kubernetes Node.

```bash
kubectl get pods -n nginx-mesh
NAME                READY   STATUS    RESTARTS   AGE
...
spire-agent-mb9jv   1/1     Running   0          24h
spire-server-0      2/2     Running   0          24h
...
```

### Verify Encryption by Using an Example Service

We'll use the [Istio `bookinfo`](https://istio.io/docs/examples/bookinfo/) example to test that traffic is, in fact, encrypted with mTLS enabled.

- {{< icon "download" >}} {{< link "/examples/bookinfo.yaml" "`bookinfo.yaml`" >}}

1. Enable [automatic sidecar injection]( {{< ref "/mesh/guides/inject-sidecar-proxy.md#automatic-proxy-injection" >}} ) for the `default` namespace.
1. Deploy the `bookinfo` application:

    ```bash
    kubectl apply -f bookinfo.yaml
    ```

1. To access `bookinfo`, set up port-forwarding:

    ```bash
    kubectl port-forward svc/productpage 9080
    ```

1. Finally, navigate to `http://localhost:9080` in a browser. On the front side, it uses clear text. All of the service-to-service calls will be SSL-encrypted.


### Debug mTLS Issues

Not all MTLS misconfiguration errors can be caught when the configuration is loaded. For example, NGINX will not detect if the certificate expires during operation. NGINX responds to requests with invalid certificates with a `400 Bad Request` error. Debugging information is provided in the error log at the `info` level.

Refer to [logging]({{< ref "/mesh/get-started/install/configuration.md#logging">}} ) for information about changing the log level.

### Update mTLS settings after deployment

The following mTLS settings can be changed after the mesh has been deployed:

- mode
- caTTL
- svidTTL
- caKeyType

{{< call-out "important" >}}
When updating `caTTL`, `svidTTL`, or `caKeyType`, the SPIRE server will be restarted and brief downtime should be expected. Certificates cannot be given out during this time, so it is advised to not create any applications until the server has fully restarted. Any existing certificates will live until their expirations, but all new certificates will use the updated mTLS settings. Workload certificates can be forced to be updated by re-rolling the workload Pods.

If using persistent storage--which is the default and recommended setting when deploying the mesh--, updated `caTTL` and `caKeyType` fields will not take effect until the original root CA certificate expires. The expiry time is based on the original `caTTL` value. If you want to change these values immediately, then the fastest--but most disruptive--way to do this is to remove and redeploy NGINX Service Mesh.
{{< /call-out >}}

See the [API Usage Guide]( {{< ref "api-usage.md#modify-the-mesh-state-by-using-the-rest-api" >}} ) for instructions on how to update the mTLS settings using the REST API.

### What Next

With mTLS properly set up within your service mesh, it is important to set up authorization to properly verify incoming connections.

See [Access Control policies]( {{< ref "/mesh/guides/smi-traffic-policies.md#access-control" >}}) for how to define authorization within your application.
