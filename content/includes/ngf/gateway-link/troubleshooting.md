---
f5-product: NGINX Gateway Fabric
---

### No IngressLink is created

Confirm the `--external-load-balancer` flag is set on the control plane deployment. Helm ignores values a chart does not define, so a chart without external load balancer support renders a deployment without the flag:

```shell
kubectl get deploy -n nginx-gateway ngf-nginx-gateway-fabric \
  -o jsonpath='{.spec.template.spec.containers[?(@.name=="nginx-gateway")].args}'
```

### The IngressLink has no status

F5 Container Ingress Services writes this status, so an empty status means it has not processed the resource. Wait up to two minutes for reconciliation, then check its logs:

```shell
kubectl logs -n kube-system deploy/f5-cis-f5-bigip-ctlr
```

### No address is allocated

Confirm F5 Container Ingress Services was deployed with `args.ipam=true`, then check the F5 IPAM Controller logs:

```shell
kubectl logs -n kube-system -l app=f5-ipam-controller --tail=20
```

A label that does not match a configured pool is reported directly:

```text
[PROV] IPAM LABEL: gatewaylink Not Found
```

Set `ipamLabel` on the `ExternalLoadBalancer` to a pool name from the `args.ip_range` map used when installing the F5 IPAM Controller.

### The AS3 declaration is rejected

Read the BIG-IP response in the F5 Container Ingress Services logs, which usually names the problem:

```shell
kubectl logs -n kube-system deploy/f5-cis-f5-bigip-ctlr | grep -E "AS3\]\[POST\]|response:"
```

### F5 Container Ingress Services reports that AS3 is not installed

The Pod is in `CrashLoopBackOff` and its logs contain `[ERROR] AS3 RPM is not installed on BIGIP`. F5 Container Ingress Services infers this from a 404 on the AS3 endpoint, so it also appears when AS3 is installed but not serving. See [Troubleshooting](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/troubleshooting.html) in the F5 documentation.

After restoring AS3, delete the Pod so it retries without waiting out its backoff:

```shell
kubectl delete pod -n kube-system -l app=f5-cis-f5-bigip-ctlr
```

### A pool is empty

Confirm the type of the Gateway's Service matches the F5 Container Ingress Services `pool_member_type`, and that the Gateway has a listener on the port the pool was built for. A missing or invalid `certificateRefs` Secret leaves an HTTPS listener unprogrammed, so the Service never exposes port 443:

```shell
kubectl get svc gateway-nginx -o jsonpath='{.spec.type}{"\n"}{.spec.ports}'
kubectl describe gateways.gateway.networking.k8s.io gateway
```

### NGINX logs show an internal address as the client

The client address travels inside the PROXY protocol header. NGINX reads it only when both the connection address and the address inside the header are trusted, so an internal address in the log means the header never arrived or was discarded.

Confirm the iRule is attached. Creating an iRule on BIG-IP does not attach it to anything:

```shell
curl -sku "$BIGIP_USERNAME:$BIGIP_PASSWORD" "https://$BIGIP_ADDRESS/mgmt/tm/ltm/virtual" \
  | python3 -c 'import sys,json
for v in json.load(sys.stdin)["items"]:
    print(v["fullPath"], "->", v.get("rules", "no rules"))'
```

If the iRule is attached, confirm the trusted addresses:

```shell
kubectl exec $NGINX_POD_NAME -c nginx -- grep set_real_ip_from /etc/nginx/conf.d/http.conf
```

Set `trustedAddresses` on the `NginxProxy` resource to the subnet of the IP address which the BIG-IP system uses to send traffic to NGINX.

### A configured field has no effect

Kubernetes discards fields that are not in the installed custom resource definition schema without reporting an error, so both controllers report success while the field never arrives. Check where the field stops:

```shell
export FIELD_NAME="ipamLabel"

kubectl get crd ingresslinks.cis.f5.com -o yaml | grep -A5 "$FIELD_NAME"
kubectl logs -n nginx-gateway deploy/ngf-nginx-gateway-fabric | grep "unknown field"
kubectl get ingresslink gateway-nginx -o jsonpath='{.spec}' | python3 -m json.tool
```

An `unknown field` message means the installed custom resource definition is older than the NGINX Gateway Fabric release. Install a matching version.
