---
title: Template API Reference
description: Template reference for the App Delivery Manager Module.
weight: 400
toc: false
draft: false
tags: ["docs"]
docs: "DOCS-1150"
---

{{< custom-styles>}}

## Template Reference Documentation

The App Delivery Manager (ADM) implementation of [GO Templates](https://pkg.go.dev/text/template) includes a set of utility functions and variables to assist template writers in extending or enhancing the built-in templates that ship with the product. These enhancements are described below.

## Template Functions

### Third-Party Template Functions

To help with string manipulations, encodings, conversions, file paths, and math operations, the Sprig library has been built into the ADM GO template engine. More details on these functions can be obtained using the link below.

* [Sprig GoLang template functions](https://masterminds.github.io/sprig/)

### NGINX Template Functions

Additional NGINX custom functions are also built into the ADM GO template engine. These are unique to ADM and are described below.

* ***IsNGINXIpPort(string) bool*** - returns TRUE if the input string specifies an IPv4 or IPv6 address (with an optional port). This is useful for analyzing workload IPs.
* ***MD5(string) string*** - generates the md5 hash for a given input string.

## Template Variables

The ADM service makes available several variables for use in the templates. These variables are set during the rendering of the API request as it is being converted into the NGINX format and can also be used when customizing a template.

{{< note >}}
The template rendering is performed on a per-instance group basis. For example, if a gateway has three instance groups defined, then the rendering of the NGINX configuration will happen three times, once for each instance group.
{{</note>}}

### InstanceGroup Template Variables

{{< note >}}
These variables are used in the `instance-group` template.
{{</note>}}

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name                   | Purpose                                                                                                        |
|---------------------------------|----------------------------------------------------------------------------------------------------------------|
| v1.gatewayMainConfigs           | Collection of NGINX rendered config objects from each gateway that belongs in the NGINX main block.            |
| v1.gatewayHTTPConfigs           | Collection of NGINX rendered config objects from each gateway that belongs in the NGINX HTTP block.            |
| v1.gatewayStreamConfigs         | Collection of NGINX rendered config objects from each gateway that belongs in the NGINX stream block.          |
| v1.webComponentMainConfigs      | Collection of NGINX rendered config objects from each Web component that belongs in the NGINX main block.      |
| v1.webComponentHTTPConfigs      | Collection of NGINX rendered config objects from each Web component that belongs in the NGINX HTTP block.      |
| v1.tcpUdpComponentMainConfigs   | Collection of NGINX rendered config objects from each TCPUDP component that belongs in the NGINX main block.   |
| v1.tcpUdpComponentStreamConfigs | Collection of NGINX rendered config objects from each TCPUDP component that belongs in the NGINX stream block. |
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
| renderedNGINXConfig | NGINX rendered configuration associated with the object. |

{{</bootstrap-table>}}

### Gateway Template Variables

{{< note >}}
These variables are used in the `gateway` template.
{{</note>}}

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name      | Purpose                                                                                 |
|--------------------|-----------------------------------------------------------------------------------------|
| v1.uid             | UUID of the gateway.                                                                    |
| v1.name            | Name of the gateway.                                                                    |
| v1.environment     | Environment object associated with the gateway.                                         |
| v1.instanceGroup   | Instance Group object associated with this rendering.                                   |
| v1.servers         | Collection of Web Server objects associated with the gateway.                           |
| v1.customExtension | User defined objects specified in top level customExtensions object in the API request. |

{{</bootstrap-table>}}

#### Gateway Server Variables

Server block variables defined by the gateway (for HTTP server blocks).

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name   | Purpose                                                                                           |
|-----------------|---------------------------------------------------------------------------------------------------|
| serverName      | The virtual server name for the NGINX HTTP server_name directive, extracted from the Gateway URI. |
| webComponents   | Collection of Web Component Location objects associated with the HTTP server block.               |
| listens         | Collection of Listener objects associated with the the server block.                              |
| statusZone      | The autogenerated zone name for the NGINX status_zone directive.                                  |
| ssl             | SSL object associated with the server block.                                                      |
| customExtension | User defined objects specified in customExtensions object under the URI in the API request.       |

{{</bootstrap-table>}}

#### WebComponentLocation

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name               | Purpose                                                               |
|-----------------------------|-----------------------------------------------------------------------|
| uid                         | UUID of the associated Web Component.                                 |
| name                        | Name of the associated Web Component.                                 |
| renderedNGINXLocationBlocks | The NGINX rendered location blocks associated with the Web Component. |

{{</bootstrap-table>}}

### TCPUDP Component Template Variables

{{< note >}}
These variables are used by the `tcpudp-component` templates.
{{</note>}}

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name      | Purpose                                                                                 |
|--------------------|-----------------------------------------------------------------------------------------|
| v1.uid             | UUID of the component.                                                                  |
| v1.name            | Name of the component.                                                                  |
| v1.environment     | `Environment` object associated with the component.                                     |
| v1.app             | `App` object associated with the component.                                             |
| v1.servers         | Collection of Server objects associated with the component.                             |
| v1.upstreams       | Collection of the `Upstream` objects associated with component.                         |
| v1.instanceGroup   | Instance Group object associated with this rendering.                                   |
| v1.customExtension | User defined objects specified in top level customExtensions object in the API request. |

{{</bootstrap-table>}}

#### TCPUDP Component Server Variables

Server block variables defined by the TCPUDP components (for stream server blocks).

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name   | Purpose                                                                                        |
|-----------------|------------------------------------------------------------------------------------------------|
| proxyPass       | The autogenerated upstream name for the NGINX proxy_pass directive.                            |
| isTlsUpstream   | Indicates that proxy_ssl directive is enabled for the server block.                            |
| listens         | Collection of Listener objects associated with the the server block.                           |
| statusZone      | The autogenerated zone name for the NGINX status_zone directive.                               |
| ssl             | SSL object associated with the server block.                                                   |
| customExtension | User defined objects specified by the customExtension object under the URI in the API request. |

{{</bootstrap-table>}}

### Web Component Template Variables

{{< note >}}
These variables are used by the `web-component`, `web-component-locations` templates.
{{</note>}}

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name      | Purpose                                                                                 |
|--------------------|-----------------------------------------------------------------------------------------|
| v1.uid             | UUID of the component.                                                                  |
| v1.name            | Name of the component.                                                                  |
| v1.environment     | `Environment` object associated with the component.                                     |
| v1.app             | `App` object associated with the component.                                             |
| v1.locations       | Collection of `HTTPLocation` objects associated with the component.                     |
| v1.upstreams       | Collection of the `Upstream` objects associated with component.                         |
| v1.instanceGroup   | Instance Group object associated with this rendering.                                   |
| v1.customExtension | User defined objects specified in top level customExtensions object in the API request. |

{{</bootstrap-table>}}

#### HTTPLocation Variables

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable Name   | Purpose                                                                                        |
|-----------------|------------------------------------------------------------------------------------------------|
| nameExpression  | The combined name in the NGINX location directive format (uri + matchMethod).                  |
| proxyPass       | Name of the upstream associated with the uri.                                                  |
| statusZone      | The zone name for the NGINX status_zone directive.                                             |
| customExtension | User defined objects specified by the customExtension object under the URI in the API request. |

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
| isMetricsModuleInstalled | Indicates the ADM metric modules are installed on the NGINX instance group. |

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
| address       | The IPv4 or IPv6 address for the NGINX server block listen directive.  A '*' indicates the wildcard IP.      |
| port          | The port that will be used for the NGINX server block listen directive. For TCPUDP this can be a port range. |
| isUdpProtocol | Boolean flag for TCPUDP listeners to indicate whether the UDP protocol is being used.                        |

{{</bootstrap-table>}}

#### Upstreams

{{<bootstrap-table "table table-striped table-bordered">}}


| Variable Name   | Purpose                                                                                                  |
|-----------------|----------------------------------------------------------------------------------------------------------|
| name            | The name for the NGINX HTTP block upstream directive.                                                    |
| servers         | Collection of `Servers` objects associated with the NGINX HTTP block upstream directive.                 |
| loadBalancing   | Object associated with Load Balancing configuration for the NGINX HTTP block upstream directive.         |
| customExtension | User defined objects specified by the customExtension object under the WorkloadGroup in the API request. |
| tlsOptions      | TLS object associated with the TLS Server Name Indication Extension.                                     |

{{</bootstrap-table>}}


#### Servers

{{<bootstrap-table "table table-striped table-bordered">}}


| Variable Name | Purpose                                                                                                      |
|---------------|--------------------------------------------------------------------------------------------------------------|
| address       | The IPv4 or IPv6 address for the NGINX server block listen directive.  A '*' indicates the wildcard IP.      |
| port          | The port that will be used for the NGINX server block listen directive. For TCPUDP this can be a port range. |
| backup        | Sets the backup parameter of the Upstream server.                                                            |
| down          | Sets the down parameter of the Upstream server.                                                              |
| drain         | Sets the drain parameter of the Upstream server.                                                             |
| maxConns      | Sets the max_conns parameter of the Upstream server.                                                         |
| maxFails      | Sets the max_fails parameter of the Upstream server.                                                         |
| weight        | Sets the weight parameter of the Upstream server.                                                            |

{{</bootstrap-table>}}


#### TLSOptions

{{<bootstrap-table "table table-striped table-bordered">}}


| Variable Name | Purpose                                                |
|---------------|--------------------------------------------------------|
| isSNIEnabled  | Set using the isSNIEnabled setting in the API request. |

{{</bootstrap-table>}}

{{< note >}}
Currently, the following fields are not populated in the template input:
- Instance group name.
- Site name and UID.
- Environment name.
- App name.
{{< /note >}}