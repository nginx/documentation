---
title: Configure API key authentication
description: "Send API keys in a header or a query parameter to protect your apps with the AuthenticationFilter CRD in F5 NGINX Gateway Fabric."
weight: 450
toc: true
f5-content-type: how-to
f5-product: F5 NGINX Gateway Fabric
f5-keywords: "NGINX Gateway Fabric, API key, API keys, authentication, AuthenticationFilter, X-API-Key"
f5-summary: >
  API key authentication checks each request for a key in a header or a query parameter before it reaches your apps.
  Keys live in a Kubernetes Secret, so you can add or revoke a key without changing your routes.
  API key authentication works with both NGINX Open Source and NGINX Plus.
f5-audience: operator
---

This page describes how to set up API key authentication in F5 NGINX Gateway Fabric using the AuthenticationFilter custom resource definition (CRD).

API key authentication looks for a key in each request. Clients send the key in a request header or a URL query parameter. NGINX Gateway Fabric loads those keys from a Kubernetes Secret into the NGINX data plane, which checks each request and rejects unknown keys before they reach your apps.

API key authentication works with NGINX Open Source and NGINX Plus. Use it for machine-to-machine traffic, such as a mobile app or partner service calling your API. For user sign-in, use [OpenID Connect authentication]({{< ref "/ngf/traffic-security/oidc-authentication.md" >}}) or [basic authentication]({{< ref "/ngf/traffic-security/basic-authentication.md" >}}) instead.

By following these instructions, you create two sample app endpoints: one that requires an API key and one that doesn't. You then send requests with a valid key, an invalid key, and no key, and compare the results.

