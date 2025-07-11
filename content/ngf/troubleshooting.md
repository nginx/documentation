---
title: Troubleshooting
toc: true
weight: 600
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-1419
---

This topic describes possible issues when using NGINX Gateway Fabric and general troubleshooting techniques. When possible, suggested workarounds are provided.

### General troubleshooting

When investigating a problem or requesting help, there are important data points that can be collected to help understand what issues may exist.

#### Resource status

To check the status of a resource, use `kubectl describe`. This example checks the status of the `coffee` HTTPRoute, which has an error:

```shell
kubectl describe httproutes.gateway.networking.k8s.io coffee -n nginx-gateway
```

```text
...
Status:
  Parents:
    Conditions:
      Last Transition Time:  2024-05-31T17:20:51Z
      Message:               The route is accepted
      Observed Generation:   4
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2024-05-31T17:20:51Z
      Message:               spec.rules[0].backendRefs[0].name: Not found: "bad-backend"
      Observed Generation:   4
      Reason:                BackendNotFound
      Status:                False
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
    Parent Ref:
      Group:         gateway.networking.k8s.io
      Kind:          Gateway
      Name:          gateway
      Namespace:     default
      Section Name:  http
```

If a resource has errors relating to its configuration or relationship to other resources, they can likely be read in the status. The `ObservedGeneration` in the status should match the `ObservedGeneration` of the resource. Otherwise, this could mean that the resource hasn't been processed yet or that the status failed to update.

If no `Status` is written on the resource, further debug by checking if the referenced resources exist and belong to NGINX Gateway Fabric.

#### Events

Events created by NGINX Gateway Fabric or other Kubernetes components could indicate system or configuration issues. To see events:

```shell
kubectl get events -n nginx-gateway
```

For example, a warning event when the NginxGateway configuration CRD is deleted:

```text
kubectl -n nginx-gateway get event
LAST SEEN   TYPE      REASON              OBJECT                                           MESSAGE
5s          Warning   ResourceDeleted     nginxgateway/ngf-config                          NginxGateway configuration was deleted; using defaults
```

#### Get shell access to NGINX container

Getting shell access to containers allows developers and operators to view the environment of a running container, see its logs or diagnose any problems. To get shell access to the NGINX container, use `kubectl exec`:

```shell
kubectl exec -it -n <nginx-pod-namespace> <nginx-pod-name> -- /bin/sh
```

#### Logs

Logs from the NGINX Gateway Fabric control plane and data plane can contain information that isn't available to status or events. These can include errors in processing or passing traffic.

{{< note >}}
You can see logs for a crashed or killed container by adding the `-p` flag to the `kubectl logs` commands below.
{{< /note >}}

1. Container Logs

   To see logs for the control plane container:

   ```shell
   kubectl -n nginx-gateway logs <ngf-pod-name> -c nginx-gateway
   ```

   To see logs for the data plane container:

   ```shell
   kubectl -n <nginx-pod-namespace> logs <nginx-pod-name> -c nginx
   ```

