Take the following steps to uninstall the Controller Agent and delete an instance.

{{< important >}}Be sure to uninstall the Controller Agent first, before you delete an instance. If you don't uninstall the Controller Agent first, the instance may reappear in NGINX Controller after it has been deleted.{{< /important >}}

1. On your NGINX Plus instance, stop the Controller Agent service:

    - On Ubuntu/Debian:

        ```bash
        service controller-agent stop
        ```

    - On CentOS/Red Hat Enterprise Linux:

        ```bash
        systemctl stop controller-agent
        ```

1. Run the appropriate command for your distribution to uninstall the Controller Agent:

    - On Ubuntu/Debian:

        ``` bash
        apt-get purge nginx-controller-agent
        ```

    - On CentOS/Red Hat Enterprise Linux:

        ``` bash
        yum remove nginx-controller-agent
        ```

        After the package is removed, you can safely delete the files in `/etc/controller-agent/` and `/var/log/nginx-controller/`.

1. (Optional) If you use SELinux on CentOS or Red Hat Enterprise Linux, take the following steps to remove the SELinux policy that was created when the Controller Agent was installed:

    1. Revert the installed permissions:

        ```bash
        sudo semodule -r nginx
        ```

    1. Remove the following files:

        - `nginx.te`
        - `nginx.mod`
        - `nginx.pp`

1. Delete the NGINX Plus instance from the NGINX Controller user interface:

    1. Open the NGINX Controller user interface and log in.

    1. Select the NGINX Controller menu icon, then select **Infrastructure**.

    1. On the **Infrastructure** menu, select **Instances** > **Overview**.

    1. On the **Instances** overview page, select the NGINX Plus instance that you want to delete.

    1. Select the delete icon (trash can).

1. Delete alerts:

    {{< note >}}When you delete an instance, any related alerts for that instance are not deleted automatically. You can delete the alerts manually, however.{{< /note >}}

    {{< include "alerts/delete-alerts.md" >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-518 -->