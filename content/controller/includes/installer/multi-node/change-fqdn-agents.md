To update the FQDN for Controller Agents, take the following steps on each instance where the Controller Agent is installed:

1. Open the `/etc/controller-agent/agent.conf` file for editing.
1. Update the `api_url` value with the new FQDN:

    ```nginx
    [cloud]
    api_url = https://<NEW_FQDN>:8443/1.4
    ```

1. Save the changes.
1. Restart the Controller Agent:

    ```bash
    sudo service controller-agent restart
    ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-298 -->