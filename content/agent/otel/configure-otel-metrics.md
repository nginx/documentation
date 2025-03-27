---
title: Metrics Export
weight: 200
---

## Overview

The F5 NGINX Agent v3 now includes an embedded [OpenTelemetry](https://opentelemetry.io/) Collector, streamlining observability and metric collection for NGINX instances. With this feature, you can collect: 

* Metrics from NGINX Plus  and NGINX OSS 
* Host metrics  (CPU, memory, disk, and network activity) from VMs or Containers
     

This guide walks you through enabling and configuring the embedded OpenTelemetry Collector for metric export. 

# Key Benefits

* Seamless Integration: No need to deploy an external OpenTelemetry Collector. All components are embedded within the Agent for streamlined observability.
* Standardized Protocol: Support for OpenTelemetry standards ensures interoperability with a wide range of observability backends, including Jaeger, Prometheus, Splunk, and more.

## Before you begin

Before you begin configuring the F5 NGINX Agent OTel Collector:

- [NGINX One Console Getting Started]({{< relref "/nginx-one/getting-started" >}})
- F5 NGINX OSS/Plus installed on a Virtual Machine
- F5 NGINX Agent v3 is installed


## Configure the OTel Collector - Virtual Machine

1. Locate the configuration file for the F5 NGINX Agent:

    ```bash
    /etc/nginx-agent/nginx-agent.conf
    ```
2. Open the configuration file for editing:

    ```bash
    sudo vim /etc/nginx-agent/nginx-agent.conf
    ```

3. Edit the `/etc/nginx-agent/nginx-agent.conf` and add the following. 

    Make sure to replace your-data-plane-key-here with the real data plane key that you are using for your application or service.

    ```vim
    collector:
        receivers:
            host_metrics:
            collection_interval: 1m0s
            initial_delay: 1s
            scrapers:
                cpu: {}
                memory: {}
                disk: {}
                network: {}
                filesystem: {}
        processors:
            batch: {}
        exporters:
            otlp_exporters:
            - server:
                host: <NGINX One Conosle Host>
                port: 443
                authenticator: headers_setter
                tls:
                skip_verify: false
        extensions:
            headers_setter:
            headers:
                - action: insert
                key: "authorization"
                value: "your-data-plane-key-here"
    ```
4. Restart the NGINX Agent service
    
    ```bash
    sudo systemctl restart nginx-agent
    ```

## Running a Container to Connect to the NGINX One Console and Send Metrics

This guide provides step-by-step instructions on how to run a container to connect to the NGINX One Console and send metrics. Follow these steps to ensure proper setup and execution.

---

## Prerequisites
Before running the container, ensure the following:
1. **Docker Installed**: Docker must be installed on your system. You can download it from [Docker's official website](https://www.docker.com/).
2. **NGINX One Console**: The NGINX One Console is set up and accessible.
3. **Data Plane Token**: Obtain an access key or Data Plane token from the NGINX One Console for authentication.
4. **Network Connectivity**: Verify that the container can reach the NGINX One Console endpoint.

---

## Steps to Run the Container

### Step 1: Pull the NGINX Metrics Agent Container Image
The NGINX Metrics Agent container image must be downloaded from a trusted source such as Docker Hub or a private container registry.

Run the following command to pull the official image:
```bash
<!-- Registry HERE -->
docker pull <Registry HERE>:latest
```

Ensure you are using the correct image version. Replace `latest` with the desired version tag if necessary.

---

### Step 2: Create a Configuration File

1. Create a configuration file named `nginx-agent.conf` in your current directory.
2. Populate the file with the following structure:

```vim
command:
  server:
    host: "<NGINX-One-Console-URL>"             # Command server host
    port: 443                    # Command server port
    type: 0                       # Server type (e.g., 0 for gRPC)
  auth:
    token: "<your-data-plane-key-here>"    # Authentication token for the command server
  tls:
    skip_verify: false
    
 collector:
    receivers:
        host_metrics:
        collection_interval: 1m0s
        initial_delay: 1s
        scrapers:
            cpu: {}
            memory: {}
            disk: {}
            network: {}
            filesystem: {}
    processors:
        batch: {}
    exporters:
        otlp_exporters:
        - server:
            host: <saas-host>
            port: 443
            authenticator: headers_setter
            tls:
            skip_verify: false
    extensions:
        headers_setter:
        headers:
            - action: insert
            key: "authorization"
            value: "your-data-plane-key-here"
```

Replace the placeholder values:
- `<NGINX-One-Console-URL>`: The URL of your NGINX One Console instance.
- `<your-data-plane-key-here>`: Your Data Plane access token.

---

### Step 3: Run the Container
Run the NGINX Agent container with the configuration file mounted.

Use the following command:
```bash
docker run -d \
  --name nginx-agent \
  -v $(pwd)/nginx-agent.conf:/etc/nginx-agent/nginx-agent.conf \
  nginx/agent:latest
```

Key options explained:
- `-d`: Runs the container in detached mode.
- `--name nginx-agent`: Assigns a name to the container for easy identification.
- `-v $(pwd)/nginx-agent.conf:/etc/nginx-agent/nginx-agent.conf`: Mounts the configuration file into the container.

---

### Step 4: Verify the Container is Running
Check the running status of the container:
```bash
docker ps
```

You should see an entry for `nginx-agent`. The `STATUS` field should indicate that the container is running.

---

### Step 5: Monitor Logs
To ensure the container is functioning properly and communicating with NGINX One Console, monitor the container logs.

Run the following command:
```bash
docker logs -f nginx-agent
```

Look for log entries indicating successful connection to the NGINX One Console and periodic metric transmission.

---

### Troubleshooting

1. **Container Fails to Start**: 
   - Check the configuration file for errors.
   - Ensure the NGINX One Console endpoint is reachable from the host.

2. **No Metrics Sent**:
   - Verify the access token is valid.
   - Confirm network connectivity to the NGINX One Console.

3. **Logs Show Errors**:
   - Examine the logs for specific error messages.
   - Address any permission or network-related issues.

---

## Clean Up
To stop and remove the container when it is no longer needed, run:
```bash
docker stop nginx-metrics-agent
docker rm nginx-metrics-agent
```

---

## Conclusion
Following these instructions, you can successfully run a container to connect to the NGINX One Console and send metrics. For further details or issues, refer to the documentation provided by NGINX or your administrator.