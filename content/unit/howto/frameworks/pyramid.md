---
title: Pyramid
weight: 1300
toc: true
---

To run apps built with the [Pyramid](https://trypyramid.com) web framework
using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3 language module.

2. Create a virtual environment to install Pyramid`s
   [PIP package](https://docs.pylonsproject.org/projects/pyramid/en/latest/narr/install.html#installing-pyramid-on-a-unix-system), for instance:

   ```console
   $ cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   $ python --version  # Make sure your virtual environment version matches the module version
         Python X.Y.Z  # Major version, minor version, and revision number
   $ python -m venv venv  # Arbitrary name of the virtual environment
   $ source venv/bin/activate  # Name of the virtual environment from the previous command
   $ pip install <package>
   $ deactivate
   ```

   {{< warning >}}
   Create your virtual environment with a Python version that matches the
   language module from Step 1 up to the minor number (**X.Y** in
   this example). Also, the app **type** in Step 5 must
   [resolve]({{< relref "/unit/configuration.md#configuration-apps-common" >}})
   to a similarly matching version; Unit doesn't infer it from the environment.
   {{< /warning >}}

   {{< note >}}
   Here, **\$VENV** isn't set because Unit picks up the virtual
   environment from **home** in Step 5.
   {{< /note >}}

3. Let's see how the apps from the Pyramid
   [tutorial](https://docs.pylonsproject.org/projects/pyramid/en/latest/quick_tutorial)
   run on Unit.

   {{< tabs name="pyramid" >}}
   {{% tab name="Single-File" %}}

   We modify the [tutorial app](https://docs.pylonsproject.org/projects/pyramid/en/latest/quick_tutorial/hello_world.html#steps)
   saving it as **/path/to/app/wsgi.py**:

   ```python
   from pyramid.config import Configurator
   from pyramid.response import Response

   def hello_world(request):
      return Response('<body><h1>Hello, World!</h1></body>')

   with Configurator() as config:
      config.add_route('hello', '/')
      config.add_view(hello_world, route_name='hello')

   # Callables' name is used in Unit configuration
   app = config.make_wsgi_app()

   # serve(app, host='0.0.0.0', port=6543)
   ```

   Note that we've dropped the server code; also, mind that Unit imports
   the module, so the **if __name__ == '__main__'** idiom would be
   irrelevant.

   {{% /tab %}}
   {{% tab name="INI-Based" %}}

   To load the
   [configuration](https://docs.pylonsproject.org/projects/pyramid/en/latest/quick_tutorial/ini.html),
   we place a **wsgi.py** file next to **development.ini** in **/path/to/app/**:

   ```python
   from pyramid.paster import get_app, setup_logging

   # Callables' name is used in Unit configuration
   app = get_app('development.ini')
   setup_logging('development.ini')
   ```

   This [sets up](https://docs.pylonsproject.org/projects/pyramid/en/latest/api/paster.html)
   the WSGI application for Unit; if the **.ini**'s pathname is
   relative, provide the appropriate **working_directory** in Unit
   configuration.

   {{% /tab %}}
   {{< /tabs >}}

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}})
   the Pyramid configuration for Unit (use real values for **type**, **home**,
   and **path**):

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/pyramid"
         }
      },
      "applications": {
         "pyramid": {
            "type": "python 3.Y",
            "type_comment": "Must match language module version and virtual environment version",
            "working_directory": "/path/to/app/",
            "working_directory_comment": "Path to the application directory; use a real path in your configuration",
            "path": "/path/to/app/",
            "path_comment": "Path to the application directory; use a real path in your configuration",
            "home": "/path/to/app/venv/",
            "home_comment": "Path to the virtual environment, if any",
            "module": "wsgi",
            "module_comment": "WSGI module filename with extension omitted",
            "callable": "app",
            "callable_comment": "Name of the callable in the module to run"
         }
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the listener’s IP
   address and port:

   ```console
   $ curl http://localhost

         <body><h1>Hello, World!</h1></body>
   ```
