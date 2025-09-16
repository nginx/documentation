---
description: This document is a summary of the known issues in F5 NGINX Management
  Suite API Connectivity Manager. Fixed issues are removed after **45 days**. <p>We
  recommend upgrading to the latest version of API Connectivity Manager to take advantage
  of new features, improvements, and bug fixes.</p>
nd-docs: DOCS-930
title: Known Issues
toc: true
weight: 200
type:
- reference
---


---

## 1.9.2
March 14, 2024

### {{% icon-bug %}} Helm chart backup and restore is broken {#44766}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 44766 | Open   |

{{</bootstrap-table>}}
#### Description
Helm backup and restore will not run in ACM-1.9.1 on NMS-2.15.x due to an underlying change in the dqlite client.

#### Workaround

None

---

## 1.9.1
October 05, 2023

### {{% icon-resolved %}} JWT tokens are overwritten when multiple proxies are assigned to one gateway {#44636}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 44636 | Fixed in API Connectivity Manager 1.9.2   |

{{</bootstrap-table>}}
#### Description
When multiple API proxies, each with its own JSON Web Token Assertion policy, are assigned to one gateway, the directives are overwritten by one another.

#### Workaround

None

---

## 1.9.0
September 07, 2023

### {{% icon-resolved %}} Module crashes when an OpenAPI spec is uploaded with a global security requirement that contains an empty security requirement object {#44393}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 44393 | Fixed in API Connectivity Manager 1.9.1   |

{{</bootstrap-table>}}
#### Description
API Connectivity Manager crashes when an OpenAPI specification file is uploaded with a global security requirement block containing an empty `security` object.

Example OpenAPI security requirement with empty security object:

```none
"security": [{}]
```

---

## 1.8.0
July 27, 2023

### {{% icon-resolved %}} Cannot use TLS enabled backend with HTTP backend-config policy {#44212}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 44212 | Fixed in API Connectivity Manager 1.9.0   |

{{</bootstrap-table>}}
#### Description
When configuring a backend-config policy with the transport protocol set to HTTP for an API, if TLS is enabled on that APIs backend, then the configuration will fail with the following error in the API Connectivity Manager log file:
  "Backend Config policy failed when checking transport protocol match because of: the backend-config policy transport protocol http does not match the proxy backend transport protocol https"

---

### {{% icon-resolved %}} Deployment fails due to duplicate locations {#43673}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 43673 | Fixed in API Connectivity Manager 1.9.0   |

{{</bootstrap-table>}}
#### Description
When more than one version of an API is published and Append Rule is set to "None", the deployment fails due to duplicate locations.

---

### {{% icon-resolved %}} Certificates associated with empty instance groups can be deleted, resulting in a broken reference in the API Connectivity Manager module {#43671}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 43671 | Fixed in API Connectivity Manager 1.9.0   |

{{</bootstrap-table>}}
#### Description
In the Instance Manager **Certificates and Keys** web interface, you can delete API Connectivity Manager TLS Policy certificates associated with empty instance groups. However, this action may lead to a broken reference problem in the API Connectivity Manager module, resulting in the inability to modify or delete the broken Environment from the web interface.

#### Workaround

You can delete the Environment using the API if it cannot be modified or deleted using the web interface.

---

## 1.7.0
June 21, 2023

### {{% icon-resolved %}} Environments with WAF enabled may transition to a Failed status when a Developer Portal cluster is added. {#43231}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 43231 | Fixed in API Connectivity Manager 1.8.0   |

{{</bootstrap-table>}}
#### Description
If you add a Developer Portal cluster to an environment that has WAF enabled, the environment may transition to a `Failed` status. If this happens, follow the steps in the workaround.

#### Workaround

On the Developer Portal:

1. Open an SSH connection to the Developer Portal and log in.
2. [Install F5 NGINX App Protect]({{< ref "/nap-waf/v4/admin-guide/install.md" >}}).
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

### {{% icon-resolved %}} Resources deployed to a Developer Portal which has had its database reset cannot be updated or removed {#43140}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 43140 | Fixed in API Connectivity Manager 1.9.0   |

{{</bootstrap-table>}}
#### Description
It is not possible to remove resources from API Connectivity Manager which have been published to a Developer Portal if the Developer Portal database is cleared.

---

## 1.6.0
May 11, 2023

