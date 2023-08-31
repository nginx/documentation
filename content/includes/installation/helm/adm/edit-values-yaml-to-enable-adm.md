---
docs: "DOCS-1320"
---

To enable the App Delivery Manager module, take the following steps:

1. Open the `values.yaml` file for editing.
1. Add the following snippet to the `values.yaml` file:

   ```yaml
   # values.yaml
   global:
       nmsModules:
           nms-adm:
               enabled: true
   nms-adm:
       imagePullSecrets:
       - name: regcred
       adm:
           image:
               repository: <my-docker-registry>/nms-adm 
               tag: <version>
   ```

   This `values.yaml` file enables the App Delivery Manager module and specifies the image pull secret, repository, and tag of the image to be used.

   - Replace `<my-docker-registry>` with your private Docker registry.
   - Replace `<version>` with the tag you noted when [loading the Docker image](#load-adm-docker-image) above.
   - In the `imagePullSecrets` section, add the credentials for your private Docker registry.

1. Close and save the `values.yaml` file.
