---
title: Migrate NGINX Agent v2 to v3 
weight: 600
toc: true
nd-docs: DOCS-1227
nd-content-type: how-to
nd-product: NAGENT
---

This guide explains how to migrate deployments from **NGINX Agent v2** to **NGINX agent v3**. Agent v3 introduces architectural and configuration changes. As a result, migrating from v2 to v3 should be approached as a controlled migration.

{{< call-out class="warning"  title="Breaking Changes in NGINX Agent v3 Migration" >}}

The migration from Agent v2 to Agent v3 introduces critical changes that may disrupt existing workflows:

### **Changed Configuration Structure**

- **Environment Variables**:
  - Agent v3 replaces Agent v2 environment variables for GRPC connectivity:
    - `NGINX_AGENT_SERVER_HOST` -> `NGINX_AGENT_COMMAND_SERVER_HOST`
    - `NGINX_AGENT_SERVER_GRPCPORT` -> `NGINX_AGENT_COMMAND_SERVER_PORT`
    - `NGINX_AGENT_SERVER_TOKEN` -> `NGINX_AGENT_COMMAND_AUTH_TOKEN`
  - Ensure the new variables are correctly updated in Agent v3 configuration before deployment.

- **Config Sync Groups**
  - In v3 config sync groups are defined using the following format: 
      ```yaml 
          - name: NGINX_AGENT_LABELS
            value: "config-sync-group=<Config Sync Group Name>"
      ``` 
 {{< /call-out >}}

## Migrate NGINX Agent running using Virtual Machines
{{< include "/agent/installation/update.md" >}}



## Migrate NGINX Agent running in Kubernetes

{{< call-out class="info">}}
Docker images are available in the [Deploying NGINX and NGINX Plus on Docker](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/) NGINX documentation.
 {{< /call-out >}}

- Prepare NGINX Agent v3 Deployment YAML, for example: 
    ```yaml
        containers:
          - name: nginx-agent
            image: <registry>/nginx-plus/agent/debian:r36
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
    ```
- Deploy the Updated Manifest, Apply the Deployment using kubectl:
    ```shell
    kubectl apply -f nginx-agent-v3-deployment.yaml
    ```
-  Monitor the Rollout Progress
kubectl rollout status deployment/<name> -n nginxone

- Validate the Replacement
Once the rollout is complete, ensure all v2 pods have been replaced with v3 pods:

- Confirm all pods transistion to running:
    ```shell
        kubectl get pods -n <namespace>
    ```

### Post-Migration Validations

1. Check for agent connected message, example: **msg="Agent connected"**
    ```shell
    kubectl logs <pod-name> -n <namespace>
    ```
2. Search for the Instance on NGINX One Console

1. **Open the Instances View**:
   - Navigate to the **Instances View** in the NGINX One Console.

2. **Search for the NGINX Instance**:
   - Enter the **Pod Name** in the search field located in the top-right corner of the Instances View.

3. **Check Instance Availability Status**:
   - Ensure the **Availability** status of the instance shows **Online**.

4. **Check Config Sync Group (If Applicable)**:
   - If your instance is part of a **Config Sync Group**:
     - Open the **Config Sync Groups** section.
     - Locate your specific **Config Sync Group**.
     - Verify that instances listed in the group are also shown as **Online** in the **Instances Section**.


### Troubleshooting

If issues arise during migration, follow these steps:

1. Check for any errors in the logs:
    ```shell
    kubectl logs <pod-name> -n <namespace>
    ```
2. Environment Variables:
Inspect the pod to confirm all environment variables are correctly set:
    ```shell
    kubectl describe pod <pod-name> -n <namespace>
    ```
3. Rollback to NGINX Agent v2 
    ```shell
    kubectl apply -f nginx-agent-v2-deployment.yaml
    ```

## Migrate NGINX Agent running using docker compose 

#### v2 Docker Compose Configuration

