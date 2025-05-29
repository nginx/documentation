---
title: Zope
weight: 2100
toc: true
---

To run apps built with the [Zope](https://www.zope.dev/) web framework using
Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3.6+ language module.

2. Install Zope. Here, we do this at **/path/to/app/**; use a real path
   in your configuration.

   {{< tabs name="installation" >}}
   {{% tab name="Buildout" %}}

   First, install Zope's
   [core files](https://zope.readthedocs.io/en/latest/INSTALL.html#installing-zope-with-zc-buildout),
   for example:

   ```console
   $ pip install -U pip wheel zc.buildout
   ```

   ```console
   $ cd /path/to/app/ # Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ wget https://pypi.org/packages/source/Z/Zope/Zope-A.B.C.tar.gz # Zope version
   ```

   ```console
   $ tar xfvz Zope-A.B.C.tar.gz --strip-components =1 # Avoids creating a redundant subdirectory
   ```

   ```console
   $ buildout
   ```

   Next, add a new configuration file named **/path/to/app/wsgi.cfg**:

   ```cfg
   [buildout]
   extends =
         buildout.cfg

   parts +=
         wsgi.py  # The basename is arbitrary; the extension is required to make the resulting Python module discoverable

   [wsgi.py]
   recipe = plone.recipe.zope2instance
   user = admin:admin  # Instance credentials; omit this line to configure them interactively
   zodb-temporary-storage = off  # Avoids compatibility issues
   eggs =
   scripts =
   initialization =
         from Zope2.Startup.run import make_wsgi_app
         wsgiapp = make_wsgi_app({}, '${buildout:parts-directory}/wsgi.py/etc/zope.conf')  # Path to the instance's configuration file
         def application(*args, **kwargs):return wsgiapp(*args, **kwargs)
   ```

   It creates a new Zope instance.  The part's name must end with
   **.py** for the resulting instance script to be recognized as a
   Python module; the **initialization** [option](https://pypi.org/project/plone.recipe.zope2instance/#common-options)
   defines a WSGI entry point.

   Rerun Buildout, feeding it the new configuration file:

   ```console
   $ buildout -c wsgi.cfg

         ...
         Installing wsgi.py.
         Generated script '/path/to/app/bin/wsgi.py'.
   ```

   Thus created, the instance script can be used with Unit.

   {{< include "unit/howto_change_ownership.md" >}}

   Last,
   [prepare]({{< relref "/unit/configuration.md#configuration-python" >}})
   the Zope configuration for Unit (use a real value for **path**):

   ```json
   {
      "listeners": {
         "*:80": {
               "pass": "applications/zope"
         }
      },

      "applications": {
         "zope": {
               "type": "python 3",
               "path": "/path/to/app/",
               "comment_path": "Path to the application directory; use a real path in your configuration",
               "module": "bin.wsgi",
               "comment_module": "WSGI module's qualified name with extension omitted"
         }
      }
   }
   ```

   {{% /tab %}}
   {{% tab name="PIP" %}}

   Create a virtual environment to install Zope's [PIP package](https://pypi.org/project/Zope/)

   ```console
   $ cd /path/to/app/ # Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ python3 --version # Make sure your virtual environment version matches the module version
         Python 3.Y.Z # Major version, minor version, and revision number
   ```

   ```console
   $ python3 -m venv venv # This is the virtual environment directory
   ```

   ```console
   $ source venv/bin/activate
   ```

   ```console
   $ pip install 'zope[wsgi]'
   ```

   ```console
   $ deactivate
   ```

   {{< warning >}}
   Create your virtual environment with a Python version that matches
   the language module from Step 1 up to the minor number
   (**3.Y** in this example).  Also, the app **type** in Unit
   configuration must
   [resolve]({{< relref "/unit/configuration.md#configuration-apps-common" >}})
   to a similarly matching version; Unit doesn't infer it from the environment.
   {{< /warning >}}

   After installation, create your Zope [instance](https://zope.readthedocs.io/en/latest/operation.html#creating-a-zope-instance):

   ```console
   $ venv/bin/mkwsgiinstance -d instance # Using Zope's own script and the Zope instance's home directory
   ```

   To run the instance on Unit, create a WSGI entry point:

   ```python
   from pathlib import Path
   from Zope2.Startup.run import make_wsgi_app

   wsgiapp = make_wsgi_app({}, str(Path(__file__).parent / 'etc/zope.conf')) # Path to the instance's configuration file
   def application(*args, **kwargs):return wsgiapp(*args, **kwargs)
   ```

   Save the script as **wsgi.py** in the instance home directory
   (here, it's **/path/to/app/instance/**).

   {{< include "unit/howto_change_ownership.md" >}}

   Last,
   [prepare]({{< relref "/unit/configuration.md#configuration-python" >}})
   the Zope configuration
   for Unit (use real values for **path** and **home**):

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/zope"
         }
      },
      "applications": {
         "zope": {
            "type": "python 3.Y",
            "type_comment": "Must match language module version and virtual environment version",
            "path": "/path/to/app/instance/",
            "path_comment": "Path to the instance/ subdirectory; use a real path in your configuration",
            "home": "/path/to/app/venv/",
            "home_comment": "Path to the virtual environment; use a real path in your configuration",
            "module": "wsgi",
            "module_comment": "WSGI module basename with extension omitted"
         }
      }
   }

   ```

   {{% /tab %}}
   {{< /tabs >}}

---


3. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your Zope instance should be available on the
   listener’s IP address and port:

   ```console
   $ curl http://localhost

         <!DOCTYPE html>
         <html>
           <head>
         <base href="http://localhost/" />

             <title>Auto-generated default page</title>
             <meta charset="utf-8" />
           </head>
           <body>

             <h2>Zope
                 Auto-generated default page</h2>

             This is Page Template <em>index_html</em>.
           </body>
         </html>
   ```

[app-link]: https://zope.readthedocs.io/en/latest/INSTALL.html
