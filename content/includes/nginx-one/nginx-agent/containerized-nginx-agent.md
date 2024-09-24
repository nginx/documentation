---
docs: DOCS-1407
---

<! -- This doc is a WIP. Do not publish -->

#### Configuring a containerized NGINX Agent {#configure-containerized-nginx-agent}

This section assumes you've already installed the NGINX Agent in a container environment. For guidance on how to do this, refer to the [NGINX Agent in a Container Environment guide](https://docs.nginx.com/nginx-management-suite/nginx-agent/nginx-agent-in-container/).

To register your containerized NGINX Agent with NGINX One:

1. On your local host, create an **nginx-agent.conf** file similar to the following example.

   In the `server` block, replace `<data-plane-key>` with the actual data plane key you generated in NGINX One.

   ```yaml
    server:
      token: "<data-plane-key>"
      host: agent.connect.nginx.com
      grpcPort: 443
    ```

    <details open>
    <summary><i class="fas fa-file"></i> Example nginx-agent.conf</summary>

    ``` yaml
    #
    # /etc/nginx-agent/nginx-agent.conf
    #
    # Configuration file for NGINX Agent.
    #
    # This file is to track NGINX Agent configuration values that are meant to be statically set. There
    # are additional NGINX Agent configuration values that are set via the API and NGINX Agent install script
    # which can be found in /var/lib/nginx-agent/agent-dynamic.conf.

    log:
      # set log level (panic, fatal, error, info, debug, trace; default "info")
      level: info
      # set log path. if empty, don't log to file.
      path: /var/log/nginx-agent/
    # data plane status message / 'heartbeat'
    nginx:
      # path of NGINX logs to exclude
      exclude_logs: ""
      socket: "unix:/var/run/nginx-agent/nginx.sock"

    dataplane:
      status:
        # poll interval for data plane status - the frequency the NGINX Agent will query the dataplane for changes
        poll_interval: 30s
        # report interval for data plane status - the maximum duration to wait before syncing dataplane information if no updates have being observed
        report_interval: 24h
    metrics:
      # specify the size of a buffer to build before sending metrics
      bulk_size: 20
      # specify metrics poll interval
      report_interval: 1m
      collection_interval: 15s
      mode: aggregated

    # OSS NGINX default config path
    # path to aux file dirs can also be added
    config_dirs: "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms"

      # api:
      # The port at which NGINX Agent accepts remote connections
      # The API address and port allow for remote management of NGINX and NGINX Agent
      #
      # ~~~ WARNING ~~~
      # Set API address to allow remote management
      # host: agent.connect.nginxlab.net
      #
      # Set this value to a secure port number to prevent information leaks.
      # port: 8038

    server:
      token: "<data-plane-key>"
      host: agent.connect.nginx.com
      grpcPort: 443

    tls:
      enable: true
      skip_verify: false
    ```

    </details>

2. Start the Docker container, mounting the **nginx-agent.conf** file on the host to the specified path inside the container:

    ```shell
    docker run \
    --mount type=bind,source=<path-to-your-nginx-agent.conf>,target=/etc/nginx-agent/nginx-agent.conf,readonly \
    <nginx-image-with-nginx-agent>
    ```

    - `<path-to-your-nginx-agent.conf>`: Replace with the path to your **nginx-agent.conf** file you created on the host.
    - `<nginx-image-with-nginx-agent>`: Replace with the name of the Docker image with the NGINX Agent