1. Error Logs

   For the _nginx-gateway_ container, you can `grep` the logs for the word `error`:

   ```shell
   kubectl -n nginx-gateway logs <ngf-pod-name> -c nginx-gateway | grep error
   ```

   For the _nginx_ container you can `grep` for various [error](https://nginx.org/en/docs/ngx_core_module.html#error_log) logs. For example, to search for all logs logged at the `emerg` level:

   ```shell
   kubectl -n <nginx-pod-namespace> logs <nginx-pod-name> -c nginx | grep emerg
   ```

   For example, if a variable is too long, NGINX may display such an error message:

   ```text
   kubectl logs -n dev-env gateway-nginx-bb8598998-jwk2m -c nginx | grep emerg
   2024/06/13 20:04:17 [emerg] 27#27: too long parameter, probably missing terminating """ character in /etc/nginx/conf.d/http.conf:78
   ```

1. Access Logs

   NGINX access logs record all requests processed by the NGINX server. These logs provide detailed information about each request, which can be useful for troubleshooting and analyzing web traffic.
   Access logs can be viewed with the above method of using `kubectl logs`, or by viewing the access log file directly. To do that, get shell access to your NGINX container using these [steps](#get-shell-access-to-nginx-container). The access logs are located in the file `/var/log/nginx/access.log` in the NGINX container.

1. Modify Log Levels

   To modify log levels for the control plane in NGINX Gateway Fabric, edit the `NginxGateway` configuration. This can be done either before or after deploying NGINX Gateway Fabric. Refer to this [guide](https://docs.nginx.com/nginx-gateway-fabric/how-to/control-plane-configuration/) to do so.
   To check error logs, modify the log level to `error` to view error logs. Similarly, change the log level to `debug` and `grep` for the word `debug` to view debug logs.

#### Understanding the generated NGINX configuration

Understanding the NGINX configuration is key for fixing issues because it shows how NGINX handles requests. This helps tweak settings to make sure NGINX behaves the way you want it to for your application. To see your current configuration, you can open a shell in the _nginx_ container by following these [steps](#get-shell-access-to-nginx-container) and run `nginx -T`. To understand the usage of NGINX directives in the configuration file, consult this list of [NGINX directives](https://nginx.org/en/docs/dirindex.html).

In this section, we will see how the configuration gets updated as we configure different Services, Deployments and HTTPRoutes with NGINX Gateway Fabric. In the configuration file, you'll often find several server blocks, each assigned to specific ports and server names. NGINX selects the appropriate server for a request and evaluates the URI against the location directives within that block.
When only a Gateway resource is defined, but no Services or HTTPRoutes are configured, NGINX generates a basic configuration. This includes a default server listening on the ports specified in the Gateway listeners, handling all incoming requests. Additionally, there are blocks to manage errors with status codes 500 or 503.

This is a default `server` block listening on port 80:

```text
server {
    listen 80 default_server;

    default_type text/html;
    return 404;
}
```

Once an HTTPRoute with path matches and rules are defined, nginx.conf is updated accordingly to determine which location block will manage incoming requests. To demonstrate how `nginx.conf` is changed, create some resources:

1. A Gateway with single listener with the hostname `*.example.com` on port 80.
2. A simple `coffee` application.
3. An HTTPRoute that exposes the `coffee` application outside the cluster using the listener created in step 1. The path and rule matches create different location blocks in `nginx.conf` to route requests as needed.

For example, this `coffee` route matches requests with path `/coffee` and type `prefix`. Examine how the `nginx.conf` is modified:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: coffee
spec:
  parentRefs:
    - name: gateway
      sectionName: http
  hostnames:
    - "cafe.example.com"
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /coffee
      backendRefs:
        - name: coffee
          port: 80
```

The modified `nginx.conf`:

```shell
server {
    listen 80 default_server;

    default_type text/html;
    return 404;
}

server {
    listen 80;

    server_name cafe.example.com;


    location /coffee/ {
        proxy_set_header Host "$gw_api_compliant_host";
        proxy_set_header X-Forwarded-For "$proxy_add_x_forwarded_for";
        proxy_set_header Upgrade "$http_upgrade";
        proxy_set_header Connection "$connection_upgrade";
        proxy_http_version 1.1;
        proxy_pass http://default_coffee_80$request_uri;
    }

    location = /coffee {
        proxy_set_header Host "$gw_api_compliant_host";
        proxy_set_header X-Forwarded-For "$proxy_add_x_forwarded_for";
        proxy_set_header Upgrade "$http_upgrade";
        proxy_set_header Connection "$connection_upgrade";
        proxy_http_version 1.1;
        proxy_pass http://default_coffee_80$request_uri;
    }

    location / {
        return 404 "";
    }

}
upstream default_coffee_80 {
    random two least_conn;
    zone default_coffee_80 512k;

    server 10.244.0.13:8080;
}
```

Key information to note is:

1. A new `server` block is created with the hostname of the HTTPRoute. When a request is sent to this hostname, it will be handled by this `server` block.
1. Within the `server` block, three new `location` blocks are added for _coffee_, each with distinct prefix and exact paths. Requests directed to the _coffee_ application with a path prefix `/coffee/hello` will be managed by the first location block, while those with an exact path `/coffee` will be handled by the second location block. Any other requests not recognized by the server block for this hostname will default to the third location block, returning a 404 Not Found status.
1. Each `location` block has headers and directives that configure the NGINX proxy to forward requests to the `/coffee` path correctly, preserving important client information and ensuring compatibility with the upstream server.
1. The `upstream` block in the given NGINX configuration defines a group of backend servers and configures how NGINX should load balance requests among them.

Review the behaviour when a curl request is sent to the `coffee` application:

Matches location /coffee/ block

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee/hello
Handling connection for 8080
Server address: 10.244.0.13:8080
Server name: coffee-56b44d4c55-hwpkp
Date: 13/Jun/2024:22:51:52 +0000
URI: /coffee/hello
Request ID: 21fc2baad77337065e7cf2cd57e04383
```

Matches location = /coffee block

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
Handling connection for 8080
Server address: 10.244.0.13:8080
Server name: coffee-56b44d4c55-hwpkp
Date: 13/Jun/2024:22:51:40 +0000
URI: /coffee
Request ID: 4d8d719e95063303e290ad74ecd7339f
```

Matches location / block

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/
Handling connection for 8080
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.25.4</center>
</body>
```

{{< warning >}}
The configuration may change in future releases. This configuration is valid for version 1.3.
{{< /warning >}}

#### Metrics for troubleshooting

Metrics can be useful to identify performance bottlenecks and pinpoint areas of high resource consumption within NGINX Gateway Fabric. To set up metrics collection, refer to the [Prometheus Metrics guide]({{< ref "/ngf/monitoring/prometheus.md" >}}). The metrics dashboard will help you understand problems with the way NGINX Gateway Fabric is set up or potential issues that could show up with time.

#### Access the NGINX Plus Dashboard

If you have NGINX Gateway Fabric installed with NGINX Plus, you can access the NGINX Plus dashboard at `http://localhost:8080/dashboard.html`.
Verify that the port number (for example, `8080`) matches the port number you have port-forwarded to your NGINX Gateway Fabric Pod. For further details, see the [dashboard guide]({{< ref "dashboard.md" >}})

### Common errors

{{< bootstrap-table "table table-striped table-bordered" >}}

| Problem Area | Symptom | Troubleshooting Method | Common Cause |
|------------------------------|----------------------------------------|---------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| Startup | NGINX Gateway Fabric fails to start. | Check logs for _nginx_ and _nginx-gateway_ containers. | Readiness probe failed. |
| Resources not configured | Status missing on resources. | Check referenced resources. | Referenced resources do not belong to NGINX Gateway Fabric. |
| NGINX errors | Reload failures on NGINX | Fix permissions for control plane. | Security context not configured. |
| NGINX Plus errors | Failure to start; traffic interruptions | Set up the [NGINX Plus JWT]({{< ref "/ngf/install/nginx-plus.md" >}}) | License is not configured or has expired. |
| Client Settings | Request entity too large error | Adjust client settings. Refer to [Client Settings Policy]({{< ref "/ngf/traffic-management/client-settings.md" >}}) | Payload is greater than the [`client_max_body_size`](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size) value.|

{{< /bootstrap-table >}}

##### NGINX fails to reload

NGINX reload errors can occur for various reasons, including syntax errors in configuration files, permission issues, and more. To determine if NGINX has failed to reload, check logs for your _nginx-gateway_ and _nginx_ containers.
You will see the following error in the _nginx-gateway_ logs: `failed to reload NGINX:`, followed by the reason for the failure. Similarly, error logs in _nginx_ container start with `emerg`. For example, `2024/06/12 14:25:11 [emerg] 12345#0: open() "/var/run/nginx.pid" failed (13: Permission denied)` shows a critical error, such as a permission problem preventing NGINX from accessing necessary files.

To debug why your reload has failed, start with verifying the syntax of your configuration files by opening a shell in the NGINX container following these [steps](#get-shell-access-to-nginx-container) and running `nginx -T`. If there are errors in your configuration file, the reload will fail and specify the reason for it.

##### NGINX Gateway Fabric Pod is not running or ready

To understand why the NGINX Gateway Fabric Pod has not started running or is not ready, check the state of the Pod to get detailed information about the current status and events happening in the Pod. To do this, use `kubectl describe`:

```shell
kubectl describe pod <ngf-pod-name> -n nginx-gateway
```

The Pod description includes details about the image name, tags, current status, and environment variables. Verify that these details match your setup and cross-check with the events to ensure everything is functioning as expected. For example, the Pod below has the nginx-gateway container that is running and the events reflect the same.

```text
Containers:
  nginx-gateway:
    Container ID:    containerd://492f380d5919ae2cdca0e009e7a7d5bf4092f8e1910f52d8951d58b73f125646
    Image:           nginx-gateway-fabric:latest
    Image ID:        sha256:c034f1e5bde0490b1f2441e0e9b0bcfce5f2e259bb6210c55d4d67f808a74ecb
    Ports:           8443/TCP, 9113/TCP, 8081/TCP
    Host Ports:      0/TCP, 0/TCP, 0/TCP
    SeccompProfile:  RuntimeDefault
    Args:
      controller
      --gateway-ctlr-name=gateway.nginx.org/nginx-gateway-controller
      --gatewayclass=nginx
      --config=my-release-config
      --service=my-release-nginx-gateway-fabric
      --agent-tls-secret=agent-tls
      --metrics-port=9113
      --health-port=8081
      --leader-election-lock-name=my-release-nginx-gateway-fabric-leader-election
    State:          Running
      Started:      Thu, 24 Apr 2025 10:57:16 -0700
    Ready:          True
    Restart Count:  0
    Readiness:      http-get http://:health/readyz delay=3s timeout=1s period=1s #success=1 #failure=3
    Environment:
      POD_NAMESPACE:  nginx-gateway (v1:metadata.namespace)
      POD_NAME:       my-release-nginx-gateway-fabric-b99bd5cdd-qzp5q (v1:metadata.name)
      POD_UID:         (v1:metadata.uid)
      INSTANCE_NAME:   (v1:metadata.labels['app.kubernetes.io/instance'])
      IMAGE_NAME:     nginx-gateway-fabric:latest
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-5dg45 (ro)
      /var/run/secrets/ngf from nginx-agent-tls (rw)
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  22s   default-scheduler  Successfully assigned nginx-gateway/my-release-nginx-gateway-fabric-b99bd5cdd-qzp5q to kind-control-plane
  Normal  Pulled     20s   kubelet            Container image "nginx-gateway-fabric:latest" already present on machine
  Normal  Created    20s   kubelet            Created container: nginx-gateway
  Normal  Started    20s   kubelet            Started container nginx-gateway
```

##### NGINX Pod is not running or ready

To understand why the NGINX Pod has not started running or is not ready, check the state of the Pod to get detailed information about the current status and events happening in the Pod. To do this, use `kubectl describe`:

```shell
kubectl describe pod <nginx-pod-name> -n <nginx-pod-namespace>
```

The Pod description includes details about the image name, tags, current status, and environment variables. Verify that these details match your setup and cross-check with the events to ensure everything is functioning as expected. For example, the Pod below has the nginx container that is running and the events reflect the same.

```text
Containers:
  nginx:
    Container ID:    containerd://0dd33fd358ba3b369de315be15b197e369342aba7aa8d3ea12e4455823fa90ce
    Image:           nginx-gateway-fabric/nginx:latest
    Image ID:        sha256:e5cb19bab49cbde6222df607a0946e1e00c1af767263b79ae36e4c69f8547f20
    Ports:           80/TCP, 9113/TCP
    Host Ports:      0/TCP, 0/TCP
    SeccompProfile:  RuntimeDefault
    State:           Running
      Started:       Thu, 24 Apr 2025 10:57:36 -0700
    Ready:           True
    Restart Count:   0
    Environment:     <none>
    Mounts:
      /etc/nginx-agent from nginx-agent (rw)
      /etc/nginx/conf.d from nginx-conf (rw)
      /etc/nginx/includes from nginx-includes (rw)
      /etc/nginx/main-includes from nginx-main-includes (rw)
      /etc/nginx/secrets from nginx-secrets (rw)
      /etc/nginx/stream-conf.d from nginx-stream-conf (rw)
      /var/cache/nginx from nginx-cache (rw)
      /var/lib/nginx-agent from nginx-agent-lib (rw)
      /var/log/nginx-agent from nginx-agent-log (rw)
      /var/run/nginx from nginx-run (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-f9kph (ro)
      /var/run/secrets/ngf from nginx-agent-tls (rw)
      /var/run/secrets/ngf/serviceaccount from token (rw)
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  2m57s  default-scheduler  Successfully assigned default/gateway-nginx-85f7f6d7d-fx7q2 to kind-control-plane
  Normal  Pulled     2m54s  kubelet            Container image "nginx-gateway-fabric:latest" already present on machine
  Normal  Created    2m54s  kubelet            Created container: init
  Normal  Started    2m54s  kubelet            Started container init
  Normal  Pulled     2m53s  kubelet            Container image "nginx-gateway-fabric/nginx:latest" already present on machine
  Normal  Created    2m53s  kubelet            Created container: nginx
  Normal  Started    2m53s  kubelet            Started container nginx
```

##### NGINX Plus failure to start or traffic interruptions

Beginning with NGINX Gateway Fabric 1.5.0, NGINX Plus requires a valid JSON Web Token (JWT) to run. If this is not set up properly, or your JWT token has expired, you may see errors in the NGINX logs that look like the following:

```text
nginx: [error] invalid license token
```

```text
nginx: [emerg] License file is required. Download JWT license from MyF5 and configure its location...
```

```text
nginx: [emerg] license expired
```

These errors could prevent NGINX Plus from starting or prevent traffic from flowing. To fix these issues, see the [NGINX Plus JWT]({{< ref "/ngf/install/nginx-plus.md" >}}) guide.

##### 413 Request Entity Too Large

If you receive the following error:

```text
<html>
<head><title>413 Request Entity Too Large</title></head>
<body>
<center><h1>413 Request Entity Too Large</h1></center>
<hr><center>nginx/1.25.5</center>
</body>
</html>
```

Or view the following error message in the NGINX logs:

```text
2024/05/30 21:48:22 [error] 138#138: *43 client intended to send too large body: 112 bytes, client: 127.0.0.1, server: cafe.example.com, request: "POST /coffee HTTP/1.1", host: "cafe.example.com:8080"
```

The request body exceeds the [client_max_body_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size).
To **resolve** this, you can configure the `client_max_body_size` using the `ClientSettingsPolicy` API. Read the [Client Settings Policy]({{< ref "/ngf/traffic-management/client-settings.md" >}}) documentation for more information.

##### IP Family Mismatch Errors

If you `describe` your HTTPRoute and see the following error:

```text
    Conditions:
      Last Transition Time:  2024-07-14T23:36:37Z
      Message:               The route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2024-07-14T23:36:37Z
      Message:               Service configured with IPv4 family but NginxProxy is configured with IPv6
      Observed Generation:   1
      Reason:                InvalidServiceIPFamily
      Status:                False
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
```

The Service associated with your HTTPRoute is configured with a IP Family different than the one specified in the NginxProxy configuration.
To **resolve** this, you can do one of the following:

- Update the NginxProxy configuration with the proper [`ipFamily`]({{< ref "/ngf/reference/api.md" >}}) field. You can edit the NginxProxy configuration using `kubectl edit`. For example:

  ```shell
  kubectl edit -n nginx-gateway nginxproxies.gateway.nginx.org ngf-proxy-config
  ```

- When installing NGINX Gateway Fabric, change the IPFamily by modifying the field `nginx.config.ipFamily` in the `values.yaml` or add the `--set nginx.config.ipFamily=` flag to the `helm install` command. The supported IPFamilies are `ipv4`, `ipv6` and `dual` (default).

- Adjust the IPFamily of your Service to match that of the NginxProxy configuration.

##### Policy cannot be applied to target

If you `describe` your Policy and see the following error:

```text
    Conditions:
      Last Transition Time:  2024-08-20T14:48:53Z
      Message:               Policy cannot be applied to target "default/route1" since another Route "default/route2" shares a hostname:port/path combination with this target
      Observed Generation:   3
      Reason:                TargetConflict
      Status:                False
      Type:                  Accepted
```

This means you are attempting to attach a Policy to a Route that has an overlapping hostname:port/path combination with another Route. To work around this, you can do one of the following:

- Combine the Route rules for the overlapping path into a single Route.
- If the Policy allows it, specify both Routes in the `targetRefs` list.

##### Broken Header error

If you check your _nginx_ container logs and see the following error:

```text
  2024/07/25 00:50:45 [error] 211#211: *22 broken header: "GET /coffee HTTP/1.1" while reading PROXY protocol, client: 127.0.0.1, server: 0.0.0.0:80
```

It indicates that `proxy_protocol` is enabled for the gateway listeners, but the request sent to the application endpoint does not contain proxy information. To **resolve** this, you can do one of the following:

- Unassign the field [`rewriteClientIP.mode`]({{< ref "/ngf/reference/api.md" >}}) in the NginxProxy configuration.

- Send valid proxy information with requests being handled by your application.

#### Custom Resource Definition is invalid due to being too large 

If you apply the NGINX Gateway Fabric CRDs and see the following error:

```text
The CustomResourceDefinition "nginxproxies.gateway.nginx.org" is invalid: metadata.annotations: Too long: may not be more than 262144 bytes
```

This is a known issue with Kubernetes, more specifically the client-side-apply annotation limit with kubectl, and our recommended workaround 
is to use kubectl's server-side apply when installing the NGINX Gateway Fabric CRDs. To do this, you can use the `--server-side` flag when applying the CRDs:

```shell
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/crds.yaml
```

### See also

You can view the [Kubernetes Troubleshooting Guide](https://kubernetes.io/docs/tasks/debug/debug-application/) for more debugging guidance.
