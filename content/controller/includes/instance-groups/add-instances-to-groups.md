To add an existing instance to an instance group, take the following steps:

1. Make sure that no [gateways]({{< relref "/services/manage-gateways.md" >}}) are using the instance as a placement. Instances that are referenced by a gateway cannot be added to an instance group. 
2. [Delete the instance]({{< relref "/infrastructure/instances/manage-instances.md#delete-an-instance" >}}).
3. [Add the instance]({{< relref "/admin-guides/install/install-nginx-controller-agent.md#install-the-nginx-controller-agent" >}}) back to NGINX Controller. Run the agent install script ([Step 11]({{< relref "/admin-guides/install/install-nginx-controller-agent.md#install-the-nginx-controller-agent" >}})).

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-835 -->