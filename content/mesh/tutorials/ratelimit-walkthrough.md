---
title: Configure Rate Limiting
description: Learn how to configure rate limiting between workloads.
draft: false
toc: true
weight: 140
nd-docs: DOCS-724
type:
- tutorial
---

## Overview

Rate limiting allows you to limit the number of HTTP requests a user can make in a given period to protect your application from being overwhelmed with traffic.

In a Kubernetes environment, rate limiting is traditionally applied at the ingress layer, restricting the number of requests that an external user can make into the cluster.

However, applications with a microservices architecture might also want to apply rate limits between their workloads running inside the cluster. For example, a rate limit applied to a particular microservice can prevent mission-critical components from being overwhelmed at times of peak traffic and attack, leading to extended periods of downtime for your users.

This tutorial shows you how to set up rate limiting policies between your workloads in F5 NGINX Service Mesh and how to attach L7 rules to a rate limit policy to give you fine-grained control over the type of traffic that is limited.

## Before You Begin

1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
1. [Deploy NGINX Service Mesh]({{< ref "/mesh/get-started/install/install.md" >}}) in your Kubernetes cluster.
1. Enable [automatic sidecar injection]( {{< ref "/mesh/guides/inject-sidecar-proxy.md#automatic-proxy-injection" >}} ) for the `default` namespace.
1. Download all of the example files:

    - {{< icon "download" >}} {{< link "/examples/rate-limit/destination.yaml" "`destination.yaml`" >}}
    - {{< icon "download" >}} {{< link "/examples/rate-limit/client-v1.yaml" "`client-v1.yaml`" >}}
    - {{< icon "download" >}} {{< link "/examples/rate-limit/client-v2.yaml" "`client-v2.yaml`" >}}
    - {{< icon "download" >}} {{< link "/examples/rate-limit/bursty-client.yaml" "`bursty-client.yaml`" >}}
    - {{< icon "download" >}} {{< link "/examples/rate-limit/ratelimit.yaml" "`ratelimit.yaml`" >}}
    - {{< icon "download" >}} {{< link "/examples/rate-limit/ratelimit-burst.yaml" "`ratelimit-burst.yaml`" >}}
    - {{< icon "download" >}} {{< link "/examples/rate-limit/ratelimit-rules.yaml" "`ratelimit-rules.yaml`" >}}

{{< call-out "note" >}}
Avoid configuring traffic policies such as TrafficSplits, RateLimits, and CircuitBreakers for headless services.
These policies will not work as expected because NGINX Service Mesh has no way to tie each pod IP address to its headless service.
{{< /call-out >}}

## Objectives

Follow the steps in this guide to configure rate limiting between workloads.

### Deploy the Destination Server

1. To begin, deploy a destination server as a Deployment, ConfigMap, and a Service.

   **Command:**

    ```bash
    kubectl apply -f destination.yaml
    ```

   **Expectation:** Deployment, ConfigMap, and Service are deployed successfully.

    Use `kubectl` to make sure the resources deploy successfully.

    ```bash
    kubectl get pods
    NAME                             READY   STATUS    RESTARTS   AGE
    dest-69f4b86fb4-r8wzh            2/2     Running   0          76s
    ```

   {{< call-out "note" >}}
   For other resource types -- for example, Deployments or Services -- use `kubectl get` for each type as appropriate.
   {{< /call-out >}}

### Deploy the Clients

Now that the destination workload is ready, you can create clients and generate unlimited traffic to the destination service.

1. Create the `client-v1` and `client-v2` Deployments. The clients are configured to send one request to the destination service every second.

   **Command:**

    ```bash
    kubectl apply -f client-v1.yaml -f client-v2.yaml
    ```

   **Expectation:** The client Deployments and Configmaps are deployed successfully.

    There should be three Pods running in the default namespace:

    ```bash
    kubectl get pods
    NAME                         READY   STATUS    RESTARTS   AGE
    client-v1-5776794486-m42bb   2/2     Running   0          26s
    client-v2-795bc558c9-x7dgx   2/2     Running   0          26s
    dest-69f4b86fb4-r8wzh        2/2     Running   0          1m46s
    ```

