---
description: Configure NGINX and F5 NGINX Plus as a web server, with support for virtual
  server multi-tenancy, URI and response rewriting, variables, and error handling.
nd-docs: DOCS-443
title: Configuring NGINX and NGINX Plus as a Web Server
toc: true
weight: 100
type:
- how-to
---

This article explains how to configure NGINX Open Source and F5 NGINX Plus as a web server.

**Note:** The information in this article applies to both NGINX Open Source and NGINX Plus. For ease of reading, the remainder of the article refers to NGINX Plus only.

At a high level, configuring NGINX Plus as a web server is a matter of defining which URLs it handles and how it processes HTTP requests for resources at those URLs. At a lower level, the configuration defines a set of _virtual servers_ that control the processing of requests for particular domains or IP addresses. For more information about configuration files, refer to [Creating NGINX and NGINX Plus Configuration Files]({{< ref "/nginx/admin-guide/basic-functionality/managing-configuration-files">}}).

Each virtual server for HTTP traffic defines special configuration instances called _locations_ that control processing of specific sets of URIs. Each location defines its own scenario of what happens to requests that are mapped to this location. NGINX Plus provides full control over this process. Each location can proxy the request or return a file. In addition, the URI can be modified, so that the request is redirected to another location or virtual server. Also, a specific error code can be returned and you can configure a specific page to correspond to each error code.


<span id="virtual-server"></span>
## Set Up Virtual Servers

The NGINX Plus configuration file must include at least one [server](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) directive to define a virtual server. When NGINX Plus processes a request, it first selects the virtual server that will serve the request.

A virtual server is defined by a `server` directive in the `http` context, for example:

```nginx
http {
    server {
        # Server configuration
    }
}
```

It is possible to add multiple `server` directives into the `http` context to define multiple virtual servers.

