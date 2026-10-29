---
title: 'Keycloak: Set up OIDC authentication on Kubernetes cluster'
toc: true
weight: 400
f5-content-type: tutorial
f5-product: NGINX Instance Manager
description: "Configure Keycloak as the OIDC identity provider for F5 NGINX Instance Manager deployed on Kubernetes cluster to enable Single Sign-On and centralized user management."
f5-summary: >
  Configure Keycloak as the identity provider for F5 NGINX Instance Manager deployed on Kubernetes cluster using OpenID Connect.
  This tutorial walks through creating a Keycloak client, configuring redirect URIs, and connecting Keycloak to NGINX Instance Manager for OIDC authentication.
---

## Overview

This guide explains how to configure Keycloak as an identity provider (IdP) for F5 NGINX Instance Manager. By implementing OIDC for authentication, administrators can simplify user management in NGINX Instance Manager. Instead of creating and managing users individually, administrators can create user groups in NGINX Instance Manager that align with groups in their Identity Provider. Access and permissions for users are determined by the roles assigned to their respective user groups. Users from the Identity Provider who are not part of a group with an assigned role will not have access to NGINX Instance Manager.

We strongly recommend OpenID Connect (OIDC) as the preferred authentication method for NGINX Instance Manager. OIDC brings several benefits, including Single Sign-On (SSO) and simplified user management through user groups.

## Requirements

