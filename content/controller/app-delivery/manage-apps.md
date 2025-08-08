---
description: Create, view, and edit Apps and Components.
nd-docs: DOCS-478
title: Manage Apps & Components
toc: true
weight: 300
type:
- how-to
---

## Overview

Follow the steps in this topic to learn how to create and manage Apps and App Components.

{{< call-out "tip" >}}You can also use the F5 NGINX Controller API to create Apps and Components. See the [NGINX Controller API Reference]({{< ref "/controller/api/_index.md" >}}) for details.{{< /call-out >}}
&nbsp;

## Before You Begin

You will need to select an [Environment]({{< ref "/controller/services/manage-environments.md#create-an-environment" >}}) and [Gateway]({{< ref "/controller/services/manage-gateways.md#create-a-gateway" >}}) -- or create new Environment and Gateway resources -- when adding a new App.

{{< call-out "note" >}}If you do not have permission to create these resources and none are available to select, contact your system administrator.{{< /call-out >}}
&nbsp;

## Create an App

To create an App:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Services**.
1. On the **Services** menu, select **Apps**.
1. On the **Apps** menu, select **Create App**.
1. On the **Create App** page, provide the following information:
   - Name
   - Environment
   - Description (Optional)
   - Display Name (Optional)
   - Tags (Optional)
1. Select **Submit**.

## Create a Component

