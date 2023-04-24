When you [update NGINX Controller]({{< relref "admin-guides/install/install-nginx-controller.md#update-nginx-controller" >}}), you also need to update the NGINX Controller Agent software on each monitored NGINX Plus instance.

To update the NGINX Controller Agent, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure** menu, select **Instances** > **Overview**.
1. On the **Instances** overview page, select **Create**.
1. Follow the instructions in the **Install Instructions** pane to connect to the NGINX instance and install the updated Controller Agent package.

      {{< note >}}

NGINX Controller 3.6 and earlier require Python 2.6 or 2.7. You'll be prompted to install Python if it's not installed already. Python is not required for NGINX Controller 3.7 and later.

      {{< /note >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-519 -->