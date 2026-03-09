---
title: Deploy a Policy for access control
weight: 900
toc: true
nd-content-type: how-to
nd-product: INGRESS
nd-docs: DOCS-1858
---

This topic describes how to use F5 NGINX Ingress Controller to apply and update a Policy for access control. You can use access control policies with [VirtualServer custom resources]({{< ref "/nic/configuration/virtualserver-and-virtualserverroute-resources.md" >}}) or with [Ingress resources]({{< ref "/nic/configuration/ingress-resources/basic-configuration.md" >}}) using the `nginx.org/policies` annotation.

---

## Before you begin

You should have a [working NGINX Ingress Controller]({{< ref "/nic/install/helm.md" >}}) instance.

For ease of use in shell commands, set two shell variables:

1. The public IP address for your NGINX Ingress Controller instance.

```shell
IC_IP=<ip-address>
```

2. The HTTP port of the same instance.

```shell
IC_HTTP_PORT=<port number>
```

3. The HTTPS port of the same instance (used for the [Ingress resource example](#use-access-control-with-ingress-resources)).

```shell
IC_HTTPS_PORT=<port number>
```

---

## Deploy the example application

Create the file _webapp.yaml_ with the following contents:

{{< ghcode "https://raw.githubusercontent.com/nginx/kubernetes-ingress/refs/heads/main/examples/custom-resources/access-control/webapp.yaml" >}}

Apply it using `kubectl`:

```shell
kubectl apply -f webapp.yaml
```

---

## Deploy a Policy to create a deny rule

Create a file named _access-control-policy-deny.yaml_. The highlighted _deny_ field will be used by the example application, and should be changed to the subnet of your machine.

{{< ghcode "https://raw.githubusercontent.com/nginx/kubernetes-ingress/refs/heads/main/examples/custom-resources/access-control/access-control-policy-deny.yaml" "hl_lines=7-8" >}}

Apply the policy:

```shell
kubectl apply -f access-control-policy-deny.yaml
```

---

## Configure load balancing

Create a file named _virtual-server.yaml_ for the VirtualServer resource. The _policies_ field references the access control Policy created in the previous section.

{{< ghcode "https://raw.githubusercontent.com/nginx/kubernetes-ingress/refs/heads/main/examples/custom-resources/access-control/virtual-server.yaml" "hl_lines=7-8" >}}

Apply the policy:

```shell
kubectl apply -f virtual-server.yaml
```

---

## Test the example application

Use `curl` to attempt to access the application:

```shell
curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP http://webapp.example.com:$IC_HTTP_PORT
```

```text
<html>
<head><title>403 Forbidden</title></head>
<body>
<center><h1>403 Forbidden</h1></center>
</body>
</html>
```

The *403* response is expected, successfully blocking your machine.

---

## Update the Policy to create an allow rule

Update the Policy with the file _access-control-policy-allow.yaml_, setting the _allow_ field to the subnet of your machine.

{{< ghcode "https://raw.githubusercontent.com/nginx/kubernetes-ingress/refs/heads/main/examples/custom-resources/access-control/access-control-policy-allow.yaml" "hl_lines=7-8" >}}

Apply the Policy:

```shell
kubectl apply -f access-control-policy-allow.yaml
```

----

## Verify the Policy update

Attempt to access the application again:

```shell
curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP http://webapp.example.com:$IC_HTTP_PORT
```

```text
Server address: 10.64.0.13:8080
Server name: webapp-5cbbc7bd78-wf85w
```

The successful response demonstrates that the policy has been updated.

---

## Use access control with Ingress resources

You can also apply access control policies to standard Kubernetes Ingress resources using the `nginx.org/policies` annotation. This section walks through a complete example.

### Deploy the cafe application

Create the file _cafe.yaml_ with the following contents:

{{< ghcode "https://raw.githubusercontent.com/nginx/kubernetes-ingress/refs/heads/main/examples/ingress-resources/access-control/cafe.yaml" >}}

Apply it using `kubectl`:

```shell
kubectl apply -f cafe.yaml
```

### Configure NGINX to use the X-Real-IP header

Create the file _nginx-config.yaml_ to configure NGINX to trust the `X-Real-IP` header. This ensures the access control policy uses the client IP provided in that header.

{{< ghcode "https://raw.githubusercontent.com/nginx/kubernetes-ingress/refs/heads/main/examples/ingress-resources/access-control/nginx-config.yaml" >}}

Apply the ConfigMap:

```shell
kubectl apply -f nginx-config.yaml
```

### Deploy a Policy to create an allow rule

Create a file named _access-control-policy-allow.yaml_. The highlighted _allow_ field permits traffic from the `10.0.0.0/8` CIDR range and blocks all other addresses.

{{< ghcode "https://raw.githubusercontent.com/nginx/kubernetes-ingress/refs/heads/main/examples/ingress-resources/access-control/access-control-policy-allow.yaml" "hl_lines=7-8" >}}

Apply the policy:

```shell
kubectl apply -f access-control-policy-allow.yaml
```

### Method #1 (VirtualServer): Create the VirtualServer resource

Create a file named _cafe-virtual-server.yaml_ for the VirtualServer resource. The highlighted _policies_ field references the access control Policy we created.

{{ < ghcode "https://raw.githubusercontent.com/nginx/kubernetes-ingress/refs/heads/main/examples/custom-resources/access-control/virtual-server.yaml "hl_lines=7-8">}}

Apply the VirtualServer:

```shell
kubectl apply -f cafe-virtual-server.yaml
```

### Method #2 (Ingress): Create the Ingress resource

Alternatively, create a file named _cafe-ingress.yaml_ for the Ingress resource. The highlighted `nginx.org/policies` annotation references the access control Policy created.

{{< ghcode "https://raw.githubusercontent.com/nginx/kubernetes-ingress/refs/heads/main/examples/ingress-resources/access-control/cafe-ingress.yaml" "hl_lines=5-6" >}}

Apply the Ingress:

```shell
kubectl apply -f cafe-ingress.yaml
```

### Test the allow policy

1. Send a request with an IP in the allowed `10.0.0.0/8` range using the `X-Real-IP` header:

    ```shell
    curl --resolve cafe.example.com:$IC_HTTPS_PORT:$IC_IP https://cafe.example.com:$IC_HTTPS_PORT/coffee --insecure -H "X-Real-IP: 10.0.0.1"
    ```

    ```text
    Server address: 10.244.0.6:8080
    Server name: coffee-7586895968-r26zn
    ...
    ```

    The request succeeds because `10.0.0.1` is in the allowed range.

2. Send a request with an IP outside the allowed range:

    ```shell
    curl --resolve cafe.example.com:$IC_HTTPS_PORT:$IC_IP https://cafe.example.com:$IC_HTTPS_PORT/coffee --insecure -H "X-Real-IP: 192.168.1.1"
    ```

    ```text
    <html>
    <head><title>403 Forbidden</title></head>
    <body>
    <center><h1>403 Forbidden</h1></center>
    </body>
    </html>
    ```

    The *403* response confirms that NGINX blocks clients outside the allowed range.

### Update the Policy to create a deny rule

Update the Policy with the file _access-control-policy-deny.yaml_, which denies traffic from the `10.0.0.0/8` CIDR range and allows all other addresses.

{{< ghcode "https://raw.githubusercontent.com/nginx/kubernetes-ingress/refs/heads/main/examples/ingress-resources/access-control/access-control-policy-deny.yaml" "hl_lines=7-8" >}}

Apply the updated Policy:

```shell
kubectl apply -f access-control-policy-deny.yaml
```

The Ingress resource picks up the change automatically because the policy name (`webapp-policy`) stays the same.

### Verify the deny policy

1. Send a request with an IP in the now-denied `10.0.0.0/8` range:

    ```shell
    curl --resolve cafe.example.com:$IC_HTTPS_PORT:$IC_IP https://cafe.example.com:$IC_HTTPS_PORT/coffee --insecure -H "X-Real-IP: 10.0.0.1"
    ```

    ```text
    <html>
    <head><title>403 Forbidden</title></head>
    <body>
    <center><h1>403 Forbidden</h1></center>
    </body>
    </html>
    ```

    The same IP that was previously allowed is now rejected.

2. Send a request with an IP outside the denied range:

    ```shell
    curl --resolve cafe.example.com:$IC_HTTPS_PORT:$IC_IP https://cafe.example.com:$IC_HTTPS_PORT/coffee --insecure -H "X-Real-IP: 192.168.1.1"
    ```

    ```text
    Server address: 10.244.0.6:8080
    Server name: coffee-7586895968-r26zn
    ...
    ```

    Clients outside the denied range are now allowed through.
