---
title: WordPress
toc: true
weight: 2300
---

{{< note >}}
For a more specific walkthrough that includes SSL setup and NGINX as a
proxy, see our [blog post](https://www.nginx.com/blog/automating-installation-wordpress-with-nginx-unit-on-ubuntu/).
{{< /note >}}

To run the [WordPress](https://wordpress.org) content management system
using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 7.3+ language module.

2. Install and configure WordPress's [prerequisites](https://wordpress.org/support/article/before-you-install/)

3. Install WordPress's [core files](https://wordpress.org/download/). Here we install them at **/path/to/app**;
   use a real path in your configuration.

4. Update the **wp-config.php** [file](https://wordpress.org/support/article/editing-wp-config-php/) with your
   database settings and other customizations.

5. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

6. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}}) the WordPress configuration for Unit
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
                     "*.php/*",
                     "/wp-admin/"
                  ]
               },
               "action": {
                  "pass": "applications/wordpress/direct"
               }
         },
         {
               "action": {
                  "share": "/path/to/app$uri",
                  "fallback": {
                     "pass": "applications/wordpress/index"
                  }
               }
         }
      ],

      "applications": {
         "wordpress": {
               "type": "php",
               "targets": {
                  "direct": {
                     "root": "/path/to/app/"
                  },
                  "index": {
                     "root": "/path/to/app/",
                     "script": "index.php"
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

7. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, browse to <http://localhost> and [set up](https://wordpress.org/support/article/how-to-install-wordpress/#step-5-run-the-install-script)
   your WordPress installation:

   ![WordPress on Unit - Setup Screen](/unit/images/wordpress.png)

   {{< note >}}
   The resulting URI scheme will affect your WordPress configuration; updates
   may require [extra steps](https://wordpress.org/support/article/changing-the-site-url/).
   {{< /note >}}