### {{% icon-resolved %}} Multiple entries selected when gateway proxy hostnames are the same {#42515}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 42515 | Fixed in API Connectivity Manager 1.7.0   |

{{</bootstrap-table>}}
#### Description
Multiple entries are selected when gateway proxy hostnames are the same.

#### Workaround

There is no impact to functionality.

---

### {{% icon-resolved %}} The routes filter under the proxy metrics page won’t work with params {#42471}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 42471 | Fixed in API Connectivity Manager 1.7.0   |

{{</bootstrap-table>}}
#### Description
The routes filter under the proxy metrics page won’t work with params currently.

For example, `/api/v1/shops/{shopID}`

The API won’t match on the above route.

---

## 1.5.0
March 28, 2023

### {{% icon-bug %}} Using policies with targetPolicyName set to anything other than the default value can cause unexpected results. {#42682}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 42682 | Open   |

{{</bootstrap-table>}}
#### Description
Creating a policy with metadata of “targetPolicyName” set to anything but default can cause issues with secrets being duplicated if more than one policy is created. Setting this value to anything but the default value will also cause the policy to not be applied. The policy may be shown as applied in the UI when it is not.

#### Workaround

Do not modify the “targetPolicyName” to be anything but the default value.

---

### {{% icon-resolved %}} Array values in token claims are treated as string values {#42388}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 42388 | Fixed in API Connectivity Manager 1.6.0   |

{{</bootstrap-table>}}
#### Description
When an Access Control Routing match rule targeted a token value that contained an array, the array was collapsed into a comma-separated string. However, the expected behavior is for rules targeting arrays to pass if any value within the array matches the condition, rather than requiring the entire array to match.

---

### {{% icon-resolved %}} Developer Portal: When typing the links to use for the footer, the text boxes keep losing focus {#41626}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 41626 | Fixed in API Connectivity Manager 1.6.0   |

{{</bootstrap-table>}}
#### Description
The **Text to Display** and **URL** boxes on the Developer Portal's _Configure Footer_ page lose focus when text is being typed.

#### Workaround

You may need to click back into the boxes several times while typing to regain focus.

---

### {{% icon-resolved %}} TLS setting on listener is not reset when TLS policy is removed {#41426}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 41426 | Fixed in API Connectivity Manager 1.6.0   |

{{</bootstrap-table>}}
#### Description
When a TLS policy is removed from an environment, the web interface will not automatically adjust the TLS setting on the listener. As a result, the listener will remain in the `TLS enabled` state, leading to an unsuccessful attempt to save and publish the environment.

#### Workaround

Toggle the TLS setting in the web interface when removing the TLS policy from an environment.

---

## 1.4.0
January 23, 2023

### {{% icon-resolved %}} Cluster and Environment deletion issues when Portal Docs are published {#40163}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 40163 | Fixed in API Connectivity Manager 1.4.1   |

{{</bootstrap-table>}}
#### Description
When a developer portal proxy is hosting API documentation, the infrastructure admin is, in some cases, unable to delete clusters in other unrelated Environments and, therefore, unable to delete those same Environments.

---

### {{% icon-resolved %}} The Proxy Cluster API isn't ready to be used {#40097}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 40097 | Fixed in API Connectivity Manager 1.5.0   |

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

| Issue ID       | Status |
|----------------|--------|
| 40035 | Fixed in API Connectivity Manager 1.5.0   |

{{</bootstrap-table>}}
#### Description
When a new instance is onboarded, it will not be configured if any other instances are offline.

#### Workaround

After onboarding the instance as usual, push the existing configuration again to the new instance, without making any changes.

---

## 1.3.0
December 12, 2022

### {{% icon-resolved %}} OIDC policy cannot be applied alongside a proxy authentication policy {#39604}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 39604 | Fixed in API Connectivity Manager 1.4.0   |

{{</bootstrap-table>}}
#### Description
It is not possible to use both an OpenID Connect (OIDC) policy and a proxy authentication policy concurrently.

---

### {{% icon-resolved %}} The web interface doesn't pass the `enableSNI` property for the TLS backend policy {#39445}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 39445 | Fixed in API Connectivity Manager 1.3.1   |

{{</bootstrap-table>}}
#### Description
When configuring a TLS backend policy in the web interface, the new `enableSNI` property does not match the value of the deprecated `proxyServerName` property, resulting in an API error. The `enableSNI` value must be the same as `proxyServerName` value.

