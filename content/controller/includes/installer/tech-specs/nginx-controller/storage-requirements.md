The following table shows the minimum storage requirements we recommend for NGINX Controller. Your final storage requirements may differ depending on your environment, configuration, and the number of instances, apps, and APIs you're managing. Production deployments, for example, will require more storage than trial deployments. Contact your NGINX Controller sales associate if you have questions about sizing for your particular environment.

We recommend using a local volume for the analytics and config databases for trial deployments, for simplicity's sake so you can get started using NGINX Controller right away. For production environments, we recommend using an external volume for the databases for resiliency.

{{< bootstrap-table "table table-striped table-bordered" >}}
| Resource | Path(s) | Minimum Storage |
|-|-|-|
| NGINX&nbsp;Controller | <code style="white-space:nowrap;">/opt/nginx-controller</code> | 80&nbsp;GB |
| Analytics database |  <code style="white-space:nowrap;">/opt/nginx-controller/clickhouse_data</code>  | &#8226;&nbsp;50&nbsp;GB <br> &#8226;&nbsp;150&nbsp;GB if App Security is enabled |
| Config database | <code style="white-space:nowrap;">/opt/nginx-controller/postgres_data</code> | 10&nbsp;GB |
| Logs  | &#8226;&nbsp;<code style="white-space:nowrap;">/var/log/nginx-controller</code> <br> &#8226;&nbsp;<code style="white-space:nowrap;">/var/log/journal</code> <br> &#8226;&nbsp;<code style="white-space:nowrap;">/var/log/pods</code> <br> &#8226;&nbsp;<code style="white-space:nowrap;">/var/lib/docker/containers</code> <br> &#8226;&nbsp;<code style="white-space:nowrap;">/var/lib/kubelet</code> <br> &#8226;&nbsp;<code style="white-space:nowrap;">/var/lib/kubernetes</code>| 15&nbsp;GB cumulative |
{{< bootstrap-table >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-321 -->