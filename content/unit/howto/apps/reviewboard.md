---
title: Review Board
toc: true
weight: 2000
---

To run the [Review Board](https://www.reviewboard.org) code review tool using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 2.7 language module.

2. Install and configure Review Board's [prerequisites](https://www.reviewboard.org/docs/manual/dev/admin/installation/linux/#before-you-begin)

   {{< note >}}
   We'll use Unit as the web server, so you can skip the corresponding step.
   {{< /note >}}

3. Install the [core files](https://www.reviewboard.org/docs/manual/dev/admin/installation/linux/#installing-review-board)
   and create a [site](https://www.reviewboard.org/docs/manual/dev/admin/installation/creating-sites/).
   Here, it's **/path/to/app/**; use a real path in your configuration:

   ```console
   rb-site install /path/to/app/ # Path to the application directory; use a real path in your configuration

         * Welcome to the Review Board site installation wizard

             This will prepare a Review Board site installation in:

             /path/to/app

             We need to know a few things before we can prepare your site for
             installation. This will only take a few minutes.
             ...
   ```

4. Add the **.py** extension to the WSGI module's name to make it
   discoverable by Unit, for example:

   ```console
   mv /path/to/app/htdocs/reviewboard.wsgi \
   /path/to/app/htdocs/wsgi.py  # Path to the application directory; use a real path in your configuration
   ```

5. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

   Also, make sure the following directories are [writable](https://www.reviewboard.org/docs/manual/dev/admin/installation/creating-sites/#changing-permissions):

   ```console
   chmod u+w /path/to/app/htdocs/media/uploaded/  # Path to the application directory; use a real path in your configuration
   ```

   ```console
   chmod u+w /path/to/app/data/ # Path to the application directory; use a real path in your configuration
   ```

6. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}})
the Review Board configuration for Unit (use real values for **share** and **path**):

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
                     "/media/*",
                     "/static/*",
                     "/errordocs/*"
                  ]
               },
               "_comment_match": "Static file directories",
               "action": {
                  "share": "/path/to/app/htdocs$uri"
               },
               "_comment_action": "Serves matching static files"
         },
         {
               "action": {
                  "pass": "applications/rb"
               }
         }
      ],

      "applications": {
         "rb": {
               "type": "python 2",
               "path": "/path/to/app/htdocs/",
               "_comment_path": "Path to the application directory; use a real path in your configuration",
               "module": "wsgi",
               "_comment_module": "WSGI module basename with extension omitted"
         }
      }
   }
   ```

7. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, browse to <http://localhost> and [set up](https://www.reviewboard.org/docs/manual/dev/admin/#configuring-review-board)
   your Review Board installation:

   ![Review Board on Unit - Dashboard Screen](/unit/images/reviewboard.png)
