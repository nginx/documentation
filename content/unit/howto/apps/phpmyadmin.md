---
title: phpMyAdmin
toc: true
weight: 1700
---

To run the [phpMyAdmin](https://www.phpmyadmin.net) web tool using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.

2. Install and configure phpMyAdmin's [prerequisites](https://docs.phpmyadmin.net/en/latest/require.html)

3. Install phpMyAdmin's [core files](https://docs.phpmyadmin.net/en/latest/setup.html#quick-install-1). Here we install them at **/path/to/app**;
   use a real path in your configuration.

   {{< note >}}
   Make sure to create the **config.inc.php** file [manually](https://docs.phpmyadmin.net/en/latest/setup.html#manually-creating-the-file)
   or using the [setup script](https://docs.phpmyadmin.net/en/latest/setup.html#using-the-setup-script).
   {{< /note >}}

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}}) the phpMyAdmin configuration for Unit
   (use real values for **share** and **root**):

   ```json
   {
      "listeners": {
         "*:80": {
               "pass": "routes"
         }
      },

      "routes": [
         {
               "match": {
                  "uri": "~\\.(css|gif|html?|ico|jpg|js(on)?|png|svg|ttf|woff2?)$"
               },
               "_comment_match": "Enables access to static content only",
               "action": {
                  "share": "/path/to/app$uri"
               },
               "_comment_action": "Serves matching static files"
         },
         {
               "action": {
                  "pass": "applications/phpmyadmin"
               }
         }
      ],

      "applications": {
         "phpmyadmin": {
               "type": "php",
               "root": "/path/to/app/"
         },
         "_comment_root": "Path to the application directory; use a real path in your configuration"
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, phpMyAdmin should be available on the listener’s IP
   address and port:

   ![phpMyAdmin on Unit](/unit/images/phpmyadmin.png)
