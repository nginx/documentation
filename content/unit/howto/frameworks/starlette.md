---
title: Starlette
toc: true
weight: 1900
---

# Starlette

To run apps built with the [Starlette](https://www.starlette.io) web
framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3.5+ language module.

2. Create a virtual environment to install Starlette's
   [PIP package](https://www.starlette.io/#installation), for
   instance:

   ```console
   $ cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   $ python --version  # Make sure your virtual environment version matches the module version
         Python X.Y.Z  # Major version, minor version, and revision number
   $ python -m venv venv  # Arbitrary name of the virtual environment
   $ source venv/bin/activate  # Name of the virtual environment from the previous command
   $ pip install 'starlette[full]'
   $ deactivate
   ```

   {{< warning >}}
   Create your virtual environment with a Python version that matches the
   language module from Step 1 up to the minor number (**X.Y** in
   this example). Also, the app **type** in Step 5 must
   [resolve]({{< relref "/unit/configuration.md#configuration-apps-common" >}})
   to a similarly matching version; Unit doesn't infer it from the environment.
   {{< /warning >}}

3. Let's try a version of a [tutorial app](https://www.starlette.io/applications/),
   saving it as **/path/to/app/asgi.py**:

   ```python
   from starlette.applications import Starlette
   from starlette.responses import PlainTextResponse
   from starlette.routing import Route, Mount, WebSocketRoute


   def homepage(request):
       return PlainTextResponse('Hello, world!')

   def user_me(request):
       username = "John Doe"
       return PlainTextResponse('Hello, %s!' % username)

   def user(request):
       username = request.path_params['username']
       return PlainTextResponse('Hello, %s!' % username)

   async def websocket_endpoint(websocket):
       await websocket.accept()
       await websocket.send_text('Hello, websocket!')
       await websocket.close()

   def startup():
       print('Ready to go')


   routes = [
       Route('/', homepage),
       Route('/user/me', user_me),
       Route('/user/{username}', user),
       WebSocketRoute('/ws', websocket_endpoint)
   ]

   app = Starlette(debug=True, routes=routes, on_startup=[startup])
   ```

   {{< note >}}
   This sample omits the static route because Unit's quite
   [capable]({{< relref "/unit/configuration.md#configuration-static" >}})
   of serving static files itself if needed.
   {{< /note >}}

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}


5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}}) the Starlette configuration for Unit
   (use real values for **type**, **home**, and **path**), adding a
   [route]({{< relref "/unit/configuration.md#configuration-routes" >}}) to serve static content:

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
            "uri": "/static/*"
            },
            "action": {
            "share": "/path/to/app$uri",
            "share_comment": "Serves static files. Thus, URIs starting with /static/ are served from /path/to/app/static/; use a real path in your configuration"
            }
         },
         {
            "action": {
            "pass": "applications/starlette"
            }
         }
      ],
      "applications": {
         "starlette": {
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

         Hello, world!
   ```

   ```console
   $ curl http://localhost/user/me

         Hello, John Doe!
   ```

   ```console
   $ wscat -c ws://localhost/ws

         Connected (press CTRL+C to quit)
         < Hello, websocket!
         Disconnected (code: 1000, reason: "")
   ```