The `server` configuration block usually includes a [listen](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive to specify the IP address and port (or Unix domain socket and path) on which the server listens for requests. Both IPv4 and IPv6 addresses are accepted; enclose IPv6 addresses in square brackets.

The example below shows configuration of a server that listens on IP address 127.0.0.1 and port 8080:

```nginx
server {
    listen 127.0.0.1:8080;
    # Additional server configuration
}
```

If a port is omitted, the standard port is used. Likewise, if an address is omitted, the server listens on all addresses. If the `listen` directive is not included at all, the “standard” port is `80/tcp` and the “default” port is `8000/tcp`, depending on superuser privileges.

If there are several servers that match the IP address and port of the request, NGINX Plus tests the request’s `Host` header field against the [server_name](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name) directives in the `server` blocks. The parameter to `server_name` can be a full (exact) name, a wildcard, or a regular expression. A wildcard is a character string that includes the asterisk (`*`) at its beginning, end, or both; the asterisk matches any sequence of characters. NGINX Plus uses the Perl syntax for regular expressions; precede them with the tilde (`~`). This example illustrates an exact name.

```nginx
server {
    listen      80;
    server_name example.org www.example.org;
    #...
}
```

If several names match the `Host` header, NGINX Plus selects one by searching for names in the following order and using the first match it finds:

1. Exact name
2. Longest wildcard starting with an asterisk, such as `*.example.org`
3. Longest wildcard ending with an asterisk, such as `mail.*`
4. First matching regular expression (in order of appearance in the configuration file)

If the `Host` header field does not match a server name, NGINX Plus routes the request to the default server for the port on which the request arrived. The default server is the first one listed in the **nginx.conf** file, unless you include the `default_server` parameter to the `listen` directive to explicitly designate a server as the default.

```nginx
server {
    listen 80 default_server;
    #...
}
```


<span id="locations"></span>
## Configure Locations

NGINX Plus can send traffic to different proxies or serve different files based on the request URIs. These blocks are defined using the [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) directive placed within a `server` directive.

For example, you can define three `location` blocks to instruct the virtual server to send some requests to one proxied server, send other requests to a different proxied server, and serve the rest of the requests by delivering files from the local file system.

NGINX Plus tests request URIs against the parameters of all `location` directives and applies the directives defined in the matching location. Inside each `location` block, it is usually possible (with a few exceptions) to place even more `location` directives to further refine the processing for specific groups of requests.

**Note:** In this guide, the word _location_ refers to a single [location](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) context.

There are two types of parameter to the `location` directive: _prefix strings_ (pathnames) and regular expressions. For a request URI to match a prefix string, it must start with the prefix string.

The following sample location with a pathname parameter matches request URIs that begin with <span style="white-space: nowrap;">**/some/path/**</span>, such as <span style="white-space: nowrap;">**/some/path/document.html**</span>. (It does not match <span style="white-space: nowrap;">**/my-site/some/path**</span> because <span style="white-space: nowrap;">**/some/path**</span> does not occur at the start of that URI.)

```nginx
location /some/path/ {
    #...
}
```

A regular expression is preceded with the tilde (`~`) for case-sensitive matching, or the tilde-asterisk (`~*`) for case-insensitive matching. The following example matches URIs that include the string **.html** or **.htm** in any position.

```nginx
location ~ \.html? {
    #...
}
```


<span id="location_priority"></span>
### NGINX Location Priority

To find the location that best matches a URI, NGINX Plus first compares the URI to the locations with a prefix string. It then searches the locations with a regular expression.

Higher priority is given to regular expressions, unless the `^~` modifier is used. Among the prefix strings NGINX Plus selects the most specific one (that is, the longest and most complete string). The exact logic for selecting a location to process a request is given below:

1. Test the URI against all prefix strings.
2. The `=` (equals sign) modifier defines an exact match of the URI and a prefix string. If the exact match is found, the search stops.
3. If the `^~` (caret-tilde) modifier prepends the longest matching prefix string, the regular expressions are not checked.
4. Store the longest matching prefix string.
5. Test the URI against regular expressions.
6. Stop processing when the first matching regular expression is found and use the corresponding location.
7. If no regular expression matches, use the location corresponding to the stored prefix string.

A typical use case for the `=` modifier is requests for **/** (forward slash). If requests for **/** are frequent, specifying `= /` as the parameter to the `location` directive speeds up processing, because the search for matches stops after the first comparison.

```nginx
location = / {
    #...
}
```

A `location` context can contain directives that define how to resolve a request – either serve a static file or pass the request to a proxied server. In the following example, requests that match the first `location` context are served files from the **/data** directory and the requests that match the second are passed to the proxied server that hosts content for the **<www.example.com>** domain.

```nginx
server {
    location /images/ {
        root /data;
    }

    location / {
        proxy_pass http://www.example.com;
    }
}
```

The [root](https://nginx.org/en/docs/http/ngx_http_core_module.html#root) directive specifies the file system path in which to search for the static files to serve. The request URI associated with the location is appended to the path to obtain the full name of the static file to serve. In the example above, in response to a request for <span style="white-space: nowrap;">**/images/example.png**</span>, NGINX Plus delivers the file <span style="white-space: nowrap;">**/data/images/example.png**</span>.

The [proxy_pass](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive passes the request to the proxied server accessed with the configured URL. The response from the proxied server is then passed back to the client. In the example above, all requests with URIs that do not start with **/images/** are be passed to the proxied server.


<span id="variables"></span>
## Use Variables

You can use variables in the configuration file to have NGINX Plus process requests differently depending on defined circumstances. Variables are named values that are calculated at runtime and are used as parameters to directives. A variable is denoted by the `$` (dollar) sign at the beginning of its name. Variables define information based upon NGINX’s state, such as the properties of the request being currently processed.

There are a number of predefined variables, such as the [core HTTP](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables) variables, and you can define custom variables using the [set](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#set), [map](https://nginx.org/en/docs/http/ngx_http_map_module.html#map), and [geo](https://nginx.org/en/docs/http/ngx_http_geo_module.html#geo) directives. Most variables are computed at runtime and contain information related to a specific request. For example, `$remote_addr` contains the client IP address and `$uri` holds the current URI value.


<span id="return-codes"></span>
## Return Specific Status Codes

Some website URIs require immediate return of a response with a specific error or redirect code, for example when a page has been moved temporarily or permanently. The easiest way to do this is to use the [return](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return) directive. For example:

```nginx
location /wrong/url {
    return 404;
}
```

The first parameter of `return` is a response code. The optional second parameter can be the URL of a redirect (for codes `301`, `302`, `303`, and `307`) or the text to return in the response body. For example:

```nginx
location /permanently/moved/url {
    return 301 http://www.example.com/moved/here;
}
```

<a name="rewrite"></a>

The `return` directive can be included in both the `location` and `server` contexts.


<span id="rewrite"></span>
## Rewrite URIs in Requests

A request URI can be modified multiple times during request processing through the use of the [rewrite](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite) directive, which has one optional and two required parameters. The first (required) parameter is the regular expression that the request URI must match. The second parameter is the URI to substitute for the matching URI. The optional third parameter is a flag that can halt processing of further `rewrite` directives or send a redirect (code `301` or `302`). For example:

```nginx
location /users/ {
    rewrite ^/users/(.*)$ /show?user=$1 break;
}
```

As this example shows, the second parameter `users` captures though matching of regular expressions.

You can include multiple `rewrite` directives in both the `server` and `location` contexts. NGINX Plus executes the directives one-by-one in the order they occur. The `rewrite` directives in a `server` context are executed once when that context is selected.

After NGINX processes a set of rewriting instructions, it selects a `location` context according to the new URI. If the selected location contains `rewrite` directives, they are executed in turn. If the URI matches any of those, a search for the new location starts after all defined `rewrite` directives are processed.

The following example shows `rewrite` directives in combination with a `return` directive.

```nginx
server {
    #...
    rewrite ^(/download/.*)/media/(\w+)\.?.*$ $1/mp3/$2.mp3 last;
    rewrite ^(/download/.*)/audio/(\w+)\.?.*$ $1/mp3/$2.ra  last;
    return  403;
    #...
}
```

This example configuration distinguishes between two sets of URIs. URIs such as <span style="white-space: nowrap;">**/download/some/media/file**</span> are changed to <span style="white-space: nowrap;">**/download/some/mp3/file.mp3**</span>. Because of the `last` flag, the subsequent directives (the second `rewrite` and the `return` directive) are skipped but NGINX Plus continues processing the request, which now has a different URI. Similarly, URIs such as <span style="white-space: nowrap;">**/download/some/audio/file**</span> are replaced with <span style="white-space: nowrap;">**/download/some/mp3/file.ra**</span>. If a URI doesn’t match either `rewrite` directive, NGINX Plus returns the `403` error code to the client.

There are two parameters that interrupt processing of `rewrite` directives:

- `last` – Stops execution of the `rewrite` directives in the current `server` or `location` context, but NGINX Plus searches for locations that match the rewritten URI, and any `rewrite` directives in the new location are applied (meaning the URI can be changed again).
- `break` – Like the [break](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#break) directive, stops processing of `rewrite` directives in the current context and cancels the search for locations that match the new URI. The `rewrite` directives in the new location are not executed.


<span id="sub_filter"></span>
## Rewrite HTTP Responses

Sometimes you need to rewrite or change the content in an HTTP response, substituting one string for another. You can use the [sub_filter](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter) directive to define the rewrite to apply. The directive supports variables and chains of substitutions, making more complex changes possible.

For example, you can change absolute links that refer to a server other than the proxy:

```nginx
location / {
    sub_filter      /blog/ /blog-staging/;
    sub_filter_once off;
}
```

Another example changes the scheme from `http://` to `https://` and replaces the `localhost` address with the hostname from the request header field. The [sub_filter_once](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter_once) directive tells NGINX to apply [sub_filter](https://nginx.org/en/docs/http/ngx_http_sub_module.html#sub_filter) directives consecutively within a location:

```nginx
location / {
    sub_filter     'href="http://127.0.0.1:8080/'    'href="https://$host/';
    sub_filter     'img src="http://127.0.0.1:8080/' 'img src="https://$host/';
    sub_filter_once on;
}
```

Note that the part of the response already modified with the `sub_filter` is not replaced again if another `sub_filter` match occurs.


<span id="errors"></span>
## Handle Errors

With the [error_page](https://nginx.org/en/docs/http/ngx_http_core_module.html#error_page) directive, you can configure NGINX Plus to return a custom page along with an error code, substitute a different error code in the response, or redirect the browser to a different URI. In the following example, the `error_page` directive specifies the page (**/404.html**) to return with the `404` error code.

```nginx
error_page 404 /404.html;
```

Note that this directive does not mean that the error is returned immediately (the `return` directive does that), but simply specifies how to treat errors when they occur. The error code can come from a proxied server or occur during processing by NGINX Plus (for example, the `404` results when NGINX Plus can’t find the file requested by the client).

In the following example, when NGINX Plus cannot find a page, it substitutes code `301` for code `404`, and redirects the client to <span style="white-space: nowrap;">**http:/example.com/new/path.html**</span>. This configuration is useful when clients are still trying to access a page at its old URI. The `301` code informs the browser that the page has moved permanently, and it needs to replace the old address with the new one automatically upon return.

```nginx
location /old/path.html {
    error_page 404 =301 http:/example.com/new/path.html;
}
```

The following configuration is an example of passing a request to the back end when a file is not found. Because there is no status code specified after the equals sign in the `error_page` directive, the response to the client has the status code returned by the proxied server (not necessarily `404`).

```nginx
server {
    ...
    location /images/ {
        # Set the root directory to search for the file
        root /data/www;

        # Disable logging of errors related to file existence
        open_file_cache_errors off;

        # Make an internal redirect if the file is not found
        error_page 404 = /fetch$uri;
    }

    location /fetch/ {
        proxy_pass http://backend/;
    }
}
```

The `error_page` directive instructs NGINX Plus to make an internal redirect when a file is not found. The `$uri` variable in the final parameter to the `error_page` directive holds the URI of the current request, which gets passed in the redirect.

For example, if <span style="white-space: nowrap;">**/images/some/file**</span> is not found, it is replaced with <span style="white-space: nowrap;">**/fetch/images/some/file**</span> and a new search for a location starts. As a result, the request ends up in the second `location` context and is [proxied](https://www.nginx.com/resources/admin-guide/reverse-proxy/) to **"http://backend/"**.

The [open_file_cache_errors](https://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache_errors) directive prevents writing an error message if a file is not found. This is not necessary here since missing files are correctly handled.
