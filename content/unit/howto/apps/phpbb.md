---
title: phpBB
toc: true
weight: 1600
---

To run the [phpBB](https://www.phpbb.com) bulletin board using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.

2. Install and configure phpBB's [prerequisites](https://www.phpbb.com/support/docs/en/3.3/ug/quickstart/requirements/)

3. Install phpBB's [core files](https://www.phpbb.com/downloads/). Here we install them at **/path/to/app**;
   use a real path in your configuration.

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, prepare the app
   [configuration]({{< relref "/unit/configuration.md#configuration-php" >}})
   for Unit (use real values for **share** and **root**):

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
                  "uri": [
                     "/cache/*",
                     "/common.php*",
                     "/config.php*",
                     "/config/*",
                     "/db/migration/data/*",
                     "/files/*",
                     "/images/avatars/upload/*",
                     "/includes/*",
                     "/store/*"
                  ]
               },
               "_comment_match": "Denies access to files and directories best kept private",
               "action": {
                  "return": 404
               }
         },
         {
               "match": {
                  "uri": [
                     "/",
                     "*.php",
                     "*.php/*"
                  ]
               },
               "action": {
                  "pass": "applications/phpbb/direct"
               }
         },
         {
               "action": {
                  "share": "/path/to/app$uri",
                  "_comment_share": "Serves static files",
                  "fallback": {
                     "pass": "applications/phpbb/index"
                  },
                  "_comment_fallback": "Catch-all for requests not yet served by other rules"
               }
         }
      ],

      "applications": {
         "phpbb": {
               "type": "php",
               "targets": {
                  "direct": {
                     "root": "/path/to/app/"
                  },
                  "_comment_direct": "Path to the application directory; use a real path in your configuration",
                  "index": {
                     "root": "/path/to/app/",
                     "script": "app.php"
                  },
                  "_comment_index": "Path to the application directory; use a real path in your configuration"
               }
         }
      }
   }
   ```

   {{< note >}}
   The difference between the **pass** targets is their usage of the
   **script** [setting]({{< relref "/unit/configuration.md#configuration-php" >}}):

   - The **direct** target runs the **.php** script from the URI or
     defaults to **index.php** if the URI omits it.
   - The **index** target specifies the **script** that Unit runs
     for *any* URIs the target receives.
   {{< /note >}}

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the listener’s IP
   address and port:

   ![phpBB on Unit](/unit/images/phpbb.png)


7. Browse to **/install/app.php** to complete your installation. Having
   done that, delete the **install/** subdirectory to mitigate security
   risks:

   ```console
   rm -rf /path/to/app/install/  # Path to the application directory; use a real path in your configuration
   ```
