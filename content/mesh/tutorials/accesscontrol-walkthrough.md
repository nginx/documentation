---
title: "Services using Access Control"
description: "This article provides a guide for using access control between services."
weight: 130
toc: true
nd-docs: "DOCS-719"
---

## Overview

You can use access control to shape traffic within your cluster and mesh. By default all services within the mesh can freely communicate, which might not be appropriate for larger production grade microservices. If traffic shaping is necessary, you can use access control resources to allow traffic to and from specific source and destination endpoints. You can apply basic rules at the L4 layer, and apply more complex, granular rules at the L7 HTTP layer.

The access control mode can be [set to `deny` at the global level]( {{< ref "/mesh/get-started/install/configuration.md#access-control" >}} ), which prevents any traffic from flowing until access control policies are defined. This tutorial assumes that the access control mode is set to the default value of `allow`.

## Before You Begin

1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
1. [Deploy F5 NGINX Service Mesh]({{< ref "/mesh/get-started/install/install.md" >}}) in your Kubernetes cluster.
1. Enable [automatic sidecar injection]( {{< ref "/mesh/guides/inject-sidecar-proxy.md#automatic-proxy-injection" >}} ) for the `default` namespace.
1. Download all of the example files:

    - {{< icon "download" >}} {{< link "/examples/dest-svc.yaml" >}}
    - {{< icon "download" >}} {{< link "/examples/access.yaml" >}}
    - {{< icon "download" >}} {{< link "/examples/driver-allowed.yaml" >}}
    - {{< icon "download" >}} {{< link "/examples/driver-disallowed.yaml" >}}

## Objectives

Follow the steps in this guide to learn how to use access control between services.

### Deploy the Destination Service

1. To begin, we'll deploy a destination target server as a Deployment and ConfigMap, a destination Service, and a ServiceAccount to provide a TrafficTarget destination resource.
  {{< call-out "tip" >}}
ServiceAccount resources are used to classify sets of workloads for access control. Multiple different types of workloads can participate in the same ServiceAccount to create M:N traffic relationships, or scaled down to a workload type per ServiceAccount for more granular control of communications. For example, a collection of frontend services that all need access to authentication or SSO endpoints can be classified together within a ServiceAccount to simplify configuration.
  {{< /call-out >}}

    **Command:**

    ```bash
    kubectl apply -f dest-svc.yaml
    ```

    **Expectation:** Deployment, Service, ServiceAccount, and ConfigMap resources are deployed successfully.

    Use `kubectl` to make sure the resources deploy successfully.

    ```bash
    kubectl get pods
    NAME                                 READY   STATUS    RESTARTS   AGE
    dest-svc-69f4b86fb4-r8wzh            2/2     Running   0          2m
    ```

    For other resource types -- for example, Deployments, ConfigMaps, Services, or ServiceAccounts -- use `kubectl get` for each type as appropriate.

1. Once the destination workload is ready, we can generate unfiltered traffic. Use a separate terminal window in order to watch traffic flow as a request driver begins sending requests.

    **Commands:**
    - Stream the destination workload's logs in your previous terminal:

      ```bash
      kubectl logs -l app=dest-svc -f -c dest-svc
      ```

    - Start an unfiltered driver to send request traffic:

      ```bash
      kubectl apply -f driver-allowed.yaml
      ```

    **Expectation:** Requests will start 10 seconds after the driver-allowed pod becomes ready. The log stream should begin showing activity by responding to requests.

    For additional verification use the `nginx-meshctl top` command to view traffic statistics.

    ```bash
    nginx-meshctl top
    Deployment         Incoming Success  Outgoing Success  NumRequests
    driver-allowed                       100.00%           15
    dest-svc           100.00%                             15
    ```

