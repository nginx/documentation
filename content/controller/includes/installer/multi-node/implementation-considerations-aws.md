Before installing or configuring NGINX Controller as a multi-node cluster, review the following list of considerations to assist with planning:

- Configuring NGINX Controller as a multi-node cluster on AWS requires **NGINX Controller 3.14 or later**. To upgrade from an earlier version, refer to the [Update NGINX Controller]({{< relref "admin-guides/install/install-nginx-controller.md#update-nginx-controller" >}}) steps for instructions.
- Data migration is not supported, so it's not possible to implement a multi-node cluster with local volumes without reinstalling NGINX Controller.
- If you plan to run NGINX Controller on AWS EC2 instances, we recommend using NFS shares for the external volumes. Using EBS shares for multi-node clusters is not recommended because of the [EBS Availability Zone limitations](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volumes-multi.html#considerations); for example, the requirement to have EC2 instances and EBS volumes in the same Availability Zone.
- Cluster config changes are orchestrated by a primary control plane node that writes to the external config database. Each NGINX Controller control plane node hosts a set of services (pods) that read and write data. Only the node that hosts the pod that manages the config data writes to the external config database.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-303 -->