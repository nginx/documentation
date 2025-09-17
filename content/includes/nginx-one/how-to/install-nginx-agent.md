---
docs:
files:
  - content/nginx-one/secure-your-fleet/set-up-security-alerts.md
  - content/nginx-one/getting-started.md
---

After entering your data plane key, you'll see a `curl` command to install NGINX Agent, similar to the one below. Copy and run this command on each NGINX instance. Once installed, NGINX Agent typically registers with NGINX One within a few seconds.

{{<call-out "important" "Connecting to NGINX One" >}}
 Make sure your firewall rules for NGINX hosts allow traffic to port `443` from these IP address ranges:

- `3.135.72.139/32`
- `3.133.232.50/32`
- `52.14.85.249/32`
- `2600:1f16:19c8:d400::/62`

NGINX Agent must be able to establish a connection to NGINX One Console's Agent endpoint (`agent.connect.nginx.com`).
{{</call-out>}}

To install NGINX Agent on an NGINX instance:

1. **Check if NGINX is running and start it if it's not:**

    First, see if NGINX is running:

    ```shell
    sudo systemctl status nginx
    ```

    If the status isn't `Active`, go ahead and start NGINX:

    ```shell
    sudo systemctl start nginx
    ```

2. **Install NGINX Agent:**

    Next, use the `curl` command provided to you to install NGINX Agent:

    ``` shell
    curl https://agent.connect.nginx.com/nginx-agent/install | DATA_PLANE_KEY="YOUR_DATA_PLANE_KEY" sh -s -- -y
    ```

   - Replace `YOUR_DATA_PLANE_KEY` with your actual data plane key.
