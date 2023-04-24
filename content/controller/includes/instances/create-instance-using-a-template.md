An [Instance Template]({{< relref "/infrastructure/instances/manage-instance-templates.md" >}}) defines the parameters to use when creating a data plane instance. Instance Templates are ideal for cloud orchestration and make managing your cloud resources easy and quick.

{{< see-also >}}
For steps on how to deploy NGINX instances on Amazon Web Services or Microsoft Azure, see the following tutorials:

- [Add an AWS NGINX Instance]({{< relref "/infrastructure/instances/add-aws-instance.md" >}})
- [Add an Azure NGINX Instance]({{< relref "/infrastructure/instances/add-azure-instance.md" >}})

{{< /see-also >}}

Take the following steps to create an instance using an Instance Template:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure** menu, select **Instances**.
1. On the **Instances** overview page, select **Create**.
1. Select **Create a new instance using a template**.
1. Add a name.
1. Select a **Location** in the list, or select **Create New** to [create a location]({{< relref "/infrastructure/locations/manage-locations.md" >}}).
1. Select an **Instance Template** in the list, or select **Create New** to [create an instance template]({{< relref "/infrastructure/instances/manage-instance-templates.md" >}}).
1. Select **Submit**.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-744 -->