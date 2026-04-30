---
nd-product: F5DOSN
nd-files:
- content/nap-dos/deployment-guide/kubernetes.md
- content/nap-dos/deployment-guide/kubernetes-with-L4-accelerated-mitigation..md
- content/nap-dos/deployment-guide/learn-about-deployment.md
---
## F5 DoS for NGINX Arbitrator

### Overview

F5 DoS for NGINX Arbitrator orchestrates all running F5 DoS for NGINX instances to synchronize local and global attack start and stop.

F5 DoS for NGINX Arbitrator is a central coordinating component for managing multiple F5 DoS for NGINX instances in a network. It is needed when there is more than one F5 DoS for NGINX instance. Its primary function is to ensure that all instances are aware of and share the same state for each protected object.

### How the Arbitrator works

- **Collecting state periodically**: The Arbitrator regularly collects state information from all running F5 DoS for NGINX instances. This collection occurs at set intervals, typically every 10 seconds.
- **State initialization for new instances**: When a new F5 DoS for NGINX instance starts, it retrieves the initial state for each protected object from the Arbitrator rather than starting with an empty state.
- **Updating state during an attack**: When an F5 DoS for NGINX instance detects an attack, it sends a notification to the Arbitrator. The Arbitrator updates the state of the affected protected object and propagates that state to all other instances.

### Why F5 DoS for NGINX Arbitrator is necessary

F5 DoS for NGINX Arbitrator is essential for several reasons:

- **Global state management**: Without the Arbitrator, each F5 DoS for NGINX instance manages its own isolated state for each protected object. This can lead to inconsistencies. For example, if instance A declares an attack on a protected object named "PO-Example," instance B remains unaware of it, potentially leaving the object vulnerable.
- **Uniform attack detection**: With the Arbitrator, when instance A detects an attack on "PO-Example" and reports it, the Arbitrator updates the state of "PO-Example" and propagates it to all instances, including instance B.

F5 DoS for NGINX Arbitrator maintains a consistent global state for protected objects across all F5 DoS for NGINX instances. This ensures attacks are detected and mitigated uniformly across your deployment.


### F5 DoS for NGINX Arbitrator Deployment

1. Pull the official F5 DoS for NGINX Arbitrator image with the command:

   ```shell
   docker pull docker-registry.nginx.com/nap-dos/app_protect_dos_arb:latest
   ```

2. Create a container based on this image, for example, `app-protect-dos-arb` container:

   ```shell
   docker run --name app_protect_dos_arb -p 3000:3000 -d docker-registry.nginx.com/nap-dos/app_protect_dos_arb
   ```

3. Verify that the `app-protect-dos-arb` container is up and running with the `docker ps` command.

4. DNS records are required for F5 DoS for NGINX Arbitrator to work properly and be accessible by F5 DoS for NGINX servers. Ensure that the `svc-appprotect-dos-arb` or configured Arbitrator FQDN (with `app_protect_dos_arb_fqdn` directive) has a valid DNS resolution.
   This step is necessary only for VM/Docker deployments with arbitrator. When the arbitrator is in the same Kubernetes namespace as F5 DoS for NGINX, this step is not needed.

### Multi-VM Deployment

The Arbitrator service is standalone. If it goes down, it can be restarted and immediately recovers all required information from F5 DoS for NGINX instances, which report to it every 10 seconds. Its downtime is around 10 to 20 seconds, which does not affect F5 DoS for NGINX operation.

F5 DoS for NGINX Arbitrator connects to port 3000. All modules try to connect to it automatically. If it's not accessible, each instance operates in standalone mode.

F5 DoS for NGINX does not support mutual TLS (mTLS) or password authentication between DoS servers and the Arbitrator. Arbitrator is not exposed outside the namespace. It is the customer's responsibility to isolate it from external access. This applies to all Arbitrator deployments, not only multi-VM.