1. Once traffic is flowing unfiltered between the driver and workload, open a third terminal to establish a second driver workload. This traffic will start unfiltered and will be restricted as we proceed.

    **Commands:**
    - Start an unfiltered driver to send request traffic:

      ```bash
      kubectl apply -f driver-disallowed.yaml
      ```

    - Stream the new driver's logs:

      ```bash
      kubectl logs -l app=driver-disallowed -f -c driver
      ```

    **Expectation:** Requests will start 10 seconds after the driver-disallowed pod becomes ready. The log stream should begin showing successful activity with response output.

    Example:

    ```bash
    *   Trying 10.100.5.18:8080...
    * Connected to dest-svc (10.100.5.18) port 8080 (#0)
    > GET /echo HTTP/1.1
    > Host: dest-svc:8080
    > User-Agent: curl/7.72.0-DEV
    > Accept: */*
    > x-demo-1:demo-1
    > x-demo-2:demo-2
    > x-demo-3:demo-3
    >
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 200 OK
    < Server: nginx/1.19.0
    < Date: Wed, 23 Sep 2020 23:51:31 GMT
    < Content-Type: text/plain
    < Content-Length: 20
    < Connection: keep-alive
    < X-Mesh-Request-ID: 45d9b1ffc53bde6aa5478a0d688894d5
    <
    { [20 bytes data]
    * Connection #0 to host dest-svc left intact
    destination service
    ```

    Once again, verify traffic statistics using `nginx-meshclt top`.

    ```bash
    nginx-meshctl top
    Deployment         Incoming Success  Outgoing Success  NumRequests
    driver-allowed                       100.00%           15
    driver-disallowed                    100.00%           15
    dest-svc           100.00%                             30
    ```

1. At this point, traffic should be freely flowing between each workload. We can now apply an HTTPRouteGroup and TrafficTarget to restrict traffic. The TrafficTarget resource establishes the source and destination relationship. It also applies the selected rules to further refine what traffic should flow between the various services. The rules are expressed via HTTPRouteGroup and TCPRoute resources; these examples will use the HTTPRouteGroup rule specifications.

    **Command:**
    - Apply the access controls:

      ```bash
      kubectl apply -f access.yaml
      ```

    **Expectation:** Once applied there should be no change in traffic between the driver-allowed and dest-svc workloads. The driver-disallowed should begin receiving HTTP 403 Forbidden errors.

    Example:

    ```bash
    *   Trying 10.100.5.18:8080...
    * Connected to dest-svc (10.100.5.18) port 8080 (#0)
    > GET /echo HTTP/1.1
    > Host: dest-svc:8080
    > User-Agent: curl/7.72.0-DEV
    > Accept: */*
    > x-demo-1:demo-1
    > x-demo-2:demo-2
    > x-demo-3:demo-3
    >
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 403 Forbidden
    < Server: nginx/1.19.0
    < Date: Wed, 23 Sep 2020 23:53:56 GMT
    < Content-Type: text/html
    < Content-Length: 153
    < Connection: keep-alive
    <
    { [153 bytes data]
    * Connection #0 to host dest-svc left intact
    <html>
    <head><title>403 Forbidden</title></head>
    <body>
    <center><h1>403 Forbidden</h1></center>
    <hr><center>nginx/1.19.0</center>
    </body>
    </html>
    ```

    Verify with `nginx-meshctl top`; driver-disallowed will display a 0 success rate.

    ```bash
    nginx-meshctl top
    Deployment         Incoming Success  Outgoing Success  NumRequests
    driver-allowed                       100.00%           15
    driver-disallowed                    0.00%             15
    dest-svc           100.00%                             30
    ```

    Let's take a closer look at what we've configured. We now have this configuration topology:

    ```txt
    --------------
    | driver     |    -----------
    | allowed    | -> | sidecar | --
    --------------    -----------   \
                                     \    -----------    ------------
                                      --> | sidecar | -> | dest-svc |
                                     /    -----------    ------------
    --------------    -----------   /
    | driver     | -> | sidecar | --
    | disallowed |    -----------
    --------------
    ```

    Each driver is sending this request:

    ```txt
    GET HTTP/1.1 /echo
    Host: dest-svc:8080
    x-demo-1:demo-1
    x-demo-2:demo-2
    x-demo-3:demo-3
    ```

    And we've configured these access control constraints:

    ```yaml
    apiVersion: access.smi-spec.io/v1alpha2
    kind: TrafficTarget
    metadata:
      name: traffic-target
    spec:
      destination:
        kind: ServiceAccount
        name: destination-sa
      rules:
      - kind: HTTPRouteGroup
        name: route-group
        matches:
        - destination-traffic
      sources:
      - kind: ServiceAccount
        name: source-allowed-sa
    ```

    ```yaml
    apiVersion: specs.smi-spec.io/v1alpha3
    kind: HTTPRouteGroup
    metadata:
      name: route-group
    spec:
      matches:
      - name: destination-traffic
        methods:
        - GET
        pathRegex: "/echo"
        headers:
          X-Demo-1: "^demo-1$"
          x-demo-2: "demo"
    ```

    Let's take a look at the subsequent configuration.
    The TrafficTarget `.spec.sources` and `.spec.destination` reference the allowed source and destination identities; this TrafficTarget configuration allows traffic from the ServiceAccount `source-allowed-sa` to the ServiceAccount `destination-sa`.
    Additionally, the `.spec.rules` configuration maps the HTTPRouteGroup's `.spec.matches` directives to the TrafficTarget. The match directive allows `GET` methods to the `/echo` path regex, with the headers `X-Demo-1: ^demo-1$` and `x-demo-2: demo` regex values.
    {{< call-out "note" >}}
