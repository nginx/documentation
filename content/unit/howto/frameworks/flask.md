---
title: Flask
toc: true
weight: 1000
---

To run apps built with the [Flask](https://flask.palletsprojects.com/en/1.1.x/) web framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3 language module.

2. Create a virtual environment to install Flasks`s
   [PIP package](https://flask.palletsprojects.com/en/1.1.x/installation/#install-flask), for
   instance:

   ```console
   $ cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   $ python --version  # Make sure your virtual environment version matches the module version
         Python X.Y.Z  # Major version, minor version, and revision number
   $ python -m venv venv  # Arbitrary name of the virtual environment
   $ source venv/bin/activate  # Name of the virtual environment from the previous command
   $ pip install Flask
   $ deactivate
   ```

   {{< warning >}}
   Create your virtual environment with a Python version that matches the
   language module from Step 1 up to the minor number (**X.Y** in
   this example). Also, the app **type** in Step 5 must
   [resolve]({{< relref "/unit/configuration.md#configuration-apps-common" >}})
   to a similarly matching version; Unit doesn't infer it from the environment.
   {{< /warning >}}

3. Let's try a basic version of the [quickstart app](https://flask.palletsprojects.com/en/1.1.x/quickstart/),
   saving it as **/path/to/app/wsgi.py**:

   ```python
   from flask import Flask
   app  = Flask(__name__) # Callable name used in Unit's condfiguration

   @app.route("/")
   def hello_world():
       return "Hello, World!"
   ```

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}}) the [ app ] configuration for
   Unit (use real values for **type**, **home**, and **path**):

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/flask"
         }
      },
      "applications": {
         "flask": {
            "type": "python 3.Y",
            "type_comment": "Must match language module version and virtual environment version",
            "path": "/path/to/app/",
            "path_comment": "Path to the WSGI module",
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

         Hello, World!
   ```