To follow the instructions in this guide, ensure you have the following setup for your Keycloak server and NGINX Instance Manager host -- 
[Keycloak Server](https://docs.nginx.com/nginx-instance-manager/admin-guide/authentication/oidc/keycloak-setup/#keycloak-server)

Set up a Keycloak server. Refer to the Keycloak [Getting Started](https://www.keycloak.org/guides#getting-started) and Server documentation for setup instructions. You will need to [create a Realm](https://www.keycloak.org/docs/latest/server_admin/#configuring-realms) with an OpenID Endpoint Configuration enabled.

## Build the NGINX Plus API gateway image

The default NIM apigw image is not sufficient for Kubernetes OIDC. You must build a custom API Gateway image that includes:

    - nginx-plus
    - nginx-plus-module-njs

Please follow the how to build nginx-plus image for apigw [Build process](https://docs.nginx.com/nginx-instance-manager/deploy/kubernetes/frequently-used-helm-configs/#use-nginx-plus-for-api-gateway)

## Prepare the Helm values file

Update only the apigw image to use the custom NGINX Plus image. The other NIM services can continue using the standard release images.

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

Install or upgrade the release:
```shell
helm upgrade --install nim ./nim-<VERSION>.tgz \
  -n nms \
  --create-namespace \
  -f ./values.yaml \
  --set adminPasswordHash="$(openssl passwd -1 '<PASSWORD>')"
Check the deployment:

kubectl -n nms get pods
kubectl -n nms get svc
kubectl -n nms get deploy
```
At this stage, apigw may fail until the NGINX Plus license is mounted.

## Add the NGINX Plus license

Create a Kubernetes secret from license.jwt:
 ```shell
  kubectl -n nms create secret generic nginx-plus-license \
  --from-file=license.jwt=/path/to/license.jwt
  ```

Patch the apigw deployment to mount the license:

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

If your OIDC runtime stores token state under /var/run/nms, mount a writable runtime directory:

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

Restart apigw:
```shell
kubectl -n nms rollout restart deployment/apigw
kubectl -n nms rollout status deployment/apigw --timeout=300s
```

## Get the public NIM URL

Find the external hostname assigned to the API Gateway service:

```shell
kubectl -n nms get svc apigw -o wide
```

Use this exact public URL for:

    - The browser login URL
    - The Keycloak Root URL
    - The Keycloak Valid Redirect URI
    - The Keycloak Web Origins

## Configure Keycloak

Create or update the Keycloak client.

Example values:

    - Client ID: nim
    - Access Type: confidential
    - Standard Flow Enabled: ON

Use the NIM public URL exactly:

    - Root URL
https://<NIM_PUBLIC_HOSTNAME>

    - Valid Redirect URI
https://<NIM_PUBLIC_HOSTNAME>/_codexch

    - Web Origins
https://<NIM_PUBLIC_HOSTNAME>

Leave Admin URL blank unless you have a specific requirement for it.

Important:

    - Do not append :443 unless that is actually part of the public URL
    - Do not use malformed values such as .com_codexch
    - Ensure the client secret matches the value configured in NIM

For general Keycloak setup steps, see: [Guide](https://docs.nginx.com/nginx-instance-manager/admin-guide/authentication/oidc/keycloak-setup/)

## Configure NIM for OIDC on Kubernetes

Three ConfigMaps must be updated:

    - nms-openid-conf
    - nms-http-conf
    - nms-nginx-conf

### Update nms-openid-conf

Configure:

    - authorization endpoint
    - token endpoint
    - JWKS endpoint
    - client ID
    - client secret
    - OIDC domain
    - HMAC key
    - redirect base handling

Example settings:

    - Keycloak authorization endpoint
https://<KEYCLOAK_HOST>:8443/auth/realms/nginx/protocol/openid-connect/auth

    - Keycloak token endpoint
https://<KEYCLOAK_HOST>:8443/auth/realms/nginx/protocol/openid-connect/token

    - Keycloak JWKS endpoint
https://<KEYCLOAK_HOST>:8443/auth/realms/nginx/protocol/openid-connect/certs

Enable the Keycloak claim maps:

```shell
map $http_authorization $groups_claim {
    default $jwt_claim_groups;
}

map $http_authorization $user_email {
    "~^Bearer.*" '$jwt_clientId@$oidc_domain';
    default $jwt_claim_email;
}
```

Use this redirect base handling so the callback URL is not generated with an incorrect port:

```shell
map $http_x_forwarded_port $redirect_base {
    ""      $proto://$host;
    default $proto://$host:$http_x_forwarded_port;
}
```

### Update nms-nginx-conf
Load the required njs modules at the top of nginx.conf:

load_module modules/ngx_http_js_module.so;
load_module modules/ngx_stream_js_module.so;

### Update nms-http-conf
Enable the OIDC include:
```shell
include /etc/nms/nginx/oidc/openid_configuration.conf;
```

Enable the OIDC server configuration:
```shell
add_header Nginx-Management-Suite-Auth "OIDC";
include /etc/nms/nginx/oidc/openid_connect.conf;
Switch the user identity headers from Basic Auth to OIDC:

proxy_set_header Nginx-Management-Suite-Auth "OIDC";
proxy_set_header Nginx-Management-Suite-User $user_email;
proxy_set_header Nginx-Management-Suite-Groups $groups_claim;
proxy_set_header Nginx-Management-Suite-ExternalId $jwt_claim_sub;
```

Comment out the Basic Auth sections:

```shell
#auth_basic_user_file /etc/nms/nginx/.htpasswd;
#add_header Nginx-Management-Suite-Auth Basic;
#proxy_set_header Nginx-Management-Suite-User $remote_user;
#proxy_set_header Nginx-Management-Suite-Groups "";
#proxy_set_header Nginx-Management-Suite-ExternalId "";
```

Enable OIDC auth in protected locations by uncommenting lines like:

```shell
error_page 401 = @do_oidc_flow;
auth_jwt "" token=$session_jwt;
auth_jwt_key_request /_jwks_uri;
```

Apply these in the protected locations such as:

    - /api
    - /login
    - /ui/*.json
    - module UI routes
    - Notification gRPC routes if needed

If your public hostname is long and NGINX reports a hash warning, set:

```shell
map_hash_bucket_size 128;
```

### Apply the updated Config Maps

Example pattern:

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

Restart apigw:

```shell
kubectl -n nms rollout restart deployment/apigw
kubectl -n nms rollout status deployment/apigw --timeout=300s
```
## Validate the deployment
Check the pod:

```shell
kubectl -n nms get pods -l app.kubernetes.io/name=apigw -o wide
```

Check logs:

```shell
kubectl -n nms logs deployment/apigw --tail=100
```

Test the login redirect:

```shell
curl -k -I https://<NIM_PUBLIC_HOSTNAME>/login
```

Expected result:

    - HTTP 302
    - Location header points to the Keycloak authorization endpoint
    - redirect_uri points to https://<NIM_PUBLIC_HOSTNAME>/_codexch
    - auth header indicates OIDC

Example:

Location: https://<KEYCLOAK_HOST>:8443/auth/realms/nginx/protocol/openid-connect/auth?...&redirect_uri=https://<NIM_PUBLIC_HOSTNAME>/_codexch
Nginx-Management-Suite-Auth: OIDC

## Troubleshooting

### Apigw fails with License file is required

Cause:
    - license.jwt is not mounted

Fix:
    - create the nginx-plus-license secret
    - patch the apigw deployment to mount /etc/nginx/license.jwt

### Apigw fails to load ngx_http_js_module.so

Cause:
    - njs was not installed
    - njs modules were not loaded
    - image build path is not correct

Fix:
    - confirm the image includes nginx-plus-module-njs
    - confirm nms-nginx-conf loads:
    - load_module modules/ngx_http_js_module.so;
    - load_module modules/ngx_stream_js_module.so;
    
### /login redirects to Keycloak, but the browser never completes login

Cause:
    - NIM cannot reach the Keycloak token endpoint

Symptoms:

    - /_codexch requests appear in logs
    - token exchange times out
    - browser appears to spin or return to the sign-in page
    
Fix:
    - Allow the apigw pod egress IP to reach Keycloak on 8443
    - verify from inside the pod that the token endpoint is reachable
    
### Redirect URI mismatch

Cause:
    - Incorrect Root URL, Valid Redirect URI, or Web Origins in Keycloak
    - Incorrect NIM public URL
    - Incorrect :443 or :8443 added to the callback
    
Fix:
    - use the exact NIM public URL
use as follows:
    - Root URL: https://<NIM_PUBLIC_HOSTNAME>
    - Valid Redirect URI: https://<NIM_PUBLIC_HOSTNAME>/_codexch
    - Web Origins: https://<NIM_PUBLIC_HOSTNAME>

### Apigw fails after enabling OIDC because /var/run/nms files cannot be created

Cause:
    - OIDC token state files require a writable runtime directory

Fix:
    - mount an emptyDir volume to /var/run/nms
