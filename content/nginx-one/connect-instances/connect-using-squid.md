---
title: Prepare - Set up Squid as a proxy
toc: true
weight: 250
nd-docs: DOCS-000
---

NGINX Agent can be configured to connect to NGINX One using a [Squid proxy](https://www.squid-cache.org/). This is useful in environments where direct internet access is restricted or monitored.

## Before you start

Ensure you have the following:

- [Squid proxy server set up and running](https://wiki.squid-cache.org/SquidFaq/InstallingSquid)
- [NGINX Agent is installed]({{< ref "nginx-one/agent/install-upgrade/" >}})
- Access to the NGINX One console


## Configure Squid

Follow the steps below to configure Squid with basic authentication.

1. Open the Squid configuration file with your favorite text editor (you might need superuser privileges):

   ```sh
   vi /etc/conf/squid.conf
   ```

1. Add the following lines to configure the proxy settings:

   ```conf
   # Standard HTTP port for the proxy.
   http_port myproxy.example.com:3128

   # Define an ACL for allowing access from the agent's IP address
   acl agent_ip src <AGENT_IP_ADDRESS>

   # Allow the agent to connect to NGINX One Console
   acl mgmt_server dstdomain agent.connect.nginx.com

   # Allow HTTPS traffic (port 443 is default for HTTPS)
   acl ssl_ports port 443

   # HTTP access rules (allow the agent to access the destination server through the proxy)
   http_access allow agent_ip mgmt_server ssl_ports

   # Deny all other traffic by default (best practice)
   http_access deny all
   ```


1. Save the changes and exit the text editor.
1. Restart the Squid service to apply the changes:

   ```sh
   sudo systemctl reload squid
   ```

---

## NGINX Agent Proxy configuration

1. Open a secure connection to your instance using SSH and log in.
1. Open the NGINX Agent configuration file (/etc/nginx-agent/nginx-agent.conf) with a text editor. To edit this file you need superuser privileges.
1. Add or modify the `proxy` section to include the Squid proxy URL and timeout settings:

   ```conf
   server:
      host: agent.connect.nginx.com
      port: 443
      proxy:
         url: "http://proxy.example.com:3128"
   ```

1. Reload NGINX Agent to apply the changes:

    ```sh
    sudo systemctl restart nginx-agent
    ```

### In a containerized environment

To configure NGINX Agent in a containerized environment:

1. Run the NGINX Agent container with the environment variables set as follows:

   ```sh
   sudo docker run \
      --add-host "myproxy.example.com:host-gateway" \
      --env=NGINX_AGENT_COMMAND_SERVER_PORT=443 \
      --env=NGINX_AGENT_COMMAND_SERVER_HOST=agent.connect.nginx.com \
      --env=NGINX_AGENT_COMMAND_AUTH_TOKEN="<your-data-plane-key-here>" \
      --env=NGINX_AGENT_COMMAND_TLS_SKIP_VERIFY=false \
      --env=NGINX_AGENT_COMMAND_SERVER_PROXY_URL=http://myproxy.example.com:3128 \
      --restart=always \
      --runtime=runc \
      -d private-registry.nginx.com/nginx-plus/agentv3:latest
   ```


## NGINX Agent proxy authentication

If your Squid proxy requires authentication, you can specify the username and password in the `proxy` section of the `agent.conf` file:

1. Open a secure connection to your instance using SSH and log in.
1. Add or modify the `proxy` section of the NGINX Agent configuration file (/etc/nginx-agent/nginx-agent.conf) to include the authentication details:

   ```conf
   proxy:
      url: "http://proxy.example.com:3128"
      auth_method: "basic"
      username: "user"
      password: "pass"
   ```

1. Reload NGINX Agent to apply the changes:

    ```sh
    sudo systemctl restart nginx-agent
    ```

### In a containerized environment

To set proxy authentication in a containerized environment:

1. Run the NGINX Agent container with the environment variables set as follows:


   ```sh
   sudo docker run \
      --add-host "myproxy.example.com:host-gateway" \
      --env=NGINX_AGENT_COMMAND_SERVER_PORT=443 \
      --env=NGINX_AGENT_COMMAND_SERVER_HOST=agent.connect.nginx.com \
      --env=NGINX_AGENT_COMMAND_AUTH_TOKEN="<your-data-plane-key-here>" \
      --env=NGINX_AGENT_COMMAND_TLS_SKIP_VERIFY=false \
      --env NGINX_AGENT_COMMAND_SERVER_PROXY_URL=http://proxy.example.com:3128
      --env NGINX_AGENT_COMMAND_SERVER_PROXY_AUTH_METHOD=basic
      --env NGINX_AGENT_COMMAND_SERVER_PROXY_USERNAME="user"
      --env NGINX_AGENT_COMMAND_SERVER_PROXY_PASSWORD="pass"
      --restart=always \
      --runtime=runc \
      -d private-registry.nginx.com/nginx-plus/agentv3:latest
   ```

## Validate connectivity between NGINX Agent, Squid, and NGINX One Console

To test the connectivity between NGINX Agent, Squid, and NGINX One Console, you can use the `curl` command with the proxy settings.

1. Open a secure connection to your instance using SSH and log in.
1. Run the following `curl` command to test the connection:
   ```sh
   curl -x http://proxy.example.com:3128 -U your_user:your_password https://agent.connect.nginx.com/api/v1/agents
   ```

   - Replace `proxy.example.com:3128` with your Squid proxy address and port.
   - Replace `your_user` and `your_password` with the credentials you set up for Squid in the previous steps.

To test the configuration from a containerized environment, run the following command from within the container:

   ```sh
   curl -x http://host.docker.internal:3128 -U your_user:your_password https://agent.connect.nginx.com/api/v1/agents
   ```

   - Replace `your_user` and `your_password` with the credentials you set up for Squid in the previous steps.

## Troubleshooting

1. Find the configuration and log files:

   - Run `squid -v | grep "configure options"`
   - Configuration directory should look like `--sysconfdir=/etc/squid'`
   - Log directory should look like `--sysconfdir=/var/log'`