#### Workaround

Use the NGINX Management Suite API Connectivity Manager REST API to send a PUT request to the following endpoint, providing the correct values for `enableSNI` and `proxyServerName`. Both values must match.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                                                             |
|--------|--------------------------------------------------------------------------------------|
| PUT    | `/infrastructure/workspaces/{{infraWorkspaceName}}/environments/{{environmentName}}` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

---

### {{% icon-resolved %}} A JWT token present in a query parameter is not proxied to the backend for advanced routes  {#39328}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 39328 | Fixed in API Connectivity Manager 1.4.0   |

{{</bootstrap-table>}}
#### Description
When using JWT authentication with advanced routes, a JWT token that is provided as a query parameter will not be proxied to the backend service.

#### Workaround

Pass the JWT token as a header instead of providing the JWT token as a query parameter.

---

## 1.2.0
October 18, 2022

### {{% icon-resolved %}} Developer Portal backend information is unintentionally updated when editing clusters within an environment {#39409}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 39409 | Fixed in API Connectivity Manager 1.3.1   |

{{</bootstrap-table>}}
#### Description
The Developer Portal backend information may be inadvertently updated in the following circumstances:

1. If you have multiple Developer Portal clusters and update the backend information (for example, enable TLS or change the host or port, etc. ) for any of those clusters, the update is applied to all of the clusters.

2. If you have one or more Developer Portal clusters and update any other cluster in the environment (for example, the API Gateway or Developer Portal Internal cluster), the backend settings for the Developer Clusters are reset to their defaults (127.0.0.1/8080/no TSL).

#### Workaround

