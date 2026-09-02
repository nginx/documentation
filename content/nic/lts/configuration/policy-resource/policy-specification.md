---
title: Policy specification
weight: 200
toc: true
f5-content-type: reference
f5-product: NGINX Ingress Controller
---

Below is an example of a policy that allows access for clients from the subnet `10.0.0.0/8` and denies access for any other clients:

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: allow-localhost
spec:
  accessControl:
    allow:
    - 10.0.0.0/8
```

{{% table %}}

|Field | Description | Type | Supported in VS/VSR | Supported in Ingress |
| ---| ---| ---| --- | --- |
|``accessControl`` | Allows or denies requests based on the client IP address. | [accessControl](#accesscontrol) | Yes | Yes |
|``rateLimit`` | Controls the request-processing rate for a defined key. | [rateLimit](#ratelimit) | Yes | No |
|``apiKey`` | Authorizes requests that include a valid API key in a specified header or query parameter. | [apiKey](#apikey) | Yes | No |
|``basicAuth`` | Authenticates client requests using HTTP Basic authentication credentials. | [basicAuth](#basicauth) | Yes | No |
|``jwt`` | Authenticates client requests using JSON Web Tokens. | [jwt](#jwt-using-a-local-kubernetes-secret) | Yes | No |
|``ingressMTLS`` | Configures client certificate verification. | [ingressMTLS](#ingressmtls) | Yes | No |
|``egressMTLS`` | Configures upstream authentication and certificate verification. | [egressMTLS](#egressmtls) | Yes | No |
|``oidc`` | Configures NGINX Plus as a relying party for OpenID Connect (OIDC) authentication. | [OIDC](#oidc) | Yes | No |
|``cache`` | Configures proxy caching for serving cached content. | [cache](#cache) | Yes | No |
|``cors`` | Configures Cross-Origin Resource Sharing (CORS) headers. | [cors](#cors) | Yes | Yes |

{{% /table %}}

{{< call-out "note" >}}

NGINX Ingress Controller LTS added Policy resource support for Ingress objects through the [`nginx.org/policies`]({{< ref "/nic/lts/configuration/ingress-resources/advanced-configuration-with-annotations.md" >}}) annotation in v5.4.0.

{{< /call-out >}}

A policy must include exactly one policy type.

## AccessControl

The access control policy configures NGINX to deny or allow requests from clients with the specified IP addresses or subnets.

For example, the following policy allows access for clients from the subnet `10.0.0.0/8` and denies access for any other clients:

```yaml
accessControl:
  allow:
  - 10.0.0.0/8
```

In contrast, the following policy does the opposite. It denies access for clients from `10.0.0.0/8` and allows access for any other clients:

```yaml
accessControl:
  deny:
  - 10.0.0.0/8
```

{{< call-out "note" >}}

This feature uses the NGINX [ngx_http_access_module](http://nginx.org/en/docs/http/ngx_http_access_module.html). The NGINX Ingress Controller LTS access control policy supports either allow rules or deny rules, but not both, unlike the module itself.

{{< /call-out >}}

{{% table %}}

|Field | Description | Type | Required |
| ---| ---| ---| --- |
|``allow`` | Allows access for the specified networks or addresses. For example, ``192.168.1.1`` or ``10.1.1.0/16``. | ``[]string`` | No |
|``deny`` | Denies access for the specified networks or addresses. For example, ``192.168.1.1`` or ``10.1.1.0/16``. | ``[]string`` | No | \* an accessControl must include either `allow` or `deny`. |

{{% /table %}}

### AccessControl merging behavior

A VirtualServer or VirtualServerRoute can reference multiple access control policies. For example, this configuration references two policies, each with a configured allow list:

```yaml
policies:
- name: allow-policy-one
- name: allow-policy-two
```

When a resource references more than one access control policy, NGINX Ingress Controller LTS merges the contents into a single allow list or a single deny list.

NGINX Ingress Controller LTS doesn't support referencing both allow and deny policies together, as shown in the following example. If a resource references both allow and deny lists, NGINX Ingress Controller LTS uses only the allow list policies.

```yaml
policies:
- name: deny-policy
- name: allow-policy-one
- name: allow-policy-two
```

## RateLimit

The rate limit policy configures NGINX to limit the processing rate of requests.

For example, the following policy limits all subsequent requests from a single IP address once the rate exceeds 10 requests per second:

```yaml
rateLimit:
  rate: 10r/s
  zoneSize: 10M
  key: ${binary_remote_addr}
