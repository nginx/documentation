---
title: MediaWiki
weight: 1000
toc: true
---

To run the [MediaWiki](https://www.mediawiki.org) collaboration and
documentation platform using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PGP language module.

2. Install MediaWiki's [core files](https://www.mediawiki.org/wiki/Download).
   Here we install them at **/path/to/app**; use a real path in your configuration.

3. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

4. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}}) the MediaWiki configuration for Unit
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
                  "uri": [
                     "!/tests/qunit/*",
                     "/cache/*",
                     "/includes/*",
                     "/languages/*",
                     "/maintenance/*",
                     "/tests/*",
                     "/vendor/*"
                  ]
               },
               "_comment_match": "Controls access to directories best kept private",
               "action": {
                  "return": 404
               }
         },
         {
               "match": {
                  "uri": [
                     "/api.php*",
                     "/img_auth.php*",
                     "/index.php*",
                     "/load.php*",
                     "/mw-config/*.php",
                     "/opensearch_desc.php*",
                     "/profileinfo.php*",
                     "/rest.php*",
                     "/tests/qunit/*.php",
                     "/thumb.php*",
                     "/thumb_handler.php*"
                  ]
               },
               "_comment_match": "Enables access to application entry points",
               "action": {
                  "pass": "applications/mw/direct"
               }
         },
         {
               "match": {
                  "uri": [
                     "!*.php",
                     "!*.json",
                     "!*.htaccess",
                     "/extensions/*",
                     "/images/*",
                     "/resources/assets/*",
                     "/resources/lib/*",
                     "/resources/src/*",
                     "/skins/*"
                  ]
               },
               "_comment_match": "Enables static access to specific content locations",
               "_comment_negations": "The negations deny access to the file types listed here",
               "action": {
                  "share": "/path/to/app$uri"
               },
               "_comment_action": "Serves matching static files"
         },
         {
               "action": {
                  "pass": "applications/mw/index"
               }
         }
      ],

      "applications": {
         "mw": {
               "type": "php",
               "targets": {
                  "direct": {
                     "root": "/path/to/app/"
                  },
                  "_comment_direct": "Path to the application directory; use a real path in your configuration",
                  "index": {
                     "root": "/path/to/app/",
                     "script": "index.php"
                  },
                  "_comment_index": "All requests are handled by a single script"
               }
         }
      }
   }
   ```

   {{< note >}}
   The difference between the **pass** targets is their usage of the
   **script** [setting]({{< relref "/unit/configuration.md#configuration-php" >}}):

   - The **direct** target runs the **.php** script from the URI or
     defaults to **index.php** if the w omits it.
   - The **index** target specifies the **script** that Unit runs
     for *any* URIs the target receives.
   {{< /note >}}

5. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

6. Browse to <http://localhost/mw-config/index.php> and set MediaWiki up using
   the settings noted earlier:

   ![MediaWiki on Unit](/unit/images/mw_install.png)

   Download the newly generated **LocalSettings.php** file and place it
   [appropriately](https://www.mediawiki.org/wiki/Manual:Config_script):

   ```console
   $ chmod 600 LocalSettings.php
   ```

   Run the following commands (as root) to set the correct ownership:

   ```console
   # chown unit:unit LocalSettings.php  # Values from Step 3
   ```

   ```console
   # mv LocalSettings.php /path/to/app/  # Path to the application directory; use a real path in your configuration
   ```

7. After installation, add a match condition to the first step to disable
   access to the **mw-config/** directory. Run the following command (as root):

   ```console
   # curl -X POST -d '"/mw-config/*"'  \
         --unix-socket /path/to/control.unit.sock  \ # Path to Unit's control socket in your installation
         http://localhost/config/routes/mediawiki/0/match/uri/  # Path to the route's first step condition and the 'uri' value in it

   {
      "success": "Reconfiguration done."
   }\
   ```

   After a successful update, MediaWiki should be available on the listener’s IP
   address and port:

   ![MediaWiki on Unit](/unit/images/mw_ready.png)
