---
title: Plone
toc: true
weight: 1800
---

To run the [Plone](https://plone.org) content management system using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3.6+ language module.

2. Install and configure Plone's [prerequisites](https://docs.plone.org/manage/installing/requirements.html)

3. Install Plone's [core files](https://docs.plone.org/manage/installing/installation.html).
   Here, we install them at **/path/to/app/**; use a real path in your configuration:

   ```console
   mkdir /tmp/plone && cd /tmp/plone/
   ```

   ```console
   wget https://launchpad.net/plone/A.B/A.B.C/+download/Plone-A.B.C-UnifiedInstaller-1.0.tgz  # Plone version
   ```

   ```console
   tar xzvf Plone-A.B.C-UnifiedInstaller-1.0.tgz --strip-components=1  # Plone version | Avoids creating a redundant subdirectory
   ```

   ```console
      ./install.sh --target=:/path/to/app/  \ # Path to the application directory; use a real path in your configuration
                  --with-python=/full/path/to/python \ # Full pathname of the Python executable used to create Plone's virtual environment
                  standalone
   ```

   {{< note >}}
   Plone's [Zope](https://plone.org/what-is-plone/zope) instance and
   virtual environment are created in the **zinstance/** subdirectory;
   later, the resulting path is used to configure Unit, so take care to note
   it in your setup. Also, make sure the Python version specified with
   `--with-python` matches the module version from Step 1.
   {{< /note >}}

4. To run Plone on Unit, add a new configuration file named
   **/path/to/app/zinstance/wsgi.cfg**:

   ```cfg
   [buildout]
   extends =
       buildout.cfg

   parts +=
       wsgi.py # The basename is arbitrary; the extension is required to make the resulting Python module discoverable

   [wsgi.py]
   recipe = plone.recipe.zope2instance
   user = admin:admin # Instance credentials; omit this line to configure them interactively
   eggs =
       ${instance:eggs}
   scripts =
   initialization =
       from Zope2.Startup.run import make_wsgi_app
       wsgiapp = make_wsgi_app({}, '${buildout:parts-directory}/instance/etc/zope.conf') # Path to the Zope instance's configuration
       def application(*args, **kwargs):return wsgiapp(*args, **kwargs)
   ```

   It creates a new Zope instance. The part's name must end with **.py**
   for the resulting instance script to be recognized as a Python module; the
   **initialization** [option](https://pypi.org/project/plone.recipe.zope2instance/#common-options)
   defines a WSGI entry point using **zope.conf** from the **instance**
   part in **buildout.cfg**.

   Rerun Buildout, feeding it the new configuration file:

   ```console
   cd /path/to/app/  # Path to the application directory; use a real path in your configurationzinstance/
   ```

   ```console
   bin/buildout -c wsgi.cfg

         ...
         Installing wsgi.py.
         Generated script '/path/to/app/zinstance/bin/wsgi.py'.
   ```

   Thus created, the instance script can be used with Unit.

5. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

6. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}}) the Plone configuration for Unit
   (use real values for **path** and **home**):

   ```json
   {
      "listeners": {
         "*:80": {
               "pass": "applications/plone"
         }
      },

      "applications": {
         "plone": {
               "type": "python 3.Y",
               "_comment_type": "Python executable version used to install Plone",
               "path": "/path/to/app/zinstance/",
               "_comment_path": "Path to the application directory; use a real path in your configuration",
               "home": "/path/to/app/zinstance/",
               "_comment_home": "Path to the application directory; use a real path in your configuration",
               "module": "bin.wsgi",
               "_comment_module": "WSGI module's qualified name with extension omitted"
         }
      }
   }
   ```

7. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your Plone instance should be available on the
   listener’s IP address and port:

   ![Plone on Unit - Setup Screen](/unit/images/plone.png)
