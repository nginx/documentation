Configure NGINX Controller with the following firewall settings:

{{< bootstrap-table "table table-striped table-bordered" >}}

|Port| Used by | Used for|
|---|---|---|
| 5432 TCP | NGINX Controller database | Incoming connections to the NGINX Controller database from the NGINX Controller host. This is the default PostgreSQL port. |
443 TCP | &bull; NGINX Controller <br/> &bull; NGINX Controller licensing | &bull; Incoming connections to NGINX Controller from a browser; for example, from an internal network and NGINX Plus instances <br/> &bull; Incoming and outgoing connections used to used to validate the entitlements for your NGINX Controller license |
| 8443 TCP | NGINX Controller | Incoming connections from NGINX Plus instances <br>You need to **open** port 8443 TCP if you're running **NGINX Controller v3.18.2 or earlier**|
| 8883 TCP | NGINX Controller licensing | Incoming and outgoing connections used to validate the entitlements for your NGINX Controller license <br> Port 8883 TCP needs to be **opened** only if you're running **NGINX Controller v3.15 or earlier**|

{{< /bootstrap-table >}}

If you have a firewall running on the NGINX Controller host, enable NAT (masquerade) and open the following ports. These ports are used for **internal traffic** only and don't need to be open to the outside:

{{< bootstrap-table "table table-striped table-bordered" >}}

|Port| Used by | Used for|
|---|---|---|
|2379 TCP</br>2380 TCP<br/>6443 TCP|NGINX Controller|Incoming requests to the Kubernetes control plane; used for the Kubernetes API server and etcd|
|10250 TCP|NGINX Controller|Incoming requests to the Kubernetes worker node; used for the Kubelet API|
|10251 TCP|NGINX Controller|Incoming requests to the Kubernetes kube-scheduler; used for the pod scheduling|
|10252 TCP|NGINX Controller|Incoming requests to the Kubernetes kube-controller-manager; used for regulating the state of the system|
|8472 UDP|NGINX Controller|Used for pod-to-pod communication in multi-node resilient clusters|

{{< /bootstrap-table >}}

For more information about these ports, see the Kubernetes guide [Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports).

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-318 -->