---
f5-product: FABRIC
---

### No IngressLink is created

The `ExternalLoadBalancer` exists, but no `IngressLink` is created from it, so nothing is ever posted to BIG-IP.

- Confirm the `--external-load-balancer` flag is set on the control plane deployment. Helm ignores values a chart does not define, so a chart without external load balancer support renders a deployment without the flag:

```shell
kubectl get deploy -n nginx-gateway ngf-nginx-gateway-fabric \
  -o jsonpath='{.spec.template.spec.containers[?(@.name=="nginx-gateway")].args}'
```

- Check the control plane logs:

```shell
kubectl logs -n nginx-gateway deploy/ngf-nginx-gateway-fabric | grep -i ingresslink
```

### The IngressLink has no status

The `IngressLink` exists, but its `status` field is empty. F5 Container Ingress Services writes this status, so an empty status means it has not processed the resource.

- Wait up to two minutes for reconciliation. If the status stays empty, check the F5 Container Ingress Services logs:

```shell
kubectl logs -n kube-system deploy/f5-cis-f5-bigip-ctlr
```

### No address is allocated

- Confirm F5 Container Ingress Services was deployed with `args.ipam=true`.
- Check the F5 IPAM Controller logs for the requested label:

```shell
kubectl logs -n kube-system -l app=f5-ipam-controller --tail=20
```

A label that does not match a configured pool is reported directly:

```text
[PROV] IPAM LABEL: gatewaylink Not Found
[PROV] Unsupported IPAM LABEL: gatewaylink
```

Set `ipamLabel` on the `ExternalLoadBalancer` to a pool name from the `args.ip_range` map used when installing the F5 IPAM Controller. A successful allocation is logged instead:

```text
[CORE] Allocated IP: 192.0.2.100 for Request: IPAMLabel: production
```

### The AS3 declaration is rejected

The `IngressLink` reports an error, or BIG-IP does not show the expected objects. BIG-IP rejected the declaration posted by F5 Container Ingress Services.

- Read the BIG-IP response in the F5 Container Ingress Services logs. The response usually names the problem precisely:

```shell
kubectl logs -n kube-system deploy/f5-cis-f5-bigip-ctlr | grep -E "AS3\]\[POST\]|response:"
```

### F5 Container Ingress Services reports that AS3 is not installed

The F5 Container Ingress Services Pod is in `CrashLoopBackOff` and its logs contain:

```text
[ERROR] AS3 RPM is not installed on BIGIP
```

F5 Container Ingress Services infers this from a 404 on the AS3 endpoint, so it also appears when AS3 is installed but not serving. See [Troubleshooting](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/troubleshooting.html) in the F5 documentation.

After restoring AS3, delete the F5 Container Ingress Services Pod so it retries immediately rather than waiting out its backoff:

```shell
kubectl delete pod -n kube-system -l app=f5-cis-f5-bigip-ctlr
```

Existing traffic is unaffected. BIG-IP keeps forwarding using the configuration already programmed, and only configuration changes are blocked.

### A pool is empty

A virtual server exists, but one of its pools contains no members, so requests to it fail.

- Confirm the type of the Gateway's Service matches the F5 Container Ingress Services `pool_member_type`. Use `NodePort` with `nodeport`, or `ClusterIP` with `cluster`:

```shell
kubectl get svc gateway-nginx -o jsonpath='{.spec.type}'
```

- With `cluster`, confirm BIG-IP has a route to the Pod network.
- Confirm the Gateway has a listener on the port the empty pool was built for. A missing or invalid `certificateRefs` Secret leaves an HTTPS listener unprogrammed, so the Service never exposes port 443:

```shell
kubectl get svc gateway-nginx -o jsonpath='{.spec.ports}' | python3 -m json.tool
kubectl describe gateways.gateway.networking.k8s.io gateway
```

### NGINX logs show an internal address as the client

NGINX applies the PROXY protocol header only when the peer address is trusted, and kube-proxy forwards the connection, so the peer is the node's Pod-network address.

- Set `trustedAddresses` on the `NginxProxy` resource to the Pod network CIDR:

```shell
kubectl get nodes -o jsonpath='{.items[*].spec.podCIDRs}'
```

Confirm the value reached the data plane:

```shell
kubectl exec <NGINX_POD_NAME> -c nginx -- grep set_real_ip_from /etc/nginx/conf.d/http.conf
```

If the trusted address is already correct, confirm the iRule is attached to the virtual server:

```shell
curl -sku '<BIGIP_USERNAME>:<BIGIP_PASSWORD>' "https://<BIGIP_ADDRESS>/mgmt/tm/ltm/virtual/~k8s~Shared~<VIRTUAL_SERVER_NAME>" \
  | python3 -m json.tool | grep -A5 rules
```

An empty `rules` list means the iRule is not attached, so no PROXY protocol header is sent at all.

### A configured field has no effect

A field set on the `ExternalLoadBalancer` never appears on BIG-IP, while the `ExternalLoadBalancer` reports `Accepted: True` and the `IngressLink` reports `OK`. Kubernetes discards fields that are not in the installed custom resource definition schema without reporting an error, so both controllers report success while the field never arrives.

- Check each stage in order to find where the field stops:

```shell
kubectl get crd ingresslinks.cis.f5.com -o yaml | grep -A5 <FIELD_NAME>
kubectl logs -n nginx-gateway deploy/ngf-nginx-gateway-fabric | grep "unknown field"
kubectl get ingresslink gateway-nginx -o jsonpath='{.spec}' | python3 -m json.tool
kubectl logs -n kube-system deploy/f5-cis-f5-bigip-ctlr | grep -i <FIELD_NAME>
```

An `unknown field` message in the NGINX Gateway Fabric log means the installed custom resource definition is older than the NGINX Gateway Fabric release. Install a matching custom resource definition version.
