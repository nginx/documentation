---
title: Lumen
weight: 1300
toc: true
---

To run apps based on the [Lumen](https://lumen.laravel.com) framework using
Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.

2. Install and configure Lumen's [requirements](https://lumen.laravel.com/docs/8.x#server-requirements)

3. Create a Lumen [project](https://lumen.laravel.com/docs/8.x#installing-lumen).
   For our purposes, the path is **/path/to/app/**:

   ```console
   $ cd /path/to/ # Path where the application directory will be created; use a real path in your configuration
   ```

   ```console
   $ composer create-project laravel/lumen app # Arbitrary app name; becomes the application directory name
   ```

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}}) the Lumen configuration for
   Unit (use real values for **share** and **root**):

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
            "uri": "!/index.php",
            "uri_comment": "Denies access to index.php as a static file"
            },
            "action": {
            "share": "/path/to/app/public/",
            "share_comment": "Serves static files",
            "fallback": {
               "pass": "applications/lumen",
               "pass_comment": "Uses the index.php at the root as the last resort"
            }
            }
         }
      ],
      "applications": {
         "lumen": {
            "type": "php",
            "root": "/path/to/app/public/",
            "root_comment": "Path to the application directory; use a real path in your configuration",
            "script": "index.php",
            "script_comment": "All requests are handled by a single script"
         }
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, browse to <http://localhost> and [set up](https://lumen.laravel.com/docs/8.x/configuration) your Lumen application.
