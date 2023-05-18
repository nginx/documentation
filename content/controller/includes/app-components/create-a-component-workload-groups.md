On the **Create App Component** *Workload Groups* page:

1. Provide a Workload Group Name.
1. (Optional) Select a Location.

   The location determines which instances or instance groups the workload group is applied to. If any workload group specifies a location, they all must specify a location. Note: If the associated gateway uses instance groups, the location should refer to the instance group location, not the location(s) of the individual instances that make up that group.

   {{< see-also >}}Refer to the [Manage Locations]({{< relref "/infrastructure/locations/manage-locations.md" >}}) topic for more information.{{< /see-also >}}
1. Define the backend workload URIs.
1. (Optional) Define the DNS Server.
1. (Optional) Select the Load Balancing Method. The default value is "Round Robin".

   {{< see-also >}}Refer to the [NGINX Plus Admin Guide](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/) for more information about the available options.{{< /see-also >}}

1. (Optional) Select the Session Persistence Type (applicable only to Web Components).
1. (Optional) Select the Desired Proxy Settings (applicable only to Web Components).

   {{< tip >}}Hover your pointer over the info icon for each setting to learn about the expected values and requirements.{{< /tip >}}
1. Select **Next**.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-498 -->