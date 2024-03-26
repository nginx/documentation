---
docs: DOCS-1316
---

To enable the API Connectivity Manager Module, take the following steps:

1. Open the `values.yaml` file for editing.
1. Add the following snippet to the `values.yaml` file:

   ```yaml
   # values.yaml
   global:
       nmsModules:
           nms-acm:
               enabled: true
   nms-acm:
       imagePullSecrets:
       - name: regcred
       acm:
           image:
               repository: <my-docker-registry>/nms-acm
               tag: <version>
   ```

   This `values.yaml` file enables the API Connectivity module and specifies the image pull secret, repository, and tag of the image to be used.

   - Replace `<my-docker-registry>` with your private Docker registry.
   - Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.
   - In the `imagePullSecrets` section, add the credentials for your private Docker registry.

1. Close and save the `values.yaml` file.
