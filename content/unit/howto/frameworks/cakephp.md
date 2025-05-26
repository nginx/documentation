---
title: CakePHP
weight: 200
toc: true
---

To run apps based on the [CakePHP](https://cakephp.org) framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP 7.2+ language module.

2. [Install](https://book.cakephp.org/4/en/installation.html) CakePHP and
   create or deploy your app. Here, we use CakePHP's [basic template](https://book.cakephp.org/4/en/installation.html#create-a-cakephp-project)
   and Composer:

   ```console
   $ cd /path/to/  # Path where the application directory will be created; use a real path in your configuration
   ```

   ```console
   $ composer create-project --prefer-dist cakephp/app:4.* app  # Arbitrary app name; becomes the application directory name

   ```

   This creates the app's directory tree at **/path/to/app/**. Its
   **webroot/** subdirectory contains both the root **index.php** and
   the static files; if your app requires additional **.php** scripts, also
   store them here.

3. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

4. Next, prepare the app [configuration]({{< relref "/unit/configuration.md#configuration-php" >}})
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
            "*.php",
            "*.php/*"
         ],
         "uri_comment": "The second element '*.php/*' handles all requests that explicitly target PHP scripts"
         },
         "action": {
         "pass": "applications/cakephp/direct"
         }
      },
      {
         "action": {
         "share": "/path/to/app/webroot$uri",
         "share_comment": "Unconditionally serves remaining requests that target static files",
         "fallback": {
            "pass": "applications/cakephp/index",
            "fallback_comment": "Serves any requests not served with the 'share' immediately above"
         }
         }
      }
   ],
   "applications": {
      "cakephp": {
         "type": "php",
         "targets": {
         "direct": {
            "root": "/path/to/app/webroot/",
            "root_comment": "Path to the webroot/ directory; use a real path in your configuration"
         },
         "index": {
            "root": "/path/to/app/webroot/",
            "root_comment": "Path to the webroot/ directory; use a real path in your configuration",
            "script": "index.php",
            "script_comment": "All requests are handled by a single script"
         }
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

   For a detailed discussion, see [Fire It Up](https://book.cakephp.org/4/en/installation.html#fire-it-up) in CakePHP   docs.

5. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the listener’s IP
   address and port:

   ![CakePHP Basic Template App on Unit](/unit/images/cakephp.png)
