---
title: Django Channels
toc: true
weight: 600
---

To run Django apps using the Django Channels [framework](https://channels.readthedocs.io/en/stable/) with Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3.6+ language module.

2. Install and configure the Django 3.0+ [framework](https://www.djangoproject.com). The official docs [recommend](https://docs.djangoproject.com/en/stable/topics/install/#installing-an-official-release-with-pip)
   setting up a virtual environment; if you do, list it as **home** when
   configuring Unit later. Here, it's **/path/to/venv/**.

3. Install Django Channels in your virtual environment:

   ```console
   $ cd /path/to/venv/ # Path to the virtual environment; use a real path in your configuration
   ```

   ```console
   $ source bin/activate
   ```

   ```console
   $ pip install channels
   ```

   ```console
   $ deactivate
   ```

4. Create a Django project. Here, we'll use the [tutorial chat app](https://channels.readthedocs.io/en/stable/tutorial/part_1.html#tutorial-part-1-basic-setup),
   installing it at **/path/to/app/**; use a real path in your
   configuration. The following steps assume your project uses [basic
   directory structure](https://docs.djangoproject.com/en/stable/ref/django-admin/#django-admin-startproject):

   ```none
   /path/to/app/  # Project directory
   |-- manage.py
   |-- chat/  # Individual app directory
   |   |-- ...
   |-- mysite/  # Project subdirectory
   |   |-- ...
   |   `-- asgi.py  # ASGI application module
   `-- static/  # Static files subdirectory
   ```

5. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

6. Integrate Django Channels into your project according to the official [Channels guide](https://channels.readthedocs.io/en/stable/tutorial/part_1.html#integrate-the-channels-library).

7. Next, create the Django Channels [configuration]({{< relref "/unit/configuration.md#configuration-python" >}}) for
   Unit. Here, the **/path/to/app/** directory is stored in the
   **path** option; the virtual environment is **home**; the ASGI
   module in the **mysite/** subdirectory is [imported](https://docs.python.org/3/reference/import.html) via **module**. If
   you reorder your directories, [set up]({{< relref "/unit/configuration.md#configuration-python" >}})
   **path**, **home**, and **module** accordingly.

   You can also set up some environment variables that your project relies on,
   using the **environment** option. Finally, if your project uses
   Django's [static files](https://docs.djangoproject.com/en/stable/howto/static-files/), optionally
   add a [route]({{< relref "/unit/configuration.md#configuration-routes" >}}) to
   [serve]({{< relref "/unit/configuration.md#configuration-static" >}}) them with Unit.

   Here's an example (use real values for **share**, **path**,
   **environment**, **module**, and **home**):

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
            "share_comment": "Serves static files. Thus, URIs starting with /static/ are served from /path/to/app/static/; use a real path in your configuration"
            }
         },
         {
            "action": {
            "pass": "applications/djangochannels"
            }
         }
      ],
      "applications": {
         "djangochannels": {
            "type": "python 3.X",
            "type_comment": "Must match language module version and virtual environment version",
            "path": "/path/to/app/",
            "path_comment": "Project directory; use a real path in your configuration",
            "home": "/path/to/venv/",
            "home_comment": "Virtual environment directory; use a real path in your configuration",
            "module": "mysite.asgi",
            "module_comment": "Note the qualified name of the ASGI module; use a real site directory name in your configuration",
            "environment": {
            "DJANGO_SETTINGS_MODULE": "mysite.settings"
            },
            "environment_comment": "App-specific environment variables"
         }
      }
   }
   ```

8.    Upload the updated configuration:

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your project and apps (here, a chat) run on
   the listener's IP address and port:

   ![Django Channels on Unit - Tutorial App Screen](/unit/images/djangochannels.png)
