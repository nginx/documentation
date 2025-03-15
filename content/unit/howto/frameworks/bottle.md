---
title: Bottle
weight: 100
toc: true
---

To run apps built with the [Bottle](https://bottlepy.org/docs/dev/) web
framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 2.7+ language module.

2. Create a virtual environment to install Bottle's
[PIP package](https://bottlepy.org/docs/dev/tutorial.html#installation), for
   instance:

   ```console
   $ cd /path/to/app/ # Path to the application directory; use a real path in your configuration
   $ python --version # Make sure your virtual environment version matches the module version
            Python X.Y.Z # Major version, minor version, and revision number
   $ python -m venv venv # Arbitrary name of the virtual environment
   $ source venv/bin/activate # Name of the virtual environment from the previous command
   $ pip install bottle
   $ deactivate
   ```

   {{< warning >}}
   Create your virtual environment with a Python version that matches the
   language module from Step 1 up to the minor number (**X.Y** in
   this example). Also, the app **type** in Step 5 must
   [resolve]({{< relref "/unit/configuration.md#configuration-apps-common" >}})
   to a similarly matching version; Unit doesn't infer it from the environment.
   {{< /warning >}}

3. Let's try an updated version of the [quickstart app](https://bottlepy.org/docs/dev/tutorial.html#the-default-application),
   saving it as **/path/to/app/wsgi.py**:

   ```python
   from bottle import Bottle, template

   app = Bottle()  # Callable name used in Unit's configuration

   @app.route('/hello/<name>')
   def hello(name):
      return template('Hello, {{name}}!', name=name)

   # run(app, host='localhost', port=8080)
   ```

   Note that we've dropped the server code.

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}}) the Bottle configuration for
   Unit (use real values for **type**, **home**, and **path**):

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/bottle"
         }
      },
      "applications": {
         "bottle": {
            "type": "python X.Y",
            "type_comment": "Must match language module version and virtual environment version",
            "path": "/path/to/app/",
            "path_comment": "Path to the WSGI module; use a real path in your configuration",
            "home": "/path/to/app/venv/",
            "home_comment": "Path to the virtual environment, if any; use a real path in your configuration",
            "module": "wsgi",
            "module_comment": "WSGI module basename with extension omitted",
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
   $ curl http://localhost/hello/Unit

         Hello, Unit!
   ```
