---
title: "Known Issues"
date: 
draft: false
description: "This document is a summary of the known issues in NGINX Management Suite API Connectivity Manager. Fixed issues are removed after **45 days**. <p>We recommend upgrading to the latest version of API Connectivity Manager to take advantage of new features, improvements, and bug fixes.</p>"
# Assign weights in increments of 100
weight: 100000
toc: true
tags: [ "docs" ]
docs: "DOCS-930"
categories: ["known issues"]
doctypes: ["reference"]
---

{{<rn-styles>}}

---
## 1.7.0

### {{% icon-bug %}} Environments with WAF enabled may transition to a Failed status when a Developer Portal cluster is added. {#43231}


{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 43231    | Open   |
{{</bootstrap-table>}}

#### Description

If you add a Developer Portal cluster to an environment that has WAF enabled, the environment may transition to a `Failed` status. If this happens, follow the steps in the workaround.

#### Workaround

On the Developer Portal:

1. Open an SSH connection to the Developer Portal and log in.
2. [Install NGINX App Protect]({{< relref "/nap-waf/admin-guide/install.md" >}}).
3. Stop the NGINX Agent:

    ```bash
    sudo systemctl stop nginx-agent
    ```

4. Run the onboarding command to add the Developer Cluster:

    ```bash
    curl -k https://<NMS-FQDN>/install/nginx-agent > install.sh && sudo sh install.sh -g <cluster> -m precompiled-publication --nap-monitoring true && sudo systemctl start nginx-agent
    ```

    Replace `<NMS-FQDN>` with the fully qualified domain name of your NGINX Management Suite, and `<cluster>` with the name of the Developer Cluster.


5. Confirm the NGINX Agent is started and restart if necessary: 

    ```bash
    sudo systemctl status nginx-agent
    sudo systemctl start nginx-agent
    ``` 

---

### {{% icon-bug %}} Resources deployed to a Developer Portal which has had its database reset cannot be updated or removed {#43140}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 43140    | Open   |
{{</bootstrap-table>}}

#### Description

It is not possible to remove resources from API Connectivity Manager which have been published to a Developer Portal if the Developer Portal database is cleared.

---

## 1.6.0

### {{% icon-resolved %}} Multiple entries selected when gateway proxy hostnames are the same {#42515}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 42515    | Fixed in 1.7.0 |
{{</bootstrap-table>}}

#### Description

Multiple entries are selected when gateway proxy hostnames are the same.
#### Workaround

There is no impact to functionality.

---

### {{% icon-resolved %}} The routes filter under the proxy metrics page won’t work with params {#42471}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 42471    | Fixed in 1.7.0 |
{{</bootstrap-table>}}

#### Description

The routes filter under the proxy metrics page doesn't work with params.

e.g. `/api/v1/shops/{shopID}`

The API won’t match on the above route.

---

## 1.5.0

### {{% icon-bug %}} Using policies with targetPolicyName set to anything other than the default value can cause unexpected results.

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 42682    | Open   |
{{</bootstrap-table>}}

#### Description

Creating a policy with metadata of "targetPolicyName" set to anything but default can cause issues with secrets being duplicated if more than one policy is created. Setting this value to anything but the default value will also cause the policy to not be applied. The policy may be shown as applied in the UI when it is not.

#### Workaround

Do not modify the "targetPolicyName" to be anything but the default value.

---

### {{% icon-resolved %}} Array values in token claims are treated as string values {#42388}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 42388    | Fixed in 1.6.0 |
{{</bootstrap-table>}}

#### Description

When an Access Control Routing match rule targeted a token value that contained an array, the array was collapsed into a comma-separated string. However, the expected behavior is for rules targeting arrays to pass if any value within the array matches the condition, rather than requiring the entire array to match.

---

### {{% icon-resolved %}} Developer Portal: When typing the links to use for the footer, the text boxes keep losing focus {#41626}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 41626    | Fixed in 1.6.0 |
{{</bootstrap-table>}}

#### Description

The **Text to Display** and **URL** boxes on the Developer Portal's _Configure Footer_ page lose focus when text is being typed.

#### Workaround

You may need to click back into the boxes several times while typing to regain focus.

---

### {{% icon-resolved %}} TLS setting on listener is not reset when TLS policy is removed {#41426}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 41426    | Fixed in 1.6.0 |
{{</bootstrap-table>}}

#### Description

When a TLS policy is removed from an environment, the web interface will not automatically adjust the TLS setting on the listener. As a result, the listener will remain in the `TLS enabled` state, leading to an unsuccessful attempt to save and publish the environment.

#### Workaround

Toggle the TLS setting in the web interface when removing the TLS policy from an environment.

---

## 1.4.0

### {{% icon-resolved %}} Cluster and Environment deletion issues when Portal Docs are published {#40163}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 40163    | Fixed in 1.4.1 |
{{</bootstrap-table>}}

#### Description

When a developer portal proxy is hosting API documentation, the infrastructure admin is, in some cases, unable to delete clusters in other unrelated Environments and therefore, unable to delete those same Environments.

---

### {{% icon-resolved %}} The Proxy Cluster API isn't ready to be used {#40097}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 40097    | Fixed in 1.5.0 |
{{</bootstrap-table>}}

#### Description

The API Connectivity Manager API documentation has inadvertently released details of Proxy Cluster endpoints and related policies before their public launch. Consequently, the following Proxy Cluster endpoints and global policies should not be used yet.

The following Proxy Cluster endpoints are not ready for use:

- `/infrastructure/workspaces/{workspaceName}/proxy-clusters`
- `/infrastructure/workspaces/{workspaceName}/proxy-clusters/{name}`

The following global policies are not yet ready for use:

- cluster-zone-sync
- cluster-wide-config

A later version of the release notes will inform you when these endpoints and policies are ready.

---

### {{% icon-resolved %}} Configurations aren't pushed to newly onboarded instances if another instance is offline {#40035}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 40035    | Fixed in 1.5.0 |
{{</bootstrap-table>}}

#### Description

When a new instance is onboarded, it will not be configured if any other instances are offline.

#### Workaround

After onboarding the instance as usual, push the existing configuration again to the new instance, without making any changes.

---

## 1.3.0

### {{% icon-resolved %}} OIDC policy cannot be applied alongside a proxy authentication policy {#39604}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 39604    | Fixed in 1.4.0 |
{{</bootstrap-table>}}

#### Description

It is not possible to use both an OpenID Connect (OIDC) policy and a proxy authentication policy concurrently.

---

### {{% icon-resolved %}} A JWT token present in a query parameter is not proxied to the backend for advanced routes  {#39328}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 39328    | Fixed in 1.4.0 |
{{</bootstrap-table>}}

#### Description

When using JWT authentication with advanced routes, a JWT token that is provided as a query parameter will not be proxied to the backend service.

#### Workaround

Pass the JWT token as a header instead of providing the JWT token as a query parameter.

---

## 1.2.0

### {{% icon-bug %}} A proxy deployed with a `specRef` field (OAS) and `basePathVersionAPpedRule` set to other than `NONE` may cause versions to appear twice in the deployed location block {#36666}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 36666    | Open   |
{{</bootstrap-table>}}

#### Description

If you add an API doc and reference it with the `specRef` field in the proxy object, the OAS (API doc) is used as the source of truth for the base path. If the OAS (API doc) contains the full correct base path, and you use any `basePathVersionAppendRule` value other than `NONE`, the base path will be corrupted by appending/prepending the version in the deployment (e.g. `/api/v3/v3`).

#### Workaround

If you are using an API doc with a proxy:

  1. Put the entire true base path of the API in the server section of the API doc:

      ```yaml
      Servers:
      - url: https://(API-address)/api/v3
      ```

      or

      ```yaml
      Servers:
      - url: /api/v3
      ```

      {{< note >}}In the example above only  `/api/v3` is relevant for this issue, and it should be the full base path to which the individual paths in the API document can be appended directly. {{< /note >}}

  2. Set the value of the base path version append rule (`basePathVersionAppendRule`) in the proxy to `NONE`.

---



## 1.0.0

### {{% icon-resolved %}} API Connectivity Manager module won't load if the Security Monitoring module is enabled {#39943}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status                          |
|----------|---------------------------------|
| 39943    | Fixed in Instance Manager 2.8.0 |
{{</bootstrap-table>}}

#### Description

If you have Instance Manager 2.7 or earlier installed and attempt to enable both the API Connectivity Manager and Security Monitoring modules on the same NGINX Management Suite management plane, the API Connectivity Manager module will not load because of incompatibility issues with the Security Monitoring module.

#### Workaround

Before enabling the API Connectivity Manager and Security Monitoring modules, ensure that your Instance Manager is upgraded to version 2.8 or later. Be sure to read the release notes for each module carefully, as they may contain important information about version dependencies.

To see which version of Instance Manager you have installed, run the following command:

- CentOS, RHEL, RPM-based:

   ```bash
   yum info nms-instance-manager
   ```

- Debian, Ubuntu, Deb-based:

   ```bash
   dpkg -s nms-instance-manager
   ```

---

### {{% icon-bug %}} PATCH on API Proxies endpoint is not implemented {#35771}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 35771    | Open   |
{{</bootstrap-table>}}

#### Description

The `PATCH` method for API proxies is listed in the API spec; however, this method hasn't been implemented yet.

#### Workaround

Use `PUT` instead for API proxies.

---

### {{% icon-bug %}} OIDC policy cannot be applied on a shared proxy cluster {#35337}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 35337    | Open   |
{{</bootstrap-table>}}

#### Description

If the same proxy cluster is used for both the Developer Portal and API Gateway, the OIDC Policy is not applied.

#### Workaround

Within an environment, use separate proxy clusters for the Developer Portal and API Gateway when applying an OIDC policy.

---

### {{% icon-bug %}} OpenID Connect Discovery is not implemented {#35186}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 35186    | Open   |
{{</bootstrap-table>}}

#### Description

The implementation to automatically fetch all the metadata from IDP's well-known endpoint is incomplete.  Though the option to specify the well-known endpoint exists in the OIDC policy, it is not functional. These endpoints have to be explicitly provided.

#### Workaround

Provide all the relevant endpoints -- such as Keys, Authorize, Token, Logoff, and Userinfo -- while configuring OIDC policy.

---

### {{% icon-bug %}} Error codes are not configurable for the OIDC policy {#34900}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 34900    | Open   |
{{</bootstrap-table>}}

#### Description

Adding custom error codes in the OIDC policy causes a validation error similar to the following example:

``` text
duplicate location \"/_oidc_err_85de2f20_default_411\
```

#### Workaround

Use the default error codes included in the OIDC policy.

---

### {{% icon-bug %}} Multiple hostnames on a single proxy cluster are not supported {#34457}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status |
|----------|--------|
| 34457    | Open   |
{{</bootstrap-table>}}

#### Description

The environment API allows an array of hostnames; however, this capability is not fully implemented.

#### Workaround

Use a single hostname per proxy cluster.

---

### {{% icon-resolved %}} CORS policy doesn't support proxying preflight requests to the backend when combined with an authentication policy {#34449}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID | Status         |
|----------|----------------|
| 34449    | Fixed in 1.6.0 |
{{</bootstrap-table>}}

#### Description

On an API Proxy with an authentication policy, applying a CORS policy with `preflightContinue=true` is not supported.

#### Workaround

Apply CORS policy and set `preflightContinue=false`.
