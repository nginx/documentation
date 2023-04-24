On the **Create App Component** *Backend* page: 

1. Provide a Workload Group Name.
1. (Optional) Select a Location.
   
   The default Location is "Unspecified". This value is applied automatically to "bring your own" (BYO) NGINX Plus instances that were not deployed by NGINX Controller.
   {{< see-also >}}Refer to the [Manage Locations]({{< relref "/infrastructure/locations/manage-locations.md" >}}) topic for more information.{{< /see-also >}}

1. Define the backend workload URIs, then select **Done**.
1. Define the DNS Server, then select **Done**.
1. (Optional) Select the Load Balancing Method. The default value is "Round Robin".

   {{< see-also >}}Refer to the [NGINX Plus Admin Guide](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/) for more information about the available options.{{< /see-also >}}

1. (Optional) Select the Session Persistence type.
1. (Optional) Define the desired Proxy settings, then select **Done**.
   
   {{< tip >}}Hover your pointer over the info icon for each setting to learn about the expected values and requirements.{{< /tip >}}

1. Select **Next**.
1. (Optional) Enable Health monitoring and define the desired Monitoring Request and Response.
   Health Monitoring is disabled by default.
1. Select **Next**.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-347 -->