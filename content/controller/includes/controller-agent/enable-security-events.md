You will need to configure the NGINX Controller Agent to emit Security Events when requests trigger security violations.

To enable Security Events, take the following steps:

1. Open the `/etc/controller-agent/agent/conf` file in your preferred editor.
1. Under "Extensions", add `security = True`.

  {{< note >}} If you are running more than one NGINX App Protect instance, you must take this step for each instance.{{< /note >}}
2. Restart the agent.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-516 -->