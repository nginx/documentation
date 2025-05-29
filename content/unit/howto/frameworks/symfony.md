---
title: Symfony
toc: true
weight: 1900
---

To run apps built with the [Symfony](https://symfony.com) framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP 8.2+ language module.

2. Next, [install](https://symfony.com/doc/current/setup.html) Symfony
   and create or deploy your app. Here, we use
   Symfony's [reference app](https://symfony.com/doc/current/setup.html#the-symfony-demo-application):

   ```console
   $ cd /path/to/ # Path where the application directory will be created; use a real path in your configuration
   ```

   ```console
   $ symfony new --demo app # Arbitrary app name
   ```

   This creates the app's directory tree at **/path/to/app/**. Its
   **public/** subdirectory contains both the root **index.php** and
   the static files; if your app requires additional **.php** scripts, also
   store them here.

3. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

4. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}}) the Symfony configuration for Unit
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
               "*.php",
               "*.php/*"
            ],
            "uri_comment": "Handles all direct script-based requests"
            },
            "action": {
            "pass": "applications/symfony/direct"
            }
         },
         {
            "action": {
            "share": "/path/to/app/public$uri",
            "share_comment": "Serves static files",
            "fallback": {
               "pass": "applications/symfony/index",
               "pass_comment": "Uses the index.php at the root as the last resort"
            }
            }
         }
      ],
      "applications": {
         "symfony": {
            "type": "php",
            "targets": {
            "direct": {
               "root": "/path/to/app/public/",
               "root_comment": "Path to the application directory; use a real path in your configuration"
            },
            "index": {
               "root": "/path/to/app/public/",
               "root_comment": "Path to the application directory; use a real path in your configuration",
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

   For a detailed discussion, see [Configuring a Web Server](https://symfony.com/doc/current/setup/web_server_configuration.html) in
   Symfony docs.

5. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your project and apps should be available on the
   listener's IP address and port:

   ![Symfony Demo App on Unit - Admin Post Update](/unit/images/symfony.png)

