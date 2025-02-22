---
title: Responder
weight: 1500
toc: true
---

# Responder

To run apps built with the [Responder](https://responder.kennethreitz.org/) web framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3.6+ language module.

2. Create a virtual environment to install Responder’s
[PIP package](https://responder.kennethreitz.org/#installing-responder),
for instance:

   ```console
   $ cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   $ python --version  # Make sure your virtual environment version matches the module version
         Python X.Y.Z  # Major version, minor version, and revision number
   $ python -m venv venv  # Arbitrary name of the virtual environment
   $ source venv/bin/activate  # Name of the virtual environment from the previous command
   $ pip install responder
   $ deactivate
   ```

   {{< warning >}}
   Create your virtual environment with a Python version that matches the
   language module from Step 1 up to the minor number (**X.Y** in
   this example). Also, the app **type** in Step 5 must
   [resolve]({{< relref "/unit/configuration.md#configuration-apps-common" >}})
   to a similarly matching version; Unit doesn't infer it from the environment.
   {{< /warning >}}


3. Let's try a Unit-friendly version of a [tutorial app](https://responder.kennethreitz.org/quickstart.html#declare-a-web-service),
   saving it as **/path/to/app/asgi.py**:

   ```python
   import responder

   app = responder.API()

   @app.route("/")
   def hello_world(req, resp):
       resp.text = "Hello, World!"

   @app.route("/hello/{who}")
   def hello_to(req, resp, *, who):
       resp.text = f"Hello, {who}!"
   ```

   The **app.run()** call is omitted because **app** will be directly
   run by Unit as an ASGI [callable](https://github.com/kennethreitz/responder/blob/c6f3a7364cfa79805b0d51eea011fe34d9bd331a/responder/api.py#L501).

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}


5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}}) the Responder configuration for
   Unit (use real values for **type**, **home**, and **path**):

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/responder"
         }
      },
      "applications": {
         "responder": {
            "type": "python 3.Y",
            "type_comment": "Must match language module version and virtual environment version",
            "path": "/path/to/app/",
            "path_comment": "Path to the ASGI module",
            "home": "/path/to/app/venv/",
            "home_comment": "Path to the virtual environment, if any",
            "working_directory": "/path/to/app/",
            "working_directory_comment": "Path to the directory where Responder creates static_dir and templates_dir",
            "module": "asgi",
            "module_comment": "ASGI module filename with extension omitted",
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

   ```console
   $ curl http://localhost/hello/JohnDoe

         Hello, JohnDoe!
   ```

