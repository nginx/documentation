---
docs: DOCS-1325
---

Run the following commands to install the NGINX Management Suite chart from the Helm repository:

```shell
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
```

The first command, `helm repo add nginx-stable https://helm.nginx.com/stable`, adds the `nginx-stable` repository to your local Helm repository list. This repository contains the Helm charts for deploying NGINX Management Suite.

The second command, `helm repo update`, updates the local Helm repository list with the newest versions of the charts from the `nginx-stable` repository. This command ensures you have the most up-to-date version of the charts available for installation.
