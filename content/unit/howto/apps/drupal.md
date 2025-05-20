---
title: Drupal
weight: 500
toc: true
---

To run the [Drupal](https://www.drupal.org) content management system using
Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.

2. Install and configure Drupal's [prerequisites](https://www.drupal.org/docs/system-requirements)

3. Install Drupal's [core files](https://www.drupal.org/docs/develop/using-composer/manage-dependencies#download-core).
Here we install them at **/path/to/app**; use a real path in your configuration.

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}}) the Drupal configuration for Unit.
   The default **.htaccess** [scheme](https://github.com/drupal/drupal)
   in a Drupal installation roughly translates into the following (use real
   values for **share** and **root**):

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
                     "!*/.well-known/*",
                     "/vendor/*",
                     "/core/profiles/demo_umami/modules/demo_umami_content/default_content/*",
                     "*.engine",
                     "*.inc",
                     "*.install",
                     "*.make",
                     "*.module",
                     "*.po",
                     "*.profile",
                     "*.sh",
                     "*.theme",
                     "*.tpl",
                     "*.twig",
                     "*.xtmpl",
                     "*.yml",
                     "*/.*",
                     "*/Entries*",
                     "*/Repository",
                     "*/Root",
                     "*/Tag",
                     "*/Template",
                     "*/composer.json",
                     "*/composer.lock",
                     "*/web.config",
                     "*sql",
                     "*.bak",
                     "*.orig",
                     "*.save",
                     "*.swo",
                     "*.swp",
                     "*~"
                  ]
               },
               "_comment_match": "Denies access to certain types of files and directories best kept hidden, allows access to well-known locations according to RFC 5785",
               "action": {
                  "return": 404
               }
         },
         {
               "match": {
                  "uri": [
                     "/core/authorize.php",
                     "/core/core.api.php",
                     "/core/globals.api.php",
                     "/core/install.php",
                     "/core/modules/statistics/statistics.php",
                     "~^/core/modules/system/tests/https?\\.php",
                     "/core/rebuild.php",
                     "/update.php",
                     "/update.php/*"
                  ]
               },
               "_comment_match": "Allows direct access to core PHP scripts",
               "action": {
                  "pass": "applications/drupal/direct"
               }
         },
         {
               "match": {
                  "uri": [
                     "!/index.php*",
                     "*.php"
                  ]
               },
               "_comment_match": "Explicitly denies access to any PHP scripts other than index.php",
               "action": {
                  "return": 404
               }
         },
         {
               "action": {
                  "share": "/path/to/app/web$uri",
                  "_comment_share": "Serves static files",
                  "fallback": {
                     "pass": "applications/drupal/index"
                  },
                  "_comment_fallback": "Funnels all requests to index.php"
               }
         }
      ],

      "applications": {
         "drupal": {
               "type": "php",
               "targets": {
                  "direct": {
                     "root": "/path/to/app/web/",
                     "_comment_root": "Path to the web/ directory; use a real path in your configuration"
                  },
                  "index": {
                     "root": "/path/to/app/web/",
                     "_comment_root": "Path to the web/ directory; use a real path in your configuration",
                     "script": "index.php",
                     "_comment_script": "All requests are handled by a single script"
                  }
               }
         }
      }
   }
   ```

   {{< note >}}
   The difference between the **pass** targets is their usage of
   the **script** [setting]({{< relref "/unit/configuration.md#configuration-php" >}}):

   - The **direct** target runs the **.php** script from the
     URI or **index.php** if the URI omits it.
   - The **index** target specifies the **script** that Unit
     runs for *any* URIs the target receives.
   {{< /note >}}

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, browse to <http://localhost> and [set up](https://www.drupal.org/docs/develop/using-composer/manage-dependencies#s-install-drupal-using-the-standard-web-interface)
   your Drupal installation:

   ![Drupal on Unit - Setup Screen](/unit/images/drupal.png)