```

{{< call-out "note" >}}

This feature uses the NGINX [ngx_http_limit_req_module](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html).

{{< /call-out >}}

{{< call-out "note" >}}

When you turn on the [zone sync feature]({{< ref "/nic/lts/configuration/global-configuration/configmap-resource.md#zone-sync" >}}) with NGINX Plus, NGINX Ingress Controller LTS synchronizes the rate limiting zone across all replicas in the cluster. This means all replicas know about requests that other replicas in the cluster have already rate limited.

{{< /call-out >}}

{{% table %}}

|Field | Description | Type | Required |
| ---| ---| ---| --- |
|``rate`` | The rate of requests permitted. The rate is specified in requests per second (r/s) or requests per minute (r/m). | ``string`` | Yes |
|``key`` | The key to which the rate limit is applied. Can contain text, variables, or a combination of them. Variables must be surrounded by ``${}``. For example: ``${binary_remote_addr}``. Accepted variables are ``$binary_remote_addr``, ``$request_uri``,``$request_method``, ``$url``, ``$http_``, ``$args``, ``$arg_``, ``$cookie_``, ``$jwt_claim_``. | ``string`` | Yes |
|``zoneSize`` | Size of the shared memory zone. Only positive values are allowed. Allowed suffixes are ``k`` or ``m``, if none are present ``k`` is assumed. | ``string`` | Yes |
|``delay`` | The delay parameter specifies a limit at which excessive requests become delayed. If not set all excessive requests are delayed. | ``int`` | No |
|``noDelay`` | Disables the delaying of excessive requests while requests are being limited. Overrides ``delay`` if both are set. | ``bool`` | No |
|``burst`` | Excessive requests are delayed until their number exceeds the ``burst`` size, in which case the request is terminated with an error. | ``int`` | No |
|``dryRun`` | Turns on dry run mode. In this mode, NGINX Ingress Controller LTS doesn't apply the rate limit, but it accounts for the number of excessive requests as usual in the shared memory zone. | ``bool`` | No |
|``logLevel`` | Sets the desired logging level for cases when the server refuses to process requests due to rate exceeding, or delays request processing. Allowed values are ``info``, ``notice``, ``warn`` or ``error``. Default is ``error``. | ``string`` | No |
|``rejectCode`` | Sets the status code to return in response to rejected requests. Must fall into the range ``400..599``. Default is ``503``. | ``int`` | No |
|``scale`` | Keeps the rate limit constant by dividing the configured rate by the number of NGINX Ingress Controller LTS pods currently serving traffic. This adjustment keeps the rate limit consistent, even as the number of pods fluctuates due to autoscaling. **This doesn't work correctly if requests from a client aren't distributed evenly across all Ingress Controller pods** (for example, with sticky sessions or long-lived TCP connections with many requests). In these cases, [zone sync]({{< ref "/nic/lts/configuration/global-configuration/configmap-resource.md#zone-sync" >}}) gives better results. Turning on `zone-sync` suppresses this setting. | ``bool`` | No |
|``condition`` | Add a condition to a rate-limit policy. | [ratelimit.condition](#ratelimitcondition) | No |

{{% /table %}}

{{< call-out "note" >}}

For each policy referenced in a VirtualServer or its VirtualServerRoutes, NGINX Ingress Controller LTS generates a single rate limiting zone defined by the [`limit_req_zone`](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone) directive. If two VirtualServer resources reference the same policy, NGINX Ingress Controller LTS generates two different rate limiting zones, one zone per VirtualServer.

{{< /call-out >}}

### RateLimit merging behavior

A VirtualServer or VirtualServerRoute can reference multiple rate limit policies. For example, this configuration references two policies:

```yaml
policies:
- name: rate-limit-policy-one
- name: rate-limit-policy-two
```

When a resource references more than one rate limit policy, NGINX Ingress Controller LTS configures NGINX to use all referenced rate limits. When you define multiple policies, each additional policy inherits the `dryRun`, `logLevel`, and `rejectCode` parameters from the first policy referenced (`rate-limit-policy-one`, in the example above).

## RateLimit.Condition

RateLimit.Condition defines a condition for a rate limit policy. For example:

```yaml
condition:
  jwt:
    claim: user_details.level
    match: premium
  default: true
```

{{% table %}}

|Field | Description | Type | Required |
| ---| ---| ---| --- |
|``jwt`` | defines a JWT condition to rate limit against. | [ratelimit.condition.jwt](#ratelimitconditionjwt) | No |
|``variables`` | defines a Variable condition to rate limit against. | [ratelimit.condition.variables](#ratelimitconditionvariables) | No |
|``default`` | sets the rate limit in this policy to be the default if no conditions are met. In a group of policies with the same condition, only one policy can be the default. | ``bool`` | No |

{{% /table %}}

{{< call-out "note" >}}

Conditions (`jwt` or `variables`) are optional, but each policy can only have one. If conditions are used and a request doesn't match any of them, NGINX Ingress Controller LTS applies the `default` policy, if one is defined. Otherwise, if no `default` is set, the request isn't rate limited.

{{< /call-out >}}

Combine the rate limit policy with condition with one or more rate limit policies. For example, you can combine multiple rate limit policies that use [RateLimit.Condition.JWT](#ratelimitconditionjwt) to apply different tiers of rate limit based on the value of a JWT claim. For a practical example of tiered rate limiting by the value of a JWT claim, see the example in the [GitHub repository](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-lts-version >}}/examples/custom-resources/rate-limit-tiered-jwt-claim/README.md).

## RateLimit.Condition.JWT

RateLimit.Condition.JWT defines a condition for a rate limit by JWT claim. For example, the following condition applies a rate limit policy only to requests with a JWT claim `user_details.level` with a value `premium`:

```yaml
jwt:
  claim: user_details.level
  match: premium
```

The rate limit policy applies only to requests that contain a JWT with the specified claim and value. For example, the following JWT payload matches the JWT condition:

```json
{
  "user_details": {
    "level": "premium"
  },
  "sub": "client1"
}
```

{{% table %}}

|Field | Description | Type | Required |
| ---| ---| ---| --- |
|``claim`` | Claim is the JWT claim to be rate limit by. Nested claims should be separated by ".". | ``string`` | Yes |
|``match`` | the value of the claim to match against. | ``string`` | Yes |

{{% /table %}}

## RateLimit.Condition.Variables

RateLimit.Condition.Variables defines a condition for a rate limit by NGINX variable. The following example defines a condition for a rate limit policy that applies only to requests with the request method with a value `GET`:

```yaml
variables:
  - name: $request_method
    match: GET
```

{{< call-out "note" >}}

NGINX Ingress Controller LTS currently supports only one variable at a time.

{{< /call-out >}}

{{% table %}}

|Field | Description | Type | Required |
| ---| ---| ---| --- |
|``name`` | the name of the NGINX variable to be rate limit by. | ``string`` | Yes |
|``match`` | the value of the NGINX variable to match against.  Values prefixed with the `~` character denote the following is a [regular expression](https://nginx.org/en/docs/http/ngx_http_map_module.html#map).  | ``string`` | Yes |

{{% /table %}}

## APIKey

The API Key auth policy configures NGINX to authorize client requests based on the presence of a valid API Key in a header or query parameter specified in the policy.

{{< call-out "note" >}}

This feature uses the NGINX [ngx_http_auth_request_module](http://nginx.org/en/docs/http/ngx_http_auth_request_module.html) and [NGINX JavaScript (NJS)](https://nginx.org/en/docs/njs/).

{{< /call-out >}}

The policy stores API keys securely using SHA-256 hashing. When a client sends an API Key, NJS hashes it and compares it to the hashed API Key in the NGINX configuration.

If the hashed keys match, the NJS subrequest issues a 204 No Content response to the `auth_request` directive, indicating successful authorization. If the client doesn't provide an API Key in the specified header or query parameter, NGINX returns a 401 Unauthorized response. If the client presents an invalid key in the expected header or query parameter, NGINX returns a 403 Forbidden response and denies access.

You can use the [errorPages]({{< ref "/nic/lts/configuration/virtualserver-and-virtualserverroute-resources.md#errorpage" >}}) property on a route to change the default behavior for 401 or 403 errors.

The policy requires at least one header or query parameter.

The policy below configures NGINX Ingress Controller LTS to require the API Key `password` in the header "my-header".

```yaml
apiKey:
    suppliedIn:
      header:
      - "my-header"
    clientSecret: api-key-secret
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: api-key-secret
type: nginx.org/apikey
data:
    client1: cGFzc3dvcmQ= # password
