---
docs: DOCS-1332
---

To publish a configuration file to an instance group:

1. {{< include "nim/webui-nim-login.md" >}}
1. On the left menu, select **Instance Groups**.
1. Select the instance group you want to publish the configuration to.
1. To add a new config:

   1. Select **Add File**.
   2. Add the path and filename of the new file.
   3. Select **Create**.
   4. On the file editor page, type or paste the contents to use for the file. The config analyzer will let you know if there are any errors.

1. To update an existing config:
   1. Edit the configuration files to make your desired changes. The config analyzer will let you know if there are any errors.

1. Select **Publish** to apply the changes and publish them to the instance.
1. (Optional) To save the file as a [staged config]({{< relref "/nms/nim/how-to/nginx/publish-configs#stage-configs" >}}), select **Save as**, then provide a name for the staged config.
