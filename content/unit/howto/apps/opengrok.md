---
title: OpenGrok
toc: true
weight: 1500
---

To run the [OpenGrok](https://github.com/oracle/opengrok) code search engine using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Java 11+ language module.

2. Follow the official OpenGrok [installation guide](https://github.com/oracle/opengrok/wiki/How-to-setup-OpenGrok). Here,
   we'll place the files at **/path/to/app/**:

   ```console
   mkdir -p /path/to/app/{src,data,dist,etc,log}  # Path to the application directory; use a real path in your configuration
   ```

   ```console
   tar -C /path/to/app/dist --strip-components=1 -xzf opengrok-X.Y.Z.tar.gz  # Path to the application directory; use a real path in your configuration | Specific OpenGrok version
   ```

   Our servlet container is Unit so we can repackage the **source.war**
   file to an arbitrary directory at [Step 2](https://github.com/oracle/opengrok/wiki/How-to-setup-OpenGrok#step2---deploy-the-web-application):

   ```console
   opengrok-deploy -c /path/to/app/etc/configuration.xml \
         /path/to/app/dist/lib/source.war /path/to/app/  # Path to the application directory; use a real path in your configuration
   ```

   The resulting pathname is **/path/to/app/source.war**.

3. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

4. Next, [prepare]({{< relref "/unit/configuration.md#configuration-java" >}})
   the OpenGrok configuration for Unit:

   ```json
   {
      "listeners": {
         "*:80": {
               "pass": "applications/opengrok"
         }
      },

      "applications": {
         "opengrok": {
               "type": "java",
               "webapp": "/path/to/app/source.war",
               "_comment_webapp": "Path to the application directory; use a real path in your configuration | Repackaged in Step 2",
               "options": [
                  "-Djava.awt.headless=true"
               ]
         }
      }
   }
   ```

5. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, OpenGrok should be available on the listener’s IP
   address and port:

   ![OpenGrok on Unit - Search Screen](/unit/images/opengrok.png)
