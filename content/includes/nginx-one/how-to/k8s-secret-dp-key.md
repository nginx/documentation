---
nd-docs: "DOCS-000"
files:
- content/nginx-one/k8s/add-ngf-manifests.md
- content/nginx-one/k8s/add-ngf-helm.md
---

To create a Kubernetes secret, you'll need:

- The Data Plane Key
- The `nginx-gateway` namespace must exist. You can create it with the following command: `kubectl create namespace nginx-gateway`

   - Then create the secret with the following command. The key must be named `dataplane.key`:

   ```shell
   kubectl create secret generic dataplane-key \
     --from-literal=dataplane.key=<Your Dataplane Key> \
     -n nginx-gateway
   ```

