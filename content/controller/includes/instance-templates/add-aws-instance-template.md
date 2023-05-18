To create an Instance Template for AWS NGINX instances, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure** > **Instance Templates**.
1. Select **Create Instance Template**.
1. Add a name.
1. (Optional) Add a display name.
1. (Optional) Add a description.
1. (Optional) Add tags.
1. Select a Location in the list, or select **Create New** to [create a Location]({{< relref "/infrastructure/locations/manage-locations.md" >}}).
1. In the Type list, select `AWS_INSTANCE_TEMPLATE`.
1. Add the [Amazon Machine Image ID](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html).
1. Add the [EC2 Instance Type](https://aws.amazon.com/ec2/instance-types/).
1. Add the [Subnet ID](https://docs.aws.amazon.com/vpc/latest/userguide/working-with-vpcs.html).
1. (Optional) Add the [Security Group IDs](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html).
1. (Optional) Add the [AWS Public Key](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html).
1. Specify whether a public IP address should be assigned to the instance.
1. Select **Submit**.

{{< note >}}

Enabling WAF via the App Security add-on is not supported when deploying Instances with an Instance Template.

{{< /note >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-738 -->