---
title: Trac
toc: true
weight: 2200
---

{{< warning >}}
So far, Unit doesn't support handling the **REMOTE_USER** headers
directly, so authentication should be implemented via external means. For
example, consider using [trac-oidc](https://pypi.org/project/trac-oidc/) or
[OAuth2Plugin](https://trac-hacks.org/wiki/OAuth2Plugin).
{{< /warning >}}

To run the [Trac](https://trac.edgewall.org) issue tracking system using
Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 2 language module.

   {{< note >}}
   As of now, Trac [doesn't fully support](https://trac.edgewall.org/ticket/12130) Python 3. Mind that Python 2
   is officially deprecated.
   {{< /note >}}

2. Prepare and activate a [virtual environment](https://virtualenv.pypa.io/en/latest/) to contain your installation
   (assuming `virtualenv` is installed):

   ```console
   mkdir -p /path/to/app/  # Path to the application directory; use a real path in your configuration
   ```

   ```console
   cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   ```

   ```console
   virtualenv venv
   ```

   ```console
   source venv/bin/activate
   ```

3. Next, [install Trac](https://trac.edgewall.org/wiki/TracInstall) and its
   optional dependencies, then initialize a [Trac environment](https://trac.edgewall.org/wiki/TracEnvironment) and deploy static files:

   ```console
   pip install Trac
   ```

   ```console
   pip install babel docutils genshi \
                 pygments pytz textile             # optional dependencies
   ```

   ```console
   mkdir static/  # Arbitrary directory name, will store Trac's /chrome/ tree
   ```

   ```console
   mkdir trac_env/ # Arbitrary directory name
   ```

   ```console
   trac-admin trac_env/ initenv                  # initialize Trac environment
   ```

   ```console
   trac-admin trac_env/ deploy static/           # extract Trac's static files
   ```

   ```console
   mv static/htdocs static/chrome                # align static file paths
   ```

   ```console
   rm -rf static/cgi-bin/                        # remove unneeded files
   ```

   ```console
   deactivate
   ```

4. Unit [uses WSGI]({{< relref "/unit/configuration.md#configuration-python" >}})
   to run Python apps, so a
   [wrapper](https://trac.edgewall.org/wiki/1.3/TracModWSGI#Averybasicscript)
   script is required to run Trac as a Unit app; let's save it as
   **/path/to/app/trac_wsgi.py**. Here, the **application** callable
   serves as the entry point for the app:

   ```python
   import trac.web.main

   def application(environ, start_response):
      environ["trac.locale"] = "en_US.UTF8"
      return trac.web.main.dispatch_request(environ, start_response)
   ```

5. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

6. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}}) the Trac configuration for Unit
   (use real values for **share**, **path**, **home**,
   **module**, **TRAC_ENV**, and **PYTHON_EGG_CACHE**):

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
                  "uri": "/chrome/*"
               },
               "action": {
                  "share": "/path/to/app/static$uri"
               },
               "_comment_action": "Serves matching static files | Path to the static files; use a real path in your configuration"
         },
         {
               "action": {
                  "pass": "applications/trac"
               }
         }
      ],

      "applications": {
         "trac": {
               "type": "python 2",
               "path": "/path/to/app/",
               "_comment_path": "Path to the application directory; use a real path in your configuration",
               "home": "/path/to/app/venv/",
               "_comment_home": "Path to the application directory; use a real path in your configuration",
               "module": "trac_wsgi",
               "_comment_module": "WSGI module basename from Step 4 with extension omitted",
               "environment": {
                  "TRAC_ENV": "/path/to/app/trac_env/",
                  "_comment_TRAC_ENV": "Path to the Trac environment; use a real path in your configuration",
                  "PYTHON_EGG_CACHE": "/path/to/app/trac_env/eggs/"
               },
               "_comment_PYTHON_EGG_CACHE": "Path to the Python egg cache for Trac; use a real path in your configuration"
         }
      }
   }
   ```

   The route serves requests for static files in Trac's **/chrome/**
   [hierarchy](https://trac.edgewall.org/wiki/TracDev/TracURLs) from the
   **static/** directory.

7. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, Trac should be available on the listener’s IP
   address and port:

   ![Trac on Unit - New Ticket Screen](/unit/images/trac.png)