To create a Component:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Services**.
1. On the **Services** menu, select **Apps**.
1. On the **Apps** menu, in the **Recent Apps** section, select the name of the App that you want to add the Component to.
1. On the Overview page for your App, select **Create Component**.
1. Then, complete each of the configuration sections as needed:

   - [General Configuration](#general-configuration)
   - [URIs](#uris)
   - [Workload Groups](#workload-groups)
   - [Ingress](#ingress)
   - [Backend](#backend)
   - [Monitoring](#monitoring)
   - [Errors and Logs](#errors-and-logs)
   - [Programmability](#programmability)
   - [Caching](#caching)
   - [Snippets](#snippets)
   - [Rate Limiting](#rate-limiting)
   - [Authentication](#authentication)
   - [Security](#security)

1. When ready, review the API Spec and then select **Submit** to create the Component.

## Configuration Options

### General Configuration

On the **Create App Component** *Configuration* page:

1. Select the App Component Type:

    - Web
    - TCP/UDP

1. Provide the name for your Component.
1. (Optional) Provide a Display Name.
1. (Optional) Provide a Description.
1. (Optional) Add any desired tags.
1. (Optional) Select a **Gateway Ref** or select **Create Gateway Ref** to create a new Gateway.
1. Select **Next**.

### URIs

A Component definition must contain one or more URIs.

**Web Component URIs** can be either of the following:

- a complete URI that follows the format `<schema://host>[:port][/path]`, or
- a relative path that follows the format `</path>[/...]`.

Relative paths inherit the host URI configured for the Gateway associated with the Component.
The host and relative path(s) defined for a Component take precedence over the host defined in the associated Gateway.

Example Web URI definitions:

- `http://www.f5.com:8080/sales`
- `http://*.f5.com:5050/test`
- `/images`
- `/*.jpg`
- `/locations/us/wa*`

**TCP/UDP URIs** must be a complete URI that follows the format `<tcp|udp|tcp+tls://*|IP:port|portRange>`.
TCP+TLS URIs can include TLS information.

Example TCP/UDP URI definitions:

- `tcp://192.168.1.1:12345`
- `tcp+tls://192.168.1.1:12346`
- `tcp://192.168.1.1:12345-12350`
- `tcp://*:12345`
- `udp://192.168.1.1:12345`
- `udp://*:12345`

On the **Create App Component** *URIs* page:

1. Define the **URIs**:

    - Select **Add URI**.
    - In the **URI** box, type the URI for the Component.
    - (Optional) Select a **Match Method** (applicable only to Web Components).
    - (Optional) Select **Customize for this URI** to add custom **TLS Settings**.

        {{< call-out "note" >}}
TLS Settings can be inherited from the Gateway, or customized at the Component level. Enable this option if you want the Component to use a different cert than that used by the Gateway.
        {{< /call-out >}}

1. (Optional) Define the **Shared TLS Settings**.

    - To use a cert that is already associated with the Gateway, select it from the list.
    - To add a new shared cert, select **Create New**.

1. Select **Next**.

### Workload Groups

On the **Create App Component** *Workload Groups* page:

1. Provide a Workload Group Name.
1. (Optional) Select a Location.

   The location determines which instances or instance groups the workload group is applied to. If any workload group specifies a location, they all must specify a location. Note: If the associated gateway uses instance groups, the location should refer to the instance group location, not the location(s) of the individual instances that make up that group.

   {{< call-out "note" >}}Refer to the [Manage Locations]({{< ref "/controller/infrastructure/locations/manage-locations.md" >}}) topic for more information.{{< /call-out>}}
1. Define the backend workload URIs.
1. (Optional) Define the DNS Server.
1. (Optional) Select the Load Balancing Method. The default value is "Round Robin".

   {{< call-out "note" >}}Refer to the [NGINX Plus Admin Guide](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/) for more information about the available options.{{< /call-out>}}

1. (Optional) Select the Session Persistence Type (applicable only to Web Components).
1. (Optional) Select the Desired Proxy Settings (applicable only to Web Components).

   {{< call-out "tip" >}}Hover your pointer over the info icon for each setting to learn about the expected values and requirements.{{< /call-out >}}
1. Select **Next**.

### Ingress

On the **Create App Component** *Ingress* page:

{{< call-out "note" >}} The following settings are applicable only to Web components. {{< /call-out >}}

1. (Optional) Select the supported HTTP methods.
1. (Optional) Set the desired **Client Max Body Size**.

    {{< call-out "note" >}}
Refer to the [`ngx_http_core_module` docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size) for more information about these options.
    {{< /call-out>}}

1. Select **Next**.

### Backend

On the **Create App Component** *Backend* page:

{{< call-out "note" >}} The following settings are applicable only to Web components. {{< /call-out >}}

1. (Optional) Enable [NTLM authentication](https://en.wikipedia.org/wiki/Integrated_Windows_Authentication) to allow proxying requests with NT LAN Manager (NTLM) Authentication.
1. (Optional) Specify the persistent state.
1. (Optional) Set the HTTP protocol version for proxying.
1. (Optional) Specify the Keep Alive settings:

    - **Connections**: Set the maximum number of idle keepalive connections to upstream servers that are preserved in the cache of each worker process. When this number is exceeded, the least recently used connections are closed.
    - **Requests per Connection**: Set the maximum number of requests that can be served through one keepalive connection. After the maximum number of requests is made, the connection is closed.
    - **Idle Timeout box**: Set a timeout during which an idle keepalive connection to an upstream server will stay open.
1. Select **Next**.

### Monitoring

On the **Create App Component** *Monitoring* page:

1. (Optional) Enable **Health Monitoring** and define the desired Monitoring Request and Response. Health Monitoring is disabled by default.
1. (Optional) Enable **Workload Health Events**. Workload Health Events are disabled by default.
1. (Optional) Specify the URI to use in health check requests (applicable only to Web Components). The default is `/`. For TCP/UDP Components, specify the Send string.
1. (Optional) Specify the port to use when connecting to a server to perform a health check. The server port is used by default.
1. (Optional) Set the interval to wait between two consecutive health checks. The default is 5 seconds.
1. (Optional) Specify the number of consecutive passed health checks that must occur for a server to be considered healthy. The default is 1.
1. (Optional) Specify the number of consecutive failed health checks that must occur for a server to be considered unhealthy. The default is 1.
1. (Optional) Specify the default state for the server. The default state is `HEALTHY`.
1. (Optional) Specify the starting HTTP status code to match against (applicable only to Web components).
1. (Optional) Specify the ending HTTP status code to match against (applicable only to Web components).
1. (Optional) Select whether a response should pass in order for the health check to pass (applicable only to Web components). By default, the response should have status code `2xx` or `3xx`.
1. Select **Next**.

    {{< call-out "note" >}}
Refer to the [`ngx_http_upstream_hc_module` docs](http://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check) for more information about these options.
    {{< /call-out>}}

### Errors and Logs

On the **Create App Component** *Logs* page:

1. (Optional) Select the logs to enable:

    - Error Log
    - Access Log

1. (Optional) Specify the log format to use.
1. Select **Next**.

    {{< call-out "note" >}}
Refer to the [`ngx_http_log_module` docs](http://nginx.org/en/docs/http/ngx_http_log_module.html) for more information about these options.
    {{< /call-out>}}

### Programmability

On the **Create App Component** *Programmability* page:

{{< call-out "note" >}} The following settings are applicable only to Web components. {{< /call-out >}}

1. (Optional) Select **Add URI Redirects** and define the desired redirect condition(s).
1. (Optional) Select **Add URI Rewrite** and define the desired rewrite pattern(s).
1. (Optional) Select **Add Request Header Modification** and define how to modify the request header.
1. (Optional) Select **Add Response Header Modification** and define how to modify the response header.
1. Select **Next**.

    {{< call-out "note" >}}
Refer to the [`ngx_http_rewrite_module` docs](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html) for more information about these options.
    {{< /call-out>}}

### Caching

{{< call-out "note" >}}
Introduced in NGINX Controller App Delivery module v3.22.
{{< /call-out >}}

On the **Create App Component** *Caching* page:

1. Select the *Enable Caching* toggle to turn on caching.
1. Define the *Split Config* settings as appropriate for your component.

   - **PERCENTAGE** -- Select if you want to split the cache across two or more disk stores and assign a percentage of the store to each location.  The *key* field is not required for this option if users set only one disk.
   - **STRING** -- Select if you want to split the cache across two or more disk stores using pattern matching. The *key* field is required for this option.

     {{< call-out "note" >}}The *key* string must contain at least one valid [NGINX variable](https://nginx.org/en/docs/varindex.html). Example: `${request_uri}`{{< /call-out >}}

1. Define the desired settings for the Disk Store:

   - **Path**: This is the location where the cache will be stored; this path must already exist on the data plane.
   - **Max Size**
   - **Min Free**
   - **In Memory Store Size**
   - **Is Default**
   - **Temp Path** (Optional)
   - **Inactive Time** (Optional)
   - **Directory Level** (Optional)
   - **Trim Policy** (Optional)
   - **Loader Policy** (Optional)
   - **Purger Policy** (Optional)

   {{< call-out "note" >}}Refer to the [`proxy_cache_path` docs](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) for more information about these options.{{< /call-out>}}

1. Select *Add Disk Store* to add another disk store (Optional).
   This will split the cache across multiple storage locations according to the *Split Config* criteria you selected.

   The following *Split Config* options will display depending on the criteria you selected:
   - **Percent Criteria** - Required when using "PERCENTAGE" criteria type; must be an integer followed by the `%` symbol; decimals are supported; for example, `75%` or `50.5%`.
   - **String Criteria** - Required when using "STRING" criteria type; Depending upon the `SplitConfig`-> `Key` it could be a string like `~/html`, `~*.html$'` or IP based string like `10.1.1.2`

1. Select **Next** to go to the next page, or **Submit** to save and submit your changes.

### Snippets

{{< call-out "note" >}}
Introduced in NGINX Controller App Delivery module v3.22.
{{< /call-out >}}

Refer to the [About Snippets]({{< ref "/controller/app-delivery/about-snippets.md" >}}) topic to learn more about Snippets and how they impact the NGINX Controller-generated `nginx.conf` file.

On the **Create App Component** *Snippets* page:

1. Select the appropriate snippet type:

    - *Add URI Snippet*: Adds NGINX directives to the component's `server` and `location` blocks.
    - *Add Workload Group Snippet*: Adds NGINX directives to the component's `upstream` block(s).

1. Paste or type the desired snippet into the text field.

   Snippets should follow the standard `nginx.conf` format.
   For example, the below URI snippet adds the `proxy_set_header` directive to the component's `server` block.

   ```Nginx configuration file
   proxy_set_header Host $proxy_host;
   ```

   {{< call-out "caution"  >}}When you use Snippets to customize your NGINX configuration, your changes are applied to the `nginx.conf` file *as is*. NGINX Controller does not verify that your configuration is valid before applying the snippet. We strongly recommend verifying Snippets in a lab environment before making any changes in production.{{< /call-out >}}

1. Select **Next** to preview the REST API call for your component, or **Submit** to save and submit your changes.

### Rate Limiting

On the **Create App Component** *Rate Limiting* page:

{{< call-out "note" >}} The following Rate Limiting settings are applicable only to Web components. {{< /call-out >}}

1. Enable Rate Limiting and select a **Key**.
1. Select options for Rate and Units.
1. (Optional) Select options for Excess Request Processing and Ignore Initial N Requests.
1. Select options for Reject Status Code.
1. Select **Next**.

### Authentication

On the **Create App Component** *Authentication* page:

1. Select **Add Authentication**.
1. Select an [**Identity Provider**]({{< ref "/controller/services/manage-identity-providers.md" >}}).
1. Select a **Credential Location**.
1. (Optional) Enable [**Conditional Access**]({{< ref "/controller/services/available-policies.md#conditional-access" >}}).
1. Select **Next**.

### Security

On the **Create App Component** *Security* page:

{{< call-out "note" >}} The following Security settings are applicable only to Web components. {{< /call-out >}}

1. (Optional) Select **Enable Web Application Firewall (WAF)** to watch for or block suspicious requests or attacks.
1. (Optional) Select **Monitor Only** to allow traffic to pass without being rejected. Security events are still generated and metrics are still collected. Refer to [About App Security Analytics]({{< ref "/controller/analytics/view-app-security-analytics.md#overview" >}}) for more information.
1. (Optional) the signature(s) that you want the WAF to ignore. You can specify multiple signatures as a comma-separated list.
1. Select **Next**.

{{< call-out "note" >}}
Refer to the [Secure Your Apps]({{< ref "/controller/app-delivery/security/_index.md" >}}) topics to learn more about WAF and the default protections provided by NGINX App Protect.
{{< /call-out>}}

## Edit or Delete Apps and Components

To view, edit, and delete Apps:

1. Open the NGINX Controller user interface and log in.
1. Select the **NGINX Controller menu icon** > **Services** > **Apps**.
1. On the **Apps** menu, select **Overview**. The **Apps Overview** page is displayed and shows a list of your Apps.
1. To view the details for an App, including metrics data and components, select the App name in the list of Apps.
1. To edit the App, select **Edit Config** on the **Quick Actions** menu.
1. To delete the App, select **Delete Config** on the **Quick Action**s menu.

To edit or delete a Component:

1. Open the NGINX Controller user interface and log in.
1. Select the **NGINX Controller menu icon** > **Services** > **Apps**.
1. On the **Apps** menu, select **Overview**. The **Apps Overview** page is displayed and shows a list of your Apps.
1. Select the App that contains the Component that you want to modify. The App's **Overview** page is displayed.
1. In the details panel for your App, select **Components**.
1. On the **Components** page, select the Component that you want to modify.
1. To edit the Component, select **Edit Config** on the **Quick Actions** menu.
1. To delete the Component, select **Delete Config** on the **Quick Actions** menu.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
