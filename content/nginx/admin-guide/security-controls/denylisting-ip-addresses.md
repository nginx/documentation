---
description: Control access to your site or apps from specific client IP addresses,
  using dynamic denylists built with the F5 NGINX Plus key-value store and API.
docs: DOCS-434
title: Dynamic Denylisting of IP Addresses
toc: true
weight: 1100
type:
- how-to
---

This section describes how to create a denylist or allowlist of specific client IP addresses, which denies or allows them access to your site, and how to dynamically maintain the list of addresses.

<span id="overview"></span>
## Overview

In F5 NGINX Plus <a href="../../../releases/#r13">Release 13</a> (R13) and later, you can denylist some IP addresses as well as create and maintain a database of denylisted IP addresses. You can also explicitly allowlist other IP addresses. The IP addresses database is managed with the NGINX Plus <a href="https://nginx.org/en/docs/http/ngx_http_api_module.html">API</a> and <a target="_blank" href="https://nginx.org/en/docs/http/ngx_http_keyval_module.html">keyval</a> modules.

NGINX Plus <a href="../../../releases/#r13">Release 19</a> (R19) extends this capability by matching an IP address to any address within a subnet or network range.


<span id="prereq"></span>
## Prerequisites

NGINX Plus <a href="../../../releases/#r13">Release 13</a> and later, NGINX Plus <a href="../../../releases/#r19">Release 19</a> and later for network ranges support.

<span id="setup"></span>
## Setup

First, enable the database for storing the list of denylisted and allowlisted IP addresses.

