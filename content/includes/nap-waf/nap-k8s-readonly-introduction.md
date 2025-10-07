F5 WAF for NGINX v5 allows you to enable the `readOnlyRootFilesystem` option in your [Kubernetes Configuration](
https://kubernetes.io/docs/tasks/configure-pod-container/security-context/). This option restricts the root filesystem to read-only mode, which improves security by limiting potential write access in case of compromise.

To enable this feature, you will need a Kubernetes cluster that supports read-only root file systems, and you access to the NGINX and F5 WAF for NGINX configurations. 

You may need to identify any extra paths that need to be writable by App Protect during runtime: the following steps assume you are using the defaults path.