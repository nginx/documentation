---
title: Roundcube
toc: true
weight: 2100
---

To run the [Roundcube](https://roundcube.net) webmail platform using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.

2. Install and configure Roundcube's [prerequisites](https://github.com/roundcube/roundcubemail/wiki/Installation#install-dependencies)

3. Install Roundcube's [core files](https://roundcube.net/download/). Here we install them at **/path/to/app**;
   use a real path in your configuration.

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}}) the Roundcube configuration for Unit
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
                     "*/"
                  ]
               },
               "_comment_match": "Serves direct requests for PHP scripts and directory-like URIs",
               "action": {
                  "pass": "applications/roundcube"
               }
         },
         {
               "action": {
                  "share": "/path/to/app$uri"
               },
               "_comment_action": "Serves static files"
         }
      ],

      "applications": {
         "roundcube": {
               "type": "php",
               "root": "/path/to/app/",
               "_comment_root": "Path to the application directory; use a real path in your configuration"
         }
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, browse to <http://localhost/installer/> and [set up](https://github.com/roundcube/roundcubemail/wiki/Installation#configuring-roundcube)
   your Roundcube installation:

   ![Roundcube on Unit - Setup Screen](/unit/images/roundcube-setup.png)



7. After installation, switch **share** and **root** to the
   **public_html/** subdirectory to [protect](https://github.com/roundcube/roundcubemail/wiki/Installation#protect-your-installation)
   sensitive data, run the following command as root:

   ```console
   curl -X PUT -d '"/path/to/app/public_html$uri"' --unix-socket /path/to/control.unit.sock \
     http://localhost/config/routes/1/action/share
   ```

   ```console
   curl -X PUT -d '"/path/to/app/public_html/"' --unix-socket /path/to/control.unit.sock \
     http://localhost/config/applications/roundcube/root
   ```

   Thus, Roundcube should be available on the listener’s IP address and port:

   ![Roundcube on Unit - Login Screen](/unit/images/roundcube.png)
