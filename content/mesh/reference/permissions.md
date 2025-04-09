---
title: NGINX Service Mesh Permissions
weight: 100
draft: false
toc: true
docs: DOCS-883
type:
- reference
---

## Init Container
The init container is a privileged container that runs as root. In addition to the container running with root privileges on the host system, it also has weaker sandboxing. The init container needs this level of access in order to manipulate `iptables` and `eBPF` on the host.

### Capabilities
Kubernetes allows pods to be given capabilities that extend their permissions and allow them to perform restricted tasks. These capabilities are modelled after the standard Linux capabilities (`man capabilities`). The sidecar init container uses the following capabilities:

- **NET_ADMIN**: (`CAP_NET_ADMIN`) This capability provides the ability to administer the IP firewall and modify the routing tables.

- **NET_RAW**: (`CAP_NET_RAW`) This capability provides the ability to open and use RAW sockets.

- **SYS_RESOURCE**: (`CAP_SYS_RESOURCE`) Used by the init container to lock memory for BPF resources.

- **SYS_ADMIN**: (`CAP_SYS_ADMIN`) This capability provides access to BPF operations, among other things.

### Tips and tricks
#### Compatibility concerns around init container privilege level
Some services like F5 NGINX Ingress Controller and Certificate Manager will fail to deploy when auto-injected with the NGINX Service Mesh init container. This may be because they specify `runAsNonRoot` in their security policies, which prevents the init container from launching. This issue can be avoided by containing these services in their own namespaces where auto-injection is disabled.

## Sidecar Proxy
The sidecar container cannot escalate privilege and is not a privileged container. The sidecar container runs as user 2102 once the init container has completed.

## Additional Containers
All other containers in NGINX Service Mesh use `securityContext: {}`.