1. Open a new terminal window and stream the logs from the `client-v1` container.

   **Command:**

      ```bash
      kubectl logs -l app=client-v1 -f -c client
      ```

   **Expectation:** Requests will start 10 seconds after the `client-v1` Pod is ready. Since we have not applied a rate limit policy, this traffic will be unlimited; therefore, all the requests should be successful.

    In the logs from the `client-v1` container, you should see the following responses from the destination server:

    ```bash
      Hello from destination service!
      Method: POST
      Path: /configuration-v1
      "x-demo": true
      Time: Tuesday, 17-Aug-2021 21:55:19 UTC

      Hello from destination service!
      Method: POST
      PATH: /configuration-v1
      "x-demo": true
      Time: Tuesday, 17-Aug-2021 21:55:20 UTC
      ```

   Note that the request time, path, method, and value of the `x-demo` header are logged for each request. The timestamp should show that the requests are spaced out by 1 second.

1. Open another terminal window and stream the logs from the `client-v2` container.

   **Command:**

   ```bash
     kubectl logs -l app=client-v2 -f -c client
   ```

   **Expectation:** Requests will start 10 seconds after the `client-v2` Pod is ready. Since we have not applied a rate limit policy to the clients and destination server, this traffic will be unlimited; therefore, all the requests should be successful.

   In the logs from the `client-v2` container, you should see the following responses from the destination server:

   ```bash
   Hello from destination service!
   Method: GET
   Path: /configuration-v2
   "x-demo": true
   Time: Tuesday, 17-Aug-2021 22:03:35 UTC

   Hello from destination service!
   Method: GET
   Path: /configuration-v2
   "x-demo": true
   Time: Tuesday, 17-Aug-2021 22:03:36 UTC
   ```

### Create a Rate Limit Policy

At this point, traffic should be flowing unabated between the clients and the destination service.

1. To create a rate limit policy to limit the amount of requests that `client-v1` can send, take the following steps:

   **Command:** Create the rate limit policy.

   ```bash
   kubectl create -f ratelimit.yaml
   ```

   **Expectation:** Once created, the requests from `client-v1` should be limited to 10 requests per minute, or one request every six seconds. In the logs of the `client-v1` container, you should see that five of every six requests are denied. If you look at the timestamps of the successful requests, you should see that they are six seconds apart. The requests from `client-v2` should not be limited.

   **Example**:

   ```bash
   kubectl logs -l app=client-v1 -f -c client

   Hello from destination service!
   Method: GET
   Path: /configuration-v1
   "x-demo": true
   Time: Friday, 13-Aug-2021 21:17:41 UTC


   <html>
   <head><title>503 Service Temporarily Unavailable</title></head>
   <body>
   <center><h1>503 Service Temporarily Unavailable</h1></center>
   <hr><center>nginx/1.19.10</center>
   </body>
   </html>


   <html>
   <head><title>503 Service Temporarily Unavailable</title></head>
   <body>
   <center><h1>503 Service Temporarily Unavailable</h1></center>
   <hr><center>nginx/1.19.10</center>
   </body>
   </html>


   <html>
   <head><title>503 Service Temporarily Unavailable</title></head>
   <body>
   <center><h1>503 Service Temporarily Unavailable</h1></center>
   <hr><center>nginx/1.19.10</center>
   </body>
   </html>
    ```

   **Consideration**:

   Let's take a closer look at the rate limit policy we've configured:

    ```yaml
    apiVersion: specs.smi.nginx.com/v1alpha2
    kind: RateLimit
    metadata:
      name: ratelimit-v1
      namespace: default
    spec:
      destination:
        kind: Service
        name: dest-svc
        namespace: default
      sources:
      - kind: Deployment
        name: client-v1
        namespace: default
      name: 10rm
      rate: 10r/m
    ```

   The `.spec.destination` is the service receiving the requests, and the `.spec.sources` is a list of clients sending requests to the destination. The destination and sources do not need to be in the same namespace; cross-namespace rate limiting is supported.

   The `.spec.rate` is the rate to restrict traffic, expressed in requests per second or per minute.

   This rate limit policy allows 10 requests per minute, or one request every six seconds, to be sent from `client-v1` to `dest-svc`.

   {{< call-out "note" >}}
   The `.spec.destination.kind` and `spec.source.kind` can be a `Service`, `Deployment`, `Pod`, `Daemonset`, or `StatefulSet`.
   {{< /call-out >}}

