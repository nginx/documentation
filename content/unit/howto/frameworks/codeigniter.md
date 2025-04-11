---
title: CodeIgniter
weight: 400
toc: true
---

To run apps built with the [CodeIgniter](https://codeigniter.com) web
framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.

2. Download CodeIgniter's [core files](https://codeigniter.com/user_guide/installation/index.html) and [build](https://codeigniter.com/user_guide/tutorial/index.html) your application.
   Here, let's use a [basic app template](https://forum.codeigniter.com/thread-73103.html), installing it at
   **/path/to/app/**.

3. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}


4. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}})
   the CodeIgniter configuration for Unit:

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
                  "uri": "!/index.php"
               },
               "_comment_match": "Denies access to index.php as a static file",

               "action": {
                  "share": "/path/to/app/public$uri",
                  "_comment_share": "Path to the application directory; use a real path in your configuration",
                  "fallback": {
                     "pass": "applications/codeigniter"
                  },
                  "_comment_fallback": "Serves any requests not served with the 'share' immediately above"
               }
         }
      ],

      "applications": {
         "codeigniter": {
               "type": "php",
               "root": "/path/to/app/public/",
               "_comment_root": "Path to the application directory; use a real path in your configuration",
               "script": "index.php"
         },
         "_comment_script": "All requests are served by a single script"
      }
   }
   ```

5. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the listener’s IP
   address and port:

   ![CodeIgniter Sample App on Unit](/unit/images/codeigniter.png)
