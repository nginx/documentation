---
description: Use the F5 NGINX Controller API Manager to add APIs and control how your
  APIs are exposed and consumed.
nd-docs: DOCS-569
title: Manage Your APIs
toc: true
weight: 110
type:
- tutorial
---

## Overview

The F5 NGINX Controller API Management module provides full life cycle management for your APIs. This document provides a walkthrough of the steps needed to create, version, and publish your API using the NGINX Controller API Management module. When you have completed this guide, you should have the following resources:

- An **API Definition**, which stores a collection of related API resources. It can be thought of as a folder.
- An **API Version**, which describes a particular API and serves as the data contract. It describes available endpoints and operations on each endpoint and can also include API documentation.
- A **Published API**, which represents an API Version that has been deployed to an NGINX Plus instance serving as an API Gateway.
- (Optional) API documentation available via the Developer Portal.

{{< note >}}

- You must have an API Management module license installed to complete the steps in this guide.
- The API Management module is available to users with the predefined [Admin or User Roles]({{< ref "/controller/platform/access-management/manage-roles.md#predefined-roles-and-role-groups" >}}).

{{< /note >}}

## Create an API Definition

An API Definition functions as a collection of related API resources.

1. Open the NGINX Controller user interface and log in.

2. Select the NGINX Controller menu icon, then select **Services**.

3. On the **Services** menu, select **APIs**.

4. On the **All APIs** page, select **Create** and choose **API Definition**. Alternatively, you can also select **Create API Definition** from the Quick Actions list.

## Create an API Version

An API Version describes a particular API. It can be thought of as an API specification.

1. Open the NGINX Controller user interface and log in.

2. Select the NGINX Controller menu icon, then select **Services**.

3. On the **Services** menu, select **APIs**.

4. On the **All APIs** page, select **Create** and choose **API Version**. Alternatively, you can also select **Create API Version** from the Quick Actions list.

5. Select an existing **API Definition** under which to group the API Version or select **Create New** to add a new **API Definition**.