The header capitalization mismatches intentionally, header names are not case-sensitive and they match regardless of case.
    {{< /call-out >}}
    We've configured our driver-allowed workload in the `source-allowed-sa` ServiceAccount (that is to say, we've given it the `source-allowed-sa` identity). But our driver-disallowed workload is configured in the `source-disallowed-sa` ServiceAccount. This source identity is not allowed, so even traffic which passes our filtering rules remains forbidden.

1. Activate previously disallowed traffic.

    **Command:**

    ```bash
    kubectl edit traffictarget traffic-target
    ```

    Add the previously denied source:

    ```yaml
    apiVersion: access.smi-spec.io/v1alpha2
    kind: TrafficTarget
    metadata:
      name: traffic-target
    spec:
      destination:
        kind: ServiceAccount
        name: destination-sa
      rules:
      - kind: HTTPRouteGroup
        name: route-group
        matches:
          - destination-traffic
      sources:
      - kind: ServiceAccount
        name: source-allowed-sa
      - kind: ServiceAccount
        name: source-disallowed-sa
    ```

    **Expectation:** Without restarting, HUP'ing, or re-rolling Pods or Deployments the traffic should begin to succeed for the driver-disallowed workload.

### Summary

You should now have a functioning access control configuration that shapes the topology of your mesh. The configuration provided here is very flexible and we encourage you to continue to experiment with different configurations. The provided drivers can be configured to send different methods, different paths, different headers, and to the Service name of your choice.

Each driver's ConfigMap supports the following options:

{{% table %}}
Parameter | Type | Description
---|---|---
`host` | string | base URL of target Service
`request_path` | string | request path
`method` | string | HTTP method to use
`headers` | string | comma-delimited list of additional request headers to include
{{% /table %}}

The destination workload can be set to serve different ports, or multiple ports. To configure the destination workload, edit the `dest-svc.yaml` file. An example configuration is shown below:

NGINX `dest-svc` Configuration:

- Update the Pod container port: `.spec.template.spec.containers[0].ports[0].containerPort`.
- Update the ConfigMap NGINX listen port: `.data.nginx.conf: http.server.listen`.
- Update the Service port: `.spec.ports[0].port`.

The following examples show snippets of the relevant sections:

  ```yaml
  ---
  kind: Deployment
  spec:
    template:
      spec:
        containers:
        - name: example
          - containerPort: 55555
  ---
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: dest-svc
  data:
    nginx.conf: |-
      events {}
      http {
        server {
          listen 55555;
          location / {
            return 200 "destination service\n";
          }
        }
      }
  ---
  kind: Service
  spec:
    ports:
    - port: 55555
  ```

Traffic can be filtered via sets that are classified via ServiceAccounts. But [TrafficSpecs](https://github.com/servicemeshinterface/smi-spec/blob/master/apis/traffic-specs/v1alpha3/traffic-specs.md) provide additional powerful configurations; lists of HTTP methods, path regular expression matching, header regular expression matching, and specific ports.
  {{< call-out "tip" >}}
For exact matches, be sure to use regular expression anchors. To exactly match the header value `hello`, be sure to use `^hello$`; otherwise, additional headers that contain the sequence `hello` will be allowed.
  {{< /call-out >}}
{{< call-out "tip" >}}
For an expanded example showing configuration for an application using a headless service, checkout our example for clustered application traffic policies {{< fa "download" >}} {{< link "/examples/clustered-application.yaml" >}}
{{< /call-out >}}

## Resources

- [SMI Traffic Access Example on GitHub](https://github.com/servicemeshinterface/smi-spec/blob/master/apis/traffic-access/v1alpha2/traffic-access.md#example-implementation) (external)
