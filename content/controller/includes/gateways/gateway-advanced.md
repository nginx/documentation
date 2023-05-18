On the **Gateways** > **Create Gateway** > **Additional** page:

1. (Optional) In the **Methods** list, select one or more of the supported HTTP methods to use.
1. (Optional) In the **Receive Buffer Size** box, set the buffer size to use for reading client requests. The default buffer size is 16k.
1. (Optional) In the **Send Buffer Size** box, set the buffer size to use for reading a response from a disk. The default buffer size is 32k.
1. (Optional) In the **Client Max Body Size** box, set the maximum size allowed for the client request body, specified in the `Content-Length` request header field. The default max body size is 1 MB.
1. (Optional) Select the **Allow Underscores in Headers** toggle to allow underscores in client request header fields. When set to disabled (the default setting), request headers with names that contain underscores are considered invalid and are ignored.
1. (Optional) Select a **TCP Keep Alive** mode to use for the idle, interval, and count settings for keep alive probes.

   - `Use OS defaults` - use the OS default settings.
   - `Explicitly Enable` - set specific values to use for the keep alive probes.
   - `Explicitly Disable` - disable keep alive.

1. (Optional) Add [**Config Snippets**]({{< relref "/app-delivery/about-snippets.md" >}}) to customize your NGINX configuration.
   
   {{< caution >}}
   When you use Snippets to customize your NGINX configuration, your changes are applied to the `nginx.conf` file *as is*. NGINX Controller does not verify that your configuration is valid before applying the snippet. 

   We strongly recommend verifying Snippets in a lab environment before making any changes in production.
   {{< /caution >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-500 -->