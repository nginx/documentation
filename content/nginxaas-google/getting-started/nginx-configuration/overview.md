---
title: Overview
weight: 50
toc: true
url: /nginxaas/google/getting-started/nginx-configuration/overview/
type:
- how-to
---


This document provides details about using NGINX configuration files with your
F5 NGINXaaS for Google Cloud deployment, restrictions, and available directives.

## NGINX configuration common user workflows

NGINX configurations can be uploaded to your NGINXaaS for Google Cloud deployment using the portal. The following documents provide detailed steps on how to upload NGINX configurations:

- [Upload using the portal]({{< ref "/nginxaas-google/getting-started/nginx-configuration/nginx-configuration-portal.md" >}})

The topics below provide information on NGINX configuration restrictions and directives that are supported by NGINXaaS for Google Cloud when using any of the above workflows.

## NGINX configuration automation workflows


## NGINX filesystem restrictions

NGINXaaS for Google Cloud places restrictions on the instance's filesystem; only a specific set of directories are allowed to be read from and written to. Below is a table describing what directories the NGINX worker process can read and write to and what directories files can be written to. These files include certificate files and any files uploaded to the deployment, excluding NGINX configuration files.

{{<bootstrap-table "table table-striped table-bordered">}}
  | Allowed Directory | NGINX worker process can read/write to | Files can be written to |
  |------------------ | ----------------- | ----------------- |
  |                   |                   |                   |
  |                   |                   |                   |
{{</bootstrap-table>}}

Attempts to access other directories will be denied and result in a `5xx` error.

## Disallowed configuration directives
Some directives are not supported because of specific limitations. If you include one of these directives in your NGINX configuration, you'll get an error.

{{<bootstrap-table "table table-striped table-bordered">}}
  | Disallowed Directive | Reason |
  |------------------ | ----------------- |
  |                   |                   |

{{</bootstrap-table>}}

You may find that a few directives are not listed here as either allowed or disallowed. Our team is working on getting these directives supported soon.

## Directives that cannot be overridden
Some directives cannot be overridden by the user provided configuration.

  {{<bootstrap-table "table table-striped table-bordered">}}
  | Persistent Directive | Value | Reason |
  |------------------ | ----------------------- | -----------------|
  |                   |                         |                  |
{{</bootstrap-table>}}


## NGINX listen port restrictions


## Configuration directives list

<details close>
<summary>Alphabetical index of directives</summary>

NGINXaaS for Google Cloud supports a limited set of NGINX directives.

TBD

</details>

<details close>
<summary>Lua dynamic module directives</summary>

TBD

</details>


<details close>
<summary>GeoIP2 dynamic module directives</summary>

TBD

</details>
