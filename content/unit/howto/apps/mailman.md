---
title: Mailman Web
toc: true
weight: 800
---

To install and run the web UI for the [Mailman 3](https://docs.list.org/en/latest/index.html) suite using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3.7+ language module.

2. Follow Mailman's [guide](https://docs.list.org/en/latest/install/virtualenv.html#virtualenv-install)
   to install its prerequisites and core files, but stop at [setting up a WSGI
   server](https://docs.list.org/en/latest/install/virtualenv.html#setting-up-a-wsgi-server);
   we'll use Unit instead. Also, note the following settings (values from the
   guide are given after the colon):

   - Virtual environment path: **/opt/mailman/venv/**
   - Installation path: **/etc/mailman3/**
   - Static file path: **/opt/mailman/web/static/**
   - User and group: **mailman:mailman**

   These are needed to configure Unit.

3. Run the following command (as root) so Unit can access Mailman's static files:

   ```console
   # chown -R unit:unit /opt/mailman/web/static/  # User and group that Unit's router runs as by default | Mailman's static file path
   ```

  {{< note >}}
   The **unit:unit** user-group pair is available only with
   [official packages]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}), Docker
   [images]({{< relref "/unit/installation.md#installation-docker" >}})
   , and some
   [third-party repos]({{< relref "/unit/installation.md#installation-community-repos" >}}).
   Otherwise, account names may differ; run the `ps aux | grep unitd` command to be sure.
   {{< /note >}}

   Alternatively, add Unit's unprivileged user account to Mailman's group so Unit
   can access the static files. Run the following command as root:

   ```console
   # usermod -a -G mailman unit  # Mailman's user group noted in Step 2 | User that Unit's router runs as by default
   ```

4. Next, prepare the Mailman [configuration]({{< relref "/unit/configuration.md#configuration-python" >}}) for Unit
   (use values from Step 2 for **share**, **path**, and **home**):

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
                  "uri": "/static/*"
               },
               "_comment_match": "Matches requests for web UI's static content",
               "action": {
                  "share": "/opt/mailman/web/$uri"
               },
               "_comment_action": "Mailman's static file path without the 'static/' part; URIs starting with /static/ are thus served from /opt/mailman/web/static/"
         },
         {
               "action": {
                  "pass": "applications/mailman_web"
               }
         }
      ],

      "applications": {
         "mailman_web": {
               "type": "python 3.X",
               "_comment_type": "Must match language module version and virtual environment version",
               "path": "/etc/mailman3/",
               "_comment_path": "Mailman's installation path you noted in Step 2",
               "home": "/opt/mailman/venv/",
               "_comment_home": "Mailman's virtual environment path you noted in Step 2",
               "module": "mailman_web.wsgi",
               "_comment_module": "Qualified name of the WSGI module, relative to installation path",
               "user": "mailman",
               "_comment_user": "Mailman's user group noted in Step 2",
               "environment": {
                  "DJANGO_SETTINGS_MODULE": "settings"
               },
               "_comment_environment": "App-specific environment variables",
               "_comment_DJANGO_SETTINGS_MODULE": "Web configuration module name, relative to installation path"
         }
      }
   }
   ```

5. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, Mailman's web UI should be available on the
   listener’s IP address and port:

   ![Mailman on Unit - Lists Screen](/unit/images/mailman.png)

