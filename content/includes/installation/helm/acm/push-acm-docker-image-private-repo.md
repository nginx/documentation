---
docs: DOCS-1315
---

After loading the Docker image, you can now tag and push the image to your private Docker registry. Replace `<my-docker-registry>` in the examples below with the path to your private Docker registry.

1. Log in to your private registry:

   ```shell
   docker login <my-docker-registry>
   ```

   - Replace `<my-docker-registry>` with your private Docker registry.

1. Tag the image with the values you noted when [loading the Docker image](#load-acm-docker-image) above.

   ```shell
   docker tag nms-acm:<version> <my-docker-registry>/nms-acm:<version>
   ```

   This command creates a new tag for an existing Docker image.

   The first argument, `nms-acm:<version>`, specifies the existing Docker image that will be tagged. The second argument, `<my-docker-registry>/nms-acm:<version>`, specifies the new tag for the image. The new tag will be used to reference the image in the private Docker registry.

   - Replace `<my-docker-registry>` with your private Docker registry.

   - Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.

1. Push the image to your private registry:

   ```shell
   docker push <my-docker-registry>/nms-acm:<version>
   ```

   This command pushes the Docker image `nms-acm` to the specified private Docker registry (`my-docker-registry`). The image will be tagged with the specified version (`<version>`).

   - Replace `<my-docker-registry>` with your private Docker registry.

   - Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.
