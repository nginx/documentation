The NGINX Management Suite modules depend on the platform capabilities of Instance Manager, which is installed with NGINX Management Suite.

If you intend to enable a module other than Instance Manager, make sure to select compatible product versions when downloading the NGINX Management Suite Helm bundle and module Docker images.

The following table shows the versions of Instance Manager and compatible modules for each version of the NGINX Management Suite helm chart.

{{<bootstrap-table "table table-striped table-bordered">}}
| NMS chart version | Instance Manager | API Connectivity Manager |
|-------------------|------------------|--------------------------|
| 1.5.1             | 2.10.0           | 1.6.0                    |
| 1.5.0             | 2.10.0           | 1.5.0                    |
| 1.4.0             | 2.9.1            | 1.5.0                    |
| 1.3.1             | 2.9.0            | 1.5.0                    |
| 1.3.0             | 2.9.0            | 1.4.1                    |
| 1.2.1             | 2.8.0            | 1.4.1                    |
| 1.2.0             | 2.8.0            | 1.4.0                    |
| 1.1.2             | 2.7.0            | 1.4.1                    |
| 1.1.1             | 2.7.0            | 1.4.0                    |
| 1.1.0             | 2.7.0            | 1.3.1                    |
| 1.0.0             | 2.6.0            | 1.3.1                    |
{{</bootstrap-table>}}
