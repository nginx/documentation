---
title: Production Tuning
weight: 80
toc: true
nd-docs: DOCS-695
type:
- how-to
---

#### Overview

While F5 NGINX Service Mesh provides a number of capabilities for finely controlling and authorizing traffic, it is up to the user to configure these options to best suit the needs of their application. This document will go over the various deployment options and tools compatible with NGINX Service Mesh that you can use to secure and orchestrate traffic throughout your application. For the best production experience possible, consider the options below.

#### mTLS Strict

By default, NGINX Service Mesh ships with mTLS `permissive` mode. Because of the security implications of allowing plaintext, unauthenticated traffic to and from your application, we strongly recommend switching to mTLS `strict` mode. This will ensure that all traffic stays within the confines of the mesh. For more information on this setting, see the [Secure Mesh Traffic using mTLS]( {{< ref "/mesh/guides/secure-traffic-mtls.md#overview" >}} ) guide.

You can also secure ingress traffic to your cluster using the NGINX Plus Ingress Controller for Kubernetes. View our tutorial to [Deploy with NGINX Plus Ingress Controller]( {{< ref "/mesh/tutorials/kic/deploy-with-kic.md" >}} ) to secure traffic at the ingress point of your cluster. If you'd like to support non-meshed services, see our [Configure a Secure Egress Route with NGINX Plus Ingress Controller]( {{< ref "/mesh/tutorials/kic/egress-walkthrough.md" >}}) tutorial for sending traffic to non-meshed or external services. Note that we do not secure traffic past the egress point, so when routing traffic to an external service, you will be required to secure that traffic yourself.

#### Access Control

Alongside the authentication piece provided by mTLS sits authorization. NGINX Service Mesh uses access control policies from the SMI Spec to support authorization. Together, mTLS and Access Control provide a holistic approach to application security. We highly recommend that you deploy the mesh using `--access-control-mode=deny` to automatically deny all incoming connections and enact a zero trust network from which to build upon. Then, piece by piece, explicitly allow connections solely from clients that you expect to be making requests to your destinations. For more information on how you can properly set up access control for your application, see the [Access Control]( {{< ref "/mesh/guides/smi-traffic-policies.md#access-control" >}}) section of our Traffic Policies guide.

#### SPIRE Settings

NGINX Service Mesh uses SPIRE as the backbone for mTLS. It is responsible for minting certificates used in the mTLS handshake between application pods, as well as specifying the certificate authority used in the mesh webhooks and Traffic Metrics extension api-server. SPIRE ships with a variety of defaults which make development and testing easy, but they should be evaluated when considering production.

##### Using an Upstream Authority

If left unspecified, NGINX Service Mesh will generate a self signed root certificate with which to sign certificates. While this works for testing and development, it is recommended that you use a proper public key infrastructure (PKI). See [Deploy Using an Upstream Root CA]( {{< ref "/mesh/guides/secure-traffic-mtls.md#deploy-using-an-upstream-root-ca" >}} ) for more information on the options available to you for deploying using your own PKI. It is recommended that you specify an intermediate certificate to NGINX Service Mesh rather than a root certificate to ensure that, even if the intermediate gets compromised, the entirety of your PKI remains secure and intact.

##### In-memory SPIRE key manager

The `memory` key manager plugin should be used when deploying NGINX Service Mesh in a production environment. By using the `memory` key manager plugin, SPIRE signing keys are kept in memory - less vulnerable to the prying eyes of bad actors should they gain access to the SPIRE server. For more information on the various key managers that NGINX Service Mesh provides, as well as the differences between the two, see the [SPIRE Key Manager Plugin]( {{< ref "/mesh/guides/secure-traffic-mtls.md#choose-a-spire-key-manager-plugin" >}}) section of our mTLS guide.

We **highly** recommend pairing the `memory` key manager plugin with an upstream authority. Without one, if the SPIRE server fails, agents must be restarted manually and all workloads must receive newly signed certificates. This can have a significant impact on the cluster's resources.

##### Persistent Storage

Persistent storage allows for optimized handling of Spire server restarts in case of a failure as data such as registration entities and selectors do not need to be rebuilt. This saves on resource utilization and removes traffic disruptions for workloads. For most environments, we deploy persistent storage by default and recommend using it. See our [Persistent Storage]( {{< ref "/mesh/get-started/platform-setup/persistent-storage.md" >}} ) setup page for more information on configuring persistent storage in your environment.

##### Certificate TTL

It is important to specify a relatively low TTL to minimize damage should a certificate be compromised. For this reason, we recommend that you keep the default mTLS TTL values provided by NGINX Service Mesh.

#### Traffic Policies

While not purely necessary for production scenarios, NGINX Service Mesh provides rate limiting and circuit breaking utilities for better stability during times of peak traffic, as well as a better customer experience in the event of service failure.

##### Rate Limit

Using the rate limiting SMI extension, you are able to place a limit on the number of requests allowed for a particular service. In your preliminary testing, you may have gotten an idea of the upper threshold of requests your service is able to handle. Short of setting up autoscaling for your services, which can add cost and complexity to your system, you can simply add a rate limiting policy which will deny traffic as soon as it hits a specified threshold. This can be useful for services which have high resource requirements, or are running on relatively lightweight equipment. A rate limit, set up properly, can be the difference between intermittent error codes and complete loss of function which, in extreme circumstances, can lead to cascading failures across your application. See our [Rate Limiting]( {{< ref "/mesh/guides/smi-traffic-policies.md#rate-limiting" >}}) section of the Traffic Policies guide for information on setting up a rate limit.

##### Circuit Breaker

If the upper limit of the backend service is unknown, or you want an added layer of security for your services, you can specify a circuit breaker. When the level of errors begin to hint at a failure in the backend service itself, a circuit breaker can trip and allow that service to recover. Paired with a fallback service, your users can experience near zero downtime. For more information on setting up a circuit breaker, see our [Circuit Breaker]( {{< ref "/mesh/guides/smi-traffic-policies.md#circuit-breaking" >}}) section of the Traffic Policies guide.
