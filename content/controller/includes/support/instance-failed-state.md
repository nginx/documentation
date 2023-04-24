If an Instance is in a `Failed` state, the Controller Agent or NGINX service may not be running.

Take the following steps to troubleshoot the issue:

1. Open an SSH connection to the failed Instance.
1. Check the status of the Controller Agent service:

    ```bash
    sudo systemctl status controller-agent.service
    ```

    If the Controller Agent service isn't running, you can start the service by running the following command:

    ```bash
    sudo systemctl start controller-agent.service
    ```

1. Check the status of the NGINX service:

    ```bash
    sudo systemctl status nginx.service
    ```

    If the NGINX service isn't running, you can start the service by running the following command:

    ```bash
    sudo systemctl start nginx.service
    ```

1. If neither of these steps resolves the issue, inspect the following log files for errors:

    - `/var/log/nginx-controller/agent.log`
    - `/var/log/nginx/error.log`

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-360 -->