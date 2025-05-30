---
title: NextCloud
weight: 1400
toc: true
---

To run the [NextCloud](https://nextcloud.com) share and collaboration
platform using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.

2. Install and configure NextCloud's [prerequisites](https://docs.nextcloud.com/server/latest/admin_manual/installation/source_installation.html#prerequisites-for-manual-installation)

3. Install NextCloud's [core files](https://docs.nextcloud.com/server/latest/admin_manual/installation/command_line_installation.html). Here we install them at **/path/to/app**;
   use a real path in your configuration.

   {{< note >}}
   Verify the resulting settings in **/path/to/app/config/config.php**;
   in particular, check the [trusted domains](https://docs.nextcloud.com/server/latest/admin_manual/installation/installation_wizard.html#trusted-domains-label)
   to ensure the installation is accessible within your network:

   ```php
   'trusted_domains' =>
   array (
     0 => 'localhost',
     1 => '*.example.com',
   ),
   ```
   {{< /note >}}

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next,
   [put together]({{< relref "/unit/configuration.md#configuration-php" >}})
   the NextCloud configuration for Unit (use real values for **share** and
   **root**). The following is based on NextCloud's own
   [guide](https://docs.nextcloud.com/server/latest/admin_manual/installation/nginx.html):

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
                     "/build/*",
                     "/tests/*",
                     "/config/*",
                     "/lib/*",
                     "/3rdparty/*",
                     "/templates/*",
                     "/data/*",
                     "/.*",
                     "/autotest*",
                     "/occ*",
                     "/issue*",
                     "/indie*",
                     "/db_*",
                     "/console*"
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
                     "/core/ajax/update.php*",
                     "/cron.php*",
                     "/index.php*",
                     "/ocm-provider*.php*",
                     "/ocs-provider*.php*",
                     "/ocs/v1.php*",
                     "/ocs/v2.php*",
                     "/public.php*",
                     "/remote.php*",
                     "/status.php*",
                     "/updater*.php*"
                  ]
               },
               "_comment_match": "Serves direct URIs with dedicated scripts",
               "action": {
                  "pass": "applications/nextcloud/direct"
               }
         },
         {
               "match": {
                  "uri": "/ocm-provider*"
               },
               "action": {
                  "pass": "applications/nextcloud/ocm"
               }
         },
         {
               "match": {
                  "uri": "/ocs-provider*"
               },
               "action": {
                  "pass": "applications/nextcloud/ocs"
               }
         },
         {
               "match": {
                  "uri": "/updater*"
               },
               "action": {
                  "pass": "applications/nextcloud/updater"
               }
         },
         {
               "action": {
                  "share": "/path/to/app$uri",
                  "_comment_share": "Serves matching static files",
                  "fallback": {
                     "pass": "applications/nextcloud/index"
                  }
               }
         }
      ],

      "applications": {
         "nextcloud": {
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
                  "_comment_index": "All requests are handled by a single script",
                  "ocm": {
                     "root": "/path/to/app/ocm-provider/",
                     "script": "index.php"
                  },
                  "_comment_ocm": "All requests are handled by a single script",
                  "ocs": {
                     "root": "/path/to/app/ocs-provider/",
                     "script": "index.php"
                  },
                  "_comment_ocs": "All requests are handled by a single script",
                  "updater": {
                     "root": "/path/to/app/nextcloud/updater/",
                     "script": "index.php"
                  },
                  "_comment_updater": "All requests are handled by a single script"
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
   - Other targets specify the **script** that Unit runs for *any* URIs
     the target receives.
   {{< /note >}}

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

 7. Adjust Unit's **max_body_size** [option]({{< relref "/unit/configuration.md#configuration-stngs" >}}).to
   avoid potential issues with large file uploads, for example, runnig the
   following command as root:

   ```console
   # curl -X PUT -d '{"http":{"max_body_size": 2147483648}}' --unix-socket \
       /path/to/control.unit.sock  # Path to Unit's control socket in your installation
       http://localhost/config/settings  # Path to the 'config/settings' section in Unit's control API
   ```

   After a successful update, browse to <http://localhost> and [set up](https://docs.nextcloud.com/server/latest/admin_manual/installation/installation_wizard.html)
   your NextCloud installation:

   ![NextCloud on Unit - Home Screen](/unit/images/nextcloud.png)