```

{{% table %}}

|Field | Description | Type | Required |
| ---| ---| ---| --- |
|``suppliedIn`` | `header` or `query`. | | Yes |
|``suppliedIn.header`` | An array of headers that the API Key may appear in. | ``string[]`` | No |
|``suppliedIn.query`` | An array of query params that the API Key may appear in. | ``string[]`` | No |
|``clientSecret`` | The name of the Kubernetes secret that stores the API Key(s). It must be in the same namespace as the Policy resource. The secret must be of the type ``nginx.org/apikey``, and the API Key(s) must be stored in a key: val format where each key is a unique clientID and each value is a unique base64 encoded API Key  | ``string`` | Yes |

{{% /table %}}

{{< call-out "important" >}}

An APIKey policy must include at least one of the `suppliedIn.header` or `suppliedIn.query` parameters. You can also include both.

{{< /call-out >}}

### APIKey merging behavior

A VirtualServer or VirtualServerRoute can be associated with only one API Key policy per route or subroute. You can replace an API Key policy from a higher level with a different policy defined on a more specific route.

For example, a VirtualServer can implement different API Key policies at various levels. In the following configuration, the server-wide `api-key-policy-server` applies to `/backend1` for authorization, because that route has no more specific policy. `/backend2` uses `api-key-policy-route`, defined at the route level.

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: virtual-server
spec:
  host: virtual-server.example.com
  policies:
  - name: api-key-policy-server
  upstreams:
  - name: backend2
    service: backend2-svc
    port: 80
  - name: backend1
    service: backend1-svc
    port: 80
  routes:
  - path: /backend1
    action:
      pass: backend1
  - path: /backend2
    action:
      pass: backend2
    policies:
      - name: api-key-policy-route
```

## BasicAuth

The basic auth policy configures NGINX to authenticate client requests using the [HTTP Basic authentication scheme](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication).

For example, the following policy rejects all requests that don't include a valid username and password combination in the HTTP header `Authentication`:

```yaml
basicAuth:
  secret: htpasswd-secret
  realm: "My API"
```

{{< call-out "note" >}}
This feature uses the NGINX [ngx_http_auth_basic_module](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html).
{{< /call-out >}}

{{% table %}}

|Field | Description | Type | Required |
| ---| ---| ---| --- |
|``secret`` | The name of the Kubernetes secret that stores the Htpasswd configuration. It must be in the same namespace as the Policy resource. The secret must be of the type ``nginx.org/htpasswd``, and the config must be stored in the secret under the key ``htpasswd``. Otherwise, NGINX Ingress Controller LTS rejects the secret as invalid. | ``string`` | Yes |
|``realm`` | The realm for the basic authentication. | ``string`` | No |

{{% /table %}}

### BasicAuth merging behavior

A VirtualServer or VirtualServerRoute can reference multiple basic auth policies, but NGINX Ingress Controller LTS applies only the first one. It ignores every subsequent reference. For example, this configuration references two policies:

```yaml
policies:
- name: basic-auth-policy-one
- name: basic-auth-policy-two
```

In this example, NGINX Ingress Controller LTS uses the configuration from the first policy reference, `basic-auth-policy-one`, and ignores `basic-auth-policy-two`.

## JWT using a local Kubernetes secret

The JWT policy configures NGINX Plus to authenticate client requests using JSON Web Tokens.

The following example policy rejects all requests that don't include a valid JWT in the HTTP header `token`:

```yaml
jwt:
  secret: jwk-secret
  realm: "My API"
  token: $http_token
```

You can pass the JWT claims and JOSE headers to the upstream servers. For example:

```yaml
action:
  proxy:
    upstream: webapp
    requestHeaders:
      set:
      - name: user
        value: ${jwt_claim_user}
      - name: alg
        value: ${jwt_header_alg}
```

This example uses the `requestHeaders` of [Action.Proxy]({{< ref "/nic/lts/configuration/virtualserver-and-virtualserverroute-resources.md#actionproxy" >}}) to set the values of two headers that NGINX passes to the upstream servers.

The value of the `${jwt_claim_user}` variable is the `user` claim of a JWT. For other claims, use `${jwt_claim_name}`, where `name` is the name of the claim. Nested claims and claims that include a period (`.`) aren't supported. Similarly, use `${jwt_header_name}`, where `name` is the name of a header. This example uses the `alg` header.

{{< call-out "note" >}}

This feature uses the NGINX Plus [ngx_http_auth_jwt_module](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html).

{{< /call-out >}}

{{% table %}}

|Field | Description | Type | Required |
| ---| ---| ---| --- |
|``secret`` | The name of the Kubernetes secret that stores the JWK. It must be in the same namespace as the Policy resource. The secret must be of the type ``nginx.org/jwk``, and the JWK must be stored in the secret under the key ``jwk``. Otherwise, NGINX Ingress Controller LTS rejects the secret as invalid. | ``string`` | Yes |
|``realm`` | The realm of the JWT. | ``string`` | Yes |
|``token`` | The token specifies a variable that contains the JSON Web Token. By default the JWT is passed in the ``Authorization`` header as a Bearer Token. JWT may be also passed as a cookie or a part of a query string, for example: ``$cookie_auth_token``. Accepted variables are ``$http_``, ``$arg_``, ``$cookie_``. | ``string`` | No |

