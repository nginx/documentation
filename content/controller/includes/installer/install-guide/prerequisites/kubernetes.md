NGINX Controller ships with a required version of Kubernetes and will install Kubernetes for you. Be sure to install NGINX Controller on a dedicated node that **does not** already have Kubernetes configured.

The following table lists the Kubernetes versions that are  installed by NGINX Controller:

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>
| NGINX&nbsp;Controller | Kubernetes         |
|-----------------------|--------------------|
| v3.x                  | v1.15.5 |

The [Kubernetes Pod DNS config](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-dns-config) has a limit of six configured DNS search domain names. This is also the [`glibc` limit](https://man7.org/linux/man-pages/man5/resolv.conf.5.html). 

In NGINX Controller, Core-DNS creates three search domains that are determined at run-time and not in `/etc/resolv.conf`:

* `<namespace>.svc.cluster.local`
* `svc.cluster.local`
* `cluster.local <any host resolv.conf search paths>`

In general, changing the settings in NGINX Controller's underlying Kubernetes cluster is not recommended. However, if you do change the cluster's Pod config to allow additional search domains, **you should not add more than three domains**.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-289 -->