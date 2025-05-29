---
title: Sanic
weight: 1700
toc: true
---

To run apps built with the [Sanic](https://sanic.dev/) web framework
using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3.7+ language module.

2. Create a virtual environment to install Sanic's
   [PIP package](https://sanic.dev/en/guide/getting-started.html), for
   instance:

   ```console
   $ cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   $ python --version  # Make sure your virtual environment version matches the module version
         Python X.Y.Z  # Major version, minor version, and revision number
   $ python -m venv venv  # Arbitrary name of the virtual environment
   $ source venv/bin/activate  # Name of the virtual environment from the previous command
   $ pip install sanic
   $ deactivate
   ```

3. Let's try a version of a [tutorial app](ttps://sanic.dev/en/guide/basics/response.html#methods),
   saving it as **/path/to/app/asgi.py**:

   ```python
   from sanic import Sanic
   from sanic.response import json

   app = Sanic()

   @app.route("/")
   async def test(request):
       return json({"hello": "world"})
   ```

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}


5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}})
   the Sanic configuration for Unit (use real values for **type**, **home**, and
   **path**):

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/sanic"
         }
      },
      "applications": {
         "sanic": {
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

         {"hello":"world"}
   ```