{{% /table %}}

### JWT merging behavior

A VirtualServer or VirtualServerRoute can reference multiple JWT policies, but NGINX Ingress Controller LTS applies only the first one. It ignores every subsequent reference. For example, this configuration references two policies:

```yaml
policies:
- name: jwt-policy-one
- name: jwt-policy-two
```

In this example, NGINX Ingress Controller LTS uses the configuration from the first policy reference, `jwt-policy-one`, and ignores `jwt-policy-two`.

## JWT using JWKS from a remote location

The JWT policy configures NGINX Plus to authenticate client requests using JSON Web Tokens. You can import the JWKS keys for a JWT policy from a URL, such as a remote server or an identity provider, so you don't have to copy and update them on the Ingress Controller pod.

The following example policy rejects all requests that don't include a valid JWT in the HTTP header fetched from the identity provider:

```yaml
jwt:
  realm: MyProductAPI
  token: $http_token
  jwksURI: <uri_to_remote_server_or_idp>
  keyCache: 1h
```

{{< call-out "note" >}}

This feature uses the NGINX Plus directive [auth_jwt_key_request](http://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_request), part of [ngx_http_auth_jwt_module](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html).

{{< /call-out >}}

{{% table %}}

|Field | Description | Type | Required | Default |
| ---| ---| ---| --- | --- |
|``jwksURI`` | The remote URI where NGINX Ingress Controller LTS sends the request to retrieve the JSON Web Key set.| ``string`` | Yes | -- |
|``keyCache`` | Turns on in-memory caching of JWKS (JSON Web Key Sets) obtained from the ``jwksURI`` and sets a valid time for expiration. | ``string`` | Yes | -- |
|``realm`` | The realm of the JWT. | ``string`` | Yes | -- |
|``token`` | The token specifies a variable that contains the JSON Web Token. By default the JWT is passed in the ``Authorization`` header as a Bearer Token. JWT may be also passed as a cookie or a part of a query string, for example: ``$cookie_auth_token``. Accepted variables are ``$http_``, ``$arg_``, ``$cookie_``. | ``string`` | No | -- |
|``sniEnabled`` | Turns on SNI (Server Name Indication) for the JWT policy. Use this when the remote server requires SNI to serve the correct certificate. | ``bool`` | No | `false` |
|``sniName`` | The SNI name to use when connecting to the remote server. If not set, NGINX Ingress Controller LTS uses the hostname from the ``jwksURI``. | ``string`` | No | -- |
|``sslVerify`` | Turns on verification of the JWKS server SSL certificate. | ``bool`` | No | `false` |
|``sslVerifyDepth`` | Sets the verification depth in the JWKS server certificates chain. | ``int`` | No | `1` |
|``trustedCertSecret`` | The name of the Kubernetes secret that stores the CA certificate for JWKS server verification. It must be in the same namespace as the Policy resource. The secret must be of the type ``nginx.org/ca``, and the certificate must be stored in the secret under the key ``ca.crt``. | ``string`` | No | -- |

{{% /table %}}

{{< call-out "note" >}}

NGINX Ingress Controller LTS turns on content caching by default for each JWT policy, with a default time of 12 hours. This improves resiliency by letting NGINX Ingress Controller LTS retrieve the JWKS (JSON Web Key Set) from the cache even after it expires.

{{< /call-out >}}

### JWT merging behavior

This behavior is similar to using a local Kubernetes secret. A VirtualServer or VirtualServerRoute can reference multiple JWT policies, but NGINX Ingress Controller LTS applies only the first one. It ignores every subsequent reference. For example, this configuration references two policies:

```yaml
policies:
- name: jwt-policy-one
- name: jwt-policy-two
```

In this example, NGINX Ingress Controller LTS uses the configuration from the first policy reference, `jwt-policy-one`, and ignores `jwt-policy-two`.

## IngressMTLS

The IngressMTLS policy configures client certificate verification.

For example, the following policy verifies a client certificate using the CA certificate specified in `ingress-mtls-secret`:

```yaml
ingressMTLS:
  clientCertSecret: ingress-mtls-secret
  verifyClient: "on"
  verifyDepth: 1
```

Below is an example of `ingress-mtls-secret` using the secret type `nginx.org/ca`:

```yaml
kind: Secret
metadata:
  name: ingress-mtls-secret
apiVersion: v1
type: nginx.org/ca
data:
  ca.crt: <base64encoded-certificate>
```

A VirtualServer that references an IngressMTLS policy must:

- Turn on [TLS termination]({{< ref "/nic/lts/configuration/virtualserver-and-virtualserverroute-resources.md#virtualservertls" >}}).
- Reference the policy in the VirtualServer [`spec`]({{< ref "/nic/lts/configuration/virtualserver-and-virtualserverroute-resources.md#virtualserver-specification" >}}). You can't reference an IngressMTLS policy in a [`route`]({{< ref "/nic/lts/configuration/virtualserver-and-virtualserverroute-resources.md#virtualserverroute" >}}) or in a VirtualServerRoute [`subroute`]({{< ref "/nic/lts/configuration/virtualserver-and-virtualserverroute-resources.md#virtualserverroutesubroute" >}}).

If a resource doesn't meet these conditions, NGINX sends the `500` status code to clients.

You can pass the client certificate details, including the certificate, to the upstream servers. For example:

```yaml
action:
  proxy:
    upstream: webapp
    requestHeaders:
      set:
      - name: client-cert-subj-dn
        value: ${ssl_client_s_dn} # subject DN
      - name: client-cert
        value: ${ssl_client_escaped_cert} # client certificate in the PEM format (urlencoded)
```

This example uses the `requestHeaders` of [Action.Proxy]({{< ref "/nic/lts/configuration/virtualserver-and-virtualserverroute-resources.md#actionproxy" >}}) to set the values of the two headers that NGINX passes to the upstream servers. See the [list of embedded variables](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#variables) that `ngx_http_ssl_module` supports, which you can use to pass the client certificate details.

{{< call-out "note" >}}

This feature uses the NGINX [ngx_http_ssl_module](https://nginx.org/en/docs/http/ngx_http_ssl_module.html).

{{< /call-out >}}

### Configure a certificate revocation list

The IngressMTLS policy supports configuring a certificate revocation list (CRL) for your policy, in one of two ways.

{{< call-out "note" >}}

You can use only one of these configuration options at a time.

{{< /call-out >}}

1. Add the `ca.crl` field to the `nginx.org/ca` secret type, which accepts a base64 encoded certificate revocation list.

   Example:

   ```yaml
   kind: Secret
   metadata:
     name: ingress-mtls-secret
   apiVersion: v1
   type: nginx.org/ca
   data:
     ca.crt: <base64encoded-certificate>
     ca.crl: <base64encoded-crl>
   ```

2. Add the `crlFileName` field to your IngressMTLS policy spec with the name of the CRL file.

   {{< call-out "note" >}}

   Use this configuration option only when your CRL is larger than 1 MiB. Otherwise, use the `nginx.org/ca` secret type to manage your CRL.

   {{< /call-out >}}

   Example:

   ```yaml
   apiVersion: k8s.nginx.org/v1
   kind: Policy
   metadata:
     name: ingress-mtls-policy
   spec:
   ingressMTLS:
       clientCertSecret: ingress-mtls-secret
       crlFileName: webapp.crl
       verifyClient: "on"
       verifyDepth: 1
   ```

{{< call-out "important" >}}

When you configure a CRL with the `ingressMTLS.crlFileName` field, keep this additional context in mind:

- NGINX Ingress Controller LTS expects the CRL, in this case `webapp.crl`, to be in `/etc/nginx/secrets`. Add a volume mount to the NGINX Ingress Controller LTS deployment to add your CRL to `/etc/nginx/secrets`.
- When you update the content of your CRL, for example after you revoke a new certificate, NGINX needs to reload to pick up the latest changes. Depending on your environment, this may require you to update the name of your CRL and apply this update to your `ingress-mtls.yaml` policy so NGINX picks up the latest CRL.

See the Kubernetes documentation on [volumes](https://kubernetes.io/docs/concepts/storage/volumes/) to find the best implementation for your environment.

{{< /call-out >}}

{{% table %}}

|Field | Description | Type | Required |
| ---| ---| ---| --- |
|``clientCertSecret`` | The name of the Kubernetes secret that stores the CA certificate. It must be in the same namespace as the Policy resource. The secret must be of the type ``nginx.org/ca``, and the certificate must be stored in the secret under the key ``ca.crt``. Otherwise, NGINX Ingress Controller LTS rejects the secret as invalid. | ``string`` | Yes |
|``verifyClient`` | Verification for the client. Possible values are ``"on"``, ``"off"``, ``"optional"``, ``"optional_no_ca"``. The default is ``"on"``. | ``string`` | No |
|``verifyDepth`` | Sets the verification depth in the client certificates chain. The default is ``1``. | ``int`` | No |
|``crlFileName`` | The file name of the Certificate Revocation List. NGINX Ingress Controller LTS looks for this file in `/etc/nginx/secrets`. | ``string`` | No |

{{% /table %}}

### IngressMTLS merging behavior

A VirtualServer can reference only a single IngressMTLS policy, and NGINX Ingress Controller LTS ignores every subsequent reference. For example, this configuration references two policies:

```yaml
policies:
- name: ingress-mtls-policy-one
- name: ingress-mtls-policy-two
```

In this example, NGINX Ingress Controller LTS uses the configuration from the first policy reference, `ingress-mtls-policy-one`, and ignores `ingress-mtls-policy-two`.

## EgressMTLS

The EgressMTLS policy configures upstream authentication and certificate verification.

For example, the following policy uses `egress-mtls-secret` to authenticate with the upstream application and `egress-trusted-ca-secret` to verify the certificate of the application:

```yaml
egressMTLS:
  tlsSecret: egress-mtls-secret
  trustedCertSecret: egress-trusted-ca-secret
  verifyServer: on
  verifyDepth: 2
```

{{< call-out "note" >}}

This feature uses the NGINX [ngx_http_proxy_module](https://nginx.org/en/docs/http/ngx_http_proxy_module.html).

{{< /call-out >}}

{{% table %}}

|Field | Description | Type | Required |
| ---| ---| ---| --- |
|``tlsSecret`` | The name of the Kubernetes secret that stores the TLS certificate and key. It must be in the same namespace as the Policy resource. The secret must be of the type ``kubernetes.io/tls``, the certificate must be stored in the secret under the key ``tls.crt``, and the key must be stored under the key ``tls.key``. Otherwise, NGINX Ingress Controller LTS rejects the secret as invalid. | ``string`` | No |
|``trustedCertSecret`` | The name of the Kubernetes secret that stores the CA certificate. It must be in the same namespace as the Policy resource. The secret must be of the type ``nginx.org/ca``, and the certificate must be stored in the secret under the key ``ca.crt``. Otherwise, NGINX Ingress Controller LTS rejects the secret as invalid. | ``string`` | No |
|``verifyServer`` | Turns on verification of the upstream HTTPS server certificate. | ``bool`` | No |
|``verifyDepth`` | Sets the verification depth in the proxied HTTPS server certificates chain. The default is ``1``. | ``int`` | No |
|``sessionReuse`` | Turns on reuse of SSL sessions to the upstreams. The default is ``true``. | ``bool`` | No |
|``serverName`` | Turns on passing of the server name through the ``Server Name Indication`` extension. | ``bool`` | No |
|``sslName`` | Lets you override the server name used to verify the certificate of the upstream HTTPS server. | ``string`` | No |
|``ciphers`` | Specifies the enabled ciphers for requests to an upstream HTTPS server. The default is ``DEFAULT``. | ``string`` | No |
|``protocols`` | Specifies the protocols for requests to an upstream HTTPS server. The default is ``TLSv1 TLSv1.1 TLSv1.2``. | ``string`` | No | > Note: NGINX Ingress Controller LTS doesn't validate the value of ``ciphers`` and ``protocols``. As a result, NGINX can fail to reload the configuration. To make sure the configuration for a VirtualServer or VirtualServerRoute that references the policy applied successfully, check its [status]({{< ref "/nic/lts/configuration/global-configuration/reporting-resources-status.md#virtualserver-and-virtualserverroute-resources" >}}). Validation for these fields is planned for a future release. |

{{% /table %}}

### EgressMTLS merging behavior

A VirtualServer or VirtualServerRoute can reference multiple EgressMTLS policies, but NGINX Ingress Controller LTS applies only the first one. It ignores every subsequent reference. For example, this configuration references two policies:

```yaml
policies:
- name: egress-mtls-policy-one
- name: egress-mtls-policy-two
```

In this example, NGINX Ingress Controller LTS uses the configuration from the first policy reference, `egress-mtls-policy-one`, and ignores `egress-mtls-policy-two`.

## OIDC

{{< call-out "tip" >}}

This feature is turned off by default. To turn it on, set the [enable-oidc]({{< ref "/nic/lts/configuration/global-configuration/command-line-arguments.md#cmdoption-enable-oidc" >}}) command-line argument of NGINX Ingress Controller LTS.

{{< /call-out >}}

The OIDC policy configures NGINX Plus as a relying party for OpenID Connect authentication.

For example, the following policy uses the client ID `nginx-plus` and the client secret `oidc-secret` to authenticate with the OpenID Connect provider `https://idp.example.com`:

```yaml
spec:
  oidc:
    clientID: nginx-plus
    clientSecret: oidc-secret
    authEndpoint: https://idp.example.com/openid-connect/auth
    tokenEndpoint: https://idp.example.com/openid-connect/token
    jwksURI: https://idp.example.com/openid-connect/certs
    endSessionEndpoint: https://idp.example.com/openid-connect/logout
    postLogoutRedirectURI: /
    accessTokenEnable: true
    pkceEnable: false
```

NGINX Plus passes the ID of an authenticated user to the backend in the HTTP header `username`.

{{< call-out "note" >}}

This feature uses the [reference implementation](https://github.com/nginxinc/nginx-openid-connect/) of NGINX Plus as a relying party for OpenID Connect authentication.

{{< /call-out >}}

### Prerequisites

To use OIDC, turn on [zone synchronization]({{< ref "/nginx/admin-guide/high-availability/zone_sync.md" >}}). If you don't set up zone synchronization, NGINX Plus fails to reload.

You also need to configure a resolver, which NGINX Plus uses to resolve the IDP authorization endpoint. You can find an example configuration [in the GitHub repository](https://github.com/nginx/kubernetes-ingress/blob/v{{< nic-lts-version >}}/examples/custom-resources/oidc#step-7---configure-nginx-plus-zone-synchronization-and-resolver).

{{< call-out "warning" >}}

The configuration in the example doesn't turn on TLS, so synchronization between replicas happens in clear text. This can expose tokens.

{{< /call-out >}}

### Limitations

The OIDC policy defines a few internal locations that you can't customize: `/_jwks_uri`, `/_token`, `/_refresh`, `/_id_token_validation`, `/logout`. In addition, `/_codexch` is the default value for the redirect URI, and `/_logout` is the default value for the post logout redirect URI. You can customize both. Specifying one of these locations as a route in the VirtualServer or VirtualServerRoute causes a collision, and NGINX Plus fails to reload.

{{% table %}}

|Field | Description | Type | Required |
| ---| ---| ---| --- |
|``clientID`` | The client ID provided by your OpenID Connect provider. | ``string`` | Yes |
|``clientSecret`` | The name of the Kubernetes secret that stores the client secret provided by your OpenID Connect provider. It must be in the same namespace as the Policy resource. The secret must be of the type ``nginx.org/oidc``, and the secret stored under the key ``client-secret``. Otherwise, NGINX Ingress Controller LTS rejects the secret as invalid. If you enable PKCE, don't configure this field. | ``string`` | Yes |
|``authEndpoint`` | URL for the authorization endpoint provided by your OpenID Connect provider. | ``string`` | Yes |
|``authExtraArgs`` | A list of extra URL arguments to pass to the authorization endpoint provided by your OpenID Connect provider. Arguments must be URL encoded, multiple arguments may be included in the list, for example ``[ arg1=value1, arg2=value2 ]`` | ``string[]`` | No |
|``tokenEndpoint`` | URL for the token endpoint provided by your OpenID Connect provider. | ``string`` | Yes |
|``endSessionEndpoint`` | URL provided by your OpenID Connect provider to request the end user be logged out. | ``string`` | No |
|``jwksURI`` | URL for the JSON Web Key Set (JWK) document provided by your OpenID Connect provider. | ``string`` | Yes |
|``scope`` | List of OpenID Connect scopes. The scope ``openid`` always needs to be present and others can be added concatenating them with a ``+`` sign, for example ``openid+profile+email``, ``openid+email+userDefinedScope``. The default is ``openid``. | ``string`` | No |
|``redirectURI`` | Lets you override the default redirect URI. The default is ``/_codexch``. | ``string`` | No |
|``postLogoutRedirectURI`` | URI to redirect to after the logout has been performed. Requires ``endSessionEndpoint``. The default is ``/_logout``. | ``string`` | No |
|``zoneSyncLeeway`` | Specifies the maximum timeout in milliseconds for synchronizing ID/access tokens and shared values between Ingress Controller pods. The default is ``200``. | ``int`` | No |
|``accessTokenEnable`` | Option of whether Bearer token is used to authorize NGINX to access protected backend. | ``boolean`` | No |
|``pkceEnable`` | Turns on Proof Key for Code Exchange. The OpenID client needs to be in public mode. `clientSecret` is not used in this mode. | ``boolean`` | No |
|``sslVerify`` | Use this option to turn on TLS verification when calls are made to the IDP endpoints. | ``boolean`` | No |
|``verifyDepth`` | Sets the verification depth in the proxied HTTPS server certificates chain. The default is ``1``. | ``int`` | No |
|``trustedCertSecret`` | The name of the Kubernetes secret that stores the CA certificate. It must be in the same namespace as the Policy resource. The secret must be of the type ``nginx.org/ca``, and the certificate must be stored in the secret under the key ``ca.crt``. Otherwise, NGINX Ingress Controller LTS rejects the secret as invalid. | ``string`` | No |

{{% /table %}}

{{< call-out "note" >}}

Only one OIDC policy can be referenced in a VirtualServer and its VirtualServerRoutes. However, you can still apply the same policy to different routes in the VirtualServer and VirtualServerRoutes.

{{< /call-out >}}

### OIDC merging behavior

A VirtualServer or VirtualServerRoute can reference only a single OIDC policy, and NGINX Ingress Controller LTS ignores every subsequent reference. For example, this configuration references two policies:

```yaml
policies:
- name: oidc-policy-one
- name: oidc-policy-two
```

In this example, NGINX Ingress Controller LTS uses the configuration from the first policy reference, `oidc-policy-one`, and ignores `oidc-policy-two`.

## Cache

The cache policy configures proxy caching, which improves performance by storing and serving cached responses to clients instead of proxying every request to upstream servers.

For example, the following policy creates a cache zone named "mycache" with 10 MB of memory allocated, and caches all GET response codes for 30 seconds:

```yaml
cache:
  cacheZoneName: "mycache"
  cacheZoneSize: "10m"
  allowedCodes: ["any"]
  allowedMethods: ["GET"]
  time: "30s"
```

Here's an example with more specific configuration:

```yaml
cache:
  cacheZoneName: "mycache"
  cacheZoneSize: "100m"
  allowedCodes: [200, 301, 302]
  allowedMethods: ["GET", "POST"]
  time: "5m"
  levels: "1:2"
  overrideUpstreamCache: true
  inactive: "60m"
  useTempPath: false
  maxSize: "10g"
  minFree: "1g"
  manager:
    files: 100
    sleep: "50ms"
    threshold: "200ms"
  cacheKey: "$scheme$host$request_uri"
  cacheUseStale: [ "error", "timeout", "updating", "http_500" ]
  cacheRevalidate: true
  cacheBackgroundUpdate: true
  cacheMinUses: 1
  lock:
    enable: true
    timeout: "5s"
    age: "30s"
  conditions:
    noCache: [ "$cookie_nocache", "$arg_nocache" ]
    bypass: [ "$http_authorization" ]
```

{{< call-out "note" >}}

This feature uses the NGINX [ngx_http_proxy_module](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) `proxy_cache_path` and related directives.

{{< /call-out >}}

{{% table %}}

|Field | Description | Type | Required |
| --- | ---| ---| --- |
|``cacheZoneName`` | CacheZoneName defines the name of the cache zone. Must start with a lowercase letter,followed by alphanumeric characters or underscores, and end with an alphanumeric character. Single lowercase letters are also allowed. Examples: "cache", "my_cache", "cache1". | ``string`` | Yes |
|``cacheZoneSize`` | CacheZoneSize defines the size of the cache zone. Must be a number followed by a size unit: 'k' for kilobytes, 'm' for megabytes, or 'g' for gigabytes. Examples: "10m", "1g", "512k". | ``string`` | Yes |
|``allowedCodes`` | AllowedCodes defines which HTTP response codes should be cached. Accepts either: - The string "any" to cache all response codes (must be the only element) - A list of HTTP status codes as integers (100-599) Examples: ["any"], [200, 301, 404], [200]. Invalid: ["any", 200] (cannot mix "any" with specific codes). | ``[]IntOrString`` | No |
|``time`` | The default cache time for responses. Required when allowedCodes is specified. Must be a number followed by a time unit: 's' for seconds, 'm' for minutes, 'h' for hours, 'd' for days. Examples: "30s", "5m", "1h", "2d". | ``string`` | No |
|``allowedMethods`` | AllowedMethods defines which HTTP methods should be cached. Only "GET", "HEAD", and "POST" are supported by the NGINX `proxy_cache_methods` directive. GET and HEAD are always cached by default even if not specified. Maximum of 3 items allowed. Examples: ["GET"], ["GET", "HEAD", "POST"]. Invalid methods: PUT, DELETE, PATCH, and so on.  | ``[]string`` | No |
|``levels`` | Levels defines the cache directory hierarchy levels for storing cached files. Must be in format "X:Y" or "X:Y:Z" where X, Y, Z are either 1 or 2. This controls the number of subdirectory levels and their name lengths. Examples: "1:2", "2:2", "1:2:2". Invalid: "3:1", "1:3", "1:2:3". | ``string`` | No |
|``overrideUpstreamCache`` | OverrideUpstreamCache controls whether to override upstream cache headers (using the `proxy_ignore_headers` directive). When true, NGINX ignores cache-related headers from upstream servers like Cache-Control, Expires, and so on. Default: false. | ``bool`` | No |
|``cachePurgeAllow`` | CachePurgeAllow defines IP addresses or CIDR blocks allowed to purge cache. Examples: ["192.168.1.100", "10.0.0.0/8", "::1"]. | ``[]string`` | No |
|``cacheKey`` | CacheKey defines a key for caching (`proxy_cache_key`). By default, "$scheme$proxy_host$uri". Must not contain command execution patterns: $(, `, ;, &&, || | ``string`` | No |
|``cacheUseStale`` | CacheUseStale determines in which cases a stale cached response can be used (`proxy_cache_use_stale`). Valid parameters: error, timeout, invalid_header, updating, http_500, http_502, http_503, http_504, http_403, http_404, http_429, off. | ``[]string`` | No |
|``cacheRevalidate`` | CacheRevalidate turns on revalidation of expired cache items using conditional requests (`proxy_cache_revalidate`). Uses "If-Modified-Since" and "If-None-Match" header fields. | ``bool`` | No |
|``cacheBackgroundUpdate`` | CacheBackgroundUpdate lets NGINX start a background subrequest to update an expired cache item (`proxy_cache_background_update`). NGINX returns a stale cached response to the client while it updates the cache. | ``bool`` | No |
|``cacheMinUses`` | CacheMinUses sets the number of requests after which NGINX Ingress Controller LTS caches the response (`proxy_cache_min_uses`). | ``integer`` | No |
|``inactive`` | Inactive sets the time after which cached data that are not accessed get removed from the cache (inactive parameter). By default, inactive is set to 10 minutes. | ``string`` | No |
|``maxSize`` | MaxSize sets the maximum cache size (max_size parameter). When the size is exceeded, the cache manager removes the least recently used data. | ``string`` | No |
|``minFree`` | MinFree sets the minimum amount of free space required on the file system with cache (min_free parameter). When there is not enough free space, the cache manager removes the least recently used data. | ``string`` | No |
|``useTempPath`` | UseTempPath controls whether temporary files and the cache are put on different file systems (use_temp_path parameter). If set to false, NGINX puts temporary files directly in the cache directory (use_temp_path=off). Default: false (use_temp_path=off, which puts temp files directly in the cache directory for better performance). | ``bool`` | No |
|``manager`` | Manager configures the cache manager process parameters (manager_files, manager_sleep, manager_threshold). | ``object`` | No |
|``manager.files`` | Files sets the maximum number of files that the cache manager deletes in one iteration. During one iteration, the cache manager deletes no more than manager_files items (by default, 100). | ``integer`` | No |
|``manager.sleep`` | Sleep sets the pause between cache manager iterations. Between iterations, a pause configured by manager_sleep (by default, 50 milliseconds) is made. | ``string`` | No |
|``manager.threshold`` | Threshold sets the maximum duration of one cache manager iteration. The duration of one iteration is limited by manager_threshold (by default, 200 milliseconds). | ``string`` | No |
|``lock`` | Lock configures cache locking to prevent multiple identical requests from populating the same cache element simultaneously. | ``object`` | No |
|``lock.enable`` | Enable sets whether cache locking is turned on (`proxy_cache_lock`). When on, only one request at a time can populate a new cache element according to the `proxy_cache_key`. | ``bool`` | No |
|``lock.timeout`` | Timeout sets a timeout for `proxy_cache_lock`. When the time expires, NGINX passes the request to the proxied server, but it doesn't cache the response. | ``string`` | No |
|``lock.age`` | Age sets the maximum time a cache lock can be held (`proxy_cache_lock_age`). If the last request passed to the proxied server for populating a new cache element hasn't completed within the specified time, NGINX may pass one more request. | ``string`` | No |
|``conditions`` | Conditions defines when responses should not be cached or taken from cache. | ``object`` | No |
|``conditions.noCache`` | NoCache defines conditions under which the response won't be saved to a cache (`proxy_no_cache`). If at least one value of the string parameters isn't empty and isn't equal to "0", NGINX doesn't save the response. | ``[]string`` | No |
|``conditions.bypass`` | Bypass defines conditions under which the response won't be taken from a cache (`proxy_cache_bypass`). If at least one value of the string parameters isn't empty and isn't equal to "0", NGINX doesn't take the response from the cache. | ``[]string`` | No |

{{% /table %}}

### Cache merging behavior

A VirtualServer or VirtualServerRoute can reference multiple cache policies, but NGINX Ingress Controller LTS applies only the first one. It ignores every subsequent reference.

## CORS

The CORS policy configures Cross-Origin Resource Sharing (CORS) headers.

{{< call-out "note" >}}This feature uses the NGINX `add_header` directive.{{< /call-out >}}

Below is an example of a CORS policy configuring all the available options:

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: cors-policy
spec:
  cors:
    allowOrigin:
      - "https://test.example.com"
      - "https://app.example.com"
      - "https://admin.example.com"

    allowMethods:
      - "GET"
      - "POST"
      - "PUT"

    allowHeaders:
      - "Content-Type"
      - "Authorization"
      - "X-Requested-With"
      - "X-API-Key"

    allowCredentials: true

    exposeHeaders:
      - "X-Total-Count"
      - "X-Page-Size"
      - "X-RateLimit-Remaining"
      - "X-RateLimit-Reset"

    maxAge: 3600 
    
```

{{% table %}}

|Field | Description | Type | Required |
| --- | ---| ---| --- |
|``allowOrigin`` | AllowOrigin defines the origins that are allowed to make cross-origin requests. Can be exact domains, single wildcards, or `*` for all origins. Examples: ["https://example.com", "https://*.mydomain.com", "*"] Security: When allowCredentials is true, wildcard "*" is not allowed. The server must specify explicit origins for credentialed requests. |``array[string]`` | Yes |
|``allowMethods`` | AllowMethods defines the HTTP methods that are allowed for cross-origin requests. | ``array[string]`` | No |
|``allowHeaders`` | AllowHeaders defines the headers that are allowed in cross-origin requests. Common safe headers: ["Accept", "Accept-Language", "Content-Language", "Content-Type"] Custom headers: ["Authorization", "X-Requested-With", "X-Custom-Header"] |  ``array[string]`` | No |
|``allowCredentials`` | AllowCredentials indicates whether the response to the request can be exposed when the credentials flag is true. When used as part of a response to a preflight request, this indicates whether the actual request can be made using credentials. | ``boolean`` | No |
|``exposeHeaders`` |  ExposeHeaders defines the headers that browsers are allowed to access. Use this field to expose additional custom headers to the browser. Example: ["X-Total-Count", "X-Page-Size", "X-RateLimit-Remaining"] Note: Set-Cookie headers cannot be exposed through CORS per official MDN specification. | ``array[string]`` | No |
|``maxAge`` |  MaxAge defines how long (in seconds) the results of a preflight request can be cached. Default: 86400 (24 hours). | ``integer`` | No |

{{% /table %}}

{{< call-out "note" >}}
If CORS is currently configured in deployments using `snippets` or `responseHeaders.add`, migrate those settings to the CORS policy and remove the duplicate configuration.
{{< /call-out >}}

### CORS merging behavior

A VirtualServer or VirtualServerRoute can reference multiple CORS policies, but NGINX Ingress Controller LTS applies only the first one. It ignores every subsequent reference.

## What's next

Learn how to [manage Policy resources with kubectl]({{< ref "/nic/lts/configuration/policy-resource/using-policy.md" >}}).
