---
title: Migrate on Kubernetes
toc: true
weight: 110
nd-content-type: how-to
nd-product: NAGENT
---

## Before you begin
- Ensure you have:
   - kubectl context set to the target cluster and namespace.
   -  Permissions to deploy to the namespace.
   - Required registry credentials available.
   - A Secret for NGINX_LICENSE_JWT or that you can create one.
- Plan a maintenance window and test in a non‑production environment first.

- kubectl context is set to the target cluster and namespace.
- You have permissions to deploy to the namespace.
- Registry credentials are available if required.
- A Secret exists for NGINX_LICENSE_JWT or you can create one.
- Plan a maintenance window and test in a non‑production environment first.

{{< call-out class="caution" title="Do not run v2 and v3 concurrently" >}}
Do not run NGINX Agent v2 and v3 in the same pod or on the same node as part of the migration.
{{< /call-out >}}

## Steps

1. Prepare the Deployment manifest for NGINX Agent v3. Example:
   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx-agent
     namespace: <namespace>
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: nginx-agent
     template:
       metadata:
         labels:
           app: nginx-agent
       spec:
         containers:
           - name: nginx-agent
             image: <registry>/nginx-plus/agent/debian:<v3-tag>
             env:
               - name: NGINX_AGENT_COMMAND_SERVER_HOST
                 value: "agent.connect.nginx.com"
               - name: NGINX_AGENT_COMMAND_SERVER_PORT
                 value: "443"
               - name: NGINX_AGENT_COMMAND_TLS_SKIP_VERIFY
                 value: "false"
               - name: NGINX_AGENT_COMMAND_AUTH_TOKEN
                 value: "<auth-token>"
               - name: NGINX_LICENSE_JWT
                 valueFrom:
                   secretKeyRef:
                     name: nginx-secret
                     key: NGINX_LICENSE_JWT
               # Optional: If using Config Sync Groups
               # - name: NGINX_AGENT_LABELS
               #   value: "config-sync-group=<config-sync-group-name>"
   ```

2. Apply the Deployment and monitor the rollout:
   ```shell
   kubectl apply -n <namespace> -f nginx-agent-v3-deployment.yaml
   kubectl rollout status deployment/nginx-agent -n <namespace>
   ```

3. Validate the replacement:
   ```shell
   kubectl get pods -n <namespace>
   kubectl logs <pod-name> -n <namespace>
   ```
   - Look for: msg="Agent connected" in the logs.

4. Verify in NGINX One Console:
   - The instance appears Online in the Instances view.
   - If using Config Sync Groups, confirm group members are Online.

## Troubleshoot

- Describe the pod to verify env vars and image tag:
  ```shell
  kubectl describe pod <pod-name> -n <namespace>
  ```

## Rollback

- Reapply the previous v2 Deployment manifest:
  ```shell
  kubectl apply -f nginx-agent-v2-deployment.yaml
  ```

## References
- [Agent v3 environment variables:]({{< ref "/nginx-one-console/agent/configure-instances/configuration-overview/" >}})
- [Docker images:]({{< ref "https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/" >}})
- Config conversion script: https://raw.githubusercontent.com/nginx/agent/v3/scripts/packages/upgrade-agent-config.sh