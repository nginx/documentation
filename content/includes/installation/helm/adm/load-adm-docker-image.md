1. Change to the directory where you downloaded the Docker image:

   ``` shell
   cd <directory name>
   ```

1. Load the Docker image from the `nms-adm-<version>-img.tar.gz` archive:

   ``` shell
   docker load -i nms-adm-<version>-img.tar.gz
   ```

   The output looks similar to the following:

   ``` shell
   $ docker load -i nms-adm-<version>-img.tar.gz
   d8b288b30ef7: Loading layer [==================================================>]    341kB/341kB
   feb7ea9a965b: Loading layer [==================================================>]  7.168kB/7.168kB
   ...
   412ceb7d513b: Loading layer [==================================================>]  62.98kB/62.98kB
   8d6c9a742f97: Loading layer [==================================================>]  102.2MB/102.2MB
   Loaded image: nms-adm:4.0.0
   ```

   {{<important>}}
   Take note of the loaded image's name and tag.  You'll need to reference this information in the next section when pushing the image to your private registry.

   In the example output above, `nms-adm` is the image name and `4.0.0` is the tag.  The image name or tag could be different depending on the product version you downloaded from MyF5.
   {{</important>}}