6. Choose how you would like to describe the API:

    1. [OpenAPI specification](#import-an-openapi-specification)

    2. [Configure manually](#define-api-resources-manually)

    3. [WSDL file](#import-a-web-services-description-language-wsdl-file) (Currently only supports unauthenticated, unencrypted traffic)

7. Provide a version. If a version isn't provided, the default version `unspecified` is used.

8. (Optional) Provide a display name.

9. (Optional) Provide a description.

   {{< note >}}

   If your API specification includes a description, that text populates this field automatically when you [add your OpenAPI spec](#import-an-openapi-specification).

   {{< /note >}}

10. (Optional) Add tags.

### Import an OpenAPI Specification

The APIM module supports import of a valid OpenAPI v3 specification formatted as valid JSON or YAML.

{{< note >}}

If your API spec includes documentation elements, the "Enable documentation" option is selected automatically. You do not need to take any additional steps to document your API.

{{< /note >}}

**To import your spec by uploading a file:**

1. Select **OpenAPI Specification**.

2. Select **Import file**.

3. Drag and drop your file into the upload box, or select **Browse** to find and upload a file.

**To import your spec by copying and pasting:**

1. Select **OpenAPI Specification**.

2. Select **Copy and paste specification text**.

3. Paste or type your API in the space provided.

Once you have imported your API spec, select **Next** to continue to the **Resources** page.

### Define API Resources Manually

Take the steps below to manually add your API resources.

1. Select **Configure Manually**.

2. Select **Next** to continue to the **Resources** page.

3. Select **Add API Resource**.

4. Select the **Match Type** to use for the API resource path.

5. Specify the **Path** for the API resource.
**Tip**: Path should start with `/`, for example, `/userlookup/{userid}/attributes/{surname}`.

6. Select the HTTP method(s).

7. (Optional) [Document Your API](#document-your-api).

8. Review the API spec that will be submitted to create the **API Version**.

9. Select **Submit** to save the **API Version**.

### Document Your API

Follow the steps below to document your API.

{{< note >}}

API documentation must follow the OpenAPI 2.0/3.0 Specification.

If you uploaded an API spec that contains documentation, you don't need take any further steps to document your API.

{{< /note >}}

{{< tip >}}

Skip to step 6 if you're continuing from the [Define API Resources Manually](#define-api-resources-manually) section.

{{< /tip >}}

1. Open the NGINX Controller user interface and log in.

2. Select the NGINX Controller menu icon, then select **Services**.

3. On the **Services** menu, select **APIs**.

4. On the **All APIs** page, select the **API Version** for which you want to create documentation. Click the pencil (edit) button to edit the API Version.

5. Select **Resources**.

6. Select the pencil (edit) icon next to the method or methods that you want to document.

7. Select **Enable Documentation**.

8. Add a summary.

9. (Optional) Add a description.

10. (Optional) Add a request body description.

11. (Optional) Add a sample request.

12. Specify whether the request body is required.

13. To add a parameter, select **Add Parameter**.

14. Provide the parameter name.

15. (Optional) Provide a parameter description.

16. Select the parameter type.

17. Select the parameter value.

18. (Optional) Specify whether the parameter is required.

19. To add a response, select **Add Response**.

20. Provide the HTTP Response status code.

21. Provide a description.

22. (Optional) Provide a sample response in JSON format.

23. Select **Next** to review the API spec that will be submitted to update the **API Version**.

24. Select **Submit** to save the **API Version**.

### Import a Web Services Description Language (WSDL) file

   {{< caution >}}

Currently, only HTTP is supported for SOAP-REST proxy traffic.  Traffic will be unauthenticated and unencrypted, and as a result will be vulnerable to several security risks. It should be treated as a beta/preview feature.

   {{< /caution >}}

The APIM module supports importing a WSDL file that describes a SOAP service.

**To import your spec by uploading a file:**

1. Select **WSDL File**.

2. Select **Import file**.

3. Drag and drop your file into the upload box, or select **Browse** to find and upload a file.

**To import your spec by copying and pasting:**

1. Select **WSDL file**.

2. Select **Copy and paste WSDL text**.

3. Paste or type your API in the space provided.

Once you've imported your API spec, select **Next** to continue to the **Resources** page. Note that you need to submit the API spec before you can modify the **Resources** and **Schema**. Select **Submit** to save the **API Version.**

### Modify Schema and Resources for an API Version created from a WSDL file

Take the following steps to **Edit** add your API Version:

1. On the **All APIs** page, select the **API Version** that was created from a WSDL

2. Select **Next** to continue to the **Resources** page.

3. For each **SOAP operation**, choose the appropriate equivalent **REST Method**.

4. (optional) Modify the **Path** for the API resource as desired.

   {{< tip >}}

   Path should start with `/`, for example, `/userlookup/{userid}/attributes/{surname}`.

   {{< /tip >}}

5. Select **Next** to continue to the **Schema** page

6. (Optional) For each JSON schema, modify the **Property** as desired

7. Review the API spec that will be submitted to create the **API Version**.

8. Select **Submit** to save the **API Version**.

## Publish an API

You need at least one of each of the resources listed below to complete this section. If you haven't already created the required resources, you can do so while configuring the Published API.

- [Environment]({{< ref "/controller/services/manage-environments.md" >}})

- [Gateway]({{< ref "/controller/services/manage-gateways.md" >}})

- [App]({{< ref "/controller/app-delivery/manage-apps.md" >}})

- [Identity Provider]({{< ref "/controller/services/manage-identity-providers.md" >}})

 (required to add Authentication to the Published API Component).

{{< tip >}}
You can connect one or more [Developer Portals]({{< ref "/controller/api-management/manage-dev-portals.md" >}}) to your Published API to host your API documentation. This can be done either when creating or editing your Published API, or independently via the API Quick Actions menu.
{{< /tip >}}

### Add a Published API

1. Open the NGINX Controller user interface and log in.

2. Select the NGINX Controller menu icon, then select **Services**.

3. On the **Services** menu, select **APIs**.

4. On the **All APIs** page, select the **API Version** that you want to publish.

5. Select **Add Published API**.

#### Configure the Published API

On the **Create Published API** *Configuration* page:

1. Select the **API Definition Version** that you want to publish.

2. (Optional) Provide a **Base Path** for the Published API.

3. Specify whether the **Strip Base Path** parameter is required.

   {{< note >}}

   The `Strip Base Path` option modifies the path that is passed from the Gateway to the upstream host. When the option is selected, the base path will be removed from the original request when the request is passed to the upstream host. If the option is not selected, the original request -- including the base path -- is passed from the Gateway to the upstream host.

   {{< /note >}}

4. Provide a Name and/or Display Name for the Published API.

5. (Optional) Provide a description for the Published API.

6. (Optional) Add tags.

7. Select **Next**.

#### Define the Published API Deployment

For each of the steps below, you can create a new resource for the Published API by selecting the **Create New** link.

On the **Create Published API** *Deployment* page:

1. Select the **Environment** that the Published API belongs to.

2. Select the **App** that the Published API represents.

3. Select the **Gateway(s)** that will expose the Published API.

4. Select the **Dev Portal(s)** that will host documentation for the Published API.

5. Select **Next**.

#### Define the Routing Rules

On the **Create Published API** *Routing* page:

1. Select the **Add New** link to create a new App Component resource for the Published API.  The **Create App Component** page has multiple sections.

2. On the **Create App Component** *Configuration* page:

    1. Provide the name for your Component.

    2. (Optional) Provide a Display Name.

    3. (Optional) Provide a Description.

    4. (Optional) Add any desired tags.

    5. (Optional) Select the error response format.

    6. Select **Next**.

3. On the **Create App Component** *Workload Groups* page:

    1. Provide a Workload Group Name.

    2. (Optional) Select a Location. The default Location is 'Unspecified'. This value is applied automatically to "bring your own" (BYO) NGINX Plus instances that were not deployed by NGINX Controller.

    3. Define the backend workload URIs.

    4. (Optional) Define the DNS Server.

    5. (Optional) Select the Load Balancing Method. The default value is `Round Robin`.

    6. (Optional) Select the Session Persistence Type (applicable only to Web Components).

    7. (Optional) Select the Desired Proxy Settings (applicable only to Web Components).

    8. Select **Next**.
   {{< see-also >}}

   - Refer to the [Manage Locations]({{< ref "/controller/infrastructure/locations/manage-locations.md" >}}) topic for more information.

   - Refer to the [NGINX Plus Admin Guide](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/) for more information about the available options.

   {{< /see-also >}}
   {{< tip >}}
   Hover your pointer over the info icon for each setting to learn about the expected values and requirements.
   {{< /tip >}}


4. On the **Create App Component** *Rate Limiting* page:

    1. Enable Rate Limiting and select a **Key**.

    2. Select options for Rate and Units.

    3. (Optional) Select options for Excess Request Processing and Ignore Initial N Requests.

    4. Select options for Reject Status Code.

    5. Select **Next**.

5. On the **Create App Component** *Authentication* page:

    1. Select **Add Authentication**.

    2. Select an [**Identity Provider**]({{< ref "/controller/services/manage-identity-providers.md" >}}).

    3. Select a **Credential Location**.

        1. (Optional) Enable [**Conditional Access**]({{< ref "/controller/services/available-policies.md#conditional-access" >}}).

    4. Select **Next**.

{{< important >}}

The **Advanced Security** features require an *NGINX Controller API Management Advanced Security* license.

{{< /important >}}

6. On the **Create App Components** *Advanced Security* page:

    1. (Optional) Select **Enable Web Application Firewall (WAF)** to monitor and block suspicious requests or attacks.

    2. (Optional) Select **Monitor Only** to allow traffic to pass without being rejected. Security events are still generated and metrics are still collected. Refer to [About App Security Analytics]({{< ref "/controller/analytics/view-app-security-analytics.md" >}}) for more information.

    3. (Optional) Add the signature(s) that you want WAF to ignore. You can specify multiple signatures as a comma-separated list.

    4. Select **Next**

    {{< see-also >}} Refer to the [Default WAF Policy]({{< ref "/controller/app-delivery/security/concepts/app-sec-default-policy-original.md" >}}) topics to learn more about the default protection provided by NGINX App Protect. {{< /see-also >}}


7. On the **Create App Component** *Ingress* page:

    1. (Optional) Set the desired **Client Max Body Size**.
    2. Select **Next**.

   {{< see-also >}}

   Refer to the [NGINX module docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size) for more information about this option.

   {{< /see-also >}}


8. On the **Create App Component** *Monitoring* page:

    1. (Optional) Enable **Health Monitoring** and define the desired Monitoring Request and Response. Health Monitoring is disabled by default.

    2. (Optional) Specify the URI to use in health check requests (applicable only to Web Components). The default is `/`. For TCP/UDP Components, specify the Send string.

    3. (Optional) Specify the port to use when connecting to a server to perform a health check. The server port is used by default.

    4. (Optional) Set the interval to wait between two consecutive health checks. The default is 5 seconds.

    5. (Optional) Specify the number of consecutive passed health checks that must occur for a server to be considered healthy. The default is `1`.

    6. (Optional) Specify the number of consecutive failed health checks that must occur for a server to be considered unhealthy. The default is `1`.

    7. (Optional) Specify the default state for the server. The default state is `HEALTHY`.

    8. (Optional) Specify the starting HTTP status code to match against (applicable only to Web components).

    9. (Optional) Specify the ending HTTP status code to match against (applicable only to Web components).

    10. (Optional) Select whether a response should pass in order for the health check to pass (applicable only to Web components). By default, the response should have status code `2xx` or `3xx`.

    11. Select **Next**.

   {{< see-also >}}

   Refer to the [NGINX module docs](http://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check) for more information about these options.

    {{< /see-also >}}

9. On the **Create App Component** *Logs* page:

    1. (Optional) Select the logs to enable:

        § Error Log

        § Access Log

    2. (Optional) Specify the log format to use.

    3. Select **Next**.

   {{< see-also >}}

   Refer to the [NGINX docs](http://nginx.org/en/docs/http/ngx_http_log_module.html) for more information about these options.

   {{< /see-also >}}

9. On the **Create App Component** *Programmability* page:

   The following settings are applicable **only to Web components**.

    1. (Optional) Select **Add URI Redirects** and define the desired redirect condition(s).

    2. (Optional) Select **Add URI Rewrite** and define the desired rewrite pattern(s).

    3. (Optional) Select **Add Request Header Modification** and define how to modify the request header.

    4. (Optional) Select **Add Response Header Modification** and define how to modify the response header.

    5. Select **Next**.

   {{< see-also >}}

   Refer to the [NGINX module docs](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html) for more information about these options.

   {{< /see-also >}}

    6. Select **Next** to review the API spec that will be sent to create the App Component.

    7. Drag and drop resources one at a time, or move multiple resources by selecting the checkboxes next to the desired resources, from the **Unrouted** column to the desired Component in the **Components** list. You can use the search bar to narrow down the list.
   **Note:** Resources can be dragged between **Components** and back to the **Unrouted** section either one at a time or by multi-select.

    8. Select **Next** to review the API spec that will be sent to create the Published API.

    9. Select **Submit** to create the Published API.

## Create a Developer Portal

Once you have created an API Definition and a Published API, you can host your API in a Developer Portal.

From the **API Definitions** page, select **Create Dev Portal** from the Quick Actions menu. Then, follow the steps in [Create a Developer Portal]({{< ref "/controller/api-management/manage-dev-portals.md" >}}) to create, customize, and publish your Dev Portal.

{{< versions "3.0" "3.18" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
