On the **Create App Component** *Backend* page:

{{< note >}} The following settings are applicable only to Web components. {{< /note >}}

1. (Optional) Enable [NTLM authentication](https://en.wikipedia.org/wiki/Integrated_Windows_Authentication) to allow proxying requests with NT LAN Manager (NTLM) Authentication.
1. (Optional) Specify the persistent state.
1. (Optional) Set the HTTP protocol version for proxying.
1. (Optional) Specify the Keep Alive settings:

    - **Connections**: Set the maximum number of idle keepalive connections to upstream servers that are preserved in the cache of each worker process. When this number is exceeded, the least recently used connections are closed.
    - **Requests per Connection**: Set the maximum number of requests that can be served through one keepalive connection. After the maximum number of requests is made, the connection is closed.
    - **Idle Timeout box**: Set a timeout during which an idle keepalive connection to an upstream server will stay open.
1. Select **Next**.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-488 -->