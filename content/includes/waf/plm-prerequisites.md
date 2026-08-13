---
f5-product: F5 WAF for NGINX
f5-files:
- content/ngf/waf-integration/get-started-plm.md
---

<!-- Maintainer note: This include contains PLM-specific prerequisites and storage defaults shared across product tutorials (NGF, NIC). Do not add product-specific requirements here; keep them in the parent tutorial's Before you begin section. -->

- A Kubernetes cluster with a default StorageClass that supports dynamic provisioning. The PLM object store relies on PersistentVolumeClaims. Without a default StorageClass, the SeaweedFS pods stay `Pending`.
- Helm 3.x installed. The PLM backend installs as a Helm chart.
- An F5 WAF for NGINX JWT from MyF5, used to pull images from `private-registry.nginx.com`.
- Optionally, `nginx-repo.crt` and `nginx-repo.key` from MyF5, needed only for authenticated signature updates from `pkgs.nginx.com`.

PLM ships with an embedded SeaweedFS S3-compatible object store. The bundled SeaweedFS operator deploys and manages it. You don't need to provide an external S3 bucket. The PLM controller writes compiled policy bundles to this store; the data plane reads from it.

By default, the deployment creates one master pod, one filer pod, and three volume pods, each backed by its own PVC. The chart generates credentials for the store and saves them in the `<release>-f5-waf-seaweedfs-auth` Secret.

By default, communication between PLM and the object store uses unencrypted HTTP. To enable TLS, see the PLM chart values (`helm show values nginx-stable/f5-waf-policy-controller`).
