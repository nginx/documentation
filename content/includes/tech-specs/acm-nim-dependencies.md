API Connectivity Manager depends on the platform capabilities of Instance Manager. The following table lists the minimum versions of Instance Manager required for ACM:

{{<bootstrap-table "table table-striped table-bordered">}}
| API Connectivity Manager | Instance Manager Dependency |
|--------------------------|-----------------------------|
| ACM 1.6.0                | NIM 2.10.0                  |
| ACM 1.5.0                | NIM 2.9.0 and later         |
| ACM 1.4.0–1.4.1          | NIM 2.7.0 and later         |
| ACM 1.3.0–1.3.1          | NIM 2.6.0 and later         |
| ACM 1.1.0–1.2.0          | NIM 2.4.0 and later         |
| ACM 1.0.0                | NIM 2.3.0 and later         |
{{</bootstrap-table>}}

<br>

To ensure API Connectivity Manager's new features work correctly, you may need to install or upgrade Instance Manager to the minimum version specified. If Instance Manager is not installed, API Connectivity Manager will install the latest version. If the installed version is below the minimum required version, API Connectivity Manager will upgrade Instance Manager to the latest version. Otherwise, API Connectivity Manager will leave Instance Manager unchanged.

{{< important >}} If you're [installing API Connectivity Manager in an offline environment]({{< relref "/nms/admin-guides/installation/on-prem/offline-install-guide.md#install-acm-offline" >}}) and the minimum required version of Instance Manager is not installed, the API Connectivity Manager installer will exit. You'll need to [install Instance Manager manually]({{< relref "/nms/admin-guides/installation/on-prem/offline-install-guide.md#install-nim-offline" >}}) before installing API Connectivity Manager.{{< /important >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1066 -->
