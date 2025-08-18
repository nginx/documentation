---
nd-docs: "DOCS-000"
files:
- content/nginx-one/k8s/add-ngf-manifests.md
- content/nginx-one/k8s/add-ngf-helm.md
---

To create a Kubernetes secret, you'll need:

- The Data Plane Key
- To set up the secret in the same namespace as NGINX Gateway Fabric
- Use the name `dataplane.key` as shown
- A namespace. The default NGINX Gateway Fabric namespace is `nginx-gateway`
  - You can create it with the following command: `kubectl create namespace nginx-gateway`

Once you have that information, run the following command:


   ```shell
   kubectl create secret generic dataplane-key \
     --from-literal=dataplane.key=<Your Dataplane Key> \
     -n <namespace>
   ```
