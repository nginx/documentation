---
title: 'Keycloak: Set up OIDC authentication on Kubernetes cluster'
toc: true
weight: 450
f5-content-type: tutorial
f5-product: NGINX Instance Manager
description: "Configure Keycloak as the OIDC identity provider for F5 NGINX Instance Manager deployed on Kubernetes cluster to enable Single Sign-On and centralized user management."
f5-summary: >
  Configure Keycloak as the identity provider for F5 NGINX Instance Manager deployed on Kubernetes cluster using OpenID Connect.
  This tutorial walks through creating a Keycloak client, configuring redirect URIs, and connecting Keycloak to NGINX Instance Manager for OIDC authentication.
---

## Overview

This guide explains how to configure Keycloak as an identity provider (IdP) for F5 NGINX Instance Manager. With OIDC authentication, you can simplify user management in NGINX Instance Manager. Instead of creating and managing users individually, you can create user groups in NGINX Instance Manager that align with groups in your identity provider. The roles assigned to each user group determine that group's access and permissions. Users from the identity provider who aren't part of a group with an assigned role don't have access to NGINX Instance Manager.

F5 recommends OpenID Connect (OIDC) as the preferred authentication method for NGINX Instance Manager. OIDC brings several benefits, including Single Sign-On (SSO) and simplified user management through user groups.

This guide walks you through the following phases, in order:

1. Build the NGINX Plus API Gateway image
2. Prepare the Helm values file
3. Install NGINX Instance Manager with Helm
4. Add the NGINX Plus license
5. Get the public NGINX Instance Manager URL
6. Configure Keycloak
7. Configure NGINX Instance Manager for OIDC on Kubernetes
8. Validate the deployment

## Requirements

Before you begin, make sure you have a Keycloak server set up. For setup instructions, see [Keycloak server]({{< ref "/nim/admin-guide/authentication/oidc/keycloak-setup.md#keycloak-server" >}}) in the NGINX Instance Manager Keycloak setup guide.