{{< call-out class="caution" >}}
Keys in a URL are less private than keys in a header. They can appear in browser history, in `Referer` headers sent to other sites, and in logs at every hop between the client and your app. Prefer a header unless your clients can't set one. If you do use a query parameter, serve traffic over [HTTPS]({{< ref "/ngf/traffic-management/https-termination.md" >}}).
{{< /call-out >}}

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.
- Make sure you have `kubectl` installed and access to a cluster.
- Check that your cluster has the `authenticationfilters.gateway.nginx.org` CRD. Run `kubectl get crd authenticationfilters.gateway.nginx.org -o jsonpath='{.spec.versions[0].schema.openAPIV3Schema.properties.spec.properties.apiKey.type}'`. The command prints `object` when your CRDs support API keys. If it prints nothing or an error, update your CRDs. See [Update the CRDs](#update-the-crds).

## Set up the example resources

Create the sample apps, the Gateway, and the API keys. Each step gives you YAML to apply with `kubectl`.

### Deploy the sample applications

Create the coffee and tea applications:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coffee
spec:
  replicas: 1
  selector:
    matchLabels:
      app: coffee
  template:
    metadata:
      labels:
        app: coffee
    spec:
      containers:
      - name: coffee
        image: nginxdemos/nginx-hello:plain-text
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: coffee
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: coffee
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tea
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tea
  template:
    metadata:
      labels:
        app: tea
    spec:
      containers:
      - name: tea
        image: nginxdemos/nginx-hello:plain-text
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: tea
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: tea
EOF
```

Check that the pods are running:

```shell
kubectl get pods
```

```text
NAME                      READY   STATUS    RESTARTS   AGE
coffee-654ddf664b-4fmcq   1/1     Running   0          13s
tea-75bc9f4b6d-8gtjl      1/1     Running   0          13s
```

### Create a Gateway

Create the Gateway resource, which makes NGINX Gateway Fabric provision an NGINX pod and a Service in front of it:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: cafe-gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    hostname: "*.example.com"
EOF
```

The `*.example.com` hostname matches any host that adds one label to `example.com`, such as the `cafe.example.com` host this guide uses.

Confirm the Gateway was assigned an IP address and reports a `Programmed=True` status with `kubectl describe`:

```shell
kubectl describe gateways.gateway.networking.k8s.io cafe-gateway
```

```text
Addresses:
  Type:   IPAddress
  Value:  192.0.2.1
```

Save the public IP address and port of the Gateway into shell variables:

```shell
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<PORT_NUMBER>
```

Replace `<PORT_NUMBER>` with the port number you use to access your Gateway.

## Create the Secret and the filter

{{< call-out class="important" >}}
API key authentication needs a version of NGINX Gateway Fabric that supports it, and CRDs that know the `apiKey` field. An older control plane ignores the field, so requests pass without a key. If `kubectl` reports `no matches for kind "AuthenticationFilter"`, or the filter is rejected as `Invalid`, fix your CRDs with [Update the CRDs](#update-the-crds) before you continue.
{{< /call-out >}}

Apply the Secret and the filter together:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: api-keys
type: Opaque
data:
  # The "auth" key contains one client per line in "client-name:api-key" format.
  #
  # Decoded value:
  #   client-mobile:key-abc123
  #   client-web:key-def456
  auth: Y2xpZW50LW1vYmlsZTprZXktYWJjMTIzCmNsaWVudC13ZWI6a2V5LWRlZjQ1Ngo=
---
apiVersion: gateway.nginx.org/v1alpha1
kind: AuthenticationFilter
metadata:
  name: api-key-auth
spec:
  type: APIKey
  apiKey:
    secretRef:
      name: api-keys
    sources:
      - type: Header
        name: X-API-Key
      - type: Query
        name: api_key
EOF
```

The Secret, named `api-keys`, holds the keys in a data entry named `auth`. Each line names one client and its key, in `client-name:api-key` format.

The filter, named `api-key-auth`, points at the Secret and says where clients send the key. The example accepts the key in the `X-API-Key` header or in an `api_key` query parameter.

The example keys are `key-abc123` for `client-mobile` and `key-def456` for `client-web`. Swap them for your own before you send real traffic. See [Use your own keys](#use-your-own-keys).

Check that the filter is accepted:

```shell
kubectl describe authenticationfilters.gateway.nginx.org api-key-auth | grep "Status:" -A10
```

```text
Status:
  Controllers:
    Conditions:
      Last Transition Time:  2026-10-19T10:26:58Z
      Message:               The AuthenticationFilter is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

## Protect a route

Apply the HTTPRoute that attaches the filter to `/coffee`. The `/tea` route has no filter, so you can compare the two:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: cafe-routes
spec:
  parentRefs:
  - name: cafe-gateway
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
    filters:
    - type: ExtensionRef
      extensionRef:
        group: gateway.nginx.org
        kind: AuthenticationFilter
        name: api-key-auth
  - matches:
    - path:
        type: PathPrefix
        value: /tea
    backendRefs:
    - name: tea
      port: 80
EOF
```

Check that the route is accepted:

```shell
kubectl describe httproute cafe-routes | grep "Status:" -A10
```

```text
Status:
  Parents:
    Conditions:
      Last Transition Time:  2026-10-19T10:28:15Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-10-19T10:28:15Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
    Parent Ref:
      Group:         gateway.networking.k8s.io
      Kind:          Gateway
      Name:          cafe-gateway
      Namespace:     default
      Section Name:  http
Events:              <none>
```

## Test your configuration

{{< call-out class="note" >}}

Your clients need to resolve `cafe.example.com` to the IP address of the NGINX Service. This guide does that with the curl `--resolve` option.

{{< /call-out >}}

Store the keys in shell variables. `GOOD_KEY` holds a key from the Secret and `BAD_KEY` holds a value that isn't in it:

```shell
GOOD_KEY=key-abc123
BAD_KEY=not-a-real-key
```

Send the key in a header:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -H "X-API-Key: $GOOD_KEY"
```

```text
Server address: 192.0.2.7:8080
Server name: coffee-654ddf664b-nhhvr
Date: 19/Oct/2026:15:20:15 +0000
URI: /coffee
Request ID: 13a925b2514b62c45ea4a79800248d5c
```

The key matches an entry in the Secret, so the request reaches the app.

Send the key in a query parameter:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP "http://cafe.example.com:$GW_PORT/coffee?api_key=$GOOD_KEY"
```

```text
Server address: 192.0.2.7:8080
Server name: coffee-654ddf664b-nhhvr
Date: 19/Oct/2026:15:21:30 +0000
URI: /coffee?api_key=key-abc123
Request ID: 7b2e4a1c9f0d3e5a8c6b4d2f1a0e9c8b
```

Both sources are enabled, so the query parameter works the same way as the header.

Send the request without a key:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

```text
<html>
<head><title>401 Authorization Required</title></head>
<body>
<center><h1>401 Authorization Required</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

Neither source has a key, so NGINX Gateway Fabric responds with `401`.

Send a key that isn't in the Secret:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -H "X-API-Key: $BAD_KEY"
```

```text
<html>
<head><title>403 Forbidden</title></head>
<body>
<center><h1>403 Forbidden</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

A `403` means NGINX Gateway Fabric checked the key and rejected it. A `401` means the request had no key to check.

Send a request to the route with no filter:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

```text
Server address: 10.244.0.10:8080
Server name: tea-75bc9f4b6d-ms2n8
Date: 19/Oct/2026:15:36:26 +0000
URI: /tea
Request ID: c7eb0509303de1c160cb7e7d2ac1d99f
```

The `/tea` route has no AuthenticationFilter, so NGINX Gateway Fabric forwards the request as it is.

### Get the response status without the body

To see only the status code for each case, add the `-o`, `-s`, and `-w` options to curl:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP -s -o /dev/null -w "%{http_code}\n" http://cafe.example.com:$GW_PORT/coffee -H "X-API-Key: $GOOD_KEY"
```

## The filter at a glance

The `apiKey` fields in the filter you created work as follows:

| Field | Description |
| ----- | ----------- |
| `type` | Set to `APIKey` to use API key authentication. A filter with `type: APIKey` can't set `spec.jwt`, `spec.oidc`, or `spec.basic`. |
| `apiKey.secretRef` | Name of the Secret that holds the keys. The Secret must be in the same namespace as the filter. Required. |
| `apiKey.sources` | Where clients can send the key. Set one or two sources. Required. |
| `sources[].type` | `Header` to read a request header, or `Query` to read a URL query parameter. |
| `sources[].name` | Header name or query parameter name. Use letters, numbers, `-`, and `_`, up to 253 characters. |

## How the check works

**Keys that get accepted**

NGINX Gateway Fabric reads the keys from the `auth` entry of the Secret and loads them into the NGINX data plane. The data plane matches keys exactly, so an uppercase letter or a trailing space makes a key invalid. The client name isn't used to authorize a request. The name tells you which key belongs to whom, so you can revoke one client without touching the others.

{{< call-out class="note" >}}
Keys can contain letters, numbers, and the characters `- _ . = + / ~`. NGINX Gateway Fabric skips lines that are malformed or that contain other characters, and it ignores duplicate keys.
{{< /call-out >}}

**Sources, where the key comes from**

A request passes when any source carries a valid key, so clients can use whichever one suits them. Header names are case-insensitive, so a source named `x-api-key` matches an `X-API-Key` header.

A query parameter name can't contain a hyphen. NGINX can't read query arguments whose names include `-`, so `api-key` is rejected while `api_key` is fine.

**What each request gets**

| Request to `/coffee`                   | Response                           |
| -------------------------------------- | ---------------------------------- |
| Header carries a key from the Secret   | `200`: the request reaches the app |
| Query carries a key from the Secret    | `200`: the request reaches the app |
| No key in any source                   | `401`: no key was found            |
| Key isn't in the Secret                | `403`: the key isn't valid         |
| Request to `/tea`, which has no filter | `200`: no check is made            |

## Additional configuration

### Use your own keys

The example Secret holds base64-encoded keys, which is easy to copy but hard to edit. Create a file with your own keys, then build the Secret from it. The `--from-file=auth` flag names the data entry `auth`:

```shell
cat <<EOF > auth
client-mobile:<API_KEY>
client-web:<API_KEY>
EOF
kubectl create secret generic api-keys --from-file=auth --dry-run=client -o yaml | kubectl apply -f -
```

Replace each `<API_KEY>` with a key of your own. Generate keys with a random generator, for example `openssl rand -hex 24`.

Check what NGINX Gateway Fabric reads by decoding the Secret:

```shell
kubectl get secret api-keys -o jsonpath='{.data.auth}' | base64 --decode
```

### Change or revoke a key

Keys come from the Secret, so you can change them without touching the filter or your routes. Change the `auth` file and run the same `kubectl apply` command. NGINX Gateway Fabric reads the changed Secret and updates the keys NGINX accepts.

To revoke a client, delete its line and apply the Secret again. Requests using that key start getting `403`.

### Accept keys in a header only

Drop the query source so clients must use a header:

```yaml
spec:
  type: APIKey
  apiKey:
    secretRef:
      name: api-keys
    sources:
      - type: Header
        name: X-API-Key
```

### Keep keys out of access logs

Routes with API key authentication log the request path without the query string. Keys sent as query parameters don't end up in the NGINX access log. Other systems can still record the full URL. Your app and any proxy between the client and the Gateway can log the key, so headers stay the safer option.

### Allow browser requests

Browsers send an unauthenticated `OPTIONS` request before a cross-origin call. When you set [CORS]({{< ref "/ngf/traffic-security/cors.md" >}}) on the same route, NGINX Gateway Fabric answers that request before it looks for a key. Only the real call needs a key.

### Give each client group its own keys

One Secret means one key list for every route that uses the filter. To give a group of clients its own keys, create a Secret and a filter for that group. Then reference the filter on the routes that group uses.

```shell
kubectl create secret generic partner-keys --from-literal=auth="partner-a:<API_KEY>" --dry-run=client -o yaml | kubectl apply -f -
```

### Update the CRDs

CRDs come with NGINX Gateway Fabric. When you upgrade NGINX Gateway Fabric, apply the matching CRDs again:

```shell
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/crds.yaml
```

The `--force-conflicts` flag is needed when Helm owns the CRDs and you update them with `kubectl`. To learn more, see [Upgrade NGINX Gateway Fabric]({{< ref "/ngf/install/upgrade-version.md#upgrade-nginx-gateway-fabric-crds" >}}).

Run the check from [Before you begin](#before-you-begin) again. It prints `object` when the CRDs are ready.

## Troubleshooting

- Your cluster is missing the NGINX Gateway Fabric CRDs. `kubectl` then fails with `no matches for kind "AuthenticationFilter" in version "gateway.nginx.org/v1alpha1"`. Confirm your cluster with `kubectl config current-context`, then see [Update the CRDs](#update-the-crds).
- If the filter is accepted but clients reach the app without a key, your CRDs are older than this feature and dropped the `apiKey` field. Run the CRD check from [Before you begin](#before-you-begin). It must print `object`.
- Check that the filter is accepted with `kubectl describe authenticationfilters.gateway.nginx.org api-key-auth`. An `Invalid` condition tells you what to fix.
- If the filter is rejected with a message about the Secret, check two things. The Secret must be in the same namespace as the filter, and its data entry must be named `auth`.
- If the filter is rejected with a message about `client-name:api-key` entries, every line failed. Check that each line has a name, a colon, and a key, and that the keys use only supported characters.
- If the filter is rejected with `query parameter names must not contain hyphens`, rename the source. Replace `-` with `_` in the name.
- If valid requests get `403`, compare the key the client sends with the decoded Secret, character by character. The check is case-sensitive and rejects extra spaces.
- If requests without a key get `200`, check that the route rule references the filter. The `extensionRef` needs `group: gateway.nginx.org`, `kind: AuthenticationFilter`, and the filter name.
- If requests stop working after you change a key, check that `kubectl get secret api-keys -o jsonpath='{.data.auth}' | base64 --decode` shows the keys you expect. NGINX Gateway Fabric ignores duplicate keys.

## Limitations

- The `auth` entry can't be empty. `kubectl create secret` fails when you give it an empty literal value. Use `--from-file`, `--from-literal`, or a manifest that sets `auth` to base64-encoded content.
- An empty key is not treated as a key. A request with an empty query parameter such as `?api_key=` gets a `401`, the same response as a request with no key.
- You can define a `Header` source and a `Query` source, but a second header or a second query parameter isn't supported. Add more filters if clients need more key locations.
- API keys don't expire. NGINX Gateway Fabric has no setting that makes a key invalid on a date. Rotate keys by changing the Secret yourself.

## Further reading

- [AuthenticationFilter API reference]({{< ref "/ngf/reference/api.md#gateway.nginx.org/v1alpha1.AuthenticationFilter" >}})
- [Configure basic authentication]({{< ref "/ngf/traffic-security/basic-authentication.md" >}})
- [Configure external authentication]({{< ref "/ngf/traffic-security/external-authentication.md" >}})
- [Configure JSON Web Token (JWT) authentication]({{< ref "/ngf/traffic-security/jwt-authentication.md" >}})
- [Configure Cross-Origin Request Sharing (CORS)]({{< ref "/ngf/traffic-security/cors.md" >}})
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)