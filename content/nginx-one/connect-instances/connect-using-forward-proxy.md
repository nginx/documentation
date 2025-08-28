---
title: Prepare - Set up an explicit forward proxy
toc: true
weight: 250
nd-docs: DOCS-000
---

NGINX Agent can be configured to connect to NGINX One using an explicit forward
proxy. This is useful in environments where direct internet access is restricted or monitored.

## Before you start

Ensure you have the following:

- An explicit forward proxy server installed and configured in your network.
- [NGINX Agent is installed]({{< ref "nginx-one/agent/install-upgrade/" >}})
- Access to the [NGINX One console]({{< ref "/nginx-one/getting-started.md#before-you-begin" >}}).


## NGINX Agent configuration for proxy usage

1. Open a secure connection to your instance using SSH and log in.
1. Open the NGINX Agent configuration file (/etc/nginx-agent/nginx-agent.conf) with a text editor. To edit this file you need superuser privileges.
1. Add or modify the `proxy` section to include the proxy URL and timeout settings:

   ```conf
   server:
      host: agent.connect.nginx.com
      port: 443
      proxy:
         url: "http://proxy.example.com:3128"
   ```

1. Restart NGINX Agent to apply the changes:

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

If your forward proxy requires authentication, you can specify the username and password in the `proxy` section of the `agent.conf` file:

1. Open a secure connection to your instance using SSH and log in.
1. Add or modify the `proxy` section of the NGINX Agent configuration file (/etc/nginx-agent/nginx-agent.conf) to include the authentication details:

   ```conf
   proxy:
      url: "http://proxy.example.com:3128"
      auth_method: "basic"
      username: "user"
      password: "pass"
   ```

1. Restart NGINX Agent to apply the changes:

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

## Validate connectivity between the components

To test the connectivity between NGINX Agent, your proxy, and NGINX One Console, you can use the `curl` command with the proxy settings.

1. Open a secure connection to your instance using SSH and log in.
1. Run the following `curl` command to test the connection:
   ```sh
   curl -x http://proxy.example.com:3128 -U your_user:your_password https://agent.connect.nginx.com/api/v1/agents
   ```

   - Replace `proxy.example.com:3128` with your proxy address and port.
   - Replace `your_user` and `your_password` with the credentials you set up for proxy in the previous steps.

To test the configuration from a containerized environment, run the following command from within the container:

   ```sh
   curl -x http://host.docker.internal:3128 -U your_user:your_password https://agent.connect.nginx.com/api/v1/agents
   ```

   - Replace `your_user` and `your_password` with the credentials you set up for proxy in the previous steps.

