On the **Create App Component** *Caching* page:

1. Select the *Enable Caching* toggle to turn on caching.
1. Define the *Split Config* settings as appropriate for your component.

   - **PERCENTAGE** -- Select if you want to split the cache across two or more disk stores and assign a percentage of the store to each location.  The *key* field is not required for this option if users set only one disk.
   - **STRING** -- Select if you want to split the cache across two or more disk stores using pattern matching. The *key* field is required for this option.

     {{< note >}}The *key* string must contain at least one valid [NGINX variable](https://nginx.org/en/docs/varindex.html). Example: `${request_uri}`{{< /note >}}

1. Define the desired settings for the Disk Store:

   - **Path**: This is the location where the cache will be stored; this path must already exist on the data plane.
   - **Max Size**
   - **Min Free**
   - **In Memory Store Size**
   - **Is Default**
   - **Temp Path** (Optional)
   - **Inactive Time** (Optional)
   - **Directory Level** (Optional)
   - **Trim Policy** (Optional)
   - **Loader Policy** (Optional)
   - **Purger Policy** (Optional)

   {{< see-also >}}Refer to the [`proxy_cache_path` docs](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) for more information about these options.{{< /see-also >}}

1. Select *Add Disk Store* to add another disk store (Optional).
   This will split the cache across multiple storage locations according to the *Split Config* criteria you selected.

   The following *Split Config* options will display depending on the criteria you selected:
   - **Percent Criteria** - Required when using "PERCENTAGE" criteria type; must be an integer followed by the `%` symbol; decimals are supported; for example, `75%` or `50.5%`.
   - **String Criteria** - Required when using "STRING" criteria type; Depending upon the `SplitConfig`-> `Key` it could be a string like `~/html`, `~*.html$'` or IP based string like `10.1.1.2`

1. Select **Next** to go to the next page, or **Submit** to save and submit your changes.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-489 -->