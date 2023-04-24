NGINX Controller uses an [Analytics, Visibility, and Reporting daemon (AVRD)]({{< relref "analytics/metrics/overview-metrics-metadata.md" >}}) to aggregate and report app-centric metrics. You can use these metrics to monitor your apps' performance and health.

To uninstall AVRD and the supporting modules, run the following command on each dataplane instance:

- Debian/Ubuntu

    ```bash
    sudo apt-get purge avrd nginx-plus-module-metrics avrd-libs
    ```

- RedHat/CentOS

    ```bash
    sudo yum remove avrd avrd-metrics nginx-plus-module-metrics
    ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-544 -->