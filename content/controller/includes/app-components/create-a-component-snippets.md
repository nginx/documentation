On the **Create App Component** *Snippets* page:

1. Select the appropriate snippet type:

    - *Add URI Snippet*: Adds NGINX directives to the component's `server` and `location` blocks.
    - *Add Workload Group Snippet*: Adds NGINX directives to the component's `upstream` block(s).

1. Paste or type the desired snippet into the text field. 

   Snippets should follow the standard `nginx.conf` format.   
   For example, the below URI snippet adds the `proxy_set_header` directive to the component's `server` block.
      
   ```Nginx configuration file
   proxy_set_header Host $proxy_host;
   ```
   
   {{< caution >}}When you use Snippets to customize your NGINX configuration, your changes are applied to the `nginx.conf` file *as is*. NGINX Controller does not verify that your configuration is valid before applying the snippet. We strongly recommend verifying Snippets in a lab environment before making any changes in production.{{< /caution >}}

1. Select **Next** to preview the REST API call for your component, or **Submit** to save and submit your changes.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-496 -->