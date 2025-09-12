---
title: Overview
weight: 50
toc: true
url: /nginxaas/azure/getting-started/nginx-configuration/overview/
type:
- how-to
---

This document provides details about using NGINX configuration files with your
F5 NGINXaaS for Azure deployment, restrictions, and available directives.

## NGINX configuration common user workflows

NGINX configurations can be uploaded to your NGINXaaS for Azure deployment using the Azure portal, Azure CLI, or Terraform. The following documents provide detailed steps on how to upload NGINX configurations:

- [Upload using the Azure portal]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md" >}})
- [Upload using the Azure CLI]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-azure-cli" >}})
- [Upload using Terraform]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configurations-terraform.md" >}})

The topics below provide information on NGINX configuration restrictions and directives that are supported by NGINXaaS for Azure when using any of the above workflows.

## NGINX configuration automation workflows

NGINX configurations stored in GitHub can be applied to existing NGINXaaS for Azure deployments using custom GitHub Action workflows. See [NGINXaaS for Azure Deployment Action](https://github.com/nginxinc/nginx-for-azure-deploy-action) for documentation and examples on how to incorporate these workflows in your GitHub Actions CI/CD pipelines.

## NGINX filesystem restrictions
NGINXaaS for Azure places restrictions on the instance's filesystem; only a specific set of directories are allowed to be read from and written to. Below is a table describing what directories the NGINX worker process can read and write to and what directories files can be written to. These files include certificate files and any files uploaded to the deployment, excluding NGINX configuration files.

  {{< table >}}
  | Allowed Directory | NGINX worker process can read/write to | Files can be written to |
  |------------------ | ----------------- | ----------------- |
  | /etc/nginx        |                   | &check;           |
  | /opt              | &check;           | &check;           |
  | /srv              | &check;           | &check;           |
  | /tmp              | &check;           |                   |
  | /var/cache/nginx  | &check;           |                   |
  | /var/www          | &check;           | &check;           |
{{< /table >}}

Attempts to access other directories will be denied and result in a `5xx` error.

## Disallowed configuration directives
Some directives are not supported because of specific limitations. If you include one of these directives in your NGINX configuration, you'll get an error.

  {{< table >}}
  | Disallowed Directive | Reason |
  |------------------ | ----------------- |
  | ssl_engine        | No hardware SSL accelerator is available. |
  | debug_points        | NGINXaaS does not provide access to NGINX processes for debugging. |
  | fastcgi_bind <br /> grpc_bind  <br /> memcached_bind  <br /> proxy_bind  <br /> scgi_bind  <br /> uwsgi_bind   | Source IP specification for active-active deployments is not allowed.           |
  | quic_bpf          | QUIC connection migration is not currently supported for active-active deployments.  |

{{< /table >}}

You may find that a few directives are not listed here as either allowed or disallowed. Our team is working on getting these directives supported soon.

## Directives that cannot be overridden
Some directives cannot be overridden by the user provided configuration.

  {{< table >}}
  | Persistent Directive | Value | Reason |
  |------------------ | ----------------------- | -----------------|
  | `user` | `nginx` | The `nginx` user has the correct permissions for accessing certificates, policy files and other auxfiles. |
  | `worker_processes` | `auto` | Set to `auto` to automatically set `worker_processes` to the number of CPU cores. |
  | `worker_connections` |   <ul><li>Standard V2 plan `4000`</li><li>basic plan `3000`</li></ul> | To ensure reasonable performance of the NGINXaaS deployment for Standard V2 plan, the `worker_connections` is fixed at 400/NCU; for basic plan this is set lower.<br><br> Changing the value in the config has no effect on the NGINX process in the deployment. |
  | `pid` | `/run/nginx/nginx.pid` | Set to this value to allow NGINXaaS to automatically manage the NGINX master process. |
  | `daemon` | `on` | Automatically set to `on` to allow NGINXaaS to manage the NGINX master process. |
  | `master_process` | `on` | This directive is intended for NGINX developers. |
  | `worker_cpu_affinity` | `auto` | The value `auto` allows binding worker processes automatically to available CPUs based on the current capacity of the deployment. |

{{< /table >}}


## NGINX listen port restrictions

- Due to port restrictions on Azure Load Balancer health probes, certain ports are not allowed for the `listen` directive in NGINX configuration. The following ports are blocked:
  - `19`, `21`, `70`, `119` - Azure health probe restricted ports
  - `49151`, `49153`, `5140`, `50000`, `54141`, `54779` - reserved ports to support other NGINXaaS features

- The [Basic]({{< ref "/nginxaas-azure/billing/overview.md#basic-plan" >}}) plan (and the deprecated Standard (v1) plan) supports a maximum of 5 listen ports in the NGINX configuration. Configurations that specify over 5 unique ports are rejected.

- The [Standard V2]({{< ref "/nginxaas-azure/billing/overview.md#standard-v2-plan" >}}) plan allow users to listen on more than 5 ports. The first five ports under this plan come at no extra cost and there are charges for each additional port utilized.

## Configuration directives list

<details close>
<summary>Alphabetical index of directives</summary>

NGINXaaS for Azure supports a limited set of NGINX directives.

[absolute_redirect](https://nginx.org/en/docs/http/ngx_http_core_module.html#absolute_redirect)\
[accept_mutex](https://nginx.org/en/docs/ngx_core_module.html#accept_mutex)\
[accept_mutex_delay](https://nginx.org/en/docs/ngx_core_module.html#accept_mutex_delay)\
[access_log (ngx_http_log_module)](https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log)\
[access_log (ngx_stream_log_module)](https://nginx.org/en/docs/stream/ngx_stream_log_module.html#access_log)\
[add_after_body](https://nginx.org/en/docs/http/ngx_http_addition_module.html#add_after_body)\
[add_before_body](https://nginx.org/en/docs/http/ngx_http_addition_module.html#add_before_body)\
[add_header](https://nginx.org/en/docs/http/ngx_http_headers_module.html#add_header)\
[add_trailer](https://nginx.org/en/docs/http/ngx_http_headers_module.html#add_trailer)\
[addition_types](https://nginx.org/en/docs/http/ngx_http_addition_module.html#addition_types)\
[aio](https://nginx.org/en/docs/http/ngx_http_core_module.html#aio)\
[aio_write](https://nginx.org/en/docs/http/ngx_http_core_module.html#aio_write)\
[alias](https://nginx.org/en/docs/http/ngx_http_core_module.html#alias)\
[allow (ngx_http_access_module)](https://nginx.org/en/docs/http/ngx_http_access_module.html#allow)\
[allow (ngx_stream_access_module)](https://nginx.org/en/docs/stream/ngx_stream_access_module.html#allow)\
[ancient_browser](https://nginx.org/en/docs/http/ngx_http_browser_module.html#ancient_browser)\
[ancient_browser_value](https://nginx.org/en/docs/http/ngx_http_browser_module.html#ancient_browser_value)\
[auth_basic](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html#auth_basic)\
[auth_basic_user_file](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html#auth_basic_user_file)\
[auth_delay](https://nginx.org/en/docs/http/ngx_http_core_module.html#auth_delay)\
[auth_http](https://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html#auth_http)\
[auth_http_header](https://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html#auth_http_header)\
[auth_http_pass_client_cert](https://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html#auth_http_pass_client_cert)\
[auth_http_timeout](https://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html#auth_http_timeout)\
[auth_jwt](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt)\
[auth_jwt_claim_set](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_claim_set)\
[auth_jwt_header_set](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_header_set)\
[auth_jwt_key_cache](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_cache)\
[auth_jwt_key_file](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_file)\
[auth_jwt_key_request](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_key_request)\
[auth_jwt_leeway](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_leeway)\
[auth_jwt_require](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_require)\
[auth_jwt_type](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_type)\
[auth_request](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html#auth_request)\
[auth_request_set](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html#auth_request_set)\
[autoindex](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex)\
[autoindex_exact_size](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex_exact_size)\
[autoindex_format](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex_format)\
[autoindex_localtime](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex_localtime)\
[break](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#break)\
[connect_timeout](https://nginx.org/en/docs/ngx_mgmt_module.html#connect_timeout)\
[charset](https://nginx.org/en/docs/http/ngx_http_charset_module.html#charset)\
[charset_map](https://nginx.org/en/docs/http/ngx_http_charset_module.html#charset_map)\
[charset_types](https://nginx.org/en/docs/http/ngx_http_charset_module.html#charset_types)\
[chunked_transfer_encoding](https://nginx.org/en/docs/http/ngx_http_core_module.html#chunked_transfer_encoding)\
[client_body_buffer_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size)\
[client_body_in_file_only](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_in_file_only)\
[client_body_in_single_buffer](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_in_single_buffer)\
[client_body_temp_path](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_temp_path)\
[client_body_timeout](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_timeout)\
[client_header_buffer_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_header_buffer_size)\
[client_header_timeout](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_header_timeout)\
[client_max_body_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size)\
[connection_pool_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#connection_pool_size)\
[create_full_put_path](https://nginx.org/en/docs/http/ngx_http_dav_module.html#create_full_put_path)\
[daemon](https://nginx.org/en/docs/ngx_core_module.html#daemon)\
[dav_access](https://nginx.org/en/docs/http/ngx_http_dav_module.html#dav_access)\
[dav_methods](https://nginx.org/en/docs/http/ngx_http_dav_module.html#dav_methods)\
[debug_connection](https://nginx.org/en/docs/ngx_core_module.html#debug_connection)\
[default_type](https://nginx.org/en/docs/http/ngx_http_core_module.html#default_type)\
[deny (ngx_http_access_module)](https://nginx.org/en/docs/http/ngx_http_access_module.html#deny)\
[deny (ngx_stream_access_module)](https://nginx.org/en/docs/stream/ngx_stream_access_module.html#deny)\
[directio](https://nginx.org/en/docs/http/ngx_http_core_module.html#directio)\
[directio_alignment](https://nginx.org/en/docs/http/ngx_http_core_module.html#directio_alignment)\
[disable_symlinks](https://nginx.org/en/docs/http/ngx_http_core_module.html#disable_symlinks)\
[empty_gif](https://nginx.org/en/docs/http/ngx_http_empty_gif_module.html#empty_gif)\
[env](https://nginx.org/en/docs/ngx_core_module.html#env)\
[error_log](https://nginx.org/en/docs/ngx_core_module.html#error_log)\
[error_page](https://nginx.org/en/docs/http/ngx_http_core_module.html#error_page)\
[etag](https://nginx.org/en/docs/http/ngx_http_core_module.html#etag)\
[events](https://nginx.org/en/docs/ngx_core_module.html#events)\
[expires](https://nginx.org/en/docs/http/ngx_http_headers_module.html#expires)\
[f4f](https://nginx.org/en/docs/http/ngx_http_f4f_module.html#f4f)\
[f4f_buffer_size](https://nginx.org/en/docs/http/ngx_http_f4f_module.html#f4f_buffer_size)\
[fastcgi_buffer_size](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_buffer_size)\
[fastcgi_buffering](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_buffering)\
[fastcgi_buffers](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_buffers)\
[fastcgi_busy_buffers_size](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_busy_buffers_size)\
[fastcgi_cache](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache)\
[fastcgi_cache_background_update](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_background_update)\
[fastcgi_cache_bypass](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_bypass)\
[fastcgi_cache_key](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_key)\
[fastcgi_cache_lock](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_lock)\
[fastcgi_cache_lock_age](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_lock_age)\
[fastcgi_cache_lock_timeout](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_lock_timeout)\
[fastcgi_cache_max_range_offset](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_max_range_offset)\
[fastcgi_cache_methods](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_methods)\
[fastcgi_cache_min_uses](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_min_uses)\
[fastcgi_cache_path](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_path)\
[fastcgi_cache_revalidate](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_revalidate)\
[fastcgi_cache_use_stale](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_use_stale)\
[fastcgi_cache_valid](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_cache_valid)\
[fastcgi_catch_stderr](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_catch_stderr)\
[fastcgi_connect_timeout](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_connect_timeout)\
[fastcgi_force_ranges](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_force_ranges)\
[fastcgi_hide_header](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_hide_header)\
[fastcgi_ignore_client_abort](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_ignore_client_abort)\
[fastcgi_ignore_headers](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_ignore_headers)\
[fastcgi_index](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_index)\
[fastcgi_intercept_errors](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_intercept_errors)\
[fastcgi_keep_conn](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_keep_conn)\
[fastcgi_limit_rate](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_limit_rate)\
[fastcgi_max_temp_file_size](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_max_temp_file_size)\
[fastcgi_next_upstream](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_next_upstream)\
[fastcgi_next_upstream_timeout](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_next_upstream_timeout)\
[fastcgi_next_upstream_tries](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_next_upstream_tries)\
[fastcgi_no_cache](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_no_cache)\
[fastcgi_param](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_param)\
[fastcgi_pass](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass)\
[fastcgi_pass_header](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass_header)\
[fastcgi_pass_request_body](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass_request_body)\
[fastcgi_pass_request_headers](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass_request_headers)\
[fastcgi_read_timeout](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_read_timeout)\
[fastcgi_request_buffering](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_request_buffering)\
[fastcgi_send_lowat](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_send_lowat)\
[fastcgi_send_timeout](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_send_timeout)\
[fastcgi_socket_keepalive](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_socket_keepalive)\
[fastcgi_split_path_info](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_split_path_info)\
[fastcgi_store](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_store)\
[fastcgi_store_access](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_store_access)\
[fastcgi_temp_file_write_size](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_temp_file_write_size)\
[fastcgi_temp_path](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_temp_path)\
[flv](https://nginx.org/en/docs/http/ngx_http_flv_module.html#flv)\
[geo (ngx_http_geo_module)](https://nginx.org/en/docs/http/ngx_http_geo_module.html#geo)\
[geo (ngx_stream_geo_module)](https://nginx.org/en/docs/stream/ngx_stream_geo_module.html#geo)\
[grpc_buffer_size](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_buffer_size)\
[grpc_connect_timeout](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_connect_timeout)\
[grpc_hide_header](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_hide_header)\
[grpc_ignore_headers](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ignore_headers)\
[grpc_intercept_errors](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_intercept_errors)\
[grpc_next_upstream](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_next_upstream)\
[grpc_next_upstream_timeout](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_next_upstream_timeout)\
[grpc_next_upstream_tries](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_next_upstream_tries)\
[grpc_pass](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_pass)\
[grpc_pass_header](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_pass_header)\
[grpc_read_timeout](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_read_timeout)\
[grpc_send_timeout](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_send_timeout)\
[grpc_set_header](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_set_header)\
[grpc_socket_keepalive](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_socket_keepalive)\
[grpc_ssl_certificate](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_certificate)\
[grpc_ssl_certificate_key](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_certificate_key)\
[grpc_ssl_ciphers](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_ciphers)\
[grpc_ssl_conf_command](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_conf_command)\
[grpc_ssl_crl](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_crl)\
[grpc_ssl_name](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_name)\
[grpc_ssl_password_file](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_password_file)\
[grpc_ssl_protocols](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_protocols)\
[grpc_ssl_server_name](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_server_name)\
[grpc_ssl_session_reuse](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_session_reuse)\
[grpc_ssl_trusted_certificate](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_trusted_certificate)\
[grpc_ssl_verify](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_verify)\
[grpc_ssl_verify_depth](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_ssl_verify_depth)\
[gunzip](https://nginx.org/en/docs/http/ngx_http_gunzip_module.html#gunzip)\
[gunzip_buffers](https://nginx.org/en/docs/http/ngx_http_gunzip_module.html#gunzip_buffers)\
[gzip](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip)\
[gzip_buffers](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_buffers)\
[gzip_comp_level](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_comp_level)\
[gzip_disable](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_disable)\
[gzip_http_version](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_http_version)\
[gzip_min_length](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_min_length)\
[gzip_proxied](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_proxied)\
[gzip_static](https://nginx.org/en/docs/http/ngx_http_gzip_static_module.html#gzip_static)\
[gzip_types](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_types)\
[gzip_vary](https://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_vary)\
[hash (ngx_http_upstream_module)](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#hash)\
[hash (ngx_stream_upstream_module)](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#hash)\
[health_check (ngx_http_upstream_hc_module)](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check)\
[health_check (ngx_stream_upstream_hc_module)](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check)\
[health_check_timeout](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#health_check_timeout)\
[hls](https://nginx.org/en/docs/http/ngx_http_hls_module.html#hls)\
[hls_buffers](https://nginx.org/en/docs/http/ngx_http_hls_module.html#hls_buffers)\
[hls_forward_args](https://nginx.org/en/docs/http/ngx_http_hls_module.html#hls_forward_args)\
[hls_fragment](https://nginx.org/en/docs/http/ngx_http_hls_module.html#hls_fragment)\
[hls_mp4_buffer_size](https://nginx.org/en/docs/http/ngx_http_hls_module.html#hls_mp4_buffer_size)\
[hls_mp4_max_buffer_size](https://nginx.org/en/docs/http/ngx_http_hls_module.html#hls_mp4_max_buffer_size)\
[http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http)\
[http2_body_preread_size](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_body_preread_size)\
[http2_chunk_size](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_chunk_size)\
[http2_idle_timeout](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_idle_timeout)\
[http2_max_concurrent_pushes](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_max_concurrent_pushes)\
[http2_max_concurrent_streams](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_max_concurrent_streams)\
[http2_max_field_size](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_max_field_size)\
[http2_max_header_size](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_max_header_size)\
[http2_max_requests](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_max_requests)\
[http2_push](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_push)\
[http2_push_preload](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_push_preload)\
[http2_recv_buffer_size](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_recv_buffer_size)\
[http2_recv_timeout](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_recv_timeout)\
[http3](http://nginx.org/en/docs/http/ngx_http_v3_module.html#http3)\
[http3_hq](http://nginx.org/en/docs/http/ngx_http_v3_module.html#http3_hq)\
[http3_max_concurrent_streams](http://nginx.org/en/docs/http/ngx_http_v3_module.html#http3_max_concurrent_streams)\
[http3_stream_buffer_size](http://nginx.org/en/docs/http/ngx_http_v3_module.html#http3_stream_buffer_size)\
[if](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#if)\
[if_modified_since](https://nginx.org/en/docs/http/ngx_http_core_module.html#if_modified_since)\
[ignore_invalid_headers](https://nginx.org/en/docs/http/ngx_http_core_module.html#ignore_invalid_headers)\
[image_filter](http://nginx.org/en/docs/http/ngx_http_image_filter_module.html#image_filter)\
[image_filter_buffer](http://nginx.org/en/docs/http/ngx_http_image_filter_module.html#image_filter_buffer)\
[image_filter_interlace](http://nginx.org/en/docs/http/ngx_http_image_filter_module.html#image_filter_interlace)\
[image_filter_jpeg_quality](http://nginx.org/en/docs/http/ngx_http_image_filter_module.html#image_filter_jpeg_quality)\
[image_filter_sharpen](http://nginx.org/en/docs/http/ngx_http_image_filter_module.html#image_filter_sharpen)\
[image_filter_transparency](http://nginx.org/en/docs/http/ngx_http_image_filter_module.html#image_filter_transparency)\
[image_filter_webp_quality](http://nginx.org/en/docs/http/ngx_http_image_filter_module.html#image_filter_webp_quality)\
[imap_auth](https://nginx.org/en/docs/mail/ngx_mail_imap_module.html#imap_auth)\
[imap_capabilities](https://nginx.org/en/docs/mail/ngx_mail_imap_module.html#imap_capabilities)\
[imap_client_buffer](https://nginx.org/en/docs/mail/ngx_mail_imap_module.html#imap_client_buffer)\
[include](https://nginx.org/en/docs/ngx_core_module.html#include)\
[index](https://nginx.org/en/docs/http/ngx_http_index_module.html#index)\
[internal](https://nginx.org/en/docs/http/ngx_http_core_module.html#internal)\
[internal_redirect](http://nginx.org/en/docs/http/ngx_http_internal_redirect_module.html#internal_redirect)\
[ip_hash](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#ip_hash)\
[js_access (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_access)\
[js_body_filter](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_body_filter)\
[js_content](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_content)\
[js_fetch_buffer_size (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_fetch_buffer_size)\
[js_fetch_buffer_size (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_fetch_buffer_size)\
[js_fetch_ciphers (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_fetch_ciphers)\
[js_fetch_ciphers (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_fetch_ciphers)\
[js_fetch_max_response_buffer_size (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_fetch_max_response_buffer_size)\
[js_fetch_max_response_buffer_size (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_fetch_max_response_buffer_size)\
[js_fetch_protocols (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_fetch_protocols)\
[js_fetch_protocols (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_fetch_protocols)\
[js_fetch_timeout (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_fetch_timeout)\
[js_fetch_timeout (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_fetch_timeout)\
[js_fetch_trusted_certificate (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_fetch_trusted_certificate)\
[js_fetch_trusted_certificate (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_fetch_trusted_certificate)\
[js_fetch_verify (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_fetch_verify)\
[js_fetch_verify (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_fetch_verify)\
[js_fetch_verify_depth (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_fetch_verify_depth)\
[js_fetch_verify_depth (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_fetch_verify_depth)\
[js_filter (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_filter)\
[js_header_filter](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_header_filter)\
[js_import (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_import)\
[js_import (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_import)\
[js_include (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_include)\
[js_include (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_include)\
[js_path (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_path)\
[js_path (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_path)\
[js_periodic (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_periodic)\
[js_periodic (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_periodic)\
[js_preload_object (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_preload_object)\
[js_preload_object (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_preload_object)\
[js_preread (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_preread)\
[js_set (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_set)\
[js_set (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_set)\
[js_var (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_var)\
[js_var (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_var)\
[js_shared_dict_zone (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_shared_dict_zone)\
[js_var (ngx_http_js_module)](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_var)\
[js_var (ngx_stream_js_module)](https://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_var)\
[keepalive](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive)\
[keepalive_disable](https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_disable)\
[keepalive_requests (ngx_http_core_module)](https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_requests)\
[keepalive_time (ngx_http_core_module)](https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_time)\
[keepalive_timeout (ngx_http_core_module)](https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_timeout)\
[keyval (ngx_http_keyval_module)](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval)\
[keyval (ngx_stream_keyval_module)](https://nginx.org/en/docs/stream/ngx_stream_keyval_module.html#keyval)\
[keyval_zone (ngx_http_keyval_module)](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone)\
[keyval_zone (ngx_stream_keyval_module)](https://nginx.org/en/docs/stream/ngx_stream_keyval_module.html#keyval_zone)\
[large_client_header_buffers](https://nginx.org/en/docs/http/ngx_http_core_module.html#large_client_header_buffers)\
[least_conn (ngx_http_upstream_module)](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_conn)\
[least_conn (ngx_stream_upstream_module)](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#least_conn)\
[least_time (ngx_http_upstream_module)](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_time)\
[least_time (ngx_stream_upstream_module)](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#least_time)\
[limit_conn (ngx_http_limit_conn_module)](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn)\
[limit_conn (ngx_stream_limit_conn_module)](https://nginx.org/en/docs/stream/ngx_stream_limit_conn_module.html#limit_conn)\
[limit_conn_dry_run (ngx_http_limit_conn_module)](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_dry_run)\
[limit_conn_dry_run (ngx_stream_limit_conn_module)](https://nginx.org/en/docs/stream/ngx_stream_limit_conn_module.html#limit_conn_dry_run)\
[limit_conn_log_level (ngx_http_limit_conn_module)](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_log_level)\
[limit_conn_log_level (ngx_stream_limit_conn_module)](https://nginx.org/en/docs/stream/ngx_stream_limit_conn_module.html#limit_conn_log_level)\
[limit_conn_status](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_status)\
[limit_conn_zone (ngx_http_limit_conn_module)](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_zone)\
[limit_conn_zone (ngx_stream_limit_conn_module)](https://nginx.org/en/docs/stream/ngx_stream_limit_conn_module.html#limit_conn_zone)\
[limit_except](https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_except)\
[limit_rate](https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_rate)\
[limit_rate_after](https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_rate_after)\
[limit_req](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req)\
[limit_req_dry_run](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_dry_run)\
[limit_req_log_level](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_log_level)\
[limit_req_status](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_status)\
[limit_req_zone](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone)\
[limit_zone](https://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_zone)\
[lingering_close](https://nginx.org/en/docs/http/ngx_http_core_module.html#lingering_close)\
[lingering_time](https://nginx.org/en/docs/http/ngx_http_core_module.html#lingering_time)\
[lingering_timeout](https://nginx.org/en/docs/http/ngx_http_core_module.html#lingering_timeout)\
[listen (ngx_http_core_module)](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen)\
[listen (ngx_mail_core_module)](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#listen)\
[load_module](https://nginx.org/en/docs/ngx_core_module.html#load_module)\
[location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location)\
[lock_file](http://nginx.org/en/docs/ngx_core_module.html#lock_file)\
[log_format (ngx_http_log_module)](https://nginx.org/en/docs/http/ngx_http_log_module.html#log_format)\
[log_format (ngx_stream_log_module)](https://nginx.org/en/docs/stream/ngx_stream_log_module.html#log_format)\
[log_not_found](https://nginx.org/en/docs/http/ngx_http_core_module.html#log_not_found)\
[log_subrequest](https://nginx.org/en/docs/http/ngx_http_core_module.html#log_subrequest)\
[mail](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#mail)\
[map (ngx_http_map_module)](https://nginx.org/en/docs/http/ngx_http_map_module.html#map)\
[map (ngx_stream_map_module)](https://nginx.org/en/docs/stream/ngx_stream_map_module.html#map)\
[map_hash_bucket_size (ngx_http_map_module)](https://nginx.org/en/docs/http/ngx_http_map_module.html#map_hash_bucket_size)\
[map_hash_bucket_size (ngx_stream_map_module)](https://nginx.org/en/docs/stream/ngx_stream_map_module.html#map_hash_bucket_size)\
[map_hash_max_size (ngx_http_map_module)](https://nginx.org/en/docs/http/ngx_http_map_module.html#map_hash_max_size)\
[map_hash_max_size (ngx_stream_map_module)](https://nginx.org/en/docs/stream/ngx_stream_map_module.html#map_hash_max_size)\
[master_process](https://nginx.org/en/docs/ngx_core_module.html#master_process)\
[match (ngx_http_upstream_hc_module)](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#match)\
[match (ngx_stream_upstream_hc_module)](https://nginx.org/en/docs/stream/ngx_stream_upstream_hc_module.html#match)\
[max_errors](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#max_errors)\
[max_ranges](https://nginx.org/en/docs/http/ngx_http_core_module.html#max_ranges)\
[memcached_buffer_size](https://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_buffer_size)\
[memcached_connect_timeout](https://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_connect_timeout)\
[memcached_gzip_flag](https://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_gzip_flag)\
[memcached_next_upstream](https://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_next_upstream)\
[memcached_next_upstream_timeout](https://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_next_upstream_timeout)\
[memcached_next_upstream_tries](https://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_next_upstream_tries)\
[memcached_pass](https://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_pass)\
[memcached_read_timeout](https://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_read_timeout)\
[memcached_send_timeout](https://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_send_timeout)\
[memcached_socket_keepalive](https://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_socket_keepalive)\
[merge_slashes](https://nginx.org/en/docs/http/ngx_http_core_module.html#merge_slashes)\
[mgmt](https://nginx.org/en/docs/ngx_mgmt_module.html#mgmt)\
[min_delete_depth](https://nginx.org/en/docs/http/ngx_http_dav_module.html#min_delete_depth)\
[mirror](https://nginx.org/en/docs/http/ngx_http_mirror_module.html#mirror)\
[mirror_request_body](https://nginx.org/en/docs/http/ngx_http_mirror_module.html#mirror_request_body)\
[modern_browser](https://nginx.org/en/docs/http/ngx_http_browser_module.html#modern_browser)\
[modern_browser_value](https://nginx.org/en/docs/http/ngx_http_browser_module.html#modern_browser_value)\
[more_clear_headers](https://github.com/openresty/headers-more-nginx-module?tab=readme-ov-file#more_clear_headers)\
[more_clear_input_headers](https://github.com/openresty/headers-more-nginx-module?tab=readme-ov-file#more_clear_input_headers)\
[more_set_headers](https://github.com/openresty/headers-more-nginx-module?tab=readme-ov-file#more_set_headers)\
[more_set_input_headers](https://github.com/openresty/headers-more-nginx-module?tab=readme-ov-file#more_set_input_headers)\
[mp4](https://nginx.org/en/docs/http/ngx_http_mp4_module.html#mp4)\
[mp4_buffer_size](https://nginx.org/en/docs/http/ngx_http_mp4_module.html#mp4_buffer_size)\
[mp4_limit_rate](https://nginx.org/en/docs/http/ngx_http_mp4_module.html#mp4_limit_rate)\
[mp4_limit_rate_after](https://nginx.org/en/docs/http/ngx_http_mp4_module.html#mp4_limit_rate_after)\
[mp4_max_buffer_size](https://nginx.org/en/docs/http/ngx_http_mp4_module.html#mp4_max_buffer_size)\
[mp4_start_key_frame](https://nginx.org/en/docs/http/ngx_http_mp4_module.html#mp4_start_key_frame)\
[mqtt](https://nginx.org/en/docs/stream/ngx_stream_mqtt_filter_module.html#mqtt)\
[mqtt_rewrite_buffer_size](https://nginx.org/en/docs/stream/ngx_stream_mqtt_filter_module.html#mqtt_rewrite_buffer_size)\
[mqtt_set_connect](https://nginx.org/en/docs/stream/ngx_stream_mqtt_filter_module.html#mqtt_set_connect)\
[msie_padding](https://nginx.org/en/docs/http/ngx_http_core_module.html#msie_padding)\
[msie_refresh](https://nginx.org/en/docs/http/ngx_http_core_module.html#msie_refresh)\
[multi_accept](https://nginx.org/en/docs/ngx_core_module.html#multi_accept)\
[ntlm](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#ntlm)\
[open_file_cache](https://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache)\
[open_file_cache_errors](https://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache_errors)\
[open_file_cache_min_uses](https://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache_min_uses)\
[open_file_cache_valid](https://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache_valid)\
[open_log_file_cache (ngx_http_log_module)](https://nginx.org/en/docs/http/ngx_http_log_module.html#open_log_file_cache)\
[open_log_file_cache (ngx_stream_log_module)](https://nginx.org/en/docs/stream/ngx_stream_log_module.html#open_log_file_cache)\
[otel_exporter](https://nginx.org/en/docs/ngx_otel_module.html#otel_exporter)\
[otel_service_name](https://nginx.org/en/docs/ngx_otel_module.html#otel_service_name)\
[otel_trace](https://nginx.org/en/docs/ngx_otel_module.html#otel_trace)\
[otel_trace_context](https://nginx.org/en/docs/ngx_otel_module.html#otel_trace_context)\
[otel_span_name](https://nginx.org/en/docs/ngx_otel_module.html#otel_span_name)\
[otel_span_attr](https://nginx.org/en/docs/ngx_otel_module.html#otel_span_attr)\
[output_buffers](https://nginx.org/en/docs/http/ngx_http_core_module.html#output_buffers)\
[override_charset](https://nginx.org/en/docs/http/ngx_http_charset_module.html#override_charset)\
[pass](https://nginx.org/en/docs/stream/ngx_stream_pass_module.html#pass)\
[pid](https://nginx.org/en/docs/ngx_core_module.html#pid)\
[pop3_auth](https://nginx.org/en/docs/mail/ngx_mail_pop3_module.html#pop3_auth)\
[pop3_capabilities](https://nginx.org/en/docs/mail/ngx_mail_pop3_module.html#pop3_capabilities)\
[port_in_redirect](https://nginx.org/en/docs/http/ngx_http_core_module.html#port_in_redirect)\
[postpone_output](https://nginx.org/en/docs/http/ngx_http_core_module.html#postpone_output)\
[preread_buffer_size (ngx_stream_core_module)](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#preread_buffer_size)\
[preread_timeout (ngx_stream_core_module)](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#preread_timeout)\
[protocol](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#protocol)\
[proxy_buffer](https://nginx.org/en/docs/mail/ngx_mail_proxy_module.html#proxy_buffer)\
[proxy_buffer_size (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffer_size)\
[proxy_buffer_size (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_buffer_size)\
[proxy_buffering](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffering)\
[proxy_buffers](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffers)\
[proxy_busy_buffers_size](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_busy_buffers_size)\
[proxy_cache](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache)\
[proxy_cache_background_update](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_background_update)\
[proxy_cache_bypass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_bypass)\
[proxy_cache_convert_head](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_convert_head)\
[proxy_cache_key](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_key)\
[proxy_cache_lock](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_lock)\
[proxy_cache_lock_age](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_lock_age)\
[proxy_cache_lock_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_lock_timeout)\
[proxy_cache_max_range_offset](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_max_range_offset)\
[proxy_cache_methods](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_methods)\
[proxy_cache_min_uses](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_min_uses)\
[proxy_cache_path](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path)\
[proxy_cache_purge](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_purge)\
[proxy_cache_revalidate](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_revalidate)\
[proxy_cache_use_stale](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_use_stale)\
[proxy_cache_valid](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_valid)\
[proxy_connect_timeout (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_connect_timeout)\
[proxy_connect_timeout (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_connect_timeout)\
[proxy_cookie_domain](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cookie_domain)\
[proxy_cookie_flags](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cookie_flags)\
[proxy_cookie_path](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cookie_path)\
[proxy_download_rate (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_download_rate)\
[proxy_force_ranges](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_force_ranges)\
[proxy_half_close (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_half_close)\
[proxy_headers_hash_bucket_size](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_headers_hash_bucket_size)\
[proxy_headers_hash_max_size](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_headers_hash_max_size)\
[proxy_hide_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_hide_header)\
[proxy_http_version](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_http_version)\
[proxy_ignore_client_abort](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ignore_client_abort)\
[proxy_ignore_headers](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ignore_headers)\
[proxy_intercept_errors](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_intercept_errors)\
[proxy_limit_rate](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_limit_rate)\
[proxy_max_temp_file_size](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_max_temp_file_size)\
[proxy_method](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_method)\
[proxy_next_upstream (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream)\
[proxy_next_upstream (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_next_upstream)\
[proxy_next_upstream_timeout (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream_timeout)\
[proxy_next_upstream_timeout (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_next_upstream_timeout)\
[proxy_next_upstream_tries (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream_tries)\
[proxy_next_upstream_tries (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_next_upstream_tries)\
[proxy_no_cache](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_no_cache)\
[proxy_pass (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass)\
[proxy_pass (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_pass)\
[proxy_pass_error_message](https://nginx.org/en/docs/mail/ngx_mail_proxy_module.html#proxy_pass_error_message)\
[proxy_pass_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass_header)\
[proxy_pass_request_body](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass_request_body)\
[proxy_pass_request_headers](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass_request_headers)\
[proxy_protocol (ngx_mail_proxy_module)](https://nginx.org/en/docs/mail/ngx_mail_proxy_module.html#proxy_protocol)\
[proxy_protocol (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_protocol)\
[proxy_protocol_timeout (ngx_stream_core_module)](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#proxy_protocol_timeout)\
[proxy_read_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout)\
[proxy_redirect](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_redirect)\
[proxy_requests (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_requests)\
[proxy_request_buffering](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_request_buffering)\
[proxy_responses (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_responses)\
[proxy_send_lowat](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_send_lowat)\
[proxy_send_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_send_timeout)\
[proxy_session_drop (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_session_drop)\
[proxy_set_body](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_body)\
[proxy_set_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_set_header)\
[proxy_smtp_auth](https://nginx.org/en/docs/mail/ngx_mail_proxy_module.html#proxy_smtp_auth)\
[proxy_socket_keepalive (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_socket_keepalive)\
[proxy_socket_keepalive (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_socket_keepalive)\
[proxy_ssl (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl)\
[proxy_ssl_certificate (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_certificate)\
[proxy_ssl_certificate (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_certificate)\
[proxy_ssl_certificate_key (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_certificate_key)\
[proxy_ssl_certificate_key (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_certificate_key)\
[proxy_ssl_ciphers (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_ciphers)\
[proxy_ssl_ciphers (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_ciphers)\
[proxy_ssl_conf_command (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_conf_command)\
[proxy_ssl_conf_command (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_conf_command)\
[proxy_ssl_crl (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_crl)\
[proxy_ssl_crl (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_crl)\
[proxy_ssl_name (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_name)\
[proxy_ssl_name (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_name)\
[proxy_ssl_password_file (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_password_file)\
[proxy_ssl_password_file (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_password_file)\
[proxy_ssl_protocols (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_protocols)\
[proxy_ssl_protocols (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_protocols)\
[proxy_ssl_server_name (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_server_name)\
[proxy_ssl_server_name (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_server_name)\
[proxy_ssl_session_reuse (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_session_reuse)\
[proxy_ssl_session_reuse (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_session_reuse)\
[proxy_ssl_trusted_certificate (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_trusted_certificate)\
[proxy_ssl_trusted_certificate (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_trusted_certificate)\
[proxy_ssl_verify (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_verify)\
[proxy_ssl_verify (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_verify)\
[proxy_ssl_verify_depth (ngx_http_proxy_module)](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_verify_depth)\
[proxy_ssl_verify_depth (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_ssl_verify_depth)\
[proxy_store](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_store)\
[proxy_store_access](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_store_access)\
[proxy_temp_file_write_size](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_temp_file_write_size)\
[proxy_temp_path](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_temp_path)\
[proxy_timeout (ngx_mail_proxy_module)](https://nginx.org/en/docs/mail/ngx_mail_proxy_module.html#proxy_timeout)\
[proxy_timeout (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_timeout)\
[proxy_upload_rate (ngx_stream_proxy_module)](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_upload_rate)\
[queue](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#queue)\
[quic_active_connection_id_limit](http://nginx.org/en/docs/http/ngx_http_v3_module.html#quic_active_connection_id_limit)\
[quic_gso](http://nginx.org/en/docs/http/ngx_http_v3_module.html#quic_gso)\
[quic_host_key](http://nginx.org/en/docs/http/ngx_http_v3_module.html#quic_host_key)\
[quic_retry](http://nginx.org/en/docs/http/ngx_http_v3_module.html#quic_retry)\
[random (ngx_http_upstream_module)](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#random)\
[random (ngx_stream_upstream_module)](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#random)\
[random_index](https://nginx.org/en/docs/http/ngx_http_random_index_module.html#random_index)\
[read_ahead](https://nginx.org/en/docs/http/ngx_http_core_module.html#read_ahead)\
[read_timeout](https://nginx.org/en/docs/ngx_mgmt_module.html#read_timeout)\
[real_ip_header](https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_header)\
[real_ip_recursive](https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_recursive)\
[recursive_error_pages](https://nginx.org/en/docs/http/ngx_http_core_module.html#recursive_error_pages)\
[referer_hash_bucket_size](https://nginx.org/en/docs/http/ngx_http_referer_module.html#referer_hash_bucket_size)\
[referer_hash_max_size](https://nginx.org/en/docs/http/ngx_http_referer_module.html#referer_hash_max_size)\
[request_pool_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#request_pool_size)\
[reset_timedout_connection](https://nginx.org/en/docs/http/ngx_http_core_module.html#reset_timedout_connection)\
[resolver (ngx_http_core_module)](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver)\
[resolver (ngx_mail_core_module)](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#resolver)\
[resolver (ngx_stream_core_module)](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#resolver)\
[resolver (ngx_stream_upstream_module)](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#resolver)\
[resolver (ngx_mgmt_module)](https://nginx.org/en/docs/ngx_mgmt_module.html#resolver)\
[resolver_timeout (ngx_http_core_module)](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver_timeout)\
[resolver_timeout (ngx_mail_core_module)](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#resolver_timeout)\
[resolver_timeout (ngx_stream_core_module)](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#resolver_timeout)\
[resolver_timeout (ngx_stream_upstream_module)](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#resolver_timeout)\
[resolver_timeout (ngx_mgmt_module)](https://nginx.org/en/docs/ngx_mgmt_module.html#resolver_timeout)\
[return (ngx_http_rewrite_module)](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return)\
[return (ngx_stream_return_module)](https://nginx.org/en/docs/stream/ngx_stream_return_module.html#return)\
[rewrite](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite)\
[rewrite_log](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite_log)\
[root](https://nginx.org/en/docs/http/ngx_http_core_module.html#root)\
[satisfy](https://nginx.org/en/docs/http/ngx_http_core_module.html#satisfy)\
[scgi_buffer_size](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_buffer_size)\
[scgi_buffering](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_buffering)\
[scgi_buffers](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_buffers)\
[scgi_busy_buffers_size](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_busy_buffers_size)\
[scgi_cache](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache)\
[scgi_cache_background_update](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_background_update)\
[scgi_cache_bypass](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_bypass)\
[scgi_cache_key](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_key)\
[scgi_cache_lock](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_lock)\
[scgi_cache_lock_age](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_lock_age)\
[scgi_cache_lock_timeout](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_lock_timeout)\
[scgi_cache_max_range_offset](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_max_range_offset)\
[scgi_cache_methods](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_methods)\
[scgi_cache_min_uses](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_min_uses)\
[scgi_cache_path](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_path)\
[scgi_cache_purge](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_purge)\
[scgi_cache_revalidate](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_revalidate)\
[scgi_cache_use_stale](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_use_stale)\
[scgi_cache_valid](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_cache_valid)\
[scgi_connect_timeout](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_connect_timeout)\
[scgi_force_ranges](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_force_ranges)\
[scgi_hide_header](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_hide_header)\
[scgi_ignore_client_abort](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_ignore_client_abort)\
[scgi_ignore_headers](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_ignore_headers)\
[scgi_intercept_errors](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_intercept_errors)\
[scgi_limit_rate](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_limit_rate)\
[scgi_max_temp_file_size](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_max_temp_file_size)\
[scgi_next_upstream](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_next_upstream)\
[scgi_next_upstream_timeout](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_next_upstream_timeout)\
[scgi_next_upstream_tries](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_next_upstream_tries)\
[scgi_no_cache](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_no_cache)\
[scgi_param](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_param)\
[scgi_pass](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_pass)\
[scgi_pass_header](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_pass_header)\
[scgi_pass_request_body](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_pass_request_body)\
[scgi_pass_request_headers](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_pass_request_headers)\
[scgi_read_timeout](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_read_timeout)\
[scgi_request_buffering](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_request_buffering)\
[scgi_send_timeout](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_send_timeout)\
[scgi_socket_keepalive](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_socket_keepalive)\
[scgi_store](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_store)\
[scgi_store_access](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_store_access)\
[scgi_temp_file_write_size](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_temp_file_write_size)\
[scgi_temp_path](https://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_temp_path)\
[secure_link](https://nginx.org/en/docs/http/ngx_http_secure_link_module.html#secure_link)\
[secure_link_md5](https://nginx.org/en/docs/http/ngx_http_secure_link_module.html#secure_link_md5)\
[secure_link_secret](https://nginx.org/en/docs/http/ngx_http_secure_link_module.html#secure_link_secret)\
[send_lowat](https://nginx.org/en/docs/http/ngx_http_core_module.html#send_lowat)\
[send_timeout (ngx_http_core_module)](https://nginx.org/en/docs/http/ngx_http_core_module.html#send_timeout)\
[send_timeout (ngx_mgmt_module)](https://nginx.org/en/docs/ngx_mgmt_module.html#send_timeout)\
[sendfile](https://nginx.org/en/docs/http/ngx_http_core_module.html#sendfile)\
[sendfile_max_chunk](https://nginx.org/en/docs/http/ngx_http_core_module.html#sendfile_max_chunk)\
[server (ngx_http_core_module)](https://nginx.org/en/docs/http/ngx_http_core_module.html#server)\
[server (ngx_mail_core_module)](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#server)\
[server (ngx_stream_core_module)](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#server)\
[server (ngx_stream_upstream_module)](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#server)\
[server_name (ngx_http_core_module)](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name)\
[server_name (ngx_mail_core_module)](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#server_name)\
[server_name (ngx_stream_core_module)](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#server_name)\
[server_name_in_redirect](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name_in_redirect)\
[server_tokens](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_tokens)\
[session_log](https://nginx.org/en/docs/http/ngx_http_session_log_module.html#session_log)\
[session_log_format](https://nginx.org/en/docs/http/ngx_http_session_log_module.html#session_log_format)\
[session_log_zone](https://nginx.org/en/docs/http/ngx_http_session_log_module.html#session_log_zone)\
[set (ngx_http_rewrite_module)](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#set)\
[set (ngx_stream_set_module)](https://nginx.org/en/docs/stream/ngx_stream_set_module.html#set)\
[set_real_ip_from (ngx_http_realip_module)](https://nginx.org/en/docs/http/ngx_http_realip_module.html#set_real_ip_from)\
[set_real_ip_from (ngx_mail_realip_module)](https://nginx.org/en/docs/mail/ngx_mail_realip_module.html#set_real_ip_from)\
[set_real_ip_from (ngx_stream_realip_module)](https://nginx.org/en/docs/stream/ngx_stream_realip_module.html#set_real_ip_from)\
[slice](https://nginx.org/en/docs/http/ngx_http_slice_module.html#slice)\
[smtp_auth](https://nginx.org/en/docs/mail/ngx_mail_smtp_module.html#smtp_auth)\
[smtp_capabilities](https://nginx.org/en/docs/mail/ngx_mail_smtp_module.html#smtp_capabilities)\
[smtp_client_buffer](https://nginx.org/en/docs/mail/ngx_mail_smtp_module.html#smtp_client_buffer)\
[smtp_greeting_delay](https://nginx.org/en/docs/mail/ngx_mail_smtp_module.html#smtp_greeting_delay)\
[source_charset](https://nginx.org/en/docs/http/ngx_http_charset_module.html#source_charset)
[spdy_chunk_size](https://nginx.org/en/docs/http/ngx_http_spdy_module.html#spdy_chunk_size)\
[spdy_headers_comp](https://nginx.org/en/docs/http/ngx_http_spdy_module.html#spdy_headers_comp)\
[split_clients (ngx_http_split_clients_module)](https://nginx.org/en/docs/http/ngx_http_split_clients_module.html#split_clients)\
[split_clients (ngx_stream_split_clients_module)](https://nginx.org/en/docs/stream/ngx_stream_split_clients_module.html#split_clients)\
[ssi](https://nginx.org/en/docs/http/ngx_http_ssi_module.html#ssi)\
[ssi_last_modified](https://nginx.org/en/docs/http/ngx_http_ssi_module.html#ssi_last_modified)\
[ssi_min_file_chunk](https://nginx.org/en/docs/http/ngx_http_ssi_module.html#ssi_min_file_chunk)\
[ssi_silent_errors](https://nginx.org/en/docs/http/ngx_http_ssi_module.html#ssi_silent_errors)\
[ssi_types](https://nginx.org/en/docs/http/ngx_http_ssi_module.html#ssi_types)\
[ssi_value_length](https://nginx.org/en/docs/http/ngx_http_ssi_module.html#ssi_value_length)\
[ssl (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl)\
[ssl (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl)\
[ssl (ngx_mgmt_module)](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl)\
[ssl_buffer_size](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_buffer_size)\
[ssl_certificate (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate)\
[ssl_certificate (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_certificate)\
[ssl_certificate (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_certificate)\
[ssl_certificate (ngx_mgmt_module)](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_certificate)\
[ssl_certificate_key (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate_key)\
[ssl_certificate_key (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_certificate_key)\
[ssl_certificate_key (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_certificate_key)\
[ssl_certificate_key (ngx_mgmt_module)](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_certificate_key)\
[ssl_ciphers (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ciphers)\
[ssl_ciphers (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_ciphers)\
[ssl_ciphers (ngx_mgmt_module)](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_ciphers)\
[ssl_client_certificate (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_client_certificate)\
[ssl_client_certificate (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_client_certificate)\
[ssl_client_certificate (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_client_certificate)\
[ssl_conf_command (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_conf_command)\
[ssl_conf_command (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_conf_command)\
[ssl_conf_command (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_conf_command)\
[ssl_crl (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_crl)\
[ssl_crl (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_crl)\
[ssl_crl (ngx_mgmt_module)](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_crl)\
[ssl_dhparam (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_dhparam)\
[ssl_dhparam (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_dhparam)\
[ssl_early_data](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_early_data)\
[ssl_ecdh_curve (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ecdh_curve)\
[ssl_ecdh_curve (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_ecdh_curve)\
[ssl_ecdh_curve (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_ecdh_curve)\
[ssl_handshake_timeout](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_handshake_timeout)\
[ssl_name](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_name)\
[ssl_ocsp](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ocsp)\
[ssl_ocsp_cache](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ocsp_cache)\
[ssl_ocsp_responder](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ocsp_responder)\
[ssl_password_file (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_password_file)\
[ssl_password_file (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_password_file)\
[ssl_password_file (ngx_mgmt_module)](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_password_file)\
[ssl_prefer_server_ciphers (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_prefer_server_ciphers)\
[ssl_prefer_server_ciphers (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_prefer_server_ciphers)\
[ssl_prefer_server_ciphers (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_prefer_server_ciphers)\
[ssl_preread (ngx_stream_ssl_preread_module)](http://nginx.org/en/docs/stream/ngx_stream_ssl_preread_module.html#var_ssl_preread_protocol)\
[ssl_protocols (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols)\
[ssl_protocols (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_protocols)\
[ssl_protocols (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_protocols)\
[ssl_protocols (ngx_mgmt_module)](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_protocols)\
[ssl_reject_handshake](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_reject_handshake)\
[ssl_server_name](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_server_name)\
[ssl_session_cache (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_cache)\
[ssl_session_cache (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_session_cache)\
[ssl_session_cache (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_session_cache)\
[ssl_session_ticket_key (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_ticket_key)\
[ssl_session_ticket_key (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_session_ticket_key)\
[ssl_session_ticket_key (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_session_ticket_key)\
[ssl_session_tickets (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_tickets)\
[ssl_session_tickets (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_session_tickets)\
[ssl_session_tickets (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_session_tickets)\
[ssl_session_timeout (ngx_http_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_session_timeout)\
[ssl_session_timeout (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_session_timeout)\
[ssl_session_timeout (ngx_stream_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_timeout)\
[ssl_stapling](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_stapling)\
[ssl_stapling_file](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_stapling_file)\
[ssl_stapling_responder](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_stapling_responder)\
[ssl_stapling_verify](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_stapling_verify)\
[ssl_trusted_certificate (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_trusted_certificate)\
[ssl_trusted_certificate (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_trusted_certificate)\
[ssl_trusted_certificate (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_trusted_certificate)\
[ssl_trusted_certificate (ngx_mgmt_module)](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_trusted_certificate)\
[ssl_verify](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_verify)\
[ssl_verify_client (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_verify_client)\
[ssl_verify_client (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_verify_client)\
[ssl_verify_client (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_verify_client)\
[ssl_verify_depth (ngx_http_ssl_module)](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_verify_depth)\
[ssl_verify_depth (ngx_mail_ssl_module)](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#ssl_verify_depth)\
[ssl_verify_depth (ngx_stream_ssl_module)](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_verify_depth)\
[ssl_verify_depth (ngx_mgmt_module)](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_verify_depth)\
[starttls](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html#starttls)\
[state (ngx_http_upstream_module)](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#state)\
[status_zone (ngx_http_api_module)](https://nginx.org/en/docs/http/ngx_http_api_module.html#status_zone)\
[sticky](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky)\
[sticky_cookie_insert](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_cookie_insert)\
[stream (ngx_stream_core_module)](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream)\
[stub_status](https://nginx.org/en/docs/http/ngx_http_stub_status_module.html#stub_status)\
[sub_filter](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter)\
[sub_filter_last_modified](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter_last_modified)\
[sub_filter_once](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter_once)\
[sub_filter_types](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter_types)\
[subrequest_output_buffer_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#subrequest_output_buffer_size)\
[tcp_nodelay (ngx_http_core_module)](https://nginx.org/en/docs/http/ngx_http_core_module.html#tcp_nodelay)\
[tcp_nodelay (ngx_stream_core_module)](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#tcp_nodelay)\
[tcp_nopush](https://nginx.org/en/docs/http/ngx_http_core_module.html#tcp_nopush)\
[thread_pool](https://nginx.org/en/docs/ngx_core_module.html#thread_pool)\
[timeout](https://nginx.org/en/docs/mail/ngx_mail_core_module.html#timeout)\
[timer_resolution](https://nginx.org/en/docs/ngx_core_module.html#timer_resolution)\
[try_files](https://nginx.org/en/docs/http/ngx_http_core_module.html#try_files)\
[types](https://nginx.org/en/docs/http/ngx_http_core_module.html#types)\
[types_hash_bucket_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#types_hash_bucket_size)\
[types_hash_max_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#types_hash_max_size)\
[underscores_in_headers](https://nginx.org/en/docs/http/ngx_http_core_module.html#underscores_in_headers)\
[uninitialized_variable_warn](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#uninitialized_variable_warn)\
[upstream (ngx_http_upstream_module)](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)\
[upstream (ngx_stream_upstream_module)](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#upstream)\
[upstream_conf](https://nginx.org/en/docs/http/ngx_http_upstream_conf_module.html#upstream_conf)\
[usage_report](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report)\
[use](https://nginx.org/en/docs/ngx_core_module.html#use)\
[user](https://nginx.org/en/docs/ngx_core_module.html#user)\
[userid](https://nginx.org/en/docs/http/ngx_http_userid_module.html#userid)\
[userid_domain](https://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_domain)\
[userid_expires](https://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_expires)\
[userid_flags](https://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_flags)\
[userid_mark](https://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_mark)\
[userid_name](https://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_name)\
[userid_p3p](https://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_p3p)\
[userid_path](https://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_path)\
[userid_service](https://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_service)\
[uuid_file](https://nginx.org/en/docs/ngx_mgmt_module.html#uuid_file)\
[uwsgi_buffer_size](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_buffer_size)\
[uwsgi_buffering](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_buffering)\
[uwsgi_buffers](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_buffers)\
[uwsgi_busy_buffers_size](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_busy_buffers_size)\
[uwsgi_cache](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache)\
[uwsgi_cache_background_update](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_background_update)\
[uwsgi_cache_bypass](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_bypass)\
[uwsgi_cache_key](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_key)\
[uwsgi_cache_lock](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_lock)\
[uwsgi_cache_lock_age](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_lock_age)\
[uwsgi_cache_lock_timeout](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_lock_timeout)\
[uwsgi_cache_max_range_offset](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_max_range_offset)\
[uwsgi_cache_methods](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_methods)\
[uwsgi_cache_min_uses](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_min_uses)\
[uwsgi_cache_path](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_path)\
[uwsgi_cache_purge](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_purge)\
[uwsgi_cache_revalidate](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_revalidate)\
[uwsgi_cache_use_stale](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_use_stale)\
[uwsgi_cache_valid](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_cache_valid)\
[uwsgi_connect_timeout](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_connect_timeout)\
[uwsgi_force_ranges](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_force_ranges)\
[uwsgi_hide_header](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_hide_header)\
[uwsgi_ignore_client_abort](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ignore_client_abort)\
[uwsgi_ignore_headers](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ignore_headers)\
[uwsgi_intercept_errors](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_intercept_errors)\
[uwsgi_limit_rate](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_limit_rate)\
[uwsgi_max_temp_file_size](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_max_temp_file_size)\
[uwsgi_modifier1](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_modifier1)\
[uwsgi_modifier2](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_modifier2)\
[uwsgi_next_upstream](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_next_upstream)\
[uwsgi_next_upstream_timeout](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_next_upstream_timeout)\
[uwsgi_next_upstream_tries](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_next_upstream_tries)\
[uwsgi_no_cache](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_no_cache)\
[uwsgi_param](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_param)\
[uwsgi_pass](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_pass)\
[uwsgi_pass_header](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_pass_header)\
[uwsgi_pass_request_body](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_pass_request_body)\
[uwsgi_pass_request_headers](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_pass_request_headers)\
[uwsgi_read_timeout](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_read_timeout)\
[uwsgi_request_buffering](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_request_buffering)\
[uwsgi_send_timeout](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_send_timeout)\
[uwsgi_socket_keepalive](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_socket_keepalive)\
[uwsgi_ssl_certificate](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_certificate)\
[uwsgi_ssl_certificate_key](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_certificate_key)\
[uwsgi_ssl_conf_command](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_conf_command)\
[uwsgi_ssl_crl](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_crl)\
[uwsgi_ssl_name](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_name)\
[uwsgi_ssl_password_file](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_password_file)\
[uwsgi_ssl_protocols](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_protocols)\
[uwsgi_ssl_server_name](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_server_name)\
[uwsgi_ssl_session_reuse](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_session_reuse)\
[uwsgi_ssl_trusted_certificate](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_trusted_certificate)\
[uwsgi_ssl_verify](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_verify)\
[uwsgi_ssl_verify_depth](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_ssl_verify_depth)\
[uwsgi_store](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_store)\
[uwsgi_store_access](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_store_access)\
[uwsgi_temp_file_write_size](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_temp_file_write_size)\
[uwsgi_temp_path](https://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_temp_path)\
[valid_referers](https://nginx.org/en/docs/http/ngx_http_referer_module.html#valid_referers)\
[variables_hash_bucket_size (ngx_http_core_module)](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables_hash_bucket_size)\
[variables_hash_bucket_size (ngx_stream_core_module)](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#variables_hash_bucket_size)\
[variables_hash_max_size (ngx_http_core_module)](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables_hash_max_size)\
[variables_hash_max_size (ngx_stream_core_module)](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#variables_hash_max_size)\
[worker_aio_requests](https://nginx.org/en/docs/ngx_core_module.html#worker_aio_requests)\
[worker_connections](https://nginx.org/en/docs/ngx_core_module.html#worker_connections)\
[worker_cpu_affinity](https://nginx.org/en/docs/ngx_core_module.html#worker_cpu_affinity)\
[worker_priority](https://nginx.org/en/docs/ngx_core_module.html#worker_priority)\
[worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes)\
[worker_rlimit_core](https://nginx.org/en/docs/ngx_core_module.html#worker_rlimit_core)\
[worker_rlimit_nofile](https://nginx.org/en/docs/ngx_core_module.html#worker_rlimit_nofile)\
[worker_shutdown_timeout](https://nginx.org/en/docs/ngx_core_module.html#worker_shutdown_timeout)\
[working_directory](https://nginx.org/en/docs/ngx_core_module.html#working_directory)\
[xclient](https://nginx.org/en/docs/mail/ngx_mail_proxy_module.html#xclient)\
[xml_entities](https://nginx.org/en/docs/http/ngx_http_xslt_module.html#xml_entities)\
[xslt_last_modified](https://nginx.org/en/docs/http/ngx_http_xslt_module.html#xslt_last_modified)\
[xslt_param](https://nginx.org/en/docs/http/ngx_http_xslt_module.html#xslt_param)\
[xslt_string_param](http://nginx.org/en/docs/http/ngx_http_xslt_module.html#xslt_string_param)\
[xslt_stylesheet](https://nginx.org/en/docs/http/ngx_http_xslt_module.html#xslt_stylesheet)\
[xslt_types](https://nginx.org/en/docs/http/ngx_http_xslt_module.html#xslt_types)\
[zone (ngx_http_upstream_module)](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone)\
[zone (ngx_stream_upstream_module)](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#zone)\
[zone_sync](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync)\
[zone_sync_buffers](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_buffers)\
[zone_sync_connect_retry_interval](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_connect_retry_interval)\
[zone_sync_connect_timeout](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_connect_timeout)\
[zone_sync_interval](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_interval)\
[zone_sync_recv_buffer_size](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_recv_buffer_size)\
[zone_sync_server](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_server)\
[zone_sync_ssl](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl)\
[zone_sync_ssl_certificate](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_certificate)\
[zone_sync_ssl_certificate_key](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_certificate_key)\
[zone_sync_ssl_ciphers](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_ciphers)\
[zone_sync_ssl_conf_command](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_conf_command)\
[zone_sync_ssl_crl](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_crl)\
[zone_sync_ssl_name](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_name)\
[zone_sync_ssl_password_file](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_password_file)\
[zone_sync_ssl_protocols](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_protocols)\
[zone_sync_ssl_server_name](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_server_name)\
[zone_sync_ssl_trusted_certificate](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_trusted_certificate)\
[zone_sync_ssl_verify](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_verify)\
[zone_sync_ssl_verify_depth](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl_verify_depth)\
[zone_sync_timeout](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_timeout)
</details>

<details close>
<summary>Lua dynamic module directives</summary>

[lua_load_resty_core](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_load_resty_core)\
[lua_use_default_type](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_use_default_type)\
[lua_malloc_trim](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_malloc_trim)\
[lua_code_cache](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_code_cache)\
[lua_thread_cache_max_entries](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_thread_cache_max_entries)\
[lua_regex_cache_max_entries](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_regex_cache_max_entries)\
[lua_regex_match_limit](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_regex_match_limit)\
[lua_package_path](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_package_path)\
[lua_package_cpath](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_package_cpath)\
[init_by_lua](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#init_by_lua)\
[init_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#init_by_lua_block)\
[init_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#init_by_lua_file)\
[init_worker_by_lua](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#init_worker_by_lua)\
[init_worker_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#init_worker_by_lua_block)\
[init_worker_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#init_worker_by_lua_file)\
[exit_worker_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#exit_worker_by_lua_block)\
[exit_worker_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#exit_worker_by_lua_file)\
[set_by_lua](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#set_by_lua)\
[set_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#set_by_lua_block)\
[set_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#set_by_lua_file)\
[content_by_lua](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#content_by_lua)\
[content_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#content_by_lua_block)\
[content_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#content_by_lua_file)\
[server_rewrite_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#server_rewrite_by_lua_block)\
[server_rewrite_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#server_rewrite_by_lua_file)\
[rewrite_by_lua](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#rewrite_by_lua)\
[rewrite_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#rewrite_by_lua_block)\
[rewrite_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#rewrite_by_lua_file)\
[access_by_lua](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#access_by_lua)\
[access_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#access_by_lua_block)\
[access_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#access_by_lua_file)\
[header_filter_by_lua](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#header_filter_by_lua)\
[header_filter_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#header_filter_by_lua_block)\
[header_filter_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#header_filter_by_lua_file)\
[body_filter_by_lua](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#body_filter_by_lua)\
[body_filter_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#body_filter_by_lua_block)\
[body_filter_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#body_filter_by_lua_file)\
[log_by_lua](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#log_by_lua)\
[log_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#log_by_lua_block)\
[log_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#log_by_lua_file)\
[balancer_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#balancer_by_lua_block)\
[balancer_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#balancer_by_lua_file)\
[lua_need_request_body](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_need_request_body)\
[ssl_client_hello_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#ssl_client_hello_by_lua_block)\
[ssl_client_hello_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#ssl_client_hello_by_lua_file)\
[ssl_certificate_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#ssl_certificate_by_lua_block)\
[ssl_certificate_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#ssl_certificate_by_lua_file)\
[ssl_session_fetch_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#ssl_session_fetch_by_lua_block)\
[ssl_session_fetch_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#ssl_session_fetch_by_lua_file)\
[ssl_session_store_by_lua_block](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#ssl_session_store_by_lua_block)\
[ssl_session_store_by_lua_file](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#ssl_session_store_by_lua_file)\
[lua_shared_dict](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_shared_dict)\
[lua_socket_connect_timeout](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_socket_connect_timeout)\
[lua_socket_send_timeout](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_socket_send_timeout)\
[lua_socket_send_lowat](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_socket_send_lowat)\
[lua_socket_read_timeout](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_socket_read_timeout)\
[lua_socket_buffer_size](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_socket_buffer_size)\
[lua_socket_pool_size](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_socket_pool_size)\
[lua_socket_keepalive_timeout](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_socket_keepalive_timeout)\
[lua_socket_log_errors](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_socket_log_errors)\
[lua_ssl_ciphers](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_ssl_ciphers)\
[lua_ssl_crl](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_ssl_crl)\
[lua_ssl_protocols](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_ssl_protocols)\
[lua_ssl_trusted_certificate](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_ssl_trusted_certificate)\
[lua_ssl_verify_depth](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_ssl_verify_depth)\
[lua_ssl_conf_command](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_ssl_conf_command)\
[lua_http10_buffering](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_http10_buffering)\
[rewrite_by_lua_no_postpone](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#rewrite_by_lua_no_postpone)\
[access_by_lua_no_postpone](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#access_by_lua_no_postpone)\
[lua_transform_underscores_in_response_headers](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_transform_underscores_in_response_headers)\
[lua_check_client_abort](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_check_client_abort)\
[lua_max_pending_timers](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_max_pending_timers)\
[lua_max_running_timers](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_max_running_timers)\
[lua_sa_restart](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_sa_restart)\
[lua_worker_thread_vm_pool_size](https://github.com/openresty/lua-nginx-module?tab=readme-ov-file#lua_worker_thread_vm_pool_size)
</details>


<details close>
<summary>GeoIP2 dynamic module directives</summary>

[geoip2 (ngx_http_geo2_module)](https://github.com/leev/ngx_http_geoip2_module#user-content-download-maxmind-geolite2-database-optional)\
[geoip2 (ngx_stream_geo2_module)](https://github.com/leev/ngx_http_geoip2_module#user-content-download-maxmind-geolite2-database-optional)\
[geoip2_proxy (ngx_http_geo2_module)](https://github.com/leev/ngx_http_geoip2_module#user-content-download-maxmind-geolite2-database-optional)\
[geoip2_proxy_recursive (ngx_http_geo2_module)](https://github.com/leev/ngx_http_geoip2_module#user-content-download-maxmind-geolite2-database-optional)\
</details>
