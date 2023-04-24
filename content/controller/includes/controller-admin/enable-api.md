NGINX Controller uses the `/api` location on the NGINX Plus instance to collect metrics.

When you push a configuration to an NGINX Plus instance, NGINX Controller automatically enables the `/api` location for that instance.

{{< note >}}
The `/api` location settings that NGINX Controller creates will override any settings that you have previously defined.
{{< /note >}}

If you use NGINX Controller solely to monitor your NGINX Plus instances, you may need to enable the `/api` location on your instances manually.
Refer to the [Configuring the API](https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/#configuring-the-api) section of the NGINX Plus Admin Guide for instructions.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-513 -->