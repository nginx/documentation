---
title: DokuWiki
toc: true
weight: 400
---

To run the [DokuWiki](https://www.dokuwiki.org) content management system
using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PGP language module.

2. Install and configure DokuWiki's [prerequisites](https://www.dokuwiki.org/requirements)

3. Install DokuWiki's [core files](https://www.dokuwiki.org/install). Here we install them at **/path/to/app**;
   use a real path in your configuration.

   ```console
   $ mkdir -p /path/to/app/ && cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
   ```

   ```console
   $ tar xvzf dokuwiki-stable.tgz --strip-components=1  # Avoids creating a redundant subdirectory
   ```

   ```console
   $ rm dokuwiki-stable.tgz
   ```

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
                     "/data/*",
                     "/conf/*",
                     "/bin/*",
                     "/inc/*",
                     "/vendor/*"
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
                     "*.php"
                  ]
               },
               "action": {
                  "pass": "applications/dokuwiki"
               }
         },
         {
               "action": {
                  "share": "/path/to/app$uri"
               },
               "_comment_action": "Serves static files"
         }
      ],

      "applications": {
         "dokuwiki": {
               "type": "php",
               "root": "/path/to/app/",
               "_comment_root": "Path to the application directory; use a real path in your configuration",
               "index": "doku.php",
               "_comment_index": "The app's main script"
         }
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the listener’s IP
   address and port.

7. Browse to **/install.php** to complete your [installation](https://www.dokuwiki.org/installer):

   ![DokuWiki on Unit - Installation Screen](/unit/images/dokuwiki.png)
