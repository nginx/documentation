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

    {{< see-also>}}
Refer to the [`ngx_http_upstream_hc_module` docs](http://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check) for more information about these options.
    {{< /see-also >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-493 -->