---
title: MODX
weight: 1200
toc: true
---

To run the [MODX](https://modx.com) content application platform using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.

2. Install and configure MODX's [prerequisites]()

3. Install MODX's [core files](https://modx.com/download). Here we install them at **/path/to/app**;
   use a real path in your configuration.

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}}) the MODX configuration for Unit
   (use real values for **share** and **root**). The default
   **.htaccess** scheme in a MODX installation roughly translates into the
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
                     "!/.well-known/",
                     "/core/*",
                     "*/.*"
                  ]
               },
               "_comment_match": "Denies access to directories best kept private",
               "action": {
                  "return": 404
               }
         },
         {
               "match": {
                  "uri": "*.php"
               },
               "_comment_match": "Serves direct requests for PHP scripts",
               "action": {
                  "pass": "applications/modx"
               }
         },
         {
               "action": {
                  "share": "/path/to/app$uri",
                  "_comment_share": "Serves static files",
                  "fallback": {
                     "pass": "applications/modx"
                  },
                  "_comment_fallback": "A catch-all destination for the remaining requests"
               }
         }
      ],

      "applications": {
         "modx": {
               "type": "php",
               "root": "/path/to/app/",
               "_comment_root": "Path to the application directory; use a real path in your configuration"
         }
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, MODX should be available on the listener’s IP
   address and port:

   ![MODX on Unit - Manager Screen](/unit/images/modx.png)
