---
title: Django
toc: true
weight: 500
---

To run apps based on the Django [framework](https://www.djangoproject.com)
using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3 language module.

2. Install and configure the Django [framework](https://www.djangoproject.com). The official docs [recommend](https://docs.djangoproject.com/en/stable/topics/install/#installing-an-official-release-with-pip)
   setting up a virtual environment; if you do, list it as **home** when
   configuring Unit later. Here, it's **/path/to/venv/**.

3. Create a Django [project](https://docs.djangoproject.com/en/stable/intro/tutorial01/). Here, we
   install it at **/path/to/app/**; use a real path in your configuration.
   The following steps assume your project uses [basic directory structure](https://docs.djangoproject.com/en/stable/ref/django-admin/#django-admin-startproject):

   ```none
   /path/to/app/  # Project directory
   |-- manage.py
   |-- django_app1/  # Individual app directory
   |   |-- ...
   |-- django_app2/  # Individual app directory
   |   |-- ...
   |-- project/  # Project subdirectory
   |   |-- ...
   |   |-- asgi.py  # ASGI application module
   |   `-- wsgi.py  #
   ```

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, prepare the Django [configuration]({{< relref "/unit/configuration.md#configuration-python" >}})
   for Unit. Here, the **/path/to/app/** directory is stored in the
   **path** option; the virtual environment is **home**; the WSGI or
   ASGI module in the **project/** subdirectory is
   [imported](https://docs.python.org/3/reference/import.html) via **module**.
   If you reorder your directories,
   [set up]({{< relref "/unit/configuration.md#configuration-python" >}})
   **path**, **home**, and **module** accordingly.

   You can also set up some environment variables that your project relies on,
   using the **environment** option. Finally, if your project uses Django's
   [static files](https://docs.djangoproject.com/en/stable/howto/static-files/),
   optionally add a
   [route]({{< relref "/unit/configuration.md#configuration-routes" >}}) to
   [serve]({{< relref "/unit/configuration.md#configuration-static" >}}) them with Unit.


   Here's an example (use real values for **share**, **path**,
   **environment**, **module**, and **home**):

   {{< tabs "interface" >}}
   {{% tab name="WSGI" %}}

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

               "action": {
                  "share": "/path/to/app$uri",
                  "_comment_share": "Thus, URIs starting with /static/ are served from /path/to/app/static/"
               }
         },
         {
               "action": {
                  "pass": "applications/django"
               }
         }
      ],

      "applications": {
         "django": {
               "type": "python 3.X",
               "_comment_type": "Must match language module version and virtual environment version",
               "path": "/path/to/app/",
               "_comment_path": "Project directory; use a real path in your configuration",
               "home": "/path/to/venv/",
               "_comment_home": "Virtual environment directory; use a real path in your configuration",
               "module": "project.wsgi",
               "_comment_module": "Note the qualified name of the WSGI module; use a real project directory name in your configuration",
               "environment": {
                  "_comment_environment": "App-specific environment variables",
                  "DJANGO_SETTINGS_MODULE": "project.settings",
                  "DB_ENGINE": "django.db.backends.postgresql",
                  "DB_NAME": "project",
                  "DB_HOST": "127.0.0.1",
                  "DB_PORT": "5432"
               }
         }
      }
   }
   ```

   {{% /tab %}}
   {{% tab name="ASGI" %}}

   {{< note >}}
   ASGI requires Python 3.5+ and Django 3.0+.
   {{< /note >}}

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

               "action": {
                  "share": "/path/to/app$uri",
                  "_comment_share": "Serves static files. URIs starting with /static/ are served from /path/to/app/static/"
               }
         },
         {
               "action": {
                  "pass": "applications/django"
               }
         }
      ],

      "applications": {
         "django": {
               "type": "python 3.X",
               "_comment_type": "Must match language module version and virtual environment version",
               "path": "/path/to/app/",
               "_comment_path": "Project directory; use a real path in your configuration",
               "home": "/path/to/venv/",
               "_comment_home": "Virtual environment directory; use a real path in your configuration",
               "module": "project.asgi",
               "_comment_module": "Note the qualified name of the ASGI module; use a real project directory name in your configuration",
               "environment": {
                  "DJANGO_SETTINGS_MODULE": "project.settings",
                  "DB_ENGINE": "django.db.backends.postgresql",
                  "DB_NAME": "project",
                  "DB_HOST": "127.0.0.1",
                  "DB_PORT": "5432"
               },
               "_comment_environment": "App-specific environment variables"
         }
      }
   }
   ```

   {{% /tab %}}
   {{< /tabs >}}

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your project and apps should be available on the
   listener's IP address and port:

   ![Django on Unit - Admin Login Screen](/unit/images/django.png)

