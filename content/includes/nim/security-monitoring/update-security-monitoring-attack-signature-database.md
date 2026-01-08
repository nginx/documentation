---
nd-docs: DOCS-117
nd-product: NIMNGR
nd-files:
- content/nim/security-monitoring/update-signatures.md
- content/nim/waf-integration/configuration/setup-signatures-and-threats/update-security-monitoring-signature-db.md
---

1. Open an SSH connection to the data plane host and log in.
1. Generate a Signature Report file using the [Attack Signature Report Tool]({{< ref "/waf/configure/converters.md#attack-signature-report-tool" >}}). Save the file as `signature-report.json`:

    ```shell
    sudo /opt/app_protect/bin/get-signatures -o ./signature-report.json
    ```

1. Open an SSH connection to the management plane host and log in.
1. Copy the `signature-report.json` file to the NGINX Instance Manager control plane at `/usr/share/nms/sigdb/`:

    ```shell
    sudo scp /path/to/signature-report.json {user}@{host}:/usr/share/nms/sigdb/signature-report.json
    ```

1. Restart the NGINX Instance Manager services to apply the update:

    ```shell
    sudo systemctl restart nms-ingestion
    sudo systemctl restart nms-core
    ```