1. The rate limit configured above only limits requests sent from `client-v1`. To limit the requests sent from `client-v2`, take the following steps to add `client-v2` to the list of sources:

   **Command:**

    ```bash
    kubectl edit ratelimit ratelimit-v1
    ```

   Add the `client-v2` Deployment to `spec.sources`:

    ```yaml
   apiVersion: specs.smi.nginx.com/v1alpha2
   kind: RateLimit
   metadata:
     name: ratelimit-v1
     namespace: default
   spec:
     destination:
       kind: Service
       name: dest-svc
       namespace: default
     sources:
     - kind: Deployment
       name: client-v1
       namespace: default
     - kind: Deployment
       name: client-v2
       namespace: default
     name: 10rm
     rate: 10r/m
    ```

   Save your edits and exit the editor.

   **Expectation:** The requests sent from `client-v2` should be limited now. When multiple sources are listed in the rate limit spec, the rate is divided evenly across all the sources. In this spec, `client-v1` and `client-v2` can send five requests per minute or one request every 12 seconds. To verify, watch the logs of each container and check that 11 out of every 12 requests are denied.

   {{< call-out "tip" >}}
   If you want to enforce a single rate limit across all clients, you can omit the source list from the rate limit spec. If there no sources are listed, the rate limit applies to all clients making requests to the destination.

   If you want to enforce a different rate limit per source, you can create a separate rate limit for each source.
   {{< /call-out >}}

### Rate Limits with L7 Rules

So far, we've configured basic rate-limiting policies based on the source and destination workloads.

What if you have a workload that exposes several endpoints, where each endpoint can handle a different amount of traffic? Or you're performing A/B testing and want to rate limit requests based on the value or presence of a header?

This section shows you how to configure rate limit rules to create more advanced L7 policies that apply to specific parts of an application rather than the entire Pod.

Let's revisit the logs of our `client-v1` and `client-v2` containers, which at this point are both rate limiting at a rate of 5r/m each. Each client is sending a different type of request.

`client-v1` and `client-v2` make requests to the destination service with the following attributes:

{{% table %}}
| attribute     | client-v1           | client-v2           |
|---------------|---------------------|---------------------|
| **path**      | `/configuration-v1` | `/configuration-v2` |
| **headers**   | `x-demo:true`       | `x-demo:true`       |
| **method**    | `POST`              | `GET`               |
{{% /table %}}

If you want to limit all GET requests, you can create an `HTTPRouteGroup` resource and add a rules section to the rate limit. Consider the following configuration:

   ```yaml
   apiVersion: specs.smi-spec.io/v1alpha3
   kind: HTTPRouteGroup
   metadata:
     name: hrg
     namespace: default
   spec:
     matches:
     - name: get-only
       methods:
       - GET
     - name: demo-header
       headers:
         X-Demo: "^true$"
     - name: config-v1-path
       pathRegex: "/configuration-v1"
     - name: v2-only
       pathRegex: "/configuration-v2"
       headers:
         X-DEMO: "^true$"
       methods:
       - GET
   ```

   {{< call-out "note" >}}
   The header capitalization `X-Demo` and `X-DEMO` in the `HTTPRouteGroup` mismatches intentionally; header names are not case-sensitive.
   {{< /call-out >}}

   The [HTTPRouteGroup](https://github.com/servicemeshinterface/smi-spec/blob/main/apis/traffic-specs/v1alpha3/traffic-specs.md#httproutegroup) is used to describe HTTP traffic.
   The `spec.matches` field defines a list of routes that an application can serve. Routes are made up of the following match conditions: pathRegex, headers, and HTTP methods.

   In the `hrg` above, four matches are defined: `get-only`, `demo-header`, `config-v1-path`, and `v2-only`.

   You can limit all `GET` requests by referencing the `get-only` match from `hrg` in our rate limit spec:

   ```yaml
   apiVersion: specs.smi.nginx.com/v1alpha2
   kind: RateLimit
   metadata:
      name: ratelimit-v1
      namespace: default
   spec:
      destination:
        kind: Service
        name: dest-svc
        namespace: default
      sources:
      - kind: Deployment
        name: client-v1
        namespace: default
      - kind: Deployment
        name: client-v2
        namespace: default
      name: 10rm
      rate: 10r/m
      rules:
      - kind: HTTPRouteGroup
        name: hrg
        matches:
        - get-only
   ```

   The `.spec.rules` list maps HTTPRouteGroup's `.spec.matches` directives to the rate limit. This means that the rate limit only applies if the request's attributes satisfy the match conditions outlined in the match directive.

   If there are multiple rules and/or multiple matches per rule, the rate limit will be applied if the request satisfies any of the specified matches.

   In this case, we're mapping just the `get-only` match directive from the `HTTPRouteGroup` : `hrg` to our rate limit . The match `get-only` matches all `GET` requests.

   {{< call-out "tip" >}}
   You can reference multiple `HTTPRouteGroups` in the `spec.rules` list, but they all must be in the same namespace of the rate limit.
   {{< /call-out >}}

1. To rate limit only `GET` requests, take the following steps:

   **Command:**

      ```bash
      kubectl apply -f ratelimit-rules.yaml
      ```

   **Expectation:** Requests from `client-v`2 should still be rate limited. Since `client-v1` is making `POST` requests, all of its requests should now be successful.

1. Edit the rate limit and add the `config-v1-path` match to the rules:

   **Command:**

     ```bash
     kubectl edit ratelimit ratelimit-v1
     ```

   Add the match `config-v1-path` to the `spec.rules[0].matches` list:

   ```yaml
   apiVersion: specs.smi.nginx.com/v1alpha2
   kind: RateLimit
   metadata:
      name: ratelimit-v1
      namespace: default
   spec:
      destination:
        kind: Service
        name: dest-svc
        namespace: default
      sources:
      - kind: Deployment
        name: client-v1
        namespace: default
      - kind: Deployment
        name: client-v2
        namespace: default
      name: 10rm
      rate: 10r/m
      rules:
      - kind: HTTPRouteGroup
        name: hrg
        matches:
        - get-only
        - config-v1-path
   ```

   Save your edits and close the editor.

   **Expectation:** Requests from both `client-v1` and `client-v2` are rate limited. If multiple matches or rules are listed in the rate limit spec, then the request has to satisfy only one of the matches. Therefore, the rules in this rate limit apply to any request that is either a `GET` request or has a path of `/configuration-v1`.

1. Edit the rate limit and add a more complex match directive.

   If you want to rate limit requests that have a combination of method, path, and headers, you can create a more complex match. For example, consider the `v2-only` match in our `HTTPRouteGroup`:

   ```yaml
   - name: v2-only
     pathRegex: "/configuration-v2"
     headers:
       X-DEMO: "^true$"
     methods:
     - GET
   ```

   This configuration matches `GET` requests with the `x-demo:true` header and a path of `/configuration-v2`.

   Try it out by editing the RateLimit and replacing the matches in rules with the `v2-only` match.

   **Command:**

   ```bash
   kubectl edit ratelimit ratelimit-v1
   ```

   Remove all of the matches from `spec.rules[0].matches` and add the `v2-only` match:

   ```yaml
   apiVersion: specs.smi.nginx.com/v1alpha2
   kind: RateLimit
   metadata:
      name: ratelimit-v1
      namespace: default
   spec:
      destination:
        kind: Service
        name: dest-svc
        namespace: default
      sources:
      - kind: Deployment
        name: client-v1
        namespace: default
      - kind: Deployment
        name: client-v2
        namespace: default
      name: 10rm
      rate: 10r/m
      rules:
      - kind: HTTPRouteGroup
        name: hrg
        matches:
        - v2-only
   ```

   Save your edits and close the editor.

   **Expectation:** Only the requests from `client-v2` are rate limited. Even though `client-v1` has the `x-demo:true` header, the rest of the request's attributes do not match the criteria in the `v2-only` match.

   {{< call-out "tip" >}}
   If you want to add all of the matches from a single `HTTPRouteGroup`, you can omit the `matches` field from the rule.
   {{< /call-out >}}

1. Clean up.

   Before moving on the next section, delete the clients and the rate limit.

   **Command:**

   ```bash
   kubectl delete -f client-v1.yaml -f client-v2.yaml -f ratelimit-rules.yaml
   ```

### Handle Bursts

Some applications are "bursty" by nature; for example, they might send multiple requests within 100ms of each other. To handle applications like this, you can leverage the burst and delay fields in the rate limit spec.

`burst` is the number of excess requests to allow beyond the rate, and `delay` controls how the burst of requests is forwarded to the destination.

Let's create a bursty application and a rate limit to demonstrate this behavior.

1. Create a bursty client.

   **Command:**

    ```bash
    kubectl apply -f bursty-client.yaml
    ```

    **Expectation:** The `bursty-client` Deployment and Configmap deployed successfully.

    There should be two Pods running in the default namespace:

    ```bash
    kubectl get pods
    NAME                             READY   STATUS    RESTARTS   AGE
    bursty-client-7b75d74d44-zjqlh   2/2     Running   0          6s
    dest-69f4b86fb4-r8wzh            2/2     Running   0          5m16s
    ```

1. Stream the logs of the `bursty-client` container in a separate terminal window.

   **Command:**

    ```bash
    kubectl logs -l app=bursty-client -f -c client
    ```

   **Expectation:** The `bursty-client` is configured to send a burst of three requests to the destination service every 10 seconds. At this point, there is no rate limit applied to the `bursty-client`, so all the requests should be successful.

    ```bash
    ----Sending burst of 3 requests----

    Hello from destination service!
    Method: GET
    Path: /echo
    "x-demo":
    Time: Friday, 13-Aug-2021 21:43:50 UTC


    Hello from destination service!
    Method: GET
    Path: /echo
    "x-demo":
    Time: Friday, 13-Aug-2021 21:43:50 UTC


    Hello from destination service!
    Method: GET
    Path: /echo
    "x-demo":
    Time: Friday, 13-Aug-2021 21:43:50 UTC

    -------Sleeping 10 seconds-------
    ```

1. Apply a rate limit with a rate of 1r/s.

   **Command:**

    ```bash
    kubectl apply -f ratelimit-burst.yaml
    ```

   **Expectation:** Since only one request is allowed per second, only one of the requests in the burst is successful.

    ```bash
    ----Sending burst of 3 requests----

    Hello from destination service!
    Method: GET
    Path: /echo
    "x-demo":
    Time: Friday, 13-Aug-2021 21:44:10 UTC


    <html>
    <head><title>503 Service Temporarily Unavailable</title></head>
    <body>
    <center><h1>503 Service Temporarily Unavailable</h1></center>
    <hr><center>nginx/1.19.10</center>
    </body>
    </html>


    <html>
    <head><title>503 Service Temporarily Unavailable</title></head>
    <body>
    <center><h1>503 Service Temporarily Unavailable</h1></center>
    <hr><center>nginx/1.19.10</center>
    </body>
    </html>

    -------Sleeping 10 seconds-------
    ```

1. Since we know that our `bursty-client` is configured to send requests in bursts of three, we can edit the rate limit and add a `burst` of `2` to make sure all requests get through to the destination service.

   **Command:**

    ```bash
    kubectl edit ratelimit ratelimit-burst
    ```

    Add a `burst` of `2`:

    ```yaml
    apiVersion: specs.smi.nginx.com/v1alpha2
    kind: RateLimit
    metadata:
      name: ratelimit-burst
      namespace: default
    spec:
      destination:
        kind: Service
        name: dest-svc
        namespace: default
      sources:
      - kind: Deployment
        name: bursty-client
        namespace: default
      name: ratelimit-burst
      rate: 1r/s
      burst: 2
   ```

    Save your changes and exit the editor.

    A `burst` of `2` means that of the three requests that the `bursty-client` sends within one second, one request is allowed and is forwarded immediately to the destination service, and the following two requests are placed in a queue of length `2`.

    The requests in the queue are forwarded to the destination service according to the `delay` field. The `delay` field specifies the number of requests, within the burst size, at which excessive requests are delayed. If any additional requests are made to the destination service once the queue is filled, they are denied.

    **Expectation:** In the `bursty-client` logs, you should see that all the requests from the `bursty-client` are successful.

    However, if you look at the timestamps of the response, you should see that each response is logged one second apart. This is because the second and third requests of the burst were added to a queue and forwarded to the destination service at a rate of one request per second.

    Delaying the excess requests in the queue can make your application appear slow. If you want to have the excess requests forwarded immediately, you can set the `delay` field to `nodelay`.

   {{< call-out "tip" >}}
   The default value for `delay` is `0`. A delay of `0` means that every request in the queue is delayed according to the rate specified in the rate limit spec.
   {{< /call-out >}}

1. To forward the excess requests to the destination service immediately, edit the rate limit and set delay to `nodelay`.

   **Command:**

    ```bash
    kubectl edit ratelimit ratelimit-burst
    ```

   Set delay to `nodelay`:

    ```yaml
    apiVersion: specs.smi.nginx.com/v1alpha2
    kind: RateLimit
    metadata:
      name: ratelimit-burst
      namespace: default
    spec:
      destination:
        kind: Service
        name: dest-svc
        namespace: default
      sources:
      - kind: Deployment
        name: bursty-client
        namespace: default
      name: ratelimit-burst
      rate: 1r/s
      burst: 2
      delay: nodelay
   ```

   **Expectation:** A delay of `nodelay` means that the requests in the queue are immediately sent to the destination service. You can verify this by looking at the timestamps of the responses in the `bursty-client` logs; they should all be within the same second.

   {{< call-out "tip" >}}
   You can also set the `delay` field to an integer. For example, a delay of `1` means that one request is forwarded immediately, and all other requests in the queue are delayed.
   {{< /call-out >}}

1. Clean up all the resources.

    **Command:**

    ```bash
    kubectl delete -f bursty-client.yaml -f ratelimit-burst.yaml -f destination.yaml
    ```

### Summary

You should now have a good idea of how to configure rate limiting between your workloads.

If you'd like to continue experimenting with different rate-limiting configurations, you can modify the configurations of the clients and destination service.

The clients can be configured to send requests to the Service name of your choice with different methods, paths, and headers.

Each client's ConfigMap supports the following options:

{{% table %}}
Parameter | Type | Description
---|---|---
`host` | string | base URL of target Service
`request_path` | string | request path
`method` | string | HTTP method to use
`headers` | string | comma-delimited list of additional request headers to include
{{% /table %}}

The bursty client Configmap also supports these additional options:

{{% table %}}
Parameter | Type | Description
---|---|---
`burst` | string | number of requests per burst
`delay` | string | number of seconds to sleep between bursts
{{% /table %}}

The destination workload can be set to serve different ports or multiple ports. To configure the destination workload, edit the `destination.yaml` file. An example configuration is shown below:

NGINX `dest-svc` configuration:

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

## Resources and Further Reading

- [Rate Limiting with NGINX and NGINX Plus](https://www.nginx.com/blog/rate-limiting-nginx/)
- [How to Use NGINX Service Mesh for Rate Limiting](https://www.nginx.com/blog/how-to-use-nginx-service-mesh-for-rate-limiting/)
- [NGINX HTTP Rate Limit Req Module](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html)
