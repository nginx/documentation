Take the following steps to create an Instance Template:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure** > **Instance Templates**.
1. Select **Create Instance Template**.
1. Add a name.
1. (Optional) Add a display name.
1. (Optional) Add a description.
1. (Optional) Add tags.
1. Select a Location in the list, or select **Create New** to [create a Location]({{< relref "/infrastructure/locations/manage-locations.md" >}}).
1. Select the Instance Template type.

    - Select `AWS_INSTANCE_TEMPLATE` to create a template for NGINX instances on Amazon Web Services. For instructions on how to deploy NGINX instances on AWS, refer to the tutorial [Add an AWS NGINX Instance]({{< relref "/infrastructure/instances/add-aws-instance.md" >}}).

1. Specify whether a public IP address should be assigned to the instance.
1. Select **Submit**.

{{< note >}}

Enabling WAF via the App Security add-on is not supported when deploying Instances with an Instance Template.

{{< /note >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-739 -->