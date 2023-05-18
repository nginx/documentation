After you install and start the Controller Agent, it should begin reporting right away, pushing aggregated data to NGINX Controller at regular one-minute intervals. It takes about one minute for a new Instance to appear in the NGINX Controller user interface.

If you don't see the new Instance in the user interface or the Controller Agent isn't collecting metrics, make sure of the following:

1. The Controller Agent package -- `nginx-controller-agent` -- installed successfully without any warnings.
1. The controller-agent service is running and updating its log file. To check the status, run the following command:

    ```bash
    systemctl status controller-agent
    ```

    {{< see-also >}}
For troubleshooting purposes, you can turn on Controller Agent debug logging by editing the `agent.conf` file. For more information, refer to [K64001240: Enabling NGINX Controller Agent debug logging](https://support.f5.com/csp/article/K64001240).
    {{< /see-also >}}

1. The system DNS resolver is correctly configured, and the NGINX Controller server's fully qualified domain name (FQDN) can be resolved.
1. The controller-agent service can be running as `root` or a different user, chosen during the installation if the Controller Agent was [installed to run as a non-root user]({{< relref "/admin-guides/install/install-agent-non-root.md" >}}). To view the user ID for the controller-agent service, run the following command:

    ```bash
    ps -ef | egrep 'agent'
    ```

    The output looks similar to the following (with a different user for non-root Agent installations):

    ```lang-none
    root     19132     1  1 Sep03 ?        00:23:45 /usr/bin/nginx-controller-agent
    ```

3. The Controller Agent and the NGINX Instance user IDs can both run the `ps` command to see all the system processes. If the `ps` command is restricted for non-privileged users, the Controller Agent won't detect the NGINX master process.
4. The system time is set correctly. If the time on the system where the Controller Agent is running is ahead or behind the NGINX Controller's system time, you won't be able to see data in  graphs. Make sure that NGINX Controller and any NGINX Instances have their time synchronized using [NTP](http://www.ntp.org).
5. The NGINX Plus API is set up correctly and working. 

   Refer to the [Configuring the API](https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/#configuring-the-api) section of the NGINX Plus Admin Guide for instructions.
7. All NGINX configuration files are readable by the Controller Agent user ID. Verify the owner, group, and permissions settings.
9. `selinux`, `apparmor`, or other third-party OS security tools are not interfering with the metrics collection. For example, for `selinux`, inspect  `/etc/selinux/config` and try `setenforce 0` temporarily to see if it improves the situation for certain metrics.
10. The virtual private server (VPS) provider has not used hardened Linux kernels that may restrict non-root users from accessing `/proc` and `/sys`. Metrics describing the system and NGINX disk I/O are usually affected. There is no easy workaround for this except to allow the Controller Agent to run as `root`. Fixing permissions for `/proc` and `/sys/block` may also help.

{{< see-also >}}

For more information on installing and configuring the Controller Agent, see the following topics:

- [Installing the NGINX Controller Agent]({{< relref "admin-guides/install/install-nginx-controller-agent.md" >}})
- [Installing the NGINX Controller Agent for non-root users]({{< relref "/admin-guides/install/install-agent-non-root.md" >}})
- [Configuring the NGINX Controller Agent]({{< relref "admin-guides/config-agent/configure-the-agent.md" >}})
- [Configuring metrics collection for NGINX Controller]({{< relref "admin-guides/config-agent/configure-metrics-collection.md" >}})

{{< /see-also >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-356 -->