```yaml
    version: "3.8"
    services:
    nginx-agent:
        image: <registry>/nginx-agent:v2
        environment:
          - NGINX_AGENT_SERVER_HOST=agent.connect.nginx.com
          - NGINX_AGENT_SERVER_GRPCPORT=50051
          - NGINX_AGENT_SERVER_TOKEN=<auth-token>
          - NGINX_LICENSE_JWT=${NGINX_LICENSE_JWT}
        secrets:
          - nginx_license_jwt

    secrets:
      nginx_license_jwt:
        file: ./nginx_license_jwt.txt
```

#### v3 Docker Compose Configuration

```yaml
version: "3.8"
services:
  nginx-agent:
    image: <registry>/nginx-plus/agent/debian:r36
    environment:
      - NGINX_AGENT_COMMAND_SERVER_HOST=agent.connect.nginx.com
      - NGINX_AGENT_COMMAND_SERVER_PORT=443
      - NGINX_AGENT_COMMAND_TLS_SKIP_VERIFY=false
      - NGINX_AGENT_COMMAND_AUTH_TOKEN=<auth-token>
      - NGINX_LICENSE_JWT=${NGINX_LICENSE_JWT}
      - NGINX_AGENT_LABELS=config-sync-group=<Config Sync Group Name>
    secrets:
      - nginx_license_jwt

secrets:
  nginx_license_jwt:
    file: ./nginx_license_jwt.txt
```

### Migration Steps for Docker Compose
1. Backup Your Existing Configuration  
    - Save a copy of your current docker-compose.yaml file to ensure you can roll back if necessary.

2. Modify the Configuration  
    - Update your service configuration as shown in the v3 Docker Compose Configuration.
     
3. Restart the Agent Service  
    - Bring down the existing agent running with v2:
        ```bash
        docker-compose down
        ```
    - Start the agent with the updated v3 configuration:
        ```bash
        docker-compose up -d
        ```
4. Validate the Migration  
    - Confirm the agent is running with the v3 changes:
        ```bash
        docker logs <nginx-agent-container-name>
        ```
    - Check the logs for successful connection messages:
    ```msg="Agent connected"```

 5. Check in NGINX One Console  
    - Ensure the updated instance is listed and active in the Instances View.
    - If the agent belongs to a Config Sync Group, verify that it is displayed as Online under the Config Sync Groups section.

## Rollback Procedure

If any issues occur, you can roll back to v2 by replacing the configuration with the v2 docker-compose.yaml and restarting the service:
  ```bash
    $ docker-compose down
    $ docker-compose up -d
  ```
## Migrate NGINX Agent running in containers

To migrate NGINX Agent containers, we provide a script to convert NGINX Agent v2 config files to NGINX Agent v3 config files: [NGINX Agent Config Upgrade Script](https://github.com/nginx/agent/blob/v3/scripts/packages/upgrade-agent-config.sh)

To upgrade the configuration, you can follow this example:

```shell
wget https://raw.githubusercontent.com/nginx/agent/refs/heads/main/scripts/packages/upgrade-agent-config.sh
./upgrade-agent-config.sh --v2-config-file=./nginx-agent-v2.conf --v3-config-file=nginx-agent-v3.conf
```

If your NGINX Agent container was previously a member of a Config Sync Group, then your NGINX Agent config must be manually updated to add the Config Sync Group label.
See [Add Config Sync Group]({{< ref "/nginx-one-console/nginx-configs/config-sync-groups/manage-config-sync-groups.md" >}}) for more information.

### Rollback Procedure

If you need to roll back your environment to NGINX Agent v2, the upgrade process creates a backup of the NGINX Agent v2 config in the file `/etc/nginx-agent/nginx-agent-v2-backup.conf`.

Replace the contents of `/etc/nginx-agent/nginx-agent.conf` with the contents of `/etc/nginx-agent/nginx-agent-v2-backup.conf` and then reinstall an older version of NGINX Agent.