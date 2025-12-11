---
nd-product: NAGENT
nd-files:
- content/nginx-one-console/agent/install-upgrade/update.md
---


The following is a summary of changes and improvements that went into NGINX Agent v3. 

- Enhanced connection handling with improved error management and retry logic.
- Improved reliability when publishing NGINX configurations to NGINX Data planes.
- Revamped logging framework for easier troubleshooting and diagnostics. 
- Improved NGINX Data plane health monitoring.
- Agent Configuration file has been simplified. 
- Built-in OpenTelemetry (OTel) support for standardized observability and monitoring. 
[Learn more about exporting metrics to NGINX One Console]({{< ref "/nginx-one-console/agent/configure-otel-metrics/" >}})
- Explicit forward proxy support.
- Enable Kubernetes control planes connections NGINX One Console

## Upgrading the Agent on Virtual Machine/Bare Metal Server

When upgrading to NGINX Agent v3, the installer automatically backs up all configuration files before proceeding. It also converts your v2 configuration to the v3 format, ensuring compatibility and preserving settings.

{{< call-out "note" >}} 
If you are using a version **older than NGINX Agent v2.31.0**, you must stop NGINX Agent before updating:

   - `sudo systemctl stop nginx-agent`

And start it again after the update or upgrade:

   - `sudo systemctl start nginx-agent`
{{< /call-out >}}

Follow the steps below to update or upgrade NGINX Agent to the latest version.
The same steps apply if you are **upgrading from NGINX Agent v2 to NGINX Agent v3**.

1. Open an SSH connection to the server where you've installed NGINX Agent.

1. Make a backup copy of the following locations to ensure that you can successfully recover if the upgrade does not complete
   successfully:
      ```shell
      sudo cp -r /etc/nginx-agent /etc/nginx-agent.bak
      ```

1. Install the updated version of NGINX Agent:

    - CentOS, RHEL, RPM-Based

        ```shell
        sudo yum -y makecache
        sudo yum update -y nginx-agent
        ```

    - Debian, Ubuntu, Deb-Based

        ```shell
        sudo apt-get update
        sudo apt-get install -y --only-upgrade nginx-agent -o Dpkg::Options::="--force-confold"
        ```
1. Verify the installation by checking the version:
    ```shell
    sudo nginx-agent -v
    ```
1. Verify the agent service is running by checking the logs

    ```shell
    sudo cat /var/log/nginx-agent/agent.log | grep -i "Starting NGINX Agent"
    ```

### Rolling back from NGINX Agent v3 to v2

If you need to roll back your environment to NGINX Agent v2, the upgrade process creates a backup of the NGINX Agent v2 config in the file `/etc/nginx-agent/nginx-agent.conf.v2-backup`.

Replace the contents of `/etc/nginx-agent/nginx-agent.conf` with the contents of `/etc/nginx-agent/nginx-agent.conf.v2-backup` and then reinstall an older version of NGINX Agent.


## Upgrading Container and Kubernetes deployments 

{{< call-out "warning" >}} NGINX Agent v3 introduces a new configuration schema that replaces all v2 environment variables. The names, structure, and sometimes the semantics of these variables have changed. There is no backward compatibility, so any automation or manifests using v2 variables must be updated to the new v3 equivalents before upgrading.

{{< /call-out >}}

### Recommended Approach

Start by reviewing the configuration in the yaml file, this example shows a subset of the v2 env vars. 
To the complete v2 and v3 list use the following links:

- [Full list of v2 environment variables]({{< ref "/agent/configuration/configuration-overview" >}})
- [Full list of v3 environment variables]({{< ref "/nginx-one-console/agent/configure-instances/configuration-overview/" >}})


Taking an example docker-compose file running a NGINX Agent v2 and update to v3. 

```yaml
  # NGINX Agent v2
  nginx-agent:
    image: private-registry.nginx.com/nginx-plus/agent:debian
    container_name: nginx-agent
    environment:
      NGINX_LICENSE_JWT: <YOUR_JWT_HERE>
      NGINX_AGENT_SERVER_GRPCPORT: 443
      NGINX_AGENT_SERVER_HOST: <Host Server>
      NGINX_AGENT_SERVER_TOKEN: <Auth Token>
      NGINX_AGENT_TLS_ENABLE: true 
```

 
1. Update the image to point to NGINX Agent v3 

1. Replace the v2 envioronment variables with v3

1. Start the updated services:
  ```shell
  docker-compose up -d
  ```
```yaml
  # NGINX Agent v3
  nginx-agent:
    image: private-registry.nginx.com/nginx-plus/agentv3:debian
    container_name: nginx-agent
    environment:
      NGINX_LICENSE_JWT: <YOUR_JWT_HERE>
      NGINX_AGENT_COMMAND_SERVER_PORT: 443 
      NGINX_AGENT_COMMAND_SERVER_HOST: <Host Server>
      NGINX_AGENT_COMMAND_AUTH_TOKEN: <Auth Token>
      NGINX_AGENT_COMMAND_TLS_SKIP_VERIFY: false 
```

1. Testing
- Verify the container is running 
- Check agent logs to confirm the upgrade: `"Starting NGINX Agent" version=v3`
- Verify the container is showing on NGINX Console view