1. In NGINX Plus configuration file, include the [keyval_zone](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone) directive in the [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context to create a memory zone for storing keys and values. This sample directive creates a 1‑MB zone called **one**.

   ```nginx
   http {
       # ...
       keyval_zone zone=one:1m;
    }
   ```

   To perform matching of an IP address against subnets (for example, `192.168.13.0/24`), specify the `type=ip` parameter of the [keyval_zone](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone) directive:

   ```nginx
   http {
       # ...
       keyval_zone zone=one:1m type=ip;
    }
   ```

   Note that the size of [keyval_zone](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone) should also be increased as the `type=ip` parameter also enables an extra index stored in the zone.

   You can optionally include the `state` parameter to create a file where the key‑value database is stored and so persists across NGINX Plus reloads and restarts; in this example, **one.keyval**:

   ```nginx
   keyval_zone zone=one:1m state=one.keyval;
   ```

2. Enable the NGINX Plus API in read‑write mode with the [api](https://nginx.org/en/docs/http/ngx_http_api_module.html#api) directive:

   ```nginx
   # ...
    server {
        listen 80;
        server_name www.example.com;

        location /api {
            api write=on;
        }
    }
    ```

   We strongly recommend [restricting access]({{< relref "/nginx/admin-guide/security-controls/controlling-access-proxied-http.md" >}}) to this location, for example by allowing access only from `localhost` (`127.0.0.1`), and by using HTTP basic authentication to restrict use of the `PATCH`, `POST`, and `DELETE` methods to a specified set of users:

   ```nginx
   # ...
    server {
        listen 80;
        server_name www.example.com;

        location /api {
            api   write=on;

            allow 127.0.0.1;
            deny  all;

            limit_except GET {
                auth_basic "NGINX Plus API";
                auth_basic_user_file /path/to/passwd/file;
            }
        }
    }
    ```

3. Populate the key‑value database with the API's [POST](https://nginx.org/en/docs/http/ngx_http_api_module.html#postHttpKeyvalZoneData) method, supplying the data in JSON format. You can use the `curl` command as in the following example. If the zone is empty, you can enter several key‑value pairs at once; otherwise, pairs must be added one at a time.

   ```shell
   $ curl -X POST -d '{
      "10.0.0.1": "1",
      "10.0.0.2": "1",
      "10.0.0.3": "0",
      "10.0.0.4": "0"
    }' -s http://www.example.com/api/6/http/keyvals/one
   ```

   If you have specified matching of IP addresses against network ranges (with the `type=ip` parameter of the [keyval_zone](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone) directive), send the `POST` command with the network range specified in CIDR notation:

   ```shell
   $ curl -X POST -d '{
      "192.168.13.0/24": "1"
    }' -s http://www.example.com/api/6/http/keyvals/one
   ```

4. Define how client IP addresses are evaluated against the key‑value database, by including the [keyval](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval) directive in the [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http) context.

   The directive takes advantage of the standard NGINX and NGINX Plus variable [`$remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_addr), which is set to the client IP address automatically for every request.

   As it processes each request, NGINX Plus:

   - Looks up the first parameter (here, `$remote_addr`, preset to the client's IP address) in the key‑value database specified by the `zone=` parameter (here, **one**).

   - If a key in the database exactly matches `$remote_addr`, sets the second parameter (here, `$target`) to the value corresponding to the key. In our example, the value is `1` for denylisted addresses or `0` for allowlisted addresses.

   ```nginx
   http {
        # ...
        keyval_zone zone=one:1m type=ip state=one.keyval;
        keyval $remote_addr $target zone=one; # Client address is the key,
                                              # $target is the value;
    }
   ```

5. Create a rule with the [if](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#if) directive that either allows or denies access depending on the client IP address. With this rule, access is allowed when `$target` is `0` and denied when it is `1`:

   ```nginx
   if ($target) {
       return 403;
   }
   ```

<span id="manage"></span><span id="curl"></span>
## Managing the Key-Value Database

You can use API methods to update a key‑value database  dynamically, without requiring a reload of NGINX Plus.

All of the following examples operate on the **one** zone, which is accessible at **<http://www.example.com/api/6/http/keyvals/one>**.

- To get the list of all database entries for a zone:

   ```shell
   curl -X GET 'http://www.example.com/api/6/http/keyvals/one'
   ```


- To update the value for an existing entry (in this example to change the access status for IP address `10.0.0.4` from allowlisted to denylisted):

   ```shell
   curl -X PATCH -d '{"10.0.0.4": "1"}' -s 'http://www.example.com/api/6/http/keyvals/one'
   ```

- To add an entry to a populated zone:

   ```shell
   curl -X POST -d '{"10.0.0.5": "1"}' -s 'http://www.example.com/api/6/http/keyvals/one'
   ```

- To delete an entry:

   ```shell
   curl -X PATCH -d '{"10.0.0.4":null}' -s 'http://www.example.com/api/6/http/keyvals/one'
   ```


<span id="example"></span>
## Full Example

The full NGINX Plus configuration:

```nginx
http {
    # ...
    keyval_zone zone=one:1m type=ip state=one.keyval;
    keyval $remote_addr $target zone=one;

    server {
        listen 80;
        server_name www.example.com;

        location /api {
            api   write=on;

            allow 127.0.0.1;
            deny  all;

            limit_except GET {
                auth_basic "NGINX Plus API";
                auth_basic_user_file /path/to/passwd/file;
            }
        }

        if ($target) {
            return 403;
        }
    }
}
```

This configuration:

- Creates a 1 MB keyval zone **one** that accepts network ranges and also creates the file **one.keyval** to make the database of key‑value pairs persists across reloads and restarts of NGINX Plus.

- Enables the NGINX Plus API in write mode so that the zone can populated with IP addresses.

- Enables lookup of the IP address `$remote_addr` in the key-value database as the key, and puts the value of the found key into the `$target` variable.

- Enables a simple rule to check for the resulting value: if the value of `$target` is `1` (address is denylisted), return `403 (Forbidden)` to the client.


The following `curl` command populates the empty keyval zone **one** with IP addresses that are denylisted (value is `1`) or allowlisted (value is `0`):

```shell
curl -X POST -d '{
     "10.0.0.1": "1",
     "192.168.13.0/24": "1",
     "10.0.0.3": "0",
     "10.0.0.4": "0"
}' -s 'http://www.example.com/api/6/http/keyvals/one'
```

<span id="see-also"></span>
## See Also

- [Dynamic IP Denylisting with NGINX Plus and fail2ban](https://www.nginx.com/blog/dynamic-ip-denylisting-with-nginx-plus-and-fail2ban/)
