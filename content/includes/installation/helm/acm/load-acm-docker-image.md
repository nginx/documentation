---
docs: DOCS-1313
---

1. Change to the directory where you downloaded the Docker image:

   ``` shell
   cd <directory name>
   ```

1. Load the Docker image from the `nms-acm-<version>-img.tar.gz` archive:

   ``` shell
   docker load -i nms-acm-<version>-img.tar.gz
   ```

   The output looks similar to the following:

   ``` shell
   $ docker load -i nms-acm-<version>-img.tar.gz
   1b5933fe4b5: Loading layer [==================================================>]  5.796MB/5.796MB
   fbe0fc9bcf95: Loading layer [==================================================>]  17.86MB/17.86MB
   ...
   112ae1f604e0: Loading layer [==================================================>]   67.8MB/67.8MB
   4b6a693b90f4: Loading layer [==================================================>]  3.072kB/3.072kB
   Loaded image: nms-acm:1.5.0
   ```

   {{<important>}}
   Take note of the loaded image's name and tag.  You'll need to reference this information in the next section when pushing the image to your private registry.

   In the example output above, `nms-acm` is the image name and `1.5.0` is the tag.  The image name or tag could be different depending on the product version you downloaded from MyF5.
   {{</important>}}
