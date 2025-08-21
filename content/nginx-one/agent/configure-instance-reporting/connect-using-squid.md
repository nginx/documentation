---
title: Connect to NGINX One using Squid
toc: true
weight: 300
nd-docs: DOCS-000
---

NGINX Agent can be configured to report to NGINX One using a [Squid proxy](https://www.squid-cache.org/). This is useful in environments where direct internet access is restricted or monitored.

## Before you start

Ensure you have the following:

- [Squid proxy server set up and running](https://wiki.squid-cache.org/SquidFaq/InstallingSquid)
- [NGINX Agent is installed]({{< ref "nginx-one/agent/install-upgrade/" >}})
- Access to the NGINX One console

## Configure Squid

TBD

## NGINX Agent Proxy configuration

1. Open a secure connection to your instance using SSH and log in.
1. Open the NGINX Agent configuration file (/etc/nginx-agent/nginx-agent.conf) with a text editor.
1. Add or modify the `proxy` section to include the Squid proxy URL and timeout settings:

   ```conf
   server:
      host: mgmt.example.com
      port: 443
      type: 1
      proxy:
         url: "http://proxy.example.com:3128"
         timeout: 10s
   ```

1. Reload NGINX Agent to apply the changes:

    ```sh
    sudo systemctl restart nginx-agent
    ```

### In a containerized environment

To configure NGINX Agent in a containerized environment, you can set the proxy
URL and timeout value as environments variables:

```bash
NGINX_AGENT_COMMAND_SERVER_PROXY_URL=http://proxy.example.com:3128
NGINX_AGENT_COMMAND_SERVER_PROXY_TIMEOUT=10
```

## NGINX Agent proxy authentication

If your Squid proxy requires authentication, you can specify the username and password in the `proxy` section of the `agent.conf` file:

1. Open a secure connection to your instance using SSH and log in.
1. Open the NGINX Agent configuration file (/etc/nginx-agent/nginx-agent.conf) with a text editor.
1. Add or modify the `proxy` section to include the authentication details:

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

To set proxy authentication in a containerized environment, you can use the following environment variables:

```bash
NGINX_AGENT_COMMAND_SERVER_PROXY_URL=http://proxy.example.com:3128
NGINX_AGENT_COMMAND_SERVER_PROXY_AUTH_METHOD=basic
NGINX_AGENT_COMMAND_SERVER_PROXY_USERNAME="user"
NGINX_AGENT_COMMAND_SERVER_PROXY_PASSWORD="pass"
```

## Validate connectivity between NGINX Agent, Squid, and NGINX One Console

TBD