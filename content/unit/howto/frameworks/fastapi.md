---
title: FastAPI
toc: true
weight: 900
---

To run apps built with the [FastAPI](https://fastapi.tiangolo.com) web framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3.6+ language module.

2. Create a virtual environment to install FastAPI's
   [PIP package](https://fastapi.tiangolo.com/tutorial/#install-fastapi), for
   instance:

   ```console
   $ cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   $ python --version  # Make sure your virtual environment version matches the module version
         Python X.Y.Z  # Major version, minor version, and revision number
   $ python -m venv venv  # Arbitrary name of the virtual environment
   $ source venv/bin/activate  # Name of the virtual environment from the previous command
   $ pip install fastapi
   $ deactivate
   ```

   {{< warning >}}
   Create your virtual environment with a Python version that matches the
   language module from Step 1 up to the minor number (**X.Y** in
   this example). Also, the app **type** in Step 5 must
   [resolve]({{< relref "/unit/configuration.md#configuration-apps-common" >}})
   to a similarly matching version; Unit doesn't infer it from the environment.
   {{< /warning >}}

3. Let's try a version of a [tutorial app](https://fastapi.tiangolo.com/tutorial/first-steps/),
   saving it as **/path/to/app/asgi.py**:

   ```python
   from fastapi import FastAPI

   app = FastAPI()

   @app.get("/")
   async def root():
       return {"message": "Hello, World!"}
   ```

   {{< note >}}
   For something more true-to-life, try the
   [RealWorld example app](https://github.com/nsidnev/fastapi-realworld-example-app); just
   install all its dependencies in the same virtual environment where you've
   installed FastAPI and add the app's **environment** {ref}`variables
   <configuration-apps-common>` like **DB_CONNECTION** or
   **SECRET_KEY** directly to the app configuration in Unit instead of
   the **.env** file.
   {{< /note >}}

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}})
   the FastAPI configuration for Unit (use real values for **type**, **home**, and **path**):

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/fastapi"
         }
      },
      "applications": {
         "fastapi": {
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
   curl http://localhost

         Hello, World!
   ```

   Alternatively, try FastAPI's nifty self-documenting features:

   ![FastAPI on Unit - Swagger Screen](/unit/images/fastapi.png)
