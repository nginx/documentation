---
docs: "DOCS-1620"
---

NGINX App Protect WAF v5 introduces a new directive, in addition to those specified in the [NGINX App Protect WAF Configuration Guide]({{< relref "/nap-waf/v5/configuration-guide/configuration.md#directives" >}}).

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Directive Name | Syntax | Description | Default |
| ---| ---| ---| --- |
|`app_protect_enforcer_address` | `<hostname/ip>:<port>` | The Enforcer service address. | None |
{{</bootstrap-table>}}

Set this directive in the `http` context of the `nginx.conf` file. The Enforcer service, by default, listens on port **50000**.

For instance, when nginx is running on a VM, or at the same Kubernetes pod with the Enforcer service, the configuration would be:

```nginx
app_protect_enforcer_address 127.0.0.1:50000;
```

And in a fully-containerized Docker deployment, we can use the name of the Enforcer container :

```nginx
app_protect_enforcer_address waf-enforcer:50000;
```