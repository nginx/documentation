---
title: Securing backend traffic
weight: 200
toc: true
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-1423
---

Learn how to encrypt HTTP traffic between NGINX Gateway Fabric and your backend pods.

## Overview

In this guide, we will show how to specify the TLS configuration of the connection from the Gateway to a backend pod with the Service API object using a [BackendTLSPolicy](https://gateway-api.sigs.k8s.io/api-types/backendtlspolicy/).

The intended use-case is when a service or backend owner is managing their own TLS and NGINX Gateway Fabric needs to know how to connect to this backend pod that has its own certificate over HTTPS.

## Note on Gateway API Experimental Features

{{< important >}} BackendTLSPolicy is a Gateway API resource from the experimental release channel. {{< /important >}}

{{< include "/ngf/installation/install-gateway-api-experimental-features.md" >}}

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with experimental features enabled.

## Set up

Create the **secure-app** application in Kubernetes by copying and pasting the following block into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secure-app
  template:
    metadata:
      labels:
        app: secure-app
    spec:
      containers:
        - name: secure-app
          image: nginxinc/nginx-unprivileged:latest
          ports:
            - containerPort: 8443
          volumeMounts:
            - name: secret
              mountPath: /etc/nginx/ssl
              readOnly: true
            - name: config-volume
              mountPath: /etc/nginx/conf.d
      volumes:
        - name: secret
          secret:
            secretName: app-tls-secret
        - name: config-volume
          configMap:
            name: secure-config
---
apiVersion: v1
kind: Service
metadata:
  name: secure-app
spec:
  ports:
    - port: 8443
      targetPort: 8443
      protocol: TCP
      name: https
  selector:
    app: secure-app
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: secure-config
data:
  app.conf: |-
    server {
      listen 8443 ssl;
      listen [::]:8443 ssl;

      server_name secure-app.example.com;

      ssl_certificate /etc/nginx/ssl/tls.crt;
      ssl_certificate_key /etc/nginx/ssl/tls.key;

      default_type text/plain;

      location / {
        return 200 "hello from pod secure-app\n";
      }
    }
---
apiVersion: v1
kind: Secret
metadata:
  name: app-tls-secret
type: Opaque
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUVpekNDQW5PZ0F3SUJBZ0lVQ0g2NWhwVDNkSlI0SVdPTXdaL2lCb3M5Q0Rrd0RRWUpLb1pJaHZjTkFRRUwKQlFBd1d6RUxNQWtHQTFVRUJoTUNWVk14Q3pBSkJnTlZCQWdNQWxkQk1SQXdEZ1lEVlFRSERBZFRaV0YwZEd4bApNUk13RVFZRFZRUUtEQXBGZUdGdGNHeGxJRU5CTVJnd0ZnWURWUVFEREE5RmVHRnRjR3hsSUZKdmIzUWdRMEV3CkhoY05NalV3TmpFMk1UVXpOelUzV2hjTk16VXdOakUwTVRVek56VTNXakJnTVFzd0NRWURWUVFHRXdKVlV6RUwKTUFrR0ExVUVDQXdDVjBFeEVEQU9CZ05WQkFjTUIxTmxZWFIwYkdVeEVUQVBCZ05WQkFvTUNFWTFJRTVIU1U1WQpNUjh3SFFZRFZRUUREQlp6WldOMWNtVXRZWEJ3TG1WNFlXMXdiR1V1WTI5dE1JSUJJakFOQmdrcWhraUc5dzBCCkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQTM3M0JyRG5kU1Z1UG0xSm5VNCtFVFZqSTFVSTJydVhIY0srUUJ5am4KNk5jMklEZ0NPNzdMOVdTajQzcmRicnlKNm1LMEFrVTBjekhlM1ZVUndaaG95TlM2QnEwaHJIOTFOWHlVcGNaMQpzaTJrbEdFbnVRYSs4dHgrVUwrUGYzck4yTlZ2TytTdnZSL2NxUWpYNnEzeURVMXJLWTZEQUlWaWxBNytDdHhVClE0KzI2MXluSlNTaWZ6YnB0R1ExTmZuV1Y5eHNoOWNyVklqbk9MNlhiek90eHNoYnBxU04xVENoQTR0KzVSb0kKOFo0aG0wWmpMNll3bVYycDB0R2ZFbVV0WGszelRjVVRYTitSODE4MVE0c0JPbEt5YjJpMG1seE9GYUpqc3hQVAprYjBsQmU2WS95TVBrallaT0o5c3YwR0k1YmszaHUwb0lGRDBOb0N5bFNmUmx3SURBUUFCbzBJd1FEQWRCZ05WCkhRNEVGZ1FVS29FbkhWU1dqSFRIeEVoK2xFazFQT2hUYWU4d0h3WURWUjBqQkJnd0ZvQVU0NS9URHQwUVE5dTQKTDN5OVJUOW50Z0VhQnE0d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dJQkFBN1ZNKzZ6bEtKZGlZVElWTjN4ZzJrOApkUG1zSm8vR1UwRW1WTFRzaFJtQWppdnI0bXBkYXRpL0p2UEtIcGtSTTNLcDNqQURmVFRqRnhuZ2ZJajNSN1J5CkpJamZVMGdrdHBKOG9UWVJlMlNsdXdVQ2VrYWlLa1BmWDRLdHcwUWVRSU4vSVN6YTdOS2krWklXOVJhRE1kbzIKNHZYUzIySDRIcjN6dmtFYVhvdHB6YXBlTzJBU1BDS3hoOWRkZWlyVzNydGZpZkRhSFF2UUpZSGpGYWpYcGZhaQpMazRHSWNrdHY2WGNqeFA5V1ArQ1RUWWFxZTVIMkg1dXlheDNyckRWRm43Y3Yzb29mcDJrTVhGUmRjTG9ERGdOCllUT3czTjhRLzl1bjNPRHBZR1l6b3V5RmJieXJ1MUlhcTZKeTRQNURnLzFSaEl3MnpuaWlCdzR0aXBzV2tqSTgKSEtRcWxKZE1KYlZUMHkraUlPMThxdWVsL1hDSC9hS1FEclpMd2Z0WVEvczVTWUtXUG5UZzhIbjJpeUlhUmZ0dQorbkgyMCszZkJuQnorK0hOd1duY2g0WmJDM0k3UklpcXFpdm1ML09YMWkvbng2UG5BVTlQMFlsOGhsMFFINndGCmtOd0NuTmE5TEp6eXBCandjY0IzU1ZaNUIxanhRTTJTcTYrSnB2cFZJSDQzL29paWJ0anhLMDhQenVVZ2luTUgKVC9aMXQ0NDBhRmk2V2VIZHRHM2RkVkM0SGxhS0JqQXVkZm44MHA1M3RPbXN6dkFRUUFidlhpd3pzZVZxYW5mdgpnS1BqWTd5aE9oZzZTdUJ2OFRTVTkvSVBDUklBTnRiMXkvOGxnVVlkVDJ0dGVmTVlnMnhFempndGIxQWEzMzBWCk1ONXV5ZFpCTU92aTRReHJuVzVICi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0=
  tls.key: LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2Z0lCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktnd2dnU2tBZ0VBQW9JQkFRRGZ2Y0dzT2QxSlc0K2IKVW1kVGo0Uk5XTWpWUWphdTVjZHdyNUFIS09mbzF6WWdPQUk3dnN2MVpLUGpldDF1dklucVlyUUNSVFJ6TWQ3ZApWUkhCbUdqSTFMb0dyU0dzZjNVMWZKU2x4bld5TGFTVVlTZTVCcjd5M0g1UXY0OS9lczNZMVc4NzVLKzlIOXlwCkNOZnFyZklOVFdzcGpvTUFoV0tVRHY0SzNGUkRqN2JyWEtjbEpLSi9OdW0wWkRVMStkWlgzR3lIMXl0VWlPYzQKdnBkdk02M0d5RnVtcEkzVk1LRURpMzdsR2dqeG5pR2JSbU12cGpDWlhhblMwWjhTWlMxZVRmTk54Uk5jMzVIegpYelZEaXdFNlVySnZhTFNhWEU0Vm9tT3pFOU9SdlNVRjdwai9JdytTTmhrNG4yeS9RWWpsdVRlRzdTZ2dVUFEyCmdMS1ZKOUdYQWdNQkFBRUNnZ0VBYXhSQXpYRkFFNnlyVlBXaUY5NjJ2ZUhBOURkbFBsMGdEekVtcUJhT3J1UFkKdHFDM2lPcHVhSG9LNllMUzJQMklyOUVmUDNycGVEd2s0aDZsaWRhc1IzbHZzbVJIbW12QnA2Q0E3N25FZUVyWgoybDJKQ2tkTk9hUUhIQlFoMUN2c3VscWppckdPM2QrUzFwOHgzdEh5NXlUbkpaTmI1UEx4VTlTOUJtdWVORnA5ClBiSWwwV0Ewb1h6VWlPa0VESFpJaE9LeEQ1SExNQkpEUGIzYy9ZRE9HSlFtTGRtRldYS1VsL3NHNHJJdzFGNWYKZzhvYzRyekJpRlhVY0EvRlhoWllNcW9lMlp6MFhXWWVCYWhINFB2Sm4zdFVhd0xFQ0NTbW1nYkVzT1ltNHdvZQptUHZmT2k3TDR3VmhGNjNBNkxnL3hpR3VFUkd0cmJlMS8xcVFlTXFGU1FLQmdRRDRmT2ZPaUVpUkViODlJeDdKCjJra3ZuS1ZERXl1YjExc3NzZTNjU054R1haVFBkK0JjTGc5YVBTdXFrWC9NbmJsQ2JBOXZhSzZOL3U2YkxsSkEKQXNnVFM0Rkc0K2J2d2hBTzQybUVKQTJIRG0zNDVGRmRFQ2JYblhjV1VxVzJWblBqNkpDdDB2d1R1ZDNMVGdxbgpFM3RmZVZuM0J4bkpsVU4vOHdXUlB1M2NoUUtCZ1FEbWdWVDJHUDZvanBudC92SjRPOTBrYnEzVVJHYklGK0tOCjYrUnJmb0kxWkN2dElXaGV4OVhtZi8wWVlBaFQvaXJTSDd3RTk3QmpIbWJTMlZId051cDNmc1dDNFNYMDFYTkwKYnFjQmxOeW1JUzFiNGN0U01jMFFyeWM5YWlMUVM1d3Fvc1UwNGZubGdkM2o2cHRjdW8vd0Z6Q3JoV0xUZDk1bgpHeUc5NTZYdWF3S0JnUURySDJWSUsvUmVNR2pBTk1jaFFJY1hvaVZOL29tNUFHR3BQUU5RK1RCVTlKK21ZRXZQCmJWWGhrUmdNWVhpSDZJWXZyNGc3WnRZa1RpRUFmU2dlb1lNbm5yNUlrY1VuQUgycFdNMnkxMXBsZk9YYUtGQkUKdXMvR0haMWRaZjZmTmRhYXhLaUJrYTRzRENjdUJENVlNVHIvOEJlTWd3K0hpdEUvOUhoRUkwTjI4UUtCZ1FDagoxazJEVnFTN1BoQ2ZIMVZNckpBMHN3NlBEOGRXZGRPc09IejFBc2llRm9NNlcwS0tDOVEzcjhVL3JCSi9VT3N5Cnl5ZWpDRUt4VVF5WTFhcnQ2THFqRU5KbWdvMnVCb0dhbmgzS2UvcVJnb2R4Qlg2MC8zellYUWF4R2wyQVhCMjIKR0ZlL2pOZElrQlFkU2NZQUZRTDJEaVdqNUgwbi9jMXd6OUlkM3ljTDNRS0JnQ3NNV1NxU1lobUN3ajdON1U2awpyWndjTGxJdS94UEZsMWFTL2Q2MGV4UXpzWmxzd0xkMzJMcStKdkxVYXNPdWVQaGlCajZZNFNiNlk3bDBLMmNvCkZndXFFbmxBL3JNY2Qxa1h6L0dEbVZvYVVoSk8rZlFNSmk3ZEQzS0tidm80SGxhSG1kSkUvNGN5ek1jQmZVeUUKUUtXUElyVS9WZFU0ckZHV0xqRjJKc1ZPCi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0=

EOF
```

This will create the **secure-app** service and a deployment, as well as a Secret containing the certificate and key that will be used by the backend application to decrypt the HTTPS traffic. Note that the application is configured to accept HTTPS traffic only. Run the following command to verify the resources were created:

```shell
kubectl get pods,svc
```

Your output should include the **secure-app** pod and the **secure-app** service:

```text
NAME                          READY   STATUS      RESTARTS   AGE
pod/secure-app-868cfd5b5-v7gwk   1/1     Running   0          9s

NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/secure-app   ClusterIP   10.96.213.57   <none>        8443/TCP  9s
```

## Configure routing rules

First, create the Gateway resource with an HTTP listener:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
EOF
```

Next, create a HTTPRoute to route traffic to the secure-app backend:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: secure-app
spec:
  parentRefs:
  - name: gateway
    sectionName: http
  hostnames:
  - "secure-app.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: secure-app
      port: 8443
EOF
```

After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service fronting it to route traffic.

Save the public IP address and port of the NGINX Service into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

{{< note >}}In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for.{{< /note >}}

---

## Send Traffic without backend TLS configuration

Using the external IP address and port for the NGINX Service, we can send traffic to our secure-app application. To show what happens if we send plain HTTP traffic from NGINX to our `secure-app`, let's try sending a request before we create the backend TLS configuration.

{{< note >}}If you have a DNS record allocated for `secure-app.example.com`, you can send the request directly to that hostname, without needing to resolve.{{< /note >}}

```shell
curl --resolve secure-app.example.com:$GW_PORT:$GW_IP http://secure-app.example.com:$GW_PORT/
```

```text
<html>
<head><title>400 The plain HTTP request was sent to HTTPS port</title></head>
<body>
<center><h1>400 Bad Request</h1></center>
<center>The plain HTTP request was sent to HTTPS port</center>
<hr><center>nginx/1.25.3</center>
</body>
</html>
```

We can see we a status 400 Bad Request message from NGINX.

---

## Create the backend TLS configuration

{{< note >}} This example uses a `ConfigMap` to store the CA certificate, but you can also use a `Secret`. This could be a better option if integrating with [cert-manager](https://cert-manager.io/). The `Secret` should have a `ca.crt` key that holds the contents of the CA certificate. {{< /note >}}

To configure the backend TLS termination, first we will create the ConfigMap that holds the `ca.crt` entry for verifying our self-signed certificates:

```yaml
kubectl apply -f - <<EOF
kind: ConfigMap
apiVersion: v1
metadata:
  name: backend-cert
data:
  ca.crt: |
    -----BEGIN CERTIFICATE-----
    MIIFlzCCA3+gAwIBAgIULQcgBeB9ApX+Wf+FYLMLAVOLwYIwDQYJKoZIhvcNAQEL
    BQAwWzELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAldBMRAwDgYDVQQHDAdTZWF0dGxl
    MRMwEQYDVQQKDApFeGFtcGxlIENBMRgwFgYDVQQDDA9FeGFtcGxlIFJvb3QgQ0Ew
    HhcNMjUwNjE2MTUzNjQzWhcNMzUwNjE0MTUzNjQzWjBbMQswCQYDVQQGEwJVUzEL
    MAkGA1UECAwCV0ExEDAOBgNVBAcMB1NlYXR0bGUxEzARBgNVBAoMCkV4YW1wbGUg
    Q0ExGDAWBgNVBAMMD0V4YW1wbGUgUm9vdCBDQTCCAiIwDQYJKoZIhvcNAQEBBQAD
    ggIPADCCAgoCggIBAI4fKNzZU/9IEifa6k9L38Ei4lFwFt6wjCZt70Rb5IpJfOkr
    PsZf+XaCgIQZh3ZTBIPZoa2uNxVF1BoKEhEqzGdWdH82lVDmbkSaLeW4YnYhM9fe
    IuYHqyVrNFsp7M+xJD3XWwwCXDN//H+vx8JLQIOX4tQ9RM4rB7avcu0rmaXJuqJi
    N0AU8AsEFpoIiC/vFBucqpG2KzC+FsVPe/Ri+PQTWJ6aLVUvGJ3hXRAQdOMzIGys
    +WTugzqk+Sv9pKDB7/EMJg+5IagNP5QWrDmdBwROdRhd8wq+zYJMxVaaSqetNrnY
    aqWPdGj+RSB5YuiL8kwDiJOPc5G4t2I/hbol5hpBleL84qijclzJQeFOKdEbRzMa
    w2QfyZxZ24TCZGwDzs480x5bKmUoRufdk8X4DSjV4tnKMh9sfHX3w4cokp2IWBqt
    B59HMN4nAKELftjfKjI9L0jnEbJR/Xae0qPLxjAuN0HARQNx1/EvvsWGhgu4Sr5S
    Ua604wHU9p85a5zWOgOJ471f/sA3q2yEiiHPYqbZ2YXmVMrHvMROO5EVCN7HOjoL
    QW4z85fX7QT3OwF6Xckk8jA45tcy0cIlOHsl19XbZUJ5Gc7jAiYbmy2IRYgNiMmb
    iSBL0eoC2jan1Y6Of0UcOiAfsMvt5f21dehYkP7Mwe7sGmMk8Lkva1PRSUFfAgMB
    AAGjUzBRMB0GA1UdDgQWBBTjn9MO3RBD27gvfL1FP2e2ARoGrjAfBgNVHSMEGDAW
    gBTjn9MO3RBD27gvfL1FP2e2ARoGrjAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3
    DQEBCwUAA4ICAQBD/b0Vu1vbRYQIeBbaPLCHS5IO8R2G18w+RyUBYpcr50FLI81X
    YPTCnEXw5sVd7Y7PNZ6q3crr4u/tGWwDWr9vHL5YWApEnUJzdp9NGv9Z29pgRrQS
    Dzr+ggv8/NRMy4xFZ/U5JKy1lHgNFhSp68PrZI6T4xN3zyTCj29qC9hxoxhYpbXS
    1m3PB84T1VqZu2dwNZll+kOIMv+Qon8MWZbuGLkFrcxuDqHB6RRAWyRB7WKKZZXu
    r+Uw+9+0htNcASNuEx1yXUaE9Bf9V22fs4ARilP2QpFtMN8BCVQiKp8tj+em3ZX0
    5KfUavNIZekrHKn/3pc9M+PhX+CEPLNncgywBVYZN89ZujyNVCKVwWD3LmH5NZ8w
    JMJ9f3SC8ZqTu7xqX6FVLvmNAm5sS7lE8M0wGzp9cZHHEmstC1//jc+JzhRu8XyU
    wGJyANVFlPn7+nnSq7dWbv4OTFsurbWrHQlzwjHaht84DGR4E0QgLUtA+ICGU0Ig
    3/Ma5N7Jugw2mbx8NupgOE3AL6aScbuSt2E1/4QZ2uNPh8soxbANu9WbEXOXzxd5
    LItmVd4ltG/4i2qwLu4NLSNA56iaCDIRD/cfr6WmNLfcMTGRMIJ+AlxnETAIy+pK
    s6cpSfBLcDUhStgvr5oNDFeCbmsXRgyJZE9I4mKijG8v+LkS9RgKsS7tRw==
    -----END CERTIFICATE-----
EOF
```

Next, we create the Backend TLS Policy which targets our `secure-app` Service and refers to the ConfigMap created in the previous step:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1alpha3
kind: BackendTLSPolicy
metadata:
  name: backend-tls
spec:
  targetRefs:
  - group: ''
    kind: Service
    name: secure-app
  validation:
    caCertificateRefs:
    - name: backend-cert
      group: ''
      kind: ConfigMap
    hostname: secure-app.example.com
EOF
```

To confirm the Policy was created and attached successfully, we can run a describe on the BackendTLSPolicy object:

```shell
kubectl describe backendtlspolicies.gateway.networking.k8s.io
```

```text
Name:         backend-tls
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  gateway.networking.k8s.io/v1alpha3
Kind:         BackendTLSPolicy
Metadata:
  Creation Timestamp:  2024-05-15T12:02:38Z
  Generation:          1
  Resource Version:    19380
  UID:                 b3983a6e-92f1-4a98-b2af-64b317d74528
Spec:
  Target Refs:
    Group:
    Kind:       Service
    Name:       secure-app
  Validation:
    Ca Certificate Refs:
      Group:
      Kind:    ConfigMap
      Name:    backend-cert
    Hostname:  secure-app.example.com
Status:
  Ancestors:
    Ancestor Ref:
      Group:      gateway.networking.k8s.io
      Kind:       Gateway
      Name:       gateway
      Namespace:  default
    Conditions:
      Last Transition Time:  2024-05-15T12:02:38Z
      Message:               BackendTLSPolicy is accepted by the Gateway
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

---

## Send traffic with backend TLS configuration

Now let's try sending traffic again:

```shell
curl --resolve secure-app.example.com:$GW_PORT:$GW_IP http://secure-app.example.com:$GW_PORT/
```

```text
hello from pod secure-app
```

---

## See also

To learn more about configuring backend TLS termination using the Gateway API, see the following resources:

- [Backend TLS Policy](https://gateway-api.sigs.k8s.io/api-types/backendtlspolicy/)
- [Backend TLS Policy GEP](https://gateway-api.sigs.k8s.io/geps/gep-1897/)
