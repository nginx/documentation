---
title: Laravel
weight: 1200
toc: true
---

To run apps based on the [Laravel](https://laravel.com) framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.

2. Install and configure Laravel's [prerequisites](https://laravel.com/docs/deployment#server-requirements).

3. Create a Laravel [project](https://laravel.com/docs/installation#creating-a-laravel-project).
   For our purposes, the path is **/path/to/app/**:

   ```console
   $ cd /path/to/ #Path where the application directory will be created; use a real path in your configuration
   ```

   ```console
   $ composer create-project laravel/laravel `app` #Arbitrary app name; becomes the application directory name
   ```

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

   {{< note >}}
   See the Laravel docs for further details on [directory structure](https://laravel.com/docs/structure).
   {{< /note >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}}) the Laravel configuration for
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
            "share": "/path/to/app/public$uri",
            "share_comment": "Serves static files",
            "fallback": {
               "pass": "applications/laravel",
               "pass_comment": "Uses the index.php at the root as the last resort"
            }
            }
         }
      ],
      "applications": {
         "laravel": {
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

   After a successful update, browse to <http://localhost> and [set up](https://laravel.com/docs/configuration) your Laravel application:

   ![Laravel on Unit - Sample Screen](/unit/images/laravel.png)

