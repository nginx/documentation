---
nd-docs: null
nd-files:
- content/nap-dos/deployment-guide/kubernetes.md
- content/nap-dos/deployment-guide/kubernetes-with-L3-mitigation.md
---
## F5 DoS for NGINX Arbitrator

### Overview

F5 DoS for NGINX arbitrator orchestrates all the running F5 DoS for NGINX instances to synchronize local/global attack start/stop.

F5 DoS for NGINX arbitrator serves as a central coordinating component for managing multiple instances of  App Protect DoS in a network. It is needed when there are more than one F5 DoS for NGINX instances. Its primary function is to ensure that all instances are aware of and share the same state for each protected object. Here's a clearer breakdown of how it works and why it's necessary:

How F5 DoS for NGINX Arbitrator Works:

- **Collecting State Periodically**: The arbitrator regularly collects the state information from all running instances of App Protect DoS. This collection occurs at set intervals, typically every 10 seconds.
- **State Initialization for New Instances**: When a new App Protect DoS instance is created, it doesn't start with a blank or uninitialized state for a protected object. Instead, it retrieves the initial state for the protected object from the arbitrator.
- **Updating State in Case of an Attack**: If an attack is detected by one of the App Protect DoS instances, that instance sends an attack notification to the arbitrator. The arbitrator then updates the state of the affected protected object to indicate that it is under attack. Importantly, this updated state is propagated to all other instances.

### Why F5 DoS for NGINX Arbitrator is Necessary

F5 DoS for NGINX Arbitrator is essential for several reasons:

- **Global State Management**: Without the arbitrator, each individual instance of App Protect DoS would manage its own isolated state for each protected object. This isolation could lead to inconsistencies. For example, if instance A declared an attack on a protected object named "PO-Example," instance B would remain unaware of this attack, potentially leaving the object vulnerable.
- **Uniform Attack Detection**: With the arbitrator in place, when instance A detects an attack on "PO-Example" and reports it to the arbitrator, the state of "PO-Example" is immediately updated to indicate an attack. This means that all instances, including instance B, are aware of the attack and can take appropriate measures to mitigate it.

In summary, F5 DoS for NGINX Arbitrator acts as a central coordinator to maintain a consistent and up-to-date global state for protected objects across multiple instances of App Protect DoS. This coordination helps ensure that attacks are properly detected and mitigated, and that knowledge gained by one instance is efficiently shared with others, enhancing the overall security of the network.


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

The Arbitrator service is standalone. Once it is down, it can be seamlessly re-started. It will immediately recover all the needed information from F5 DoS for NGINX instances that communicate to it every 10 sec. It’s downtime is around 10-20 seconds which  will not affect the F5 DoS for NGINX working.

F5 DoS for NGINX Arbitrator service connects to port 3000 and can be seen under App Protect DoS instances. All modules try to connect to this service automatically. If it’s not accessible, each instance works in standalone mode.

There is no such option for authentications between F5 DoS for NGINX servers and Arbitrator service like MTLS or password . Currently Arbitrator service is not exposed outside of the namespace. It is customers responsibility to isolate it from outside. It is applicable to any deployment of Arbitrator, not only to multi-VM.

