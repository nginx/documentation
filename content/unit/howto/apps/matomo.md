---
title: Matomo
toc: true
weight: 900
---

To run the [Matomo](https://matomo.org) web analytics platform using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.

2. Install and configure Matomo's [prerequisites](https://matomo.org/faq/on-premise/matomo-requirements/)

3. Install Matomo's [core files](https://matomo.org/faq/on-premise/installing-matomo/).
   Here we install them at **/path/to/app**; use a real path in your configuration.

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}}) the Matomo configuration for Unit
   (use real values for **share** and **root**). The default
   **.htaccess** scheme in a Matomo installation roughly translates into the
   following:

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
                     "/index.php",
                     "/js/index.php",
                     "/matomo.php",
                     "/misc/cron/archive.php",
                     "/piwik.php",
                     "/plugins/HeatmapSessionRecording/configs.php"
                  ]
               },
               "_comment_match": "Handles all PHP scripts that should be public",
               "action": {
                  "pass": "applications/matomo/direct"
               }
         },
         {
               "match": {
                  "uri": [
                     "*.php",
                     "*/.htaccess",
                     "/config/*",
                     "/core/*",
                     "/lang/*",
                     "/tmp/*"
                  ]
               },
               "_comment_match": "Denies access to files and directories best kept private, including internal PHP scripts",
               "action": {
                  "return": 404
               }
         },
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
               "match": {
                  "uri": [
                     "!/libs/*",
                     "!/node_modules/*",
                     "!/plugins/*",
                     "!/vendor/*",
                     "!/misc/cron/*",
                     "!/misc/user/*"
                  ]
               },
               "_comment_match": "Disables access to certain directories that may nonetheless contain public-facing static content served by the previous rule; forwards all unhandled requests to index.php in the root directory",
               "action": {
                  "share": "/path/to/app$uri",
                  "_comment_action": "Serves remaining static files",
                  "fallback": {
                     "pass": "applications/matomo/index"
                  },
                  "_comment_fallback": "A catch-all destination for the remaining requests"
               }
         }
      ],

      "applications": {
         "matomo": {
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

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, Matomo should be available on the listener’s IP
   address and port:

   ![Matomo on Unit](/unit/images/matomo.png)