To set up the Keycloak server, refer to the Keycloak [Getting Started](https://www.keycloak.org/guides#getting-started) and Server documentation. You'll also need to [create a realm](https://www.keycloak.org/docs/latest/server_admin/#configuring-realms) with an OpenID endpoint configuration.

## Build the NGINX Plus API Gateway image

The default `apigw` image for NGINX Instance Manager doesn't support Kubernetes OIDC. You need to build a custom API Gateway image that includes:

- `nginx-plus`
- `nginx-plus-module-njs`

For build instructions, see [Use NGINX Plus for API Gateway]({{< ref "/nim/deploy/kubernetes/frequently-used-helm-configs.md#use-nginx-plus-for-api-gateway" >}}).

## Prepare the Helm values file

Update only the `apigw` image to use your custom NGINX Plus image. The other NGINX Instance Manager services can continue using the standard release images.

Example:

```yaml
imagePullSecrets:
  - name: regcred

apigw:
  service:
    type: LoadBalancer
  image:
    repository: <MY_REGISTRY>/nms-apigw-plus
    tag: "<VERSION>"

core:
  image:
    repository: <MAIN_REGISTRY>/core
    tag: latest

dpm:
  image:
    repository: <MAIN_REGISTRY>/dpm
    tag: latest

ingestion:
  image:
    repository: <MAIN_REGISTRY>/ingestion
    tag: latest

integrations:
  image:
    repository: <MAIN_REGISTRY>/integrations
    tag: latest

secmon:
  image:
    repository: <MAIN_REGISTRY>/secmon
    tag: latest

utility:
  image:
    repository: <MAIN_REGISTRY>/utility
    tag: latest

global:
  utility: true
```

## Install NGINX Instance Manager with Helm

1. Install or upgrade the release:

    ```shell
    helm upgrade --install nim ./nim-<VERSION>.tgz \
      -n nms \
      --create-namespace \
      -f ./values.yaml \
      --set adminPasswordHash="$(openssl passwd -1 '<PASSWORD>')"
    ```

2. Check the deployment:

    ```shell
    kubectl -n nms get pods
    kubectl -n nms get svc
    kubectl -n nms get deploy
    ```

    At this stage, `apigw` might fail until the NGINX Plus license is mounted.

## Add the NGINX Plus license

1. Create a Kubernetes secret from `license.jwt`:

    ```shell
    kubectl -n nms create secret generic nginx-plus-license \
      --from-file=license.jwt=/path/to/license.jwt
    ```

2. Patch the `apigw` deployment to mount the license:

    ```shell
    kubectl -n nms patch deployment apigw --type='json' -p='[
      {
        "op":"add",
        "path":"/spec/template/spec/volumes/-",
        "value":{
          "name":"nginx-plus-license",
          "secret":{
            "secretName":"nginx-plus-license"
          }
        }
      },
      {
        "op":"add",
        "path":"/spec/template/spec/containers/0/volumeMounts/-",
        "value":{
          "name":"nginx-plus-license",
          "mountPath":"/etc/nginx/license.jwt",
          "subPath":"license.jwt",
          "readOnly":true
        }
      }
    ]'
    ```

3. If your OIDC runtime stores token state under `/var/run/nms`, mount a writable runtime directory:

    ```shell
    kubectl -n nms patch deployment apigw --type='json' -p='[
      {
        "op":"add",
        "path":"/spec/template/spec/volumes/-",
        "value":{
          "name":"nms-run",
          "emptyDir":{}
        }
      },
      {
        "op":"add",
        "path":"/spec/template/spec/containers/0/volumeMounts/-",
        "value":{
          "name":"nms-run",
          "mountPath":"/var/run/nms"
        }
      }
    ]'
    ```

4. Restart `apigw`:

    ```shell
    kubectl -n nms rollout restart deployment/apigw
    kubectl -n nms rollout status deployment/apigw --timeout=300s
    ```

## Get the public NGINX Instance Manager URL

Find the external hostname assigned to the API Gateway (`apigw`) service:

```shell
kubectl -n nms get svc apigw -o wide
```

Use this exact public URL for:

- The browser login URL
- The Keycloak Root URL
- The Keycloak Valid Redirect URI
- The Keycloak Web Origins

## Configure Keycloak

1. Create or update the Keycloak client using these example values:

    - Client ID: `nim`
    - Access Type: `confidential`
    - Standard Flow Enabled: `ON`

2. Set the following Keycloak settings to your exact NGINX Instance Manager public URL:

    - Root URL: `https://<NIM_PUBLIC_HOSTNAME>`
    - Valid Redirect URI: `https://<NIM_PUBLIC_HOSTNAME>/_codexch`
    - Web Origins: `https://<NIM_PUBLIC_HOSTNAME>`

3. Leave Admin URL blank unless you have a specific requirement for it.

**Important:**

- Don't append `:443` unless it's part of the actual public URL.
- Don't use malformed values, such as `.com_codexch`.
- Make sure the client secret matches the value configured in NGINX Instance Manager.

For general Keycloak setup steps, see [Configure Keycloak]({{< ref "/nim/admin-guide/authentication/oidc/keycloak-setup.md#configure-keycloak" >}}).

## Configure NGINX Instance Manager for OIDC on Kubernetes

Update the following three ConfigMaps, in order:

1. `nms-openid-conf`
2. `nms-nginx-conf`
3. `nms-http-conf`

### Update `nms-openid-conf`

1. Update the following settings:

    - Authorization endpoint
    - Token endpoint
    - JWKS endpoint
    - Client ID
    - Client secret
    - OIDC domain
    - HMAC key
    - Redirect base handling

    Example settings:

    - Keycloak authorization endpoint: `https://<KEYCLOAK_HOST>:8443/auth/realms/nginx/protocol/openid-connect/auth`
    - Keycloak token endpoint: `https://<KEYCLOAK_HOST>:8443/auth/realms/nginx/protocol/openid-connect/token`
    - Keycloak JWKS endpoint: `https://<KEYCLOAK_HOST>:8443/auth/realms/nginx/protocol/openid-connect/certs`

2. Add the Keycloak claim maps:

    ```shell
    map $http_authorization $groups_claim {
        default $jwt_claim_groups;
    }

    map $http_authorization $user_email {
        "~^Bearer.*" '$jwt_clientId@$oidc_domain';
        default $jwt_claim_email;
    }
    ```

3. Add this redirect base handling so NGINX doesn't generate the callback URL with an incorrect port:

    ```shell
    map $http_x_forwarded_port $redirect_base {
        ""      $proto://$host;
        default $proto://$host:$http_x_forwarded_port;
    }
    ```

### Update `nms-nginx-conf`

Load the required njs modules at the top of `nginx.conf`:

```nginx
load_module modules/ngx_http_js_module.so;
load_module modules/ngx_stream_js_module.so;
```

### Update `nms-http-conf`

1. Add the OIDC include:

    ```shell
    include /etc/nms/nginx/oidc/openid_configuration.conf;
    ```

2. Add the OIDC server configuration:

    ```shell
    add_header Nginx-Management-Suite-Auth "OIDC";
    include /etc/nms/nginx/oidc/openid_connect.conf;
    ```

3. Switch the user identity headers from Basic Auth to OIDC:

    ```shell
    proxy_set_header Nginx-Management-Suite-Auth "OIDC";
    proxy_set_header Nginx-Management-Suite-User $user_email;
    proxy_set_header Nginx-Management-Suite-Groups $groups_claim;
    proxy_set_header Nginx-Management-Suite-ExternalId $jwt_claim_sub;
    ```

4. Comment out the Basic Auth sections:

    ```shell
    #auth_basic_user_file /etc/nms/nginx/.htpasswd;
    #add_header Nginx-Management-Suite-Auth Basic;
    #proxy_set_header Nginx-Management-Suite-User $remote_user;
    #proxy_set_header Nginx-Management-Suite-Groups "";
    #proxy_set_header Nginx-Management-Suite-ExternalId "";
    ```

5. Turn on OIDC authentication in protected locations by uncommenting lines like:

    ```shell
    error_page 401 = @do_oidc_flow;
    auth_jwt "" token=$session_jwt;
    auth_jwt_key_request /_jwks_uri;
    ```

    Apply these settings to protected locations, such as:

    - `/api`
    - `/login`
    - `/ui/*.json`
    - Module UI routes
    - Notification gRPC routes, if needed

6. If your public hostname is long and NGINX reports a hash warning, add:

    ```shell
    map_hash_bucket_size 128;
    ```

### Apply the updated ConfigMaps

1. Apply the updated ConfigMaps:

    ```shell
    kubectl -n nms create configmap nms-openid-conf \
      --from-file=openid_configuration.conf=/tmp/openid_configuration.conf \
      --from-file=openid_connect.conf=/tmp/openid_connect.conf \
      -o yaml --dry-run=client | kubectl apply -f -

    kubectl -n nms create configmap nms-http-conf \
      --from-file=nms-http.conf=/tmp/nms-http.conf \
      -o yaml --dry-run=client | kubectl apply -f -

    kubectl -n nms create configmap nms-nginx-conf \
      --from-file=nginx.conf=/tmp/nginx.conf \
      -o yaml --dry-run=client | kubectl apply -f -
    ```

2. Restart `apigw`:

    ```shell
    kubectl -n nms rollout restart deployment/apigw
    kubectl -n nms rollout status deployment/apigw --timeout=300s
    ```

## Validate the deployment

1. Check the pod:

    ```shell
    kubectl -n nms get pods -l app.kubernetes.io/name=apigw -o wide
    ```

2. Check the logs:

    ```shell
    kubectl -n nms logs deployment/apigw --tail=100
    ```

3. Test the login redirect:

    ```shell
    curl -k -I https://<NIM_PUBLIC_HOSTNAME>/login
    ```

    Expected result:

    - HTTP 302
    - Location header points to the Keycloak authorization endpoint
    - `redirect_uri` parameter points to `https://<NIM_PUBLIC_HOSTNAME>/_codexch`
    - Auth header indicates OIDC

    Example response:

    ```text
    Location: https://<KEYCLOAK_HOST>:8443/auth/realms/nginx/protocol/openid-connect/auth?...&redirect_uri=https://<NIM_PUBLIC_HOSTNAME>/_codexch
    Nginx-Management-Suite-Auth: OIDC
    ```

## Troubleshooting

### `apigw` fails with a missing license error

**Cause:** `license.jwt` isn't mounted.

**Fix:**

- Create the `nginx-plus-license` secret.
- Patch the `apigw` deployment to mount `/etc/nginx/license.jwt`.

### `apigw` fails to load `ngx_http_js_module.so`

**Cause:**

- njs wasn't installed.
- The njs modules weren't loaded.
- The image build path is incorrect.

**Fix:**

- Confirm the image includes `nginx-plus-module-njs`.
- Confirm `nms-nginx-conf` loads the required modules:

  ```nginx
  load_module modules/ngx_http_js_module.so;
  load_module modules/ngx_stream_js_module.so;
  ```

### `/login` redirects to Keycloak, but the browser never completes login

**Cause:** NGINX Instance Manager can't reach the Keycloak token endpoint.

**Symptoms:**

- `/_codexch` requests appear in the logs.
- The token exchange times out.
- The browser spins or returns to the sign-in page.

**Fix:**

- Allow the `apigw` pod egress IP to reach Keycloak on port 8443.
- Verify from inside the pod that the token endpoint is reachable.

### Redirect URI mismatch

**Cause:**

- The Root URL, Valid Redirect URI, or Web Origins in Keycloak is incorrect.
- The NGINX Instance Manager public URL is incorrect.
- `:443` or `:8443` was added to the callback incorrectly.

**Fix:** Use the exact NGINX Instance Manager public URL for each Keycloak setting:

- Root URL: `https://<NIM_PUBLIC_HOSTNAME>`
- Valid Redirect URI: `https://<NIM_PUBLIC_HOSTNAME>/_codexch`
- Web Origins: `https://<NIM_PUBLIC_HOSTNAME>`

### `apigw` fails after you turn on OIDC because files in `/var/run/nms` can't be created

**Cause:** OIDC token state files require a writable runtime directory.

**Fix:** Mount an `emptyDir` volume to `/var/run/nms`.
