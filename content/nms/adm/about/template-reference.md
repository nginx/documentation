---
title: Template API Reference
description: Learn how to customize and extend App Delivery Manager's built-in templates using a specialized set of utility functions and variables.
weight: 200
toc: true
draft: false
tags: ["docs"]
docs: "DOCS-1150"
---

{{< custom-styles>}}

## Overview

With the App Delivery Manager implementation of [Go Templates](https://pkg.Go.dev/text/template), template writers can extend or enhance the built-in templates that ship with the product using a set of utility functions and variables. These enhancements are described below.

---

## Template Functions

### Third-Party Template Functions

A library called Sprig has been integrated into App Delivery Manager's Go template engine to assist with string manipulations, encodings, conversions, file paths, and math operations. You can learn more about these functions by clicking on the link below.

{{< see-also >}}[Sprig GoLang template functions](https://masterminds.github.io/sprig/){{< /see-also>}}

### NGINX Template Functions

App Delivery Manager's Go template engine also includes custom NGINX functions. These functions, unique to App Delivery Manager, are described below.

- ***IsNGINXIpPort(string) bool*** - returns `TRUE`` if the input string specifies an IPv4 or IPv6 address (with an optional port). This is useful for analyzing workload IPs.
- ***MD5(string) string*** - generates the MD5 hash for a given input string.

---
## Template Variables

App Delivery Manager provides several variables for use in templates. These variables are set when the API request is rendered and converted into the NGINX format. You can also use these variables when customizing a template.

{{< note >}}
Templates are rendered for each instance group. So, for example, if a gateway has three instance groups, the NGINX configuration will be rendered three times -- one for each group.
{{</note>}}

### InstanceGroup Template Variables

{{< note >}}
These variables are used in the `instance-group` template.
{{</note>}}

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name                   | Purpose                                                                                                        |
|---------------------------------|----------------------------------------------------------------------------------------------------------------|
| v1.gatewayMainConfigs           | Collection of NGINX-rendered config objects from each gateway that belongs in the NGINX main block.            |
| v1.gatewayHTTPConfigs           | Collection of NGINX-rendered config objects from each gateway that belongs in the NGINX HTTP block.            |
| v1.gatewayStreamConfigs         | Collection of NGINX-rendered config objects from each gateway that belongs in the NGINX stream block.          |
| v1.webComponentMainConfigs      | Collection of NGINX-rendered config objects from each web component that belongs in the NGINX main block.      |
| v1.webComponentHTTPConfigs      | Collection of NGINX-rendered config objects from each web component that belongs in the NGINX HTTP block.      |
| v1.tcpUdpComponentMainConfigs   | Collection of NGINX-rendered config objects from each TCP/UDP component that belongs in the NGINX main block.   |
| v1.tcpUdpComponentStreamConfigs | Collection of NGINX-rendered config objects from each TCP/UDP component that belongs in the NGINX stream block. |
| v1.instanceGroup                | Instance Group object associated with this rendering.                                                          |
{{</bootstrap-table>}}

{{< note >}}
The Instance Group object definitions can be found in the [Common Template Variables and Objects](#instancegroup) section.
{{</note>}}

#### Config Variables

The configuration objects mentioned above all share the same definition as shown below:

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name       | Purpose                                                  |
|---------------------|----------------------------------------------------------|
| uid                 | UUID of the specific object.                             |
| name                | Name of the object.                                      |
| renderedNGINXConfig | NGINX-rendered configuration associated with the object. |

{{</bootstrap-table>}}

### Gateway Template Variables

{{< note >}}
These variables are used in the `gateway` template.
{{</note>}}

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name       | Purpose                                                                                    |
|---------------------|--------------------------------------------------------------------------------------------|
| v1.uid              | UUID of the gateway.                                                                       |
| v1.name             | Name of the gateway.                                                                       |
| v1.environment      | Environment object associated with the gateway.                                            |
| v1.instanceGroup    | Instance Group object associated with this rendering.                                      |
| v1.servers          | Collection of Web Server objects associated with the gateway.                              |
| v1.customExtensions | User-defined objects specified in the top-level `customExtensions` object in the API request. |

{{</bootstrap-table>}}

#### Gateway Server Variables

Server block variables defined by the gateway (for HTTP server blocks).

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name          | Purpose                                                                                           |
|------------------------|---------------------------------------------------------------------------------------------------|
| serverName             | The virtual server name for the NGINX HTTP `server_name`` directive, extracted from the gateway URI. |
| webComponents          | Collection of Web Component Location objects associated with the HTTP server block.               |
| listens                | Collection of Listener objects associated with the the server block.                              |
| statusZone             | The autogenerated zone name for the NGINX `status_zone` directive.                                  |
| ssl                    | SSL object associated with the server block.                                                      |
| customExtensions       | User-defined objects specified in `customExtensions` object under the URI in the API request.       |
| mergedCustomExtensions | The result of merging URI-level with Gateway-level `customExtensions` objects.<br>If both objects contain the same key, the URI-level value will be used.                                                                                   |     

{{</bootstrap-table>}}

#### WebComponentLocation

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name               | Purpose                                                               |
|-----------------------------|-----------------------------------------------------------------------|
| uid                         | UUID of the associated web component.                                 |
| name                        | Name of the associated web component.                                 |
| renderedNGINXLocationBlocks | The NGINX-rendered location blocks associated with the web component. |

{{</bootstrap-table>}}

### TCP/UDP Component Template Variables

{{< note >}}
These variables are used by the `tcpudp-component` templates.
{{</note>}}

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name       | Purpose                                                                                 |
|---------------------|-----------------------------------------------------------------------------------------|
| v1.uid              | UUID of the component.                                                                  |
| v1.name             | Name of the component.                                                                  |
| v1.environment      | `Environment` object associated with the component.                                     |
| v1.app              | `App` object associated with the component.                                             |
| v1.servers          | Collection of Server objects associated with the component.                             |
| v1.upstreams        | Collection of the `Upstream` objects associated with component.                         |
| v1.instanceGroup    | Instance Group object associated with this rendering.                                   |
| v1.customExtensions | User-defined objects specified in the top-level `customExtensions` object in the API request. |

{{</bootstrap-table>}}

#### TCP/UDP Component Server Variables

Server block variables defined by the TCP/UDP components (for stream server blocks).

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name          | Purpose                                                                                                |
|------------------------|--------------------------------------------------------------------------------------------------------|
| proxyPass              | The autogenerated upstream name for the NGINX `proxy_pass` directive.                                    |
| isTlsUpstream          | Indicates that `proxy_ssl` directive is enabled for the server block.                                    |
| listens                | Collection of Listener objects associated with the the server block.                                   |
| statusZone             | The autogenerated zone name for the NGINX `status_zone` directive.                                       |
| ssl                    | SSL object associated with the server block.                                                           |
| customExtensions       | User-defined objects specified by the `customExtensions` object under the URI in the API request.        |
| mergedCustomExtensions | The result of merging URI-level with TCP/UDP-Component-level customExtensions objects.<br>If both objects contain the same key, the URI-level value will be used.                                                                                |  

{{</bootstrap-table>}}

### Web Component Template Variables

{{< note >}}
These variables are used by the `web-component`, `web-component-locations` templates.
{{</note>}}

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name       | Purpose                                                                                 |
|---------------------|-----------------------------------------------------------------------------------------|
| v1.uid              | UUID of the component.                                                                  |
| v1.name             | Name of the component.                                                                  |
| v1.environment      | `Environment` object associated with the component.                                     |
| v1.app              | `App` object associated with the component.                                             |
| v1.locations        | Collection of `HTTPLocation` objects associated with the component.                     |
| v1.upstreams        | Collection of the `Upstream` objects associated with component.                         |
| v1.instanceGroup    | Instance Group object associated with this rendering.                                   |
| v1.customExtensions | User-defined objects specified in the top-level customExtensions object in the API request. |

{{</bootstrap-table>}}

#### HTTPLocation Variables

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name           | Purpose                                                                                         |
|-------------------------|-------------------------------------------------------------------------------------------------|
| nameExpression          | The combined name in the NGINX location directive format (uri + matchMethod).                   |
| proxyPass               | Name of the upstream associated with the uri.                                                   |
| statusZone              | The zone name for the NGINX status_zone directive.                                              |
| customExtensions        | User defined objects specified by the customExtensions object under the URI in the API request. |
| mergedCustomExtensions | The result of merging URI-level with web-component-level `customExtensions` objects. <br>If both objects contain the same key, the URI-level value will be used.                                                                             |  

{{</bootstrap-table>}}

### Common Template Variables and Objects

#### Environment

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name | Purpose                  |
|---------------|--------------------------|
| uid           | UUID of the environment. |
| name          | Name of the environment. |

{{</bootstrap-table>}}

#### App

{{<bootstrap-table "table table-striped table-bordered">}}


| Variable Name | Purpose          |
|---------------|------------------|
| uid           | UUID of the app. |
| name          | Name of the app. |

{{</bootstrap-table>}}

#### InstanceGroup

The Instance Group object is set to the instance group that is currently being rendered.

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name            | Purpose                                                                     |
|--------------------------|-----------------------------------------------------------------------------|
| uid                      | UUID of the instance group.                                                 |
| name                     | Name of the instance group.                                                 |
| site                     | Site variables associated with the instance group.                          |
| isMetricsModuleInstalled | Indicates the App Delivery Manager metric modules are installed on the NGINX instance group. |

{{</bootstrap-table>}}

#### Site

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name | Purpose                                             |
|---------------|-----------------------------------------------------|
| uid           | UUID of the site associated with an Instance Group. |
| name          | Name of the site.                                   |

{{</bootstrap-table>}}

#### SSL

{{<bootstrap-table "table table-striped table-bordered">}}


| Variable Name  | Purpose                |
|----------------|------------------------|
| certificate    | Certificate file path. |
| certificateKey | Private key file path. |

{{</bootstrap-table>}}

#### Listens

{{<bootstrap-table "table table-striped table-bordered">}}


| Variable Name | Purpose                                                                                                      |
|---------------|--------------------------------------------------------------------------------------------------------------|
| address       | The IPv4 or IPv6 address for the NGINX server block `listen` directive.  A `*`` indicates the wildcard IP.      |
| port          | The port that will be used for the NGINX server block `listen` directive. For TCP/UDP this can be a port range. |
| isUdpProtocol | Boolean flag for TCP/UDP listeners to indicate whether the UDP protocol is being used.                        |

{{</bootstrap-table>}}

#### Upstreams

{{<bootstrap-table "table table-striped table-bordered">}}


| Variable Name    | Purpose                                                                                                   |
|------------------|-----------------------------------------------------------------------------------------------------------|
| name             | The name for the NGINX HTTP block upstream directive.                                                     |
| servers          | Collection of `Servers` objects associated with the NGINX HTTP block `upstream` directive.                  |
| loadBalancing    | Object associated with Load Balancing configuration for the NGINX HTTP block `upstream` directive.          |
| customExtensions | User-defined objects specified by the `customExtensions` object under the WorkloadGroup in the API request. |
| tlsOptions       | TLS object associated with the TLS Server Name Indication Extension.                                      |

{{</bootstrap-table>}}


#### Servers

{{<bootstrap-table "table table-striped table-bordered">}}


| Variable Name | Purpose                                                                                                      |
|---------------|--------------------------------------------------------------------------------------------------------------|
| address       | The IPv4 or IPv6 address for the NGINX server block `listen` directive.  A `*`` indicates the wildcard IP.      |
| port          | The port that will be used for the NGINX server block `listen` directive. For TCP/UDP this can be a port range. |
| backup        | Sets the `backup` parameter of the upstream server.                                                            |
| down          | Sets the `down` parameter of the upstream server.                                                              |
| drain         | Sets the `drain` parameter of the upstream server.                                                             |
| maxConns      | Sets the `max_conns` parameter of the upstream server.                                                         |
| maxFails      | Sets the `max_fails` parameter of the upstream server.                                                         |
| weight        | Sets the `weight` parameter of the upstream server.                                                            |

{{</bootstrap-table>}}


#### TLSOptions

{{<bootstrap-table "table table-striped table-bordered">}}


| Variable Name | Purpose                                                |
|---------------|--------------------------------------------------------|
| isSNIEnabled  | Set using the `isSNIEnabled` setting in the API request. |

{{</bootstrap-table>}}

{{< note >}}
Currently, the following fields are not populated in the template input:
- Instance group name
- Site name and UID
- Environment name
- App name
{{< /note >}}
