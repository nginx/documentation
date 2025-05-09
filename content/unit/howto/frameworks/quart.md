---
title: Quart
weight: 1400
toc: true
---


To run apps built with the [Quart](https://pgjones.gitlab.io/quart/index.html) web framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3.5+ language module.

2. Create a virtual environment to install Quart`s
   [PIP package](https://pgjones.gitlab.io/quart/tutorials/installation.html),
   for instance:

   ```console
   $ cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   $ python --version  # Make sure your virtual environment version matches the module version
         Python X.Y.Z  # Major version, minor version, and revision number
   $ python -m venv venv  # Arbitrary name of the virtual environment
   $ source venv/bin/activate  # Name of the virtual environment from the previous command
   $ pip install quart
   $ deactivate
   ```

   {{< warning >}}
   Create your virtual environment with a Python version that matches the
   language module from Step 1 up to the minor number (**X.Y** in
   this example). Also, the app **type** in Step 5 must
   [resolve]({{< relref "/unit/configuration.md#configuration-apps-common" >}})
   to a similarly matching version; Unit doesn't infer it from the environment.
   {{< /warning >}}


3. Let's try a WebSocket-enabled version of a
   [tutorial app](https://pgjones.gitlab.io/quart/tutorials/deployment.html),
   saving it as **/path/to/app/asgi.py**:

   ```python
   from quart import Quart, websocket

   app = Quart(__name__)

   @app.route('/')
   async def hello():
       return '<body><h1>Hello, World!</h1></body>'

   # Let's add WebSocket support to the app as well
   @app.websocket('/ws')
   async def ws():
       while True:
           await websocket.send('Hello, World!')
   ```

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}})
   the Quart configuration for Unit (use real values for **type**, **home**,
   and **path**):

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/quart"
         }
      },
      "applications": {
         "quart": {
            "type": "python 3.Y",
            "type_comment": "Must match language module version and virtual environment version",
            "path": "/path/to/app/",
            "path_comment": "Path to the ASGI module",
            "home": "/path/to/app/venv/",
            "home_comment": "Path to the virtual environment, if any",
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

         <body><h1>Hello, World!</h1></body>
   ```

   ```console
   $ wscat -c ws://localhost/ws

         < Hello, World!
         < Hello, World!
         < Hello, World!
         ...
   ```
