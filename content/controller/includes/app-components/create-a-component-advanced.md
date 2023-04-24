On the **Create App Component** *Advanced* page:

1. (Optional) Set the desired **Client Max Body Size**.

    {{< see-also >}}
Refer to the [NGINX module docs](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size) for more information about this option.
    {{< /see-also >}}
2. Select **Next**.
3. (Optional) Select **Add URI Redirects** and define the desired redirect condition(s).
4. (Optional) Select **Add URI Rewrite** and define the desired rewrite pattern(s).
5. (Optional) Select **Add Request Header Modification** and define how to modify the request header.
6. (Optional) Select **Add Response Header Modification** and define how to modify the response header.

    {{< see-also >}}
Refer to the [NGINX module docs](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html) for more information about these options.
    {{< /see-also >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-346 -->