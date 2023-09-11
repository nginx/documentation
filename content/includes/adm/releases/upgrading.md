---
docs: DOCS-1293
---

### Upgrading from previous Early Access releases

{{< custom-styles >}}
<style>
ul#reinstall_app_delivery_manager {
  margin: 0 0 10px 0px;
}
</style>

The latest (August 24th) release introduces several breaking changes. We strongly recommend a fresh installation of the latest release:

{{<tabs name="reinstall_app_delivery_manager">}}
{{%tab name="CentOS, RHEL, and RPM-Based"%}}

  1. Completely uninstall App Delivery Manager by running the following command:

      ```bash
      yum remove nms-app-delivery-manager
      ```

  1. Remove all the files in the `/var/lib/nms/dqlite/adm` directory.

  1. [Install]({{< relref "/nms/installation/vm-bare-metal/install-adm.md" >}}) the latest Early Access release.

  1.  Remove the empty `builtin-*` folders from the `/etc/nms/modules/adm/templates/usecases` directory.

{{%/tab%}}
{{%tab name="Debian, Ubuntu, and Deb-Based"%}}

  1. Completely uninstall App Delivery Manager by running the following command:

      ```bash
      sudo apt-get purge nms-app-delivery-manager
      ```

  1. Remove all the files in the `/var/lib/nms/dqlite/adm` directory.

  1. [Install]({{< relref "/nms/installation/vm-bare-metal/install-adm.md" >}}) the latest Early Access release.


{{%/tab%}}
{{</tabs>}}

{{< note >}}If you choose to upgrade instead, review the [Changes in Behavior]({{< relref "/nms/adm/releases/release-notes.md#4-0-0-EA3-changes-in-behavior" >}}) section below and perform the necessary changes in your environment.{{< /note >}}