- Workaround for scenario #1

  Use the NGINX Management Suite API Connectivity Manager REST API to send a PUT request to the following endpoint with the correct backend settings for each Developer Portal cluster:

  {{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
  {{<bootstrap-table "table">}}
  | Method | Endpoint                                                                             |
  |--------|--------------------------------------------------------------------------------------|
  | PUT    | `/infrastructure/workspaces/{{infraWorkspaceName}}/environments/{{environmentName}}` |
  {{</bootstrap-table>}}
  {{< raw-html>}}</div>{{</raw-html>}}

- Workaround for scenario #2

  If you have just one Developer Portal cluster, you can use the web interface to update the backend settings for the cluster if you're not using the default settings.

  If you have more than one Developer Portal cluster, use the NGINX Management Suite API Connectivity Manager REST API to send a PUT request to the following endpoint with the correct backend settings for each cluster:

  {{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
  {{<bootstrap-table "table">}}
  | Method | Endpoint                                                                             |
  |--------|--------------------------------------------------------------------------------------|
  | PUT    | `/infrastructure/workspaces/{{infraWorkspaceName}}/environments/{{environmentName}}` |
  {{</bootstrap-table>}}
  {{< raw-html>}}</div>{{</raw-html>}}

---

### {{% icon-resolved %}} The user interface is erroneously including irrelevant information on the TLS inbound policy workflow {#38046}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 38046 | Fixed in API Connectivity Manager 1.3.0   |

{{</bootstrap-table>}}
#### Description
On the TLS inbound policy, toggling `Enable Client Verification` On/Off results in the user interface adding irrelevant information that causes the publish to fail due to validation error.

#### Workaround

Dismiss the policy without saving and restart the UI workflow to add the TLS inbound policy.

---

### {{% icon-resolved %}} Portals secured with TLS policy require additional environment configuration prior to publishing API docs {#38028}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 38028 | Fixed in API Connectivity Manager 1.3.0   |

{{</bootstrap-table>}}
#### Description
When the `tls-backend` policy is applied on a developer portal cluster, the communication between the portal UI and portal backend service is secured. By default, when the portal cluster is created, and the backend is not explicitly specified in the payload, it defaults to HTTP.   Adding the tls-backend policy does not automatically upgrade the protocol to HTTPS. If the protocol is not set to HTTPS, publishing API docs to the portal will fail. The user has to explicitly change the backend protocol to HTTPS.

#### Workaround

In the user interface, navigate to Workspace > Environment > Developer Portal Clusters > Edit Advanced Config. Select "edit the Backend" and toggle the Enable TLS switch to enabled.

---

### {{% icon-resolved %}}  A proxy deployed with a `specRef` field (OAS) and `basePathVersionAppendRule` set to other than `NONE` may cause versions to appear twice in the deployed location block {#36666}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 36666 | Fixed in API Connectivity Manager 1.9.0   |

{{</bootstrap-table>}}
#### Description
If you add an API doc and reference it with the `specRef` field in the proxy object, the OAS (API doc) is used as the source of truth for the base path. If the OAS (API doc) contains the full correct base path, and you use any `basePathVersionAppendRule` value other than `NONE`, the base path will be corrupted by appending/prepending the version in the deployment (e.g. `/api/v3/v3`).

#### Workaround

If you are using an API doc with a proxy:

  1. Put the entire true base path of the API in the server section of the API doc:

      ```nginx
      Servers:
      - url: https://(API-address)/api/v3
      ```

      or

      ```nginx
      Servers:
      - url: /api/v3
      ```

      {{< call-out "note" >}}In the example above only  `/api/v3` is relevant for this issue, and it should be the full base path to which the individual paths in the API document can be appended directly. {{< /call-out >}}

  2. Set the value of the base path version append rule (`basePathVersionAppendRule`) in the proxy to `NONE`.

---

### {{% icon-resolved %}} New users are unable to see pages even though they have been given access. {#36607}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 36607 | Fixed in API Connectivity Manager 1.3.0   |

{{</bootstrap-table>}}
#### Description
A newly created role needs a minimum of READ access on the LICENSING feature. Without this, the users will not have access to the pages even though they have been granted permission. They will see 403 errors surfacing as license errors while accessing the pages.

#### Workaround

Assign a minimum of READ access on the LICENSING feature to all new roles

---

## 1.1.0
August 18, 2022

### {{% icon-resolved %}} To see updates to the Listener's table, forced refresh of the cluster details page is required. {#36540}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 36540 | Fixed in API Connectivity Manager 1.2.0   |

{{</bootstrap-table>}}
#### Description
When trying to update the Advance Config for Environment cluster, changes are not reflected on the cluster details page after saving and submitting successfully.

#### Workaround

Refresh or reload the browser page to see changes on the cluster details page.

---

### {{% icon-resolved %}} Using labels to specify the backend is partially available {#36317}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 36317 | Fixed in API Connectivity Manager 1.2.0   |

{{</bootstrap-table>}}
#### Description
The `targetBackendServiceLabel`  label is not editable through the web interface. `targetBackendServiceLabel` is not configurable at the URI level in the spec.

#### Workaround

`targetBackendServiceLabel` label can be updated by sending a PUT command to the API.

---

### {{% icon-resolved %}} Ratelimit policy cannot be applied with OAuth2 JWT Assertion policy. {#36095}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 36095 | Fixed in API Connectivity Manager 1.2.0   |

{{</bootstrap-table>}}
#### Description
Rate limit policy cannot be applied with the OAuth2 JWT assertion policy.

---

### {{% icon-resolved %}} Enums are not supported in Advanced Routing. {#34854}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 34854 | Fixed in API Connectivity Manager 1.2.0   |

{{</bootstrap-table>}}
#### Description
Enums cannot be set for path or query parameters while applying advanced routing. A list of specific values cannot be specified for their advanced routing parameters.

---

## 1.0.0
July 19, 2022

### {{% icon-resolved %}} The API Connectivity Manager module won't load if the Security Monitoring module is enabled {#39943}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 39943 | Fixed in Instance Manager 2.8.0   |

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

### {{% icon-resolved %}} Credentials endpoint is disabled by default {#35630}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 35630 | Fixed in API Connectivity Manager 1.2.0   |

{{</bootstrap-table>}}
#### Description
For security reasons, the credentials endpoint on API Connectivity Manager(ACM) is disabled by default. To use the developer portal credentials workflow, configuration changes need to be made on the ACM host to enable credentials endpoints. Also, communication between ACM and the developer portal can be secured by providing certificates.

#### Workaround

To enable the credentials endpoints on ACM host

1. SSH to the ACM host
1. Enable resource credentials endpoint
  In {{/etc/nms/nginx/locations/nms-acm.conf}}, uncomment the location block

    ```nginx
    #Deployment of resource credentials from the devportal
    #  Uncomment this block when using devportal. Authentication is disabled
    #  for this location. This location block will mutually
    #  verify the client trying to access the credentials API.
    #  location = /api/v1/devportal/credentials {
    #    OIDC authentication (uncomment to disable)
    #    auth_jwt off;
    #    auth_basic off;
    #    error_page 401 /401_certs.json;
    #    if ($ssl_client_verify != SUCCESS) {
    #      return 401;
    #    }
    #    proxy_pass http://apim-service/api/v1/devportal/credentials;
    #}
    ```

1. Save the changes.
1. Reload NGINX on the ACM host: `nginx -s reload`

---

### {{% icon-resolved %}} Unable to delete an environment that is stuck in a Configuring state. {#35546}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 35546 | Fixed in API Connectivity Manager 1.2.0   |

{{</bootstrap-table>}}
#### Description
In the web interface, after deleting all of the proxy clusters is an environment that's in a `FAIL` state, the environment may transition to a `CONFIGURING` state and cannot be deleted.

#### Workaround

Add back the deleted proxy clusters using the web interface. The environment will transition to a `Fail` state. At this point, you can use the API to delete the proxy by sending a `DELETE` request to:

``` text
https://<NMS-FQDN>/api/acm/v1/infrastructure/workspaces/<infra-workspace-name>/environments/<environmentname>
```

---

### {{% icon-resolved %}} Installing NGINX Agent on Ubuntu 22.04 LTS fails with `404 Not Found` error {#35339}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 35339 | Fixed in API Connectivity Manager 1.3.0   |

{{</bootstrap-table>}}
#### Description
When installing the NGINX Agent on Ubuntu 22.04 LTS, the installation script fails with a `404 Not Found` error similar to the following:

```text
404 Not found [IP: <IP address>]
Reading package lists...
E: The repository 'https://192.0.2.0/packages-repository/deb/ubuntu jammy Release' does not have a Release file.
E: The repository 'https://pkgs.nginx.com/app-protect/ubuntu jammy Release' does not have a Release file.
E: The repository 'https://pkgs.nginx.com/app-protect-security-updates/ubuntu jammy Release' does not have a Release file.
```

#### Workaround

Edit the NGINX Agent install script to use the codename `focal` for Ubuntu 20.04.

1. Download the installation script:

    ```bash
    curl -k https://<NGINX-INSTANCE-MANAGER-FQDN>/install/nginx-agent > install.sh
    ```

2. Open the `install.sh` file for editing.
3. Make the following changes:

    On **lines 256-258**, change the following:

    ```text
    codename=$(cat /etc/*-release | grep '^DISTRIB_CODENAME' |
    sed 's/^[^=]*=\([^=]*\)/\1/' |
    tr '[:upper:]' '[:lower:]')
    ```

    to:

    ```text
    codename=focal
    ```

    <br>

    **—OR—**

    Alternatively, on **line 454**, change the following:

    ```text
    deb ${PACKAGES_URL}/deb/${os}/ ${codename} agent
    ```

    to:

    ```text
    deb ${PACKAGES_URL}/deb/${os}/ focal agent
    ```

4. Save the changes.
5. Run the `install.sh` script.

---

### {{% icon-bug %}} OIDC policy cannot be applied on a shared proxy cluster {#35337}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 35337 | Open   |

{{</bootstrap-table>}}
#### Description
If the same proxy cluster is used for both the Developer Portal and API Gateway, the OIDC Policy is not applied.

#### Workaround

Within an environment, use separate proxy clusters for the Developer Portal and API Gateway when applying an OIDC policy.

---

### {{% icon-resolved %}} No validation when conflicting policies are added {#34531}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 34531 | Fixed in API Connectivity Manager 1.3.0   |

{{</bootstrap-table>}}
#### Description
When securing the API Proxy with policies like basic authentication or APIKey authentication, the user is not warned if a duplicate or conflicting policy is already added. Conflicting policies are not validated.

#### Workaround

Secure the API proxy with only one policy.

---

### {{% icon-resolved %}} CORS policy doesn't support proxying preflight requests to the backend when combined with an authentication policy {#34449}

{{<bootstrap-table "table table-striped table-bordered">}}

| Issue ID       | Status |
|----------------|--------|
| 34449 | Fixed in API Connectivity Manager 1.6.0   |

{{</bootstrap-table>}}
#### Description
On an API Proxy with an authentication policy, applying a CORS policy with `preflightContinue=true` is not supported.

#### Workaround

Apply CORS policy and set `preflightContinue=false`.
