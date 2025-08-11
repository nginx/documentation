---
description: Learn how to set up an F5 NGINX Management Suite API Connectivity Manager
  OAuth2 Introspection policy with Keycloak as the authorization server.
nd-docs: DOCS-954
title: OAuth2 Introspection with Keycloak
toc: true
weight: 400
type:
- tutorial
---

## Overview

This tutorial walks through configuring an OAuth2 Introspection policy on an API Proxy in API Connectivity Manager with Keycloak as the authorization server.

{{< call-out "important" >}}The configuration presented in this guide is for demonstration purposes only. The secure configuration of Environments and Proxies in API Connectivity Manager, or the secure configuration of Keycloak as the authorization server, is not in scope for this tutorial and should be given full attention when planning for production use.{{< /call-out >}}

{{< call-out "note" >}}See the [OAuth2 Introspection Policy]({{< ref "/nms/acm/how-to/policies/introspection.md" >}}) reference guide for a detailed overview of the policy.{{< /call-out>}}

---

## What is OAuth2?

{{< include "acm/tutorials/what-is-OAuth2.md" >}}

---

## Before You Begin

To complete the instructions in this guide, you need the following:

- Access to a virtual environment
- Four virtual hosts with Linux installed - this guide uses [Ubuntu 20.04 LTS](https://releases.ubuntu.com/focal/).

   <details close>
   <summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

   {{< include "nim/tech-specs/supported-distros.md" >}}

   </details>

---

## Host Setup

This section configures the hosts used in this tutorial. In the following table, you'll find the details of the test environment used in this tutorial's examples. The options presented are the minimum host requirements for running a fully functional test environment. Remember that production environments may need more resources and incur greater costs.

{{<bootstrap-table "table table-striped table-bordered">}}

| Hosts                        | Virtual Cores | Memory | Storage | IP Address    | Hostname    |
|------------------------------|---------------|--------|---------|---------------|-------------|
| F5 NGINX Management Suite Host  | 2 vCPUs       | 4GB    | 100GB   | `192.0.2.2` | `acm-ctrl`  |
| Data Plane Host              | 1 vCPU        | 1GB    | 10GB    | `192.0.2.3` | `data-host` |
| Echo Server                  | 1 vCPU        | 1GB    | 10GB    | `192.0.2.4` | `echo-host` |
| Authorization Server         | 1 vCPU        | 1GB    | 10GB    | `192.0.2.5` | `auth-host` |

{{</bootstrap-table>}}

### Install NGINX Management Suite & API Connectivity Manager {#install-nsm-acm}

1. Follow the steps in the [Installation Guide]({{< ref "/nim/deploy/_index.md" >}}) to set up NGINX Management Suite and API Connectivity Manager. You do not need to configure a Developer Portal for this tutorial.

### Install NGINX Agent on Data Plane Host {#install-agent}

1. Run the following commands to install the NGINX Agent on the data plane host, create a new Instance Group called `test-ig`, and add the host to it:

   ``` shell
   curl --insecure https://192.0.2.2/install/nginx-agent > install.sh \
   && sudo sh install.sh -g test-ig \
   && sudo systemctl start nginx-agent
   ```

### Install Echo Server {#install-echo-server}

1. [Download and install the latest version of Go](https://go.dev/doc/install) by following the instructions on the official Go website.
2. Run the following commands to install and start [Echo Server](https://github.com/jmalloc/echo-server):

   ```shell
   go env -w GO111MODULE=off
   go get -u github.com/jmalloc/echo-server/...
   PORT=10000 LOG_HTTP_BODY=true LOG_HTTP_HEADERS=true echo-server
   ```

### Install Authorization Server {#install-auth-server}

This tutorial uses Keycloak in **Development mode**. Development mode is suitable for people trying out Keycloak for the first time who want to get it up and running quickly.

Development mode sets the following default configuration:

- HTTP is enabled
- Strict hostname resolution is disabled
- The cache is set to local (no distributed cache mechanism is used for high availability)
- Theme-caching and template-caching are disabled.

<details>
<summary><i class="fa-solid fa-circle-info"></i> (Optional) Production mode default configuration</summary>

For all conventional and production use cases, we recommend starting Keycloak in **Production mode**, which follows a "secure by default" principle.

Production mode sets the following default configuration:

- HTTP is disabled as transport layer security (HTTPS) is essential
- Hostname configuration is expected
- HTTPS/TLS configuration is expected

</details>

<br>

1. To install the Keycloak prerequisites run the following commands:

   ```shell
   sudo apt-get update
   sudo apt-get -y install openjdk-11-jre
   ```

2. Download and extract the Keycloak tarball:

   ```shell
   KEYCLOAK_VERSION=19.0.3

   curl -L -o keycloak-${KEYCLOAK_VERSION}.tar.gz \
   https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.tar.gz
   tar -zxf keycloak-${KEYCLOAK_VERSION}.tar.gz
   rm -rf keycloak-${KEYCLOAK_VERSION}.tar.gz
   ```

3. Create environment variables for the Keycloak admin username and password:

   {{< call-out "important" >}} Do not use the example `admin/password` combination in any scenario. Replace the username and password with strong alternatives. {{< /call-out >}}

   ```shell
    export KEYCLOAK_ADMIN=<admin user>
    export KEYCLOAK_ADMIN_PASSWORD=<password>
   ```

4. Start Keycloak in **Development Mode**:

   ```shell
   cd keycloak-${KEYCLOAK_VERSION}/
   bin/kc.sh start-dev
   ```

---

## Configure Keycloak {#configure-keycloak}

In this section, we'll configure Keycloak as our OAuth2 authorization server.

### Accessing the Keycloak UI

Using the Keycloak admin credentials that you configured in the preceding [Install Authorization Server](#install-auth-server) section, you can access and log in to Keycloak web interface by going to:

- `http://192.0.2.5:8080/admin`

### Configure a Realm {#configure-realm}

A _Realm_ manages a set of users, credentials, roles, and groups. A user belongs to and logs in to a Realm. Realms are isolated from one another and can manage and authenticate only the users they control.

1. To create a Realm, select **Master** in the left navigation bar, then select **Add realm** from the list.
2. Enter the Realm details. For the purposes of this demonstration, our Realm will be called `nginx`.
3. Select **Create** to create the Realm.
4. The **Realm** list in the left navigation bar should now be set to `nginx`.

### Configure a User {#configure-user}

_Users_ are entities that can log in to your system. User attributes include an email, username, address, phone number, and birthday. Users can be assigned a group membership and have specific roles assigned to them.

1. To create a user, select **Users**, then select **Create new User**.
2. Enter the user's details. For the purposes of this demonstration, just the required field **Username** is set as `nginx-user`.
3. Select **Create** to create the user.
4. To set the user's password, select the **Credentials** tab.
5. Select **Set Password**. Enter the desired password in the **Password** and **Password Confirmation** boxes. Set **Temporary** to **OFF**.
6. Select **Save**.
7. Select **Save Password** to confirm the password change.

### Configure a Client {#configure-client}

Clients are entities that can ask Keycloak to authenticate a user. Most often, clients are applications and services that use Keycloak to secure themselves and provide a single sign-on solution. Clients can also be entities that request identity information or an access token to invoke other services on the network that are secured by Keycloak.

To configure a client, take the following steps:

1. Select **Clients**. You will see a list of pre-created Keycloak clients. To create a new one, select **Create Client**.
2. Enter the details for the client. For the purposes of this demonstration, type `nginx-plus` for the **Client ID**. Leave **Client Type** as the default value **OpenID Connect**.
3. Select **Next** to continue.
4. In the **Capability Config** section of the client configuration, set **Client Authentication** as **On**.
5. Select **Save** to create the client.
6. Select the **Credentials** tab. In the **Client Authenticator** list, choose **Client ID and Secret**.
7. Copy the **Client Secret**. You will need this secret for authenticating the `nginx-plus` client with Keycloak.

### Configure a Custom Role {#configure-custom-role}

_Roles_ identify a user type or category. Typical roles in an organization include admin, user, manager, and employee. Applications often assign access and permissions to specific roles rather than individual users, as dealing with users can be too fine-grained and challenging to manage.

To configure a custom role, take the following steps:

1. Select **Realm Roles**. You will see a list of pre-created Keycloak roles. To create a new role, select **Create Role**.
2. Type the **Role Name**. For the purposes of this demonstration, use `nginx-keycloak-role` for the role name.
3. Select **Save**.
4. Once a role has been created, you need to assign the role to users. Select **Users**, then select the `nginx-user` user you created in the preceding [Configure a User](#configure-user) steps.
5. Select the **Role Mapping** tab, then select **Assign Role**.
6. Select the checkbox beside the `nginx-keycloak-role` role, then select **Assign**.

---

## Test OAuth2 Token Introspection {#test-oauth2-token-introspection}

Follow the steps in this section to test the OAuth functionality of Keycloak, token issuing, and token introspection.

### Get the Keycloak Token Introspection Endpoints {#get-keycloak-introspection-endpoints}

An introspection endpoint is needed to configure the Introspection policy in API Connectivity Manager. Additionally, a token endpoint is required for users to authenticate and access tokens for introspection. You can retrieve these endpoints using a REST API call to Keycloak.

#### Structure

```bash
curl -L -X GET http://{HOST/IP_ADDRESS}:{PORT}/realms/{REALM}/.well-known/openid-configuration
```

#### Example

{{< call-out "note" >}} `jq` is used in the following examples to format the JSON response from Keycloak in a legible and attractive way. For more information about `jq`   , see the [jq GitHub page](https://github.com/stedolan/jq). {{< /call-out >}}

```bash
curl -L -X GET http://192.0.2.5:8080/realms/nginx/.well-known/openid-configuration | jq
```

JSON Response:

```json
{
   "issuer": "http://192.0.2.5:8080/realms/nginx",
   "authorization_endpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/auth",
   "token_endpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/token",
   "introspection_endpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/token/introspect",
   "userinfo_endpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/userinfo",
   "end_session_endpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/logout",
   "jwks_uri": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/certs",
   "check_session_iframe": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/login-status-iframe.html",
   "grant_types_supported": [
      "authorization_code",
      "implicit",
      "refresh_token",
      "password",
      "client_credentials",
      "urn:ietf:params:oauth:grant-type:device_code",
      "urn:openid:params:grant-type:ciba"
   ]
}
```

<br>

### Generate a User Access Token {#generate-user-access-token}

To generate an access token the below request structure is used:

#### Structure

```bash
curl -L -X POST 'http://{HOST/IP_ADDRESS}:{PORT}/realms/{REALM}/protocol/openid-connect/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'client_id=<REPLACE_WITH_CLIENT_ID>' \
  --data-urlencode 'grant_type=password' \
  --data-urlencode 'client_secret=<REPLACE_ME_WITH_CLIENT_SECRET>' \
  --data-urlencode 'scope=openid' \
  --data-urlencode 'username=<REPLACE_WITH_USERNAME>' \
  --data-urlencode 'password=<REPLACE_ME_WITH_PASSWORD>'
```

#### Example

```bash
curl -L -X POST 'http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'client_id=nginx-plus' \
  --data-urlencode 'grant_type=password' \
  --data-urlencode 'client_secret=<REPLACE_WITH_CLIENT_SECRET>' \
  --data-urlencode 'scope=openid' \
  --data-urlencode 'username=nginx-user' \
  --data-urlencode 'password=password' \
  | jq
```

JSON Response:

Keycloak will respond with a JSON object containing an `access_token` for the user `nginx-user`:

```json
{
"access_token": "<JWT_token>",
"expires_in": 300,
"refresh_expires_in": 1800,
"refresh_token": "<JWT_token>",
"token_type": "Bearer",
"id_token": "<JWT_token>",
"not-before-policy": 0,
"session_state": "9836f5fd-987f-4875-ac75-f7dd5325047c",
"scope": "openid profile email"
}
```

Typically, the `access_token` is passed in requests to a **Resource Server** (API Proxy) as a `Bearer` token in the `Authorization` header. This is the default OAuth2 Introspection policy behavior in API Connectivity Manager.

<br>

### Introspecting a User Access Token {#introspect-token-test}

You can mimic the process by which an NGINX client introspects an incoming user `access_token` with Keycloak.

{{< call-out "note" >}} Keycloak is configured to accept basic auth credentials from the `nginx-plus` client; in this case, the credentials are formatted as `CLIENT_ID:CLIENT_SECRET`. This combination must be [base64 url encoded](https://www.base64url.com/) before it is passed in the `Authorization` header. {{< /call-out >}}

#### Structure

```shell
curl -L -X POST 'http://{HOST/IP_ADDRESS}:{PORT}/realms/{REALM}/protocol/openid-connect/token/introspect' \
   -H "Authorization: Bearer <access token>" \
   -H "Accept: application/json" \
   -H "Content-Type: application/x-www-form-urlencoded" \
   --data-urlencode 'token=<ACCESS_TOKEN>' \
   | jq
```

#### Example

```shell
curl -L -X POST 'http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/token/introspect' \
   -H "Authorization: Bearer <access token>" \
   -H "Accept: application/json" \
   -H "Content-Type: application/x-www-form-urlencoded" \
   --data-urlencode 'token=<JWT_token>'
   | jq
```

JSON Response:

Keycloak responds with a token introspection JSON response with associated claims that NGINX can extract and forward to backend services.

```json
{
   "active": true,
    "exp": 1665585794,
   "iat": 1665585494,
   "jti": "c8723771-2474-4c94-b155-f78a4583419f",
   "iss": "http://192.0.2.5:8080/realms/nginx",
   "aud": "account",
   "sub": "a95117bf-1a2e-4d46-9c44-5fdee8dddd11",
   "typ": "Bearer",
   "azp": "nginx-plus",
   "session_state": "b7ca9271-02ce-453f-b491-61ec4e648d5d",
   "given_name": "",
   "family_name": "",
   "preferred_username": "nginx-user",
   "email_verified": false,
   "acr": "1",
   "scope": "openid profile email",
   "sid": "b7ca9271-02ce-453f-b491-61ec4e648d5d",
   "client_id": "nginx-plus",
   "username": "nginx-user",
   "realm_access": {
      "roles": [
         "default-roles-nginx",
         "offline_access",
         "nginx-keycloak-role",
         "uma_authorization"
      ]
   },
   "resource_access": {
      "account": {
         "roles": [
            "manage-account",
            "manage-account-links",
            "view-profile"
         ]
      }
   }
}
```

<br>

At this checkpoint in the tutorial, Keycloak is sufficiently configured for token introspection.

---

## Configure API Connectivity Manager {#amc-config}

In this section, we will use the API Connectivity Manager Rest API to set up a proxy in API Connectivity Manager. You'll need to pass the NGINX Management Suite user credentials in the Basic Authentication header for each REST request.

### Creating Workspaces & Environment {#create-workspace-environment}

1. To create an Infrastructure Workspace with a minimum configuration, send the following JSON request to the `/infrastructure/workspaces` endpoint:

   ```bash
   POST https://192.0.2.2/api/acm/v1/infrastructure/workspaces
   ```

   **JSON Request**

   ```json
   {
      "name": "infra-ws"
   }
   ```

1. To create an Environment with a minimum configuration, send the following JSON request to the `/infrastructure/workspaces/infra-ws/environments` endpoint. The `proxyClusterName`, `test-ig`, is the name of the Instance Group that the data plane host was added to when you [installed the NGINX Agent](#install-agent) above. The `hostnames` array should contain the hostname of the data plane host.

   ```bash
   POST https://192.0.2.2/api/acm/v1/infrastructure/workspaces/infra-ws/environments
   ```

   **JSON Request**

   ```json
   {
      "name": "demo-env",
      "proxies": [
         {
            "proxyClusterName": "test-ig",
            "hostnames": [
               "data-host"
            ]
         }
      ]
   }
   ```

3. To create a Service Workspace with a minimum configuration, send the following JSON request to the `/services/workspaces` endpoint.

   ```bash
   POST https://192.0.2.2/api/acm/v1/services/workspaces
   ```

   **JSON Request**

   ```json
   {
      "name": "service-ws"
   }
   ```

### Create a Basic API Proxy {#create-basic-api-proxy}

1. To create an API proxy with a minimum configuration and no non-default policies, send the following JSON request to the `/services/workspaces/service-ws/proxies` endpoint. The Proxy service target is our echo server.

   ```bash
   POST https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies
   ```

   **JSON Request**

   ```json
   {
      "name": "test-proxy",
      "version": "v1",
      "proxyConfig": {
         "hostname": "data-host",
         "ingress": {
            "basePath": "/",
            "basePathVersionAppendRule": "NONE"
         },
         "backends": [
            {
               "serviceName": "backend-echo-svc",
               "serviceTargets": [
                  {
                     "hostname": "192.0.2.4",
                     "listener": {
                        "enableTLS": false,
                        "port": 10000,
                        "transportProtocol": "HTTP"
                     }
                  }
               ]
            }
         ]
      }
   }
   ```

2. To test whether the API Proxy and backend echo server are working correctly, send a custom header and dummy JSON body to show these proxied values in the echo server response.

   ```bash
   POST https://192.0.2.4/my/test/api
   HEADERS:
      X-NGINX-Test: true
   ```

   **JSON Request**

   ```json
   {
      "testKey": "testValue"
   }
   ```

   **Expected Result**

   If everything is configured correctly in API Connectivity Manager and the echo server, the response should be similar to the following example:

   ```bash
   Request served by echo-host

   HTTP/1.0 POST /my/test/api

   Host: 192.0.2.4
   Accept: */*
   Cache-Control: no-cache
   Content-Length: 30
   Content-Type: application/json
   X-Correlation-Id: c241b72519e71cf7bce9262910ffbe40
   X-Real-Ip: 192.0.2.1
   X-NGINX-Test: true

   {"testKey": "testValue"}
   ```

### Upsert OAuth2 Introspection Policy

1. Upsert the API proxy with an OAuth2 Introspection policy. The default `action.introspectionResponse` type `application/json` is used, so you don't need to define it in the API request body.

   {{< call-out "note" >}} This shortened request body removes all the default API proxy policies. To maintain these default policies, perform a `GET` request on the proxy before the upsert and copy the policy configuration from the response. {{< /call-out >}}

   ```bash
   PUT https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies/test-proxy
   ```

   **JSON Request**

   ```json
   {
      "name": "test-proxy",
      "version": "v1",
      "proxyConfig": {
         "hostname": "data-host",
         "ingress": {
            "basePath": "/",
            "basePathVersionAppendRule": "NONE"
         },
         "backends": [
            {
               "serviceName": "backend-echo-svc",
               "serviceTargets": [
                  {
                     "hostname": "192.0.2.4",
                     "listener": {
                        "enableTLS": false,
                        "port": 10000,
                        "transportProtocol": "HTTP"
                     }
                  }
               ]
            }
         ],
         "policies": {
            "oauth2-introspection": [
               {
                  "action": {
                     "introspectionEndpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/token/introspect"
                  },
                  "data": [
                     {
                        "clientAppID": "nginx-plus",
                        "clientSecret": "<client secret>"
                     }
                  ]
               }
            ]
         }
      }
   }
   ```

### Testing the Introspection Policy {#test-introspection-policy}

1. Using the same echo server request from the previous section, test the echo server again:

    ```bash
    POST https://192.0.2.4/my/test/api
    ```

    If you've successfully configured and applied the OAuth2 Introspection policy, the request is blocked from reaching the backend, and `401 Unauthorized` is returned.

   JSON Response:

   ```json
   {
       "message": "Unauthorized",
       "status": "401"
   }
   ```

2. Using the Keycloak user you created in the [Configure a User](#configure-user) section above, obtain an access token from Keycloak. Follow the steps you completed in the [Generate a User Access Token](#generate-user-access-token) section.
3. Copy the `access_token` in the JSON response that's returned from Keycloak.
4. In the next request to the echo server, add a request header with the following details:

   - key: `Authorization`
   - value: `Bearer <ACCESS_TOKEN>`, where `<ACCESS_TOKEN>` is the token you copied in step 3.

      The `<ACCESS_TOKEN>` is prefixed with `Bearer` because it's passed as a [bearer token](https://www.rfc-editor.org/rfc/rfc6750) to the API proxy.

   If the OAuth2 Introspection policy has been configured and applied successfully, the request is blocked from reaching the backend, and `401 Unauthorized` is returned.

   ```bash
   POST https://192.0.2.4/my/test/api
   HEADERS:
     Authorization: 'Bearer <JWT_token>'
   ```

   The access token is taken from the `Authorization` header and introspected against the Keycloak introspection endpoint defined in the policy configuration. If the OAuth2 server responds with `"active": true` in the introspection response, the request proceeds to the backend. The response should look like the following example:

   ```bash
   Request served by echo-host

   HTTP/1.0 POST /my/test/api

   Host: default_http_a4334620-226b-491d-8503-e0724bdf5521
   Accept: */*
   Accept-Encoding: gzip, deflate, br
   Cache-Control: no-cache
   Connection: close
   Content-Length: 30
   Content-Type: application/json
   X-Correlation-Id: ffc5dc656e220a20fa57835e0653f19f
   X-Token-Exp: 1666003414
   X-Token-Scope: openid email profile
   X-Token-Username: nginx-user
   ```

There are a few things to note here:

- The default headers changed because we removed the default request headers policy when upserting the Introspection policy. This won't happen in environments where default policies are included in the upsert request, in which case, the default request headers are forwarded to the backend services.
- There are new headers proxied to the backend `X-Token-Exp`, `X-Token-Scope`, and `X-Token-Scope`. These are the default claims defined in the policy configuration value `action.forwardedClaimsInProxyHeader`, and values are taken from the Identify Provider (IdP) introspection response to the in-flight request.
- There is no `Authorization` header in the request forwarded to the backend. This is because NGINX strips the incoming user access token from the header or query parameters regardless of the key used.

If you pass an inactive or invalid token and perform the same request above, the request is blocked from reaching the backend, and `403 Forbidden` is returned.`

```json
{
    "message": "Forbidden",
    "status": "403"
}
```

You can check the logs on the data host to determine the cause of the `403 Forbidden` response. There may be several reasons for a forbidden response message; however, the user only sees `403 Forbidden` in all cases, except where no access token is provided. In that case, the response is `401 Not Authorized`.

```bash
cat /var/log/nginx/data-host-error.log
2022/10/17 10:23:11 [error] 35643#35643: *15 js: OAuth introspection access_token not provided.
2022/10/17 11:24:30 [error] 39542#39542: *49 js: OAuth token introspection found inactive token.
```

### Custom Token Placement & Key {#custom-token-placement-key}

You can configure the Introspection policy to let users pass their access token as a header or query parameter using any key name. By default, the access token is given in the `Authorization` header as a bearer token. The `Bearer` prefix is required when the access token is passed in the `Authorization` header. If the header is changed from this default `Authorization` value, passing a `Bearer` prefix will render the request invalid.

`action.clientTokenSuppliedIn` configures how the access token is passed in the user request; `action.clientTokenName`configures the key under which the access token is extracted from the user request.

1. Upsert the proxy with an updated Introspection policy configuration, where the access token is passed in the request headers as `apiAccessToken`. The default value for `action.clientTokenSuppliedIn` is `HEADER`, so you don't need to include it in the API request body.

   ```bash
   PUT https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies/test-proxy
   ```

   **JSON Request**

   ```json
   {
      "name": "test-proxy",
      "version": "v1",
      "proxyConfig": {
         "hostname": "data-host",
         "ingress": {
            "basePath": "/",
            "basePathVersionAppendRule": "NONE"
         },
         "backends": [
            {
               "serviceName": "backend-echo-svc",
               "serviceTargets": [
                  {
                     "hostname": "192.0.2.4",
                     "listener": {
                        "enableTLS": false,
                        "port": 10000,
                        "transportProtocol": "HTTP"
                     }
                  }
               ]
            }
         ],
         "policies": {
            "oauth2-introspection": [
               {
                  "action": {
                     "introspectionEndpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/token/introspect",
                           "clientTokenName": "apiAccessToken"
                  },
                  "data": [
                     {
                        "clientAppID": "nginx-plus",
                        "clientSecret": "<client secret>"
                     }
                  ]
               }
            ]
         }
      }
   }
   ```

2. In the next request to the echo server, change the request header so the access token is passed in `apiAccessToken`.

   ```bash
   POST https://192.0.2.4/my/test/api
   HEADERS:
     apiAccessToken: '<JWT_token>'
   ```

   The request should proceed to the backend service as expected, and the echo server should respond in turn.

3. Upsert the proxy with an updated Introspection policy configuration, where the access token is passed in the query arguments as `queryAuthz` with `action.clientTokenSuppliedIn` set to `QUERY`.

   ```bash
   PUT https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies/test-proxy
   ```

   ```json
   {
      "name": "test-proxy",
      "version": "v1",
      "proxyConfig": {
         "hostname": "data-host",
         "ingress": {
            "basePath": "/",
            "basePathVersionAppendRule": "NONE"
         },
         "backends": [
            {
               "serviceName": "backend-echo-svc",
               "serviceTargets": [
                  {
                     "hostname": "192.0.2.4",
                     "listener": {
                        "enableTLS": false,
                        "port": 10000,
                        "transportProtocol": "HTTP"
                     }
                  }
               ]
            }
         ],
         "policies": {
            "oauth2-introspection": [
               {
                  "action": {
                     "introspectionEndpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/token/introspect",
                           "clientTokenSuppliedIn": "QUERY",
                           "clientTokenName": "queryAuthz"
                  },
                  "data": [
                     {
                        "clientAppID": "nginx-plus",
                        "clientSecret": "<client secret>"
                     }
                  ]
               }
            ]
         }
      }
   }
   ```

4. In the next request to the echo server, remove the custom request header `apiAccessToken` and pass the access token in the query argument `queryAuthz`.

   ```bash
   POST https://192.0.2.4/my/test/api?queryAuthz=<JWT_token>
   ```

   The request should proceed to the backend service as expected, and the echo server should respond in turn. Similar to passing the access token as a header, the user's access token is stripped from the in-flight request before it's forwarded to the backend service.

### Token Caching {#token-caching}

OAuth2 token introspection is provided by the Identify Provider (IdP) at a JSON/REST endpoint, so the standard response is a JSON object with HTTP status 200. When this response is keyed against the access token, it becomes highly cacheable.

You can configure NGINX to cache a copy of the introspection response for each access token. Then, the next time the same access token is presented, NGINX serves the cached introspection response instead of making an API call to the IdP. Token caching vastly improves overall latency for subsequent requests. You can manage how long cached responses are used to mitigate the risk of accepting an expired or recently revoked access token. For example, suppose an API client typically makes a burst of several API calls over a short period. In that case, a cache validity of 10 seconds might be sufficient to provide a measurable improvement in user experience.

#### Security Considerations {#security-considerations}

{{< call-out "important" >}}There are some security considerations to keep in mind when enabling token caching. For example, a shorter cache expiration time is more secure since the resource servers must query the introspection endpoint more frequently; however, the increased number of queries may put a load on the endpoint. Longer expiration times, by comparison, open a window where a token may actually be expired or revoked but still be able to be used at a resource server for the remaining cache time.

You can mitigate these situations by never caching the value beyond the token's expiration time. For example, in Keycloak, the default token duration is **300 seconds**. This should be the upper limit of token caching in the Introspection policy configuration.{{< /call-out >}}

#### Token Caching Setup {#token-caching-setup}

You can configure token caching in the Introspection policy by setting the `action.cacheIntrospectionResponse` value. An NGINX unit-of-time measurement is expected in seconds, minutes, or hours. By default, token caching is enabled for a five-minute (`5m`) cache duration. Setting the value to `0s`, `0m`, or `0h` disables caching.

1. Upsert the proxy with an Introspection policy configuration to set a token cache duration of ten seconds (`10s`).

   ```bash
   PUT https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies/test-proxy
   ```

   ```json
   {
      "name": "test-proxy",
      "version": "v1",
      "proxyConfig": {
         "hostname": "data-host",
         "ingress": {
            "basePath": "/",
            "basePathVersionAppendRule": "NONE"
         },
         "backends": [
            {
               "serviceName": "backend-echo-svc",
               "serviceTargets": [
                  {
                     "hostname": "192.0.2.4",
                     "listener": {
                        "enableTLS": false,
                        "port": 10000,
                        "transportProtocol": "HTTP"
                     }
                  }
               ]
            }
         ],
         "policies": {
            "oauth2-introspection": [
               {
                  "action": {
                     "introspectionEndpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/token/introspect",
                           "cacheIntrospectionResponse": "10s"

                  },
                  "data": [
                     {
                        "clientAppID": "nginx-plus",
                        "clientSecret": "<client secret>"
                     }
                  ]
               }
            ]
         }
      }
   }
   ```

2. Send a request to the echo server API proxy with the provided access token. The introspection token response will be cached in the data host.

3. To verify whether token caching is successful, locate the token cache Realm on the data host. Realms follow the pattern `tokens_<SHORT_PROXY_UUID>_<LABEL>` and can be found in `/var/cache/nginx`.

   ```bash
   ls -l /var/cache/nginx/ | grep tokens_
   drwx------ 4 nginx nginx-agent 4096 Oct 18 10:24 tokens_07b28d26_default
   ```

4. To disable token caching, set `action.cacheIntrospectionResponse` to `0s`:

   ```bash
   PUT https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies/test-proxy
   ```

   ```json
   {
      "name": "test-proxy",
      "version": "v1",
      "proxyConfig": {
         "hostname": "data-host",
         "ingress": {
            "basePath": "/",
            "basePathVersionAppendRule": "NONE"
         },
         "backends": [
            {
               "serviceName": "backend-echo-svc",
               "serviceTargets": [
                  {
                     "hostname": "192.0.2.4",
                     "listener": {
                        "enableTLS": false,
                        "port": 10000,
                        "transportProtocol": "HTTP"
                     }
                  }
               ]
            }
         ],
         "policies": {
            "oauth2-introspection": [
               {
                  "action": {
                     "introspectionEndpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/token/introspect",
                           "cacheIntrospectionResponse": "0s"

                  },
                  "data": [
                     {
                        "clientAppID": "nginx-plus",
                        "clientSecret": "<client secret>"
                     }
                  ]
               }
            ]
         }
      }
   }
   ```

   All subsequent requests to this API proxy will not have introspection token responses cached.

### OAuth2 Server Hostname Resolution {#oauth2-server-hostname-resolution}

If hostname resolution is required for resolving the OAuth2 server hostname, you can configure multiple DNS resolvers for the Introspection policy using the `action.resolver` setting.

You can define multiple hostnames/IP addresses and port combinations, along with `valid` and `timeout` configurations. By default, NGINX caches answers using the TTL value of a response. The `valid` parameter allows overriding the TTL value. The `timeout` parameter sets a timeout for name resolution.

1. Upsert the proxy with an updated Introspection policy configuration for `action.introspectionEndpoint` that includes a hostname NGINX must resolve:

   ```bash
   PUT https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies/test-proxy
   ```

   ```json
   {
      "name": "test-proxy",
      "version": "v1",
      "proxyConfig": {
         "hostname": "data-host",
         "ingress": {
            "basePath": "/",
            "basePathVersionAppendRule": "NONE"
         },
         "backends": [
            {
               "serviceName": "backend-echo-svc",
               "serviceTargets": [
                  {
                     "hostname": "192.0.2.4",
                     "listener": {
                        "enableTLS": false,
                        "port": 10000,
                        "transportProtocol": "HTTP"
                     }
                  }
               ]
            }
         ],
         "policies": {
            "oauth2-introspection": [
               {
                  "action": {
                     "introspectionEndpoint": "https://hosted.idp.com:8080/realms/nginx/protocol/openid-connect/token/introspect",
                     "introspectionResponse": "application/json"

                  },
                  "data": [
                     {
                        "clientAppID": "nginx-plus",
                        "clientSecret": "<client secret>"
                     }
                  ]
               }
            ]
         }
      }
   }
   ```

2. Send a request to the echo server API proxy with the provided access token. The request should not proceed to the backend, and `403 Forbidden` should be returned to the user. If you look at the data host error logs, you'll see the root cause of the `403` response: there was an issue resolving the introspection endpoint host in the introspection sub-request.

   ```bash
   sudo cat /var/log/nginx/data-host-error.log
   2022/10/17 13:22:04 [error] 44933#44933: *76 js: no resolver defined to resolve hosted.idp.com, client: 192.0.2.1, server: data-host, request: "POST /my/test/api HTTP/1.1", subrequest: "/_oauth2_send_introspection_request", host: "data-host"
   ```

3. Upsert the proxy with an updated Introspection policy configuration for `action.resolver`. Include the DNS server(s) needed for resolving the host used for introspection. In the following example, two DNS servers are configured along with `valid` and `timeout` parameters.

   ```bash
   PUT https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies/test-proxy
   ```

   ```json
   {
      "name": "test-proxy",
      "version": "v1",
      "proxyConfig": {
         "hostname": "data-host",
         "ingress": {
            "basePath": "/",
            "basePathVersionAppendRule": "NONE"
         },
         "backends": [
            {
               "serviceName": "backend-echo-svc",
               "serviceTargets": [
                  {
                     "hostname": "192.0.2.4",
                     "listener": {
                        "enableTLS": false,
                        "port": 10000,
                        "transportProtocol": "HTTP"
                     }
                  }
               ]
            }
         ],
         "policies": {
            "oauth2-introspection": [
               {
                  "action": {
                     "introspectionEndpoint": "https://hosted.idp.com:8080/realms/nginx/protocol/openid-connect/token/introspect",
                     "resolver": {
                        "valid": "30s",
                        "timeout": "60s",
                        "servers": [
                           {
                              "hostname": "10.0.0.1"
                           },
                           {
                              "hostname": "10.0.0.2",
                              "port": 5353
                           }
                        ]
                     }
                  },
                  "data": [
                     {
                        "clientAppID": "nginx-plus",
                        "clientSecret": "<client secret>"
                     }
                  ]
               }
            ]
         }
      }
   }
   ```

4. Send a request to the echo server API proxy with the provided access token. The hostname should resolve, and the request should proceed to the backend as expected.

### Forwarding Token Claims in Proxy Header {#forwarding-token-claims}

When a user access token is introspected with an OAuth server, the token introspection endpoint should respond with a JSON object with the properties listed below. Only the `active` property is required; the rest are optional.

{{< call-out "note" >}} Detailed descriptions of each claim can be found in [Section 2.2 of OAuth 2.0 Token Introspection Token [RFC7662]](https://datatracker.ietf.org/doc/html/rfc7662#section-2.2). {{< /call-out>}}

{{<bootstrap-table "table table-striped table-bordered">}}

| Claim | Required | Description |
|------------ |---------- |-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `active` | REQUIRED | Boolean indicator of whether the presented token is `active`. The specifics of a token's `active` state vary depending on the authorization server's implementation and the information it keeps about its tokens. Generally, however, a `true` value returned for the `active` property indicates that a given token has been issued by this authorization server, has not been revoked by the resource owner, and is within its given time window of validity (for example, after its issuance time and before its expiration time). |
| `scope` | OPTIONAL | A JSON string containing a space-separated list of scopes associated with this token. |
| `client_id` | OPTIONAL | Identifier for the OAuth 2.0 client that requested this token. |
| `username` | OPTIONAL | Human-readable identifier for the resource owner who authorized this token. |
| `token_type` | OPTIONAL | Type of the token. |
| `exp` | OPTIONAL | Integer timestamp, measured in the number of seconds since January 1, 1970, UTC, indicating when this token will expire. |
| `iat` | OPTIONAL | Integer timestamp, measured in the number of seconds since January 1, 1970, UTC, indicating when this token was issued. |
| `nbf` | OPTIONAL | Integer timestamp, measured in the number of seconds since January 1, 1970, UTC, indicating when this token should not be used before. |
| `sub` | OPTIONAL | Subject of the token. Usually, a machine-readable identifier of the resource owner who authorized this token. |
| `aud` | OPTIONAL | Service-specific string identifier or list of string identifiers representing the intended audience for this token. |
| `iss` | OPTIONAL | String representing the issuer of this token. |
| `jti` | OPTIONAL | String identifier for the token. |

{{</bootstrap-table>}}

With the API Connectivity Manager OAuth2 Introspection policy, extracting any claim from an IdP token introspection request and forwarding the claim to the backend service as a request header is possible. By default, the Introspection policy forwards the `exp`, `scope`, and `username` claims to the backend. When a token claim is extracted and sent to a backend service, it follows the naming pattern `X-Token-<Claim>`.

You'll need to consult your OAuth server's documentation to determine which claims you can forward to the backend. For this Keycloak example, you can examine the response from the [Introspecting a User Access Token](#introspect-token-test) test you completed above.

1. Upsert the proxy with an updated Introspection policy configuration to forward non-default claims in the proxy header. To access nested JSON object values, link the path to the value with full-stop [`.`] characters; for example, `resource_access.account.roles`. A non-existent claim called `fake-claim` has also been added.

    ```bash
    PUT https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies/test-proxy
    ```

    ```json
    {
        "name": "test-proxy",
        "version": "v1",
        "proxyConfig": {
            "hostname": "data-host",
            "ingress": {
                "basePath": "/",
                "basePathVersionAppendRule": "NONE"
            },
            "backends": [
                {
                    "serviceName": "backend-echo-svc",
                    "serviceTargets": [
                        {
                            "hostname": "192.0.2.4",
                            "listener": {
                                "enableTLS": false,
                                "port": 10000,
                                "transportProtocol": "HTTP"
                            }
                        }
                    ]
                }
            ],
            "policies": {
                "oauth2-introspection": [
                    {
                        "action": {
                            "introspectionEndpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/token/introspect",
                            "introspectionResponse": "application/json",
                            "forwardedClaimsInProxyHeader": [
                                "username",
                                "exp",
                                "scope",
                                "iss",
                                "client-id",
                                "resource_access.account.roles",
                                "fake-claim"
                            ]
                        },
                        "data": [
                            {
                                "clientAppID": "nginx-plus",
                                "clientSecret": "<client secret>"
                            }
                        ]
                    }
                ]
            }
        }
    }
    ```

2. Send another request to the echo server API proxy:

   ```bash
   POST https://192.0.2.4/my/test/api
   HEADERS:
     Authorization: 'Bearer <JWT_token>'
   ```

   The response returned from the echo server should contain the custom list of claims defined in the Introspection policy configuration. The non-existent claim is not present because the claim `fake-claim` did not exist in the token introspection response, so the related header field remained empty. By default, NGINX does not proxy empty headers to the backend; as such, it gracefully handles invalid claims without affecting user requests.

   ```bash
   Request served by echo-host

   HTTP/1.0 POST /my/test/api

   Host: default_http_a4334620-226b-491d-8503-e0724bdf5521
   Accept: */*
   Accept-Encoding: gzip, deflate, br
   Cache-Control: no-cache
   Connection: close
   Content-Length: 30
   Content-Type: application/json
   X-Correlation-Id: e537dec880a0e3eab70fe8b87f6b5838
   X-Token-Client-Id: nginx-plus
   X-Token-Exp: 1666011139
   X-Token-Iss: http://192.0.2.5:8080/realms/nginx
   X-Token-Resource-Access-Account-Roles: manage-account
   X-Token-Scope: openid email profile
   X-Token-Username: nginx-user
   ```

### Verifying Introspected Token Claim Values {#verifying-token-claims}

From API Connectivity Manager 1.4.0, API admins can configure Introspection token claim verification whereby NGINX will assert the value of an introspected token claim against values provided by the API admin. If these values match, the request proceeds to the backend, if not the request is denied and `403 Forbidden` is returned.

It is possible to verify string, integer, boolean, and array of strings data-types. Delimited strings, commonly encountered in the scope claim, are also supported. To access nested JSON object values, link the path to the value with full-stop [`.`] characters; for example, `resource_access.account.roles`. Both reserved and custom claims are supported, the only requirement is they are string data type.

1. Upsert the proxy with an updated Introspection policy configuration to include claim verification.

    ```bash
    PUT https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies/test-proxy
    ```

    ```json
    {
        "name": "test-proxy",
        "version": "v1",
        "proxyConfig": {
            "hostname": "data-host",
            "ingress": {
                "basePath": "/",
                "basePathVersionAppendRule": "NONE"
            },
            "backends": [
                {
                    "serviceName": "backend-echo-svc",
                    "serviceTargets": [
                        {
                            "hostname": "192.0.2.4",
                            "listener": {
                                "enableTLS": false,
                                "port": 10000,
                                "transportProtocol": "HTTP"
                            }
                        }
                    ]
                }
            ],
            "policies": {
                "oauth2-introspection": [
                    {
                        "action": {
                            "introspectionEndpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/token/introspect",
                            "introspectionResponse": "application/json",
                            "verifyClaims": [
                                {
                                    "claim": "aud",
                                    "type": "STRING",
                                    "value": "account"
                                },
                                {
                                    "claim": "scope",
                                    "type": "STRING",
                                    "value": "openid profile email",
                                    "delimiter": "SPACE"
                                },
                                {
                                    "claim": "acr",
                                    "type": "INTEGER",
                                    "value": 1
                                },
                                {
                                    "claim": "email_verified",
                                    "type": "BOOLEAN",
                                    "value": true
                                },
                                {
                                    "claim": "resource_access.account.roles",
                                    "type": "ARRAY",
                                    "value": [
                                        "manage-account",
                                        "manage-account-links",
                                        "view-profile"
                                    ]
                                }
                            ]
                        },
                        "data": [
                            {
                                "clientAppID": "nginx-plus",
                                "clientSecret": "<client secret>"
                            }
                        ]
                    }
                ]
            }
        }
    }
    ```

#### Claim Verification Examples
To demonstrate claim verification and the various permutations of what may be encountered, simple examples with various go/no go scenarios will be presented. In these examples the **expected** claim value from the policy configuration will be presented along with the **actual** introspected token claim value, the result, and if verification fails the reason why.

It should be noted that if a claim is defined in the policy configuration but does not exist in an introspected token response, verification instantly fails and the request will not proceed to the backend.

If a claim verification failure is encountered the end user will get a `403 Forbidden` response, in the data-path error logs only the claim name that failed will be logged. For security reasons and the highly sensitive nature of the data in token introspection responses the claim values from the failed claim verification are not logged. To debug these failures, manually introspect a user's token and verify the contents against the policy configuration for claim verification.

{{<bootstrap-table "table table-striped table-bordered">}}

| Type        | Expected Value           | Actual Value                       | Result | Failure Reason                        |
|-------------|--------------------------|------------------------------------|--------|---------------------------------------|
| `string`    | `"account"`              | `"account"`                        | Pass   |                                       |
| `string`    | `"account"`              | `"monitor"`                        | Fail   | Values do not match                   |
| `string`    | `"account"`              | `"Account"`                        | Fail   | Values do not match - case sensitive  |
| `string`    | `"account"`              | `["account"]`                      | Pass   |                                       |
| `string`    | `"account"`              | `["account", "monitor"]`           | Pass   |                                       |
| `string`    | `"account"`              | `["report", "monitor"]`            | Fail   | The expected value could not be found |
| `string`    | `"openid profile email"` | `"openid profile email"`           | Pass   |                                       |
| `string`    | `"openid profile email"` | `"openid email profile"`           | Pass   |                                       |
| `string`    | `"openid profile email"` | `"openid profile email account"`   | Pass   |                                       |
| `string`    | `"openid profile email"` | `"openid+email+profile"`           | Fail   | Delimiters do not match               |
| `string`    | `"openid profile email"` | `"openid profile"`                 | Fail   | Could not find "email"                |
| `string`    | `"openid profile email"` | `["openid", "profile", "email"]`   | Fail   | Expected delimited string             |
| `integer`   | `42`                     | `42`                               | Pass   |                                       |
| `integer`   | `42`                     | `"42"`                             | Pass   |                                       |
| `integer`   | `42`                     | `43`                               | Fail   | Values do not match                   |
| `boolean`   | `true`                   | `true`                             | Pass   |                                       |
| `boolean`   | `true`                   | `"TRUE"`                           | Pass   |                                       |
| `boolean`   | `true`                   | `false`                            | Fail   | Values do not match                   |
| `array`     | `["account"]`            | `["account"]`                      | Pass   |                                       |
| `array`     | `["account"]`            | `"account"`                        | Pass   |                                       |
| `array`     | `["account"]`            | `["monitor"]`                      | Fail   | Values do not match                   |
| `array`     | `["account"]`            | `["account", "monitor"]`           | Pass   |                                       |
| `array`     | `["account"]`            | `["report", "monitor"]`            | Fail   | The expected value could not be found |
| `array`     | `["account", "monitor"]` | `["account", "monitor"]`           | Pass   |                                       |
| `array`     | `["account", "monitor"]` | `["monitor", "account"]`          | Pass   |                                       |
| `array`     | `["account", "monitor"]` | `["account", "monitor", "report"]`| Pass   |                                       |
| `array`     | `["account", "monitor"]` | `["account"]`                      | Fail   | Could not find "monitor"              |

{{</bootstrap-table>}}

### Custom Error Return Codes

When users fail to pass an access token in requests to an API Proxy configured with an Introspection policy, they get back a `401 Unauthorized` response. If they try with an inactive or non-existent token, or if there's a problem with the introspection request or response, they get back a `403 Forbidden` response.

You can change the `401` and `403` response codes by configuring the `action.errorReturnConditions` setting.

1. Upsert the proxy with an updated Introspection policy configuration to include custom error return codes. In this example, we want to return `410` when the token is inactive or no match is found, and `418` when no access token is provided.

   ```bash
   PUT https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies/test-proxy
   ```

   ```json
   {
      "name": "test-proxy",
      "version": "v1",
      "proxyConfig": {
         "hostname": "data-host",
         "ingress": {
            "basePath": "/",
            "basePathVersionAppendRule": "NONE"
         },
         "backends": [
            {
               "serviceName": "backend-echo-svc",
               "serviceTargets": [
                  {
                     "hostname": "192.0.2.4",
                     "listener": {
                        "enableTLS": false,
                        "port": 10000,
                        "transportProtocol": "HTTP"
                     }
                  }
               ]
            }
         ],
         "policies": {
            "oauth2-introspection": [
               {
                  "action": {
                     "introspectionEndpoint": "http://192.0.2.5:8080/realms/nginx/protocol/openid-connect/token/introspect",
                     "introspectionResponse": "application/json",
                     "errorReturnConditions": {
                        "noMatch": {
                           "returnCode": 418
                        },
                        "notSupplied": {
                           "returnCode": 410
                        }
                     }
                  },
                  "data": [
                     {
                        "clientAppID": "nginx-plus",
                        "clientSecret": "<client secret>"
                     }
                  ]
               }
            ]
         }
      }
   }
   ```

   {{< call-out "note" >}} To edit the response message and format for these custom error codes, add them to the default global policy `error-response-format` with the related `errorCode` and `errorMessage`. {{< /call-out >}}

2. Send a request to the echo server API proxy without providing an access token. The request should not go to the backend, and the API proxy should respond with the status code `410 Gone`.

3. Send a request to the echo server API proxy with an invalid or inactive access token. The request should not go to the backend, and the API proxy should respond with the status code `418 I'm a teapot`.

### Introspection JWT Response Type & Token Forwarding

[OAuth 2.0 Token Introspection [RFC7662]](https://datatracker.ietf.org/doc/html/rfc7662) specifies how a protected resource can query an OAuth 2.0 authorization server to determine the state of an access token, and obtain data associated with the access token. This method allows deployments to implement opaque access tokens in an interoperable manner.

The introspection response, as specified in OAuth 2.0 Token Introspection [RFC7662], is a plain JSON object. However, there are use cases where the resource server may require stronger assurance that the authorization server issued the token introspection response for an access token, including cases where the authorization server assumes liability for the content of the token introspection response.

An example is a resource server using verified personal data to create certificates, which are then used to create qualified electronic signatures. In such use cases, it may be helpful or even required to return a signed [JSON Web token (JWT) [RFC7519]](https://www.rfc-editor.org/rfc/rfc7519) as the introspection response.

{{< call-out "important" >}}The introspection response type `application/jwt`, configured using `action.introspectionResponse`, has not finalized its security protocol specification at the time of writing, and it remains in **DRAFT** status. While in **DRAFT** status, the specification may change at any time, and API Connectivity Manager may change to meet the requirements of the specification. We recommend using the default OAuth2 Introspection response type `application/json` for all **production** scenarios.

For reference, see [JWT Response for OAuth Token Introspection](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-jwt-introspection-response).
{{< /call-out >}}

{{< call-out "note" >}} Not all OAuth2 servers support the `application/jwt` response type; Keycloak, for example, does not. Check your OAuth2 server documentation to verify support for this introspection response type. {{< /call-out >}}

1. Upsert the proxy with an updated Introspection policy configuration that sets the `action.introspectionResponse` parameter to `application/jwt`.

   In the following example, the OAuth2 server is changed from Keycloak to a platform that supports the `application/jwt` response type. For simplicity, the `nginx-plus` client credentials are the same.

   ```bash
   PUT https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies/test-proxy
   ```

   ```json
   {
      "name": "test-proxy",
      "version": "v1",
      "proxyConfig": {
         "hostname": "data-host",
         "ingress": {
            "basePath": "/",
            "basePathVersionAppendRule": "NONE"
         },
         "backends": [
            {
               "serviceName": "backend-echo-svc",
               "serviceTargets": [
                  {
                     "hostname": "192.0.2.4",
                     "listener": {
                        "enableTLS": false,
                        "port": 10000,
                        "transportProtocol": "HTTP"
                     }
                  }
               ]
            }
         ],
         "policies": {
            "oauth2-introspection": [
               {
                  "action": {
                     "introspectionEndpoint": "https://192.0.2.5:8080/oauth/v2/oauth-introspect",
                     "introspectionResponse": "application/jwt"

                  },
                  "data": [
                     {
                        "clientAppID": "nginx-plus",
                        "clientSecret": "<client secret>"
                     }
                  ]
               }
            ]
         }
      }
   }
   ```

2. Send a request to the echo server API proxy with the provided access token. The request should proceed to the backend as expected. The difference in responses is abstracted away from the end-user; token introspection is successful if the user passes an active access token. This change becomes apparent through token forwarding, which we discuss in the following steps.

   ```bash
   Request served by echo-host

   HTTP/1.0 POST /my/test/api

   Host: default_http_07b28d26-9641-4a67-a422-0c4e14f27b03
   Accept: */*
   Accept-Encoding: gzip, deflate, br
   Cache-Control: no-cache
   Connection: close
   Content-Length: 30
   Content-Type: application/json
   X-Correlation-Id: 00342cadec0651b6643fcf092246535f
   ```

3. When `action.introspectionResponse` is configured as `application/jwt`, the configuration parameter `action.forwardedClaimsInProxyHeader` is not valid. For `application/jwt` responses, the configuration value `action.forwardToken` is used to forward the entire JWT token from the introspection request to the backend. This allows backend services to decode and parse the token to determine how to further process an in-flight user request after it has been introspected and routed by the API proxy.

   Upsert the proxy with an updated Introspection policy configuration parameter `action.forwardToken` set to `true`:

   ```bash
   PUT https://192.0.2.2/api/acm/v1/services/workspaces/service-ws/proxies/test-proxy
   ```

   ```json
   {
      "name": "test-proxy",
      "version": "v1",
      "proxyConfig": {
         "hostname": "data-host",
         "ingress": {
            "basePath": "/",
            "basePathVersionAppendRule": "NONE"
         },
         "backends": [
            {
               "serviceName": "backend-echo-svc",
               "serviceTargets": [
                  {
                     "hostname": "192.0.2.4",
                     "listener": {
                        "enableTLS": false,
                        "port": 10000,
                        "transportProtocol": "HTTP"
                     }
                  }
               ]
            }
         ],
         "policies": {
            "oauth2-introspection": [
               {
                  "action": {
                     "introspectionEndpoint": "https://192.0.2.5:8080/oauth/v2/oauth-introspect",
                     "introspectionResponse": "application/jwt",
                           "forwardToken": true

                  },
                  "data": [
                     {
                        "clientAppID": "nginx-plus",
                        "clientSecret": "<client secret>"
                     }
                  ]
               }
            ]
         }
      }
   }
   ```

4. Send a request to the echo server API proxy with the provided access token. When the API proxy parses the user access token and sends it to the OAuth2 Server for introspection, the response JWT token is added to the in-flight request headers as a bearer token in the `Authorization` header.

   ```shell
   Request served by echo-host

   HTTP/1.0 POST /my/test/api

   Host: default_http_07b28d26-9641-4a67-a422-0c4e14f27b03
   Accept: */*
   Accept-Encoding: gzip, deflate, br
   Authorization: Bearer <access token>
   Cache-Control: no-cache
   Connection: close
   Content-Length: 30
   Content-Type: application/json
   X-Correlation-Id: 00342cadec0651b6643fcf092246535f
   ```

### Opaque Tokens

An opaque token, also known as a phantom token, is a random, unique string of characters issued by an OAuth2 server token service as an alternative to JWT access tokens. Opaque tokens are pass-by-reference tokens, meaning they do not carry information and can only be further processed by the token service that issued them. Standard JWT access tokens can be decoded to view any included information. Opaque tokens offer an extra level of security for in-flight requests.

Opaque tokens are supported out-of-the-box with the API Connectivity Manager OAuth2 Introspection policy. Just pass the opaque token in place of the standard access token when a user sends a request to an API proxy with token introspection configured.

{{< call-out "note" >}} Not all OAuth2 Servers support opaque tokens; Keycloak, for example, does not. Check your OAuth2 server documentation to verify support for this token format. {{< /call-out >}}

```bash
POST https://192.0.2.4/my/test/api
HEADERS:
  Authorization: 'Bearer <OAuth 2 token>'
```

```bash
Request served by echo-host

HTTP/1.0 POST /my/test/api

Host: default_http_07b28d26-9641-4a67-a422-0c4e14f27b03
Accept: */*
Accept-Encoding: gzip, deflate, br
Cache-Control: no-cache
Connection: close
Content-Length: 30
Content-Type: application/json
X-Correlation-Id: 00342cadec0651b6643fcf092246535f
```
