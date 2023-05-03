API Connectivity Manager (ACM) depends on the platform capabilities of Instance Manager. The following table lists the minimum versions of Instance Manager required for ACM:

The following table lists the minimum versions of Instance Manager required for ACM:

{{<bootstrap-table "table table-striped table-bordered">}}
| API Connectivity Manager | Instance Manager Dependency |
|--------------------------|-----------------------------|
| ACM 1.5.0                | NIM 2.9.0–2.9.1             |
| ACM 1.4.0–1.4.1          | NIM 2.7.0 and later         |
| ACM 1.3.0–1.3.1          | NIM 2.6.0 and later         |
| ACM 1.1.0–1.2.0          | NIM 2.4.0 and later         |
| ACM 1.0.0                | NIM 2.3.0 and later         |
{{</bootstrap-table>}}

<br>

To ensure ACM's new features work correctly, you may need to install or upgrade Instance Manager to the minimum version specified. If Instance Manager is not installed, ACM will install the latest version. If the installed version is below the minimum required version, ACM will upgrade Instance Manager to the latest version. Otherwise, ACM will leave Instance Manager unchanged.

{{< important >}} If you're [installing ACM in an offline environment]({{< relref "/nms/admin-guides/installation/on-prem/offline-install-guide.md#install-acm-offline" >}}) and the minimum required version of Instance Manager is not installed, the ACM installer will exit. You'll need to [install Instance Manager manually]({{< relref "/nms/admin-guides/installation/on-prem/offline-install-guide.md#install-nim-offline" >}}) before installing ACM.{{< /important >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1066 -->
