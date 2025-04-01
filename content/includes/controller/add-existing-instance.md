Take the following steps to add an instance to NGINX Controller:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Infrastructure**.
3. On the **Infrastructure** menu, select **Instances** > **Overview**.
4. On the **Instances** overview page, select **Create**.
5. On the **Create Instance** page, select **Add an existing instance**.
6. Add a name for the instance. If you don't provide a name, the hostname of the instance is used by default.
7. To add the instance to an existing [Instance Group]({{< ref "/controller/infrastructure/instances/manage-instances.md#instance-groups" >}}), select an Instance Group from the list. Or to create an Instance Group, select **Create New**.
8. To add the instance to an existing Location, select a Location from the list. Or to create a Location, select **Create New**.

    {{< important >}}
Once set, the Location for an instance cannot be changed. If you need to change or remove the Location for an instance, you must [remove the instance from NGINX Controller]({{< ref "/controller/infrastructure/instances/manage-instances.md#delete-an-instance" >}}), and then add it back.
    {{< /important >}}

    {{< important >}}
Instances and the instance groups they belong to should specify the same location; however, this requirement is not currently enforced. If different locations are specified, the instance group's location takes precedence. This is important to remember when [assigning locations to workload groups]({{< ref "/controller/app-delivery/manage-apps.md#workload-groups">}}).
    {{< /important >}}

9. (Optional) By default, registration of NGINX Plus instances is performed over a secure connection. To use self-signed certificates with the Controller Agent, select **Allow insecure server connections to NGINX Controller using TLS**. For security purposes, we recommend that you secure the Controller Agent with signed certificates when possible.
10. Use SSH to connect and log in to the NGINX instance that you want to connect to NGINX Controller.
11. Run the `curl` or `wget` command that's shown in the **Installation Instructions** section on the NGINX instance to download and install the Controller Agent package. When specified, the `-i` and `-l` options for the `install.sh` script refer to the instance name and Location, respectively.

    {{< note >}}

Make sure you enter the commands to download and run the `install.sh` script on the NGINX Plus system, and not on the NGINX Controller.

NGINX Controller 3.6 and earlier require Python 2.6 or 2.7. You'll be prompted to install Python if it's not installed already. Python is not required for NGINX Controller v3.7 and later.

    {{< /note >}}

After a few minutes, the NGINX instance will appear on the **Instances** overview page.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-743 -->