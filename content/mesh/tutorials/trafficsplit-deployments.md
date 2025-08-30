---
title: Deployments using Traffic Splitting
description: This topic provides a guide for using traffic splits with different deployment
  strategies.
weight: 110
toc: true
nd-docs: DOCS-725
type:
- tutorial
---

## Overview

You can use traffic splitting for most deployment scenarios, including canary, blue-green, A/B testing, and so on. The ability to control traffic flow to different versions of an application makes it easy to roll out a new application version with minimal effort and interruption to production traffic.

## Before You Begin

1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
1. (Optional) If you want to view metrics, ensure that you have deployed Prometheus and Grafana.
  Refer to the [Monitoring and Tracing]( {{< ref "/mesh/guides/monitoring-and-tracing.md" >}} ) guide for instructions.
1. Set up a Kubernetes cluster with [F5 NGINX Service Mesh]( {{< ref "/mesh/get-started/install/install.md" >}} ) deployed with the following configuration:
    - `--mtls-mode` is set to `permissive` or `off` states.
    - (Optional) `--prometheus-address` is pointed to the Prometheus instance you created above.
1. Enable [automatic sidecar injection]( {{< ref "/mesh/guides/inject-sidecar-proxy.md#automatic-proxy-injection" >}} ) for the `default` namespace.
1. Download all the example files:

    - {{< icon "download" >}} {{< link "/examples/traffic-split/gateway.yaml" "gateway.yaml" >}}
    - {{< icon "download" >}} {{< link "/examples/traffic-split/target-svc.yaml" "target-svc.yaml" >}}
    - {{< icon "download" >}} {{< link "/examples/traffic-split/target-v1.0.yaml" "target-v1.0.yaml" >}}
    - {{< icon "download" >}} {{< link "/examples/traffic-split/target-v2.0-failing.yaml" "target-v2.0-failing.yaml" >}}
    - {{< icon "download" >}} {{< link "/examples/traffic-split/target-v2.1-successful.yaml" "target-v2.1-successful.yaml" >}}
    - {{< icon "download" >}} {{< link "/examples/traffic-split/target-v3.0.yaml" "target-v3.0.yaml" >}}
    - {{< icon "download" >}} {{< link "/examples/traffic-split/trafficsplit.yaml" "trafficsplit.yaml" >}}
    - {{< icon "download" >}} {{< link "/examples/traffic-split/trafficsplit-matches.yaml" "trafficsplit-matches.yaml" >}}


{{< call-out "note" >}}
The NGINX Plus Ingress Controller's custom resource [TransportServer](https://docs.nginx.com/nginx-ingress-controller/configuration/transportserver-resource/) has the same Kubernetes short name(`ts`) as the custom resource TrafficSplit.
If you have the NGINX Plus Ingress Controller installed, use the full name `trafficsplit(s)` instead of `ts` in the following instructions.
{{< /call-out >}}

{{< call-out "note" >}}
Avoid configuring traffic policies such as TrafficSplits, RateLimits, and CircuitBreakers for headless services.
These policies will not work as expected because NGINX Service Mesh has no way to tie each pod IP address to its headless service.
{{< /call-out >}}

## Objectives

Follow the steps in this guide to learn how to use traffic splitting for various deployment strategies.

### Deploy the Production Version of the Target App

1. First, let's begin by deploying the "production" v1.0 target app, the load balancer Service, and the ingress gateway.
{{< call-out "tip" >}}
For simplicity, this guide uses a simple NGINX reverse proxy for the ingress gateway. For production usage and for more advanced ingress control, we recommend using the [NGINX Ingress Controller for Kubernetes](https://www.nginx.com/products/nginx-ingress-controller/). Refer to [Deploy NGINX Ingress Controller with NGINX Service Mesh]( {{< ref "ingress-walkthrough.md" >}} ) to learn more.
{{< /call-out >}}

    **Command:**

    ```bash
    kubectl apply -f target-svc.yaml -f target-v1.0.yaml -f gateway.yaml
    ```

    **Expectation:** All Pods and Services deploy successfully.

    Use `kubectl` to make sure the Pods and Services deploy successfully.

    Example:

    ```bash
    $ kubectl get pods
    NAME                           READY   STATUS    RESTARTS   AGE
    gateway-58c6c76dd-4mmht        2/2     Running   0          2m
    target-v1-0-6f69fc48f6-mzcf2   2/2     Running   0          2m
    ```

    ```bash
    $ kubectl get svc
    NAME          TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
    gateway-svc   LoadBalancer   10.0.0.2        1.2.3.4         80:30975/TCP   2m
    target-svc    ClusterIP      10.0.0.3        <none>          80/TCP         2m
    target-v1-0   ClusterIP      10.0.0.4        <none>          80/TCP         2m
    ```

    To better understand what is going on here, let's take a quick look at what we deployed here:
    - **gateway**: simple NGINX reverse proxy that forwards traffic to the target app. Besides providing a single point of ingress to the cluster, using the gateway lets us use the `nginx-meshctl top` command to check traffic metrics between it and the backend Services it is sending traffic to.
    - **target-svc**: the root Service that connects to all the different versions of the target app.
    - **target**: for our example we will be deploying 3 different versions of the target app. The target app is a basic NGINX server that returns the target version. Each one has its own Service tagged with its version number. These are the Services that the root target-svc sends requests to.

1. Once the Pods and Services are ready, generate traffic to `target-svc`. Use a different bash window for this step so you can watch the traffic change as you are doing the deployments.

    **Commands:**
    - Get the external IP for gateway-svc:

      ```bash
      kubectl get svc gateway-svc
      ```

    - Save the IP address as an environment variable:

      ```bash
      export GATEWAY_IP=<gateway external IP>
      ```

    - Start a loop that sends a request to that IP once per second for 5 minutes. Rerun as needed:

      ```bash
      for i in $(seq 1 300); do curl $GATEWAY_IP; sleep 1; done
      ```

    **Expectation:** Requests will start to come in to `target-svc`. At this point you should only see `target v1.0` responses.

1. Back in your original bash window, use the mesh CLI to check traffic metrics.

    **Command:** `nginx-meshctl top` \
    **Expectation:** The `target-v1-0` deployment will show 100% incoming success rate and the `gateway` deployment will show 100% outgoing success rate. The `top` command only shows traffic from the last 30s. `top` provides a quick look at your Services for immediate debugging and to see if there’s any anomalies that need further investigation. For more detailed and accurate traffic monitoring, we recommend using Grafana. Refer to [traffic metrics]( {{< ref "/mesh/guides/smi-traffic-metrics.md" >}} ) for details.

    Example:

    ```bash
    $ nginx-meshctl top
    Deployment   Incoming Success  Outgoing Success  NumRequests
    gateway                        100.00%           10
    target-v1-0  100.00%                             10
    ```

### Deploy a New Version of the Target App using a Canary Deployment

Using traffic splits we can use a variety of deployment strategies. Whether using a blue-green deployment, canary deployment, or a hybrid of different deployment strategies, traffic splits make the process extremely easy.

For this version of the target app, let's try using a canary deployment strategy.

1. Apply the traffic split so that once a new version is deployed, it will not receive any traffic until we are ready. Ideally we would apply this at the same time as the first `target` version, `target-svc`, and `gateway`. To make it easier to see what is happening though, we are applying it in this separate step.

    **Command:**

    ```bash
    kubectl apply -f trafficsplit.yaml
    ```

    **Expectation:** The traffic split is applied successfully. Use `kubectl get ts` to see the current traffic splits.

    Use `kubectl describe ts target-ts` to see details about the traffic split we just applied. Currently the traffic split is configured to send 100% of traffic to target v1.0.

    ```yaml
    apiVersion: split.smi-spec.io/v1alpha3
    kind: TrafficSplit
    metadata:
      name: target-ts
    spec:
      service: target-svc
      backends:
      - service: target-v1-0
        weight: 100
    ```

1. Now let's deploy target v2.0. To show a scenario where an upgrade is failing, this version of target is configured to return a `500` error status code instead of a successful `200`.

    **Command:**

    ```bash
    kubectl apply -f target-v2.0-failing.yaml
    ```

    **Expectation:** Target v2.0 will deploy to the cluster successfully. You should see the new `target-v2-0` Pod and Service in the `kubectl get pods`/`kubectl get svc` output. Since we deployed the traffic split, if you look at your other bash window where the traffic is being generated you should still only see responses from target v1.0. If you check `nginx-meshctl top` you should see the same deployments as before. This is because no traffic has been sent to or received from target v2.0.

1. For this deployment we'll send 10% of traffic to target v2.0 while 90% is still going to target v1.0. Open `trafficsplit.yaml` in the editor of your choice and add a new backend for `target-v2-0` with a weight of `10`. Change the weight of `target-v1-0` to `90`.

    ```yaml
    apiVersion: split.smi-spec.io/v1alpha3
    kind: TrafficSplit
    metadata:
      name: target-ts
    spec:
      service: target-svc
      backends:
      - service: target-v1-0
        weight: 90
      - service: target-v2-0
        weight: 10
    ```

1. After updating `trafficsplit.yaml`, save and apply it.

    **Command:**

    ```bash
    kubectl apply -f trafficsplit.yaml
    ```

    **Expectation:** After applying the updated traffic split, you should start seeing responses from target v2.0 in the other bash where traffic is being generated. Because of the weight we set in the previous step, about 1 out of 10 requests will be sent to v2.0. Something to keep in mind is that these are weighted, so it will not be exactly 1 in 10, but it will be close.

1. Check the traffic metrics now that v2.0 is available.

    **Command:**

    ```bash
    nginx-meshctl top
    ```

    **Expectation:**

    - `target-v1-0` deployment will still show 100% incoming success rate
    - `target-v2-0` deployment will show 0% incoming success rate
    - `gateway` deployment will show the appropriate percentage of successful outgoing requests

    Example:

    ```bash
    $ nginx-meshctl top
    Deployment   Incoming Success  Outgoing Success  NumRequests
    gateway                        90.00%            10
    target-v1-0  100.00%                             9
    target-v2-0  0.00%                               1
    ```

1. It looks like v2.0 doesn't work! We can see that because the incoming success rate to target-v2 is 0%. Thankfully, using traffic splitting, it is easy to redirect all traffic back to v1.0 without doing a complicated rollback. To update the traffic split, simply update `trafficsplit.yaml` to send 100% of traffic to v1.0 and 0% of traffic to v2.0 and re-apply it.

    You can either explicitly set the weight of `target-v2-0` to `0` or remove the `target-v2-0` backend completely. The result will be the same.

    At this point you can delete v2.0 from the cluster.

   **Command:**

   ```bash
   kubectl delete -f target-v2.0-failing.yaml
   ```

### Deploy a New Version of the Target App using a Blue-Green Deployment

For this version of the target app, let's use a blue-green deployment.

1. Deploy v2.1 of target, which fixes the issue causing the failing requests that we saw in v2.0.

    **Command:**

    ```bash
    kubectl apply -f target-v2.1-successful.yaml
    ```

    **Expectation:** Target v2.1 will deploy successfully. You should see the new `target-v2-1` Pod and Service in the `kubectl get pods`/`kubectl get svc` output. Just as with `target-v2-0` though, we have the traffic split configured to send all traffic to `target-v1-0` until we are ready to do the actual deployment and make `target-v2-1` available for traffic.

1. Since we are doing a blue-green deployment, we will configure the traffic split to send all traffic to target v2.1. Open `trafficsplit.yaml` in the editor of your choice and add a new backend for `target-v2-1` with a weight of `100`. Change the weight of `target-v1-0` to `0`. You could also delete the `target-v1-0` backend completely, but with this type of deployment it's easier to set the weight to `0` in case you need to roll back quickly.

    ```yaml
    apiVersion: split.smi-spec.io/v1alpha3
    kind: TrafficSplit
    metadata:
      name: target-ts
    spec:
      service: target-svc
      backends:
      - service: target-v1-0
        weight: 0
      - service: target-v2-1
        weight: 100
    ```

1. After updating `trafficsplit.yaml`, save and apply it.

    **Command:**

    ```bash
    kubectl apply -f trafficsplit.yaml
    ```

    **Expectation:** After applying the updated traffic split, you should start seeing responses from target v2.1 in the other bash where traffic is being generated. Because of the weight we set in the previous step, all traffic should be going to v2.1.

1. Check the traffic metrics now that v2.1 is available.

    **Command:**

    ```bash
    nginx-meshctl top
    ```

    **Expectation:**

    - `target-v1-0` deployment will not show up, although keep in mind that it will take a bit for the previous requests to move out of the 30s metric window. If you see `target-v1-0`, try again in 30s or so.
    - `target-v2-1` deployment will show 100% incoming success rate
    - `gateway` deployment will show 100% outgoing success rate

    Example:

    ```bash
    $ nginx-meshctl top
    Deployment   Incoming Success  Outgoing Success  NumRequests
    gateway                        100.00%           10
    target-v2-1  100.00%                             10
    ```

1. Since target v2.1 is working as expected, we can delete v1.0 from the cluster. If v2.1 had started failing, we could have quickly rolled back to v1.0 just as we did earlier.

   **Command:**

   ```bash
   kubectl delete -f target-v1.0.yaml
   ```

### A/B Testing with Traffic Splits

If you want to implement A/B testing, you can create an HTTPRouteGroup resource and associate the HTTPRouteGroup with the traffic split.

Consider the following configuration:

```yaml
apiVersion: specs.smi-spec.io/v1alpha3
kind: HTTPRouteGroup
metadata:
  name: target-hrg
  namespace: default
spec:
  matches:
  - name: firefox-users
    headers:
      user-agent: ".*Firefox.*"
```

The [HTTPRouteGroup](https://github.com/servicemeshinterface/smi-spec/blob/main/apis/traffic-specs/v1alpha3/traffic-specs.md#httproutegroup) is used to describe HTTP traffic. The `spec.matches` field defines a list of routes that an application can serve. Routes are made up of the following match conditions: pathRegex, headers, and HTTP methods.
In the `target-hrg` example above, we have defined one route, `firefox-users`, using the header filter `user-agent: ".*Firefox.*"`. Incoming HTTP traffic that has the `user-agent` header set to a value that matches the regex `".*Firefox.*"` satisfies the `firefox-users` match condition.

{{< call-out "tip" >}}
A route with multiple match conditions (pathRegex, headers, and/or HTTP methods) within a single match represent an `AND` condition. This means that all match conditions must be satisfied for the traffic to match the route.
{{< /call-out >}}

To associate the `target-hrg` HTTPRouteGroup with the traffic split we need to add the `matches` field to our traffic split spec:

```yaml
apiVersion: split.smi-spec.io/v1alpha3
kind: TrafficSplit
metadata:
  name: target-ts
spec:
  service: target-svc
  backends:
  - service: target-v2-1
    weight: 0
  - service: target-v3-0
    weight: 100
  matches:
  - kind: HTTPRouteGroup
    name: target-hrg
```

Traffic split `matches` allow you to associate one or more `HTTPRouteGroups` with a traffic split.
The `matches` field in the traffic split spec maps the HTTPRouteGroup's `matches` directives to the traffic split. This means that the traffic split only applies if the request's attributes satisfy the match conditions outlined in the match directives.

If there are multiple HTTPRouteGroups listed in the traffic split `matches` field and/or multiple matches defined in the HTTPRouteGroup, the traffic split will be applied if the request satisfies any of the specified matches.

In this example, all traffic sent to the root Service `target-svc` that contains the string `Firefox` in the `user-agent` header will be routed to the `target-v2-1` backend. All other traffic will be sent to the root Service `target-svc`.

1. To demonstrate how to A/B test with traffic splits, let's create a new version of the target application:

   **Command:**

   ```bash
   kubectl apply -f target-v3.0.yaml
   ```

   **Expectation:** The target-v3-0 Pod and Service deploy successfully. At this point there should be three Pods and four Services running.

   Example:

    ```bash
    $ kubectl get pods
    NAME                            READY   STATUS    RESTARTS   AGE
    gateway-58c6c76dd-4mmht         2/2     Running   0          2m
    target-v2-1-6f69fc48f6-mzcf2    2/2     Running   0          2m
    target-v3-0-5f6fc9cf99-tps6k    2/2     Running   0          2m
    ```

    ```bash
    $ kubectl get svc
    NAME          TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
    gateway-svc   LoadBalancer   10.0.0.2        1.2.3.4         80:30975/TCP   2m
    target-svc    ClusterIP      10.0.0.3        <none>          80/TCP         2m
    target-v2-1   ClusterIP      10.0.0.4        <none>          80/TCP         2m
    target-v3-0   ClusterIP      10.0.0.5        <none>          80/TCP         2m
    ```

   In the terminal window where you are generating traffic to the gateway Service you should still see all responses coming from the `target-v2-1` backend. You may need to restart the loop that generates traffic:

   ```bash
   for i in $(seq 1 300); do curl $GATEWAY_IP; sleep 1; done
   ```

1. Create the `target-hrg` HTTPRouteGroup and update the traffic split:

   **Command:**

   ```bash
   kubectl apply -f trafficsplit-matches.yaml
   ```

   **Expectation:** The `target-hrg` HTTPRouteGroup is created and the `target-ts` traffic split is updated.

   {{< call-out "tip" >}} Use `kubectl get` and `kubectl describe` for `httproutegroups` and `trafficsplits` to make sure the resources were created or updated. {{< /call-out >}}

   In the terminal window where you are generating traffic to the gateway Service you should now see responses from both the `target-v2-1` and `target-v3` backends. To test the A/B traffic shaping, open another terminal window and generate traffic to the gateway Service with the header `user-agent: Firefox`:

   ```bash
   for i in $(seq 1 100); do curl $GATEWAY_IP -H "user-agent:Firefox"; sleep 1; done
   ```

   Since the `user-agent` header is set to "Firefox", you should see responses from the `target-v3-0` backend only.

### Traffic Splitting based on path and HTTP methods

In addition to supporting traffic splitting based on header filters, NGINX Service Mesh also supports traffic splitting based on path and HTTP methods. To demonstrate this let's update the `target-hrg` and add a new match.

1. Edit the HTTPRouteGroup `target-hrg`:

   **Command:**

   ```bash
   kubectl edit httproutegroup target-hrg
   ```

   Add the `get-api-requests` route to the list of matches:

   ```yaml
   apiVersion: specs.smi-spec.io/v1alpha3
   kind: HTTPRouteGroup
   metadata:
     name: target-hrg
     namespace: default
   spec:
     matches:
     - name: firefox-users
       headers:
         user-agent: ".*Firefox.*"
     - name: get-api-requests
       pathRegex: "/api"
       methods:
       - GET
   ```

   Save and close the editor.

   The `get-api-requests` route will match all GET requests to the `/api` endpoint. By adding this route to the `target-hrg` matches, the `target-ts` traffic split will now have both the `firefox-users` and `get-api-requests` matches applied to it. Since multiple matches are applied with an `OR` operator, if an incoming HTTP request to `target-svc` matches either `firefox-users` or `get-api-requests`, the traffic split will be applied, and the request will be routed to the `target-v3-0` backend Service.
   All other incoming HTTP requests will be routed to the root `target-svc`, which will forward the request to one of the target services based on the load-balancing algorithm of the mesh.

   **Expectations:**

   - In the terminal window where requests to the gateway Service have the `user-agent:Firefox` header set, you should still see responses from the `target-v3-0` backend only.
   - To test the `get-api-requests` route, start a new for loop that sends GET requests to the `/api` endpoint:

      ```bash
      for i in $(seq 1 100); do curl $GATEWAY_IP/api; sleep 1; done
      ```

      You should only see responses from the `target-v3-0` backend. If you remove the `/api` path from the request you should see responses from both the `target-v2-1` and `target-v3-0` backends.

## Cleanup

Delete all the resources from your cluster:

**Command:**

```bash
kubectl delete -f gateway.yaml -f target-svc.yaml -f target-v2.1-successful.yaml -f target-v3.0.yaml -f trafficsplit-matches.yaml
```

## Use Case

An example use case for traffic splitting can be seen in [this blog](https://www.nginx.com/blog/how-do-i-choose-api-gateway-vs-ingress-controller-vs-service-mesh/#East-West-API-Gateway-Use-Cases:-Use-a-Service-Mesh). The blog uses a self-referential TrafficSplit configuration in which the root service is also listed as a backend service. Even though the Service Mesh Interface specification mentions that self-referential configurations are invalid, NGINX Service Mesh supports this type of configuration due to its value in use cases like the example defined in the blog.

## Summary

These are just a couple examples of how you can use traffic splits for a deployment. Whether you want to do a gradual roll out of 5% increments or send 5% to two staging backends while 90% goes to production or any other combination of splits, traffic splits offer a convenient way to handle almost any deployment strategy you need.

## Resources

<!-- vale off -->
- [SMI Traffic Split Example on GitHub](https://github.com/servicemeshinterface/smi-spec/blob/master/apis/traffic-split/v1alpha3/traffic-split.md#example-implementation)
<!-- vale on -->
