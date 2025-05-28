---
title: Falcon
weight: 800
toc: true
---

To run apps built with the [Falcon](https://falcon.readthedocs.io/en/stable/)
web framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3.5+ language module.

2. Create a virtual environment to install Falcon's
   [PIP package](https://falcon.readthedocs.io/en/stable/user/install.html), for
   instance:

   ```console
   $ cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   $ python --version  # Make sure your virtual environment version matches the module version
         Python X.Y.Z  # Major version, minor version, and revision number
   $ python -m venv venv  # Arbitrary name of the virtual environment
   $ source venv/bin/activate  # Name of the virtual environment from the previous command
   $ pip install falcon
   $ deactivate
   ```


   {{< warning >}}
   Create your virtual environment with a Python version that matches the
   language module from Step 1 up to the minor number (**X.Y** in
   this example). Also, the app **type** in Step 5 must
   [resolve]({{< relref "/unit/configuration.md#configuration-apps-common" >}})
   to a similarly matching version; Unit doesn't infer it from the environment.
   {{< /warning >}}

3. Let's try an updated version of the [quickstart app](https://falcon.readthedocs.io/en/stable/user/quickstart.html):

   {{< tabs name="falcon" >}}
   {{% tab name="WSGI" %}}

   ```python
      import falcon

      # Falcon follows the REST architectural style, meaning (among
      # other things) that you think in terms of resources and state
      # transitions, which map to HTTP verbs.
      class HelloUnitResource:
            def on_get(self, req, resp):
               """Handles GET requests"""
               resp.status = falcon.HTTP_200  # This is the default status
               resp.content_type = falcon.MEDIA_TEXT  # Default is JSON, so override
               resp.text = ('Hello, Unit!')

      # falcon.App instances are callable WSGI apps
      # in larger applications the app is created in a separate file
      app = falcon.App()

      # Resources are represented by long-lived class instances
      hellounit = HelloUnitResource()

      # hellounit will handle all requests to the '/unit' URL path
      app.add_route('/unit', hellounit)
   ```

   Note that we’ve dropped the server code; save the file as
      **/path/to/app/wsgi.py**.


   {{% /tab %}}
   {{% tab name="ASGI" %}}

   ```python
   import falcon
   import falcon.asgi


   # Falcon follows the REST architectural style, meaning (among
   # other things) that you think in terms of resources and state
   # transitions, which map to HTTP verbs.
   class HelloUnitResource:
         async def on_get(self, req, resp):
            """Handles GET requests"""
            resp.status = falcon.HTTP_200  # This is the default status
            resp.content_type = falcon.MEDIA_TEXT  # Default is JSON, so override
            resp.text = ('Hello, Unit!')

   # falcon.asgi.App instances are callable ASGI apps...
   # in larger applications the app is created in a separate file
   app = falcon.asgi.App()

   # Resources are represented by long-lived class instances
   hellounit = HelloUnitResource()

   # hellounit will handle all requests to the '/unit' URL path
   app.add_route('/unit', hellounit)
   ```

   Save the file as **/path/to/app/asgi.py**.

   {{% /tab %}}
   {{< /tabs >}}

---

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}


5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}})
   the configuration for Unit (use real values for **type**, **home**, **module**,
   **protocol**, and **path**):

   ```json
   {
         "listeners": {
            "*:80": {
               "pass": "applications/falcon"
            }
         },
         "applications": {
            "falcon": {
               "type": "python X.Y",
               "type_comment": "Must match language module version and virtual environment version",
               "path": "/path/to/app/",
               "path_comment": "Path to the WSGI module; use a real path in your configuration",
               "home": "/path/to/app/venv/",
               "home_comment": "Path to the virtual environment, if any; use a real path in your configuration",
               "module": "module_basename",
               "module_comment": "WSGI/ASGI module basename with extension omitted, such as 'wsgi' or 'asgi' from Step 3",
               "protocol": "wsgi_or_asgi",
               "protocol_comment": "'wsgi' or 'asgi', as appropriate",
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
   $ curl http://localhost/unit

         Hello, Unit!
   ```
