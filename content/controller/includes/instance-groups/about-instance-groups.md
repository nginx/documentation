An instance group is a logically grouped set of instances that can be used as a placement for a gateway, rather than a single instance. This concept supports the ability to scale horizontally without having to update the gateway placement. As instances are added to a group, they receive an NGINX configuration identical to those instances in the group. Instances in an instance group can be stand-alone or clustered NGINX Plus instances.  Instances can also leave the group, with the remaining instances continuing to function as intended.

{{< important >}}
**Workload affinity with instance groups**: Similar to instances, instance groups are associated with a location. If a location is not explicitly specified, the unspecified location is assumed. Instances in an instance group should be configured to use the same location; however, this requirement is not currently enforced.

For the workload affinity feature, the location of the instance group must be specified using the optional `locationRef` field in the component's workload group API request. The locations of the instances in the instance group are ignored. The workload affinity feature uses this information and the workload groups to load balance traffic to the correct endpoints.
{{< /important >}}

{{< important >}}
Instance groups are supported on the following versions of NGINX Controller:

- NGINX Controller API Management module v3.18 and later
- NGINX Controller Application Delivery module v3.21 and later
{{< /important >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-734 -->