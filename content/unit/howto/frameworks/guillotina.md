---
title: Gillotina
toc: true
weight: 1000
---

To run apps built with the [Guillotina](https://guillotina.readthedocs.io/en/latest/) web framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3.7+ language module.

2. Create a virtual environment to install Guillotina's
   [PIP package](https://guillotina.readthedocs.io/en/latest/training/installation.html),
   for instance:

   ```console
   $ cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   $ python --version  # Make sure your virtual environment version matches the module version
         Python X.Y.Z  # Major version, minor version, and revision number
   $ python -m venv venv  # Arbitrary name of the virtual environment
   $ source venv/bin/activate  # Name of the virtual environment from the previous command
   $ pip install guillotina
   $ deactivate
   ```

   {{< warning >}}
   Create your virtual environment with a Python version that matches the
   language module from Step 1 up to the minor number (**X.Y** in
   this example). Also, the app **type** in Step 5 must
   [resolve]({{< relref "/unit/configuration.md#configuration-apps-common" >}})
   to a similarly matching version; Unit doesn't infer it from the environment.
   {{< /warning >}}

3. Let's try a version of the [tutorial app](https://guillotina.readthedocs.io/en/latest/#build-a-guillotina-app),
   saving it as **/path/to/app/asgi.py**:

   ```python
   from guillotina import configure
   from guillotina import content
   from guillotina import schema
   from guillotina.factory import make_app
   from zope import interface


   class IMyType(interface.Interface):
      textline = schema.TextLine()


   @configure.contenttype(
      type_name="MyType",
      schema=IMyType,
      behaviors=["guillotina.behaviors.dublincore.IDublinCore"],
   )
   class MyType(content.Resource):
      pass


   @configure.service(
      context=IMyType,
      method="GET",
      permission="guillotina.ViewContent",
      name="@textline",
   )
   async def textline_service(context, request):
      return {"textline": context.textline}


   # Callable name that Unit looks for
   application = make_app(
      settings={
         "applications": ["__main__"],
         "root_user": {"password": "root"},
         "databases": {
               "db": {"storage": "DUMMY_FILE", "filename": "dummy_file.db"}
         },
      }
   )
   ```

   Note that all server calls and imports are removed.

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}}) the Guillotina configuration for
   Unit (use real values for **type**, **home**, and **path**):

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/guillotina"
         }
      },
      "applications": {
         "guillotina": {
            "type": "python 3.Y",
            "type_comment": "Must match language module version and virtual environment version",
            "path": "/path/to/app/",
            "path_comment": "Path to the ASGI module",
            "home": "/path/to/app/venv/",
            "home_comment": "Path to the virtual environment, if any",
            "module": "asgi",
            "module_comment": "ASGI module filename with extension omitted",
            "protocol": "asgi",
            "protocol_comment": "Protocol hint for Unit, required to run Guillotina apps"
         }
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the listener’s IP
   address and port:

   ```console
   $ curl -XPOST --user root:root http://localhost/db \
          -d '{ "@type": "Container", "id": "container" }'

         {"@type":"Container","id":"container","title":"container"}
   ```

   ```console
   $ curl --user root:root http://localhost/db/container

         {
             "@id": "http://localhost/db/container",
             "@type": "Container",
             "@name": "container",
             "@uid": "84651300b2f14170b2b2e4a0f004b1a3",
             "@static_behaviors": [
             ],
             "parent": {
             },
             "is_folderish": true,
             "creation_date": "2020-10-16T14:07:35.002780+00:00",
             "modification_date": "2020-10-16T14:07:35.002780+00:00",
             "type_name": "Container",
             "title": "container",
             "uuid": "84651300b2f14170b2b2e4a0f004b1a3",
             "__behaviors__": [
             ],
             "items": [
             ],
             "length": 0
         }
   ```

