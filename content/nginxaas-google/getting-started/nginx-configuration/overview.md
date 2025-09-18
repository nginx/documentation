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

There are limits to where files, including NGINX configuration files, certificate files, and any other files uploaded to the deployment, can be placed on the filesystem. There are also limits on what directories NGINX can access during runtime. These limits help support the separation of roles, enforce the principal of least privilege, and ensure the smooth operation of the system.

{{<table variant="narrow" theme="bordered">}}
  | Allowed Directory   |  User can upload files to | NGINX master process can read | NGINX master process can write | NGINX worker process can read | NGINX worker process can write |
  | -------------------- | -------------------- | -------------------- | -------------------- | -------------------- | -------------------- |
  | /etc/nginx           | {{< icon "check" >}} | {{< icon "check" >}} |                      |                      |                      |
  | /opt                 | {{< icon "check" >}} | {{< icon "check" >}} | {{< icon "check" >}} | {{< icon "check" >}} | {{< icon "check" >}} |
  | /srv                 | {{< icon "check" >}} | {{< icon "check" >}} |                      | {{< icon "check" >}} |                      |
  | /tmp                 |                      | {{< icon "check" >}} | {{< icon "check" >}} | {{< icon "check" >}} | {{< icon "check" >}} |
  | /spool/nginx         |                      | {{< icon "check" >}} |                      | {{< icon "check" >}} | {{< icon "check" >}} |
  | /var/cache/nginx     |                      | {{< icon "check" >}} | {{< icon "check" >}} | {{< icon "check" >}} | {{< icon "check" >}} |
  | /var/log/nginx       |                      | {{< icon "check" >}} | {{< icon "check" >}} |                      |                      |
  | /var/spool/nginx     |                      | {{< icon "check" >}} |                      | {{< icon "check" >}} | {{< icon "check" >}} |
  | /var/www             | {{< icon "check" >}} | {{< icon "check" >}} |                      | {{< icon "check" >}} |                      |
{{< /table >}}

For example, `/etc/nginx` is only readable by the NGINX master process, making it a secure location for certificate files that won't be accidentally served due to configuration errors. `/var/www` is a secure location for static content because the NGINX worker process can serve files from it but cannot modify them, ensuring content integrity. `/tmp` is a good choice for storing temporary files with `proxy_temp_path` or `client_body_temp_path` since it is writable by the NGINX worker process.

If you need access to additional directories, please [contact us]({{< ref "/nginxaas-google/get-help.md" >}}).

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
