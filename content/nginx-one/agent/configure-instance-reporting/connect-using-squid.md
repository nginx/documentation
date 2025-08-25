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

## Install Squid

Follow the instructions in the [Squid website](https://wiki.squid-cache.org/SquidFaq/BinaryPackages) to install Squid on your server.


## Configure Squid

Follow the steps below to configure Squid with basic authentication.

1. Set up an HTTP Proxy with Basic Authentication. This setup requires users to provide a username and password. Run the
   following commands as a superuser:

   ```sh
   apt-get install apache2-utils -y  # Install htpasswd utility
   htpasswd -c /usr/local/squid/passwd your_user # Create a user
   ```

   - You will be prompted to enter and confirm a password for `your_user`.

1. Locate the Squid configuration file:
   - Run `squid -v` to find the configuration file path. Look for the `--sysconfdir` flag (usually `/etc/squid/squid.conf` on Ubuntu).

1. Find the path to your basic_ncsa_auth program:
   - On Ubuntu, it is usually located at `/usr/lib/squid/basic_ncsa_auth`.

1. Open the Squid configuration file with your favorite text editor (you might need superuser privileges):

   ```sh
   vim <path to config file>/squid.conf
   ```

1. Add or modify the following lines (usually at the top of the file) to configure the proxy settings:

   ```conf
   auth_param basic program <path_to_basic_ncsa_auth>/basic_ncsa_auth /usr/local/etc/squid/passwd auth_param basic realm Squid proxy-caching web server acl authenticated proxy_auth REQUIRED
   ```

1. In the same configuration file, find the line that starts with `http_access deny all` and add the `http_access allow authenticated` line above it. It should look like this:

   ```conf
   http_access allow authenticated
   http_access deny all
   ```

1. Save the changes and exit the text editor.
1. Restart the Squid service to apply the changes:

   ```sh
   sudo systemctl restart squid
   ```

---

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

To configure NGINX Agent in a containerized environment:

1. Run the NGINX Agent container with the environment variables set as follows:

   ```sh
   docker run -d \
      --name nginx-agent \
      -e NGINX_AGENT_COMMAND_SERVER_PROXY_URL=http://proxy.example.com:3128
      -e NGINX_AGENT_COMMAND_SERVER_PROXY_TIMEOUT=10
      nginx/nginx-agent:latest
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

To set proxy authentication in a containerized environment:

1. Run the NGINX Agent container with the environment variables set as follows:

   ```sh
   docker run -d \
      --name nginx-agent \
      -e NGINX_AGENT_COMMAND_SERVER_PROXY_URL=http://proxy.example.com:3128
      -e NGINX_AGENT_COMMAND_SERVER_PROXY_AUTH_METHOD=basic
      -e NGINX_AGENT_COMMAND_SERVER_PROXY_USERNAME="user"
      -e NGINX_AGENT_COMMAND_SERVER_PROXY_PASSWORD="pass"
      nginx/nginx-agent:latest
   ```


## Validate connectivity between NGINX Agent, Squid, and NGINX One Console

To test the connectivity between NGINX Agent, Squid, and NGINX One Console, you can use the `curl` command with the proxy settings.

1. Open a secure connection to your instance using SSH and log in.
1. Run the following `curl` command to test the connection:
   ```sh
   curl -x http://proxy.example.com:3128 -U your_user:your_password https://mgmt.example.com/api/v1/agents
   ```

   - Replace `proxy.example.com:3128` with your Squid proxy address and port.
   - Replace `your_user` and `your_password` with the credentials you set up for Squid in the previous steps.
   - Replace `mgmt.example.com` with your NGINX One Console address.

To test the configuration from a containerized environment, run the following command from within the container:

   ```sh
   curl -x http://host.docker.internal:3128 -U your_user:your_password https://mgmt.example.com/api/v1/agents
   ```

   - Replace `your_user` and `your_password` with the credentials you set up for Squid in the previous steps.
   - Replace `mgmt.example.com` with your NGINX One Console address.

## Troubleshooting

1. Find the configuration and log files:

   - Run `squid -v`.
   - Look for the `--sysconfdir` flag (usually `/usr/local/etc/squid/squid.conf` or `/opt/homebrew/etc/squid.conf` on
      Mac OS, and `/etc/squid/squid.conf` on Ubuntu) to find the configuration file.
   - Look for the `--prefix` flag to find the log file path (usually `/usr/local/var/logs/squid` or `/opt/homebrew/var/logs/squid`
      on Mac OS, and `/var/log/squid` on Ubuntu) to find the log files.
   - Look for the `--localstatedir` flag to find the cache directory path (usually `/usr/local/var/cache/squid` or `/opt/homebrew/var/cache/squid`
      on Mac OS, and `/var/spool/squid` on Ubuntu) to find the cache directory.

