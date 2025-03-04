---
title: Datasette
weight: 300
toc: true
---

To run the [Datasette](https://docs.datasette.io/en/stable/) data exploration tool using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 3.6+ language module.

2. Create a virtual environment to install Datasette's
   [PIP package](https://docs.datasette.io/en/stable/installation.html#using-pip), for instance:

   ```console
   $ cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   $ python --version  # Make sure your virtual environment version matches the module version
         Python X.Y.Z  # Major version, minor version, and revision number
   $ python -m venv venv  # Arbitrary name of the virtual environment
   $ source venv/bin/activate  # Name of the virtual environment from the previous command
   $ pip install datasette
   $ deactivate
   ```

3. Running Datasette on Unit requires a wrapper to expose the [application object](https://github.com/simonw/datasette/blob/4f7c0ebd85ccd8c1853d7aa0147628f7c1b749cc/datasette/app.py#L169)
   as the ASGI callable. Let's use the following basic version, saving it as
   **/path/to/app/asgi.py**:

   ```python
   import glob
   from datasette.app import Datasette

   application = Datasette(glob.glob('*.db')).app()
   ```

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}}) the Datasette configuration for
   Unit (use real values for **type**, **home**, and **path**):

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/datasette"
         }
      },

      "applications": {
         "datasette": {
            "type": "python 3.Y",
            "_comment_type": "Must match language module version and virtual environment version",
            "path": "/path/to/app/",
            "_comment_path": "Path to the ASGI module",
            "home": "/path/to/app/venv/",
            "_comment_home": "Path to the virtual environment, if any",
            "module": "asgi",
            "_comment_module": "ASGI module filename with extension omitted",
            "callable": "app",
            "_comment_callable": "Name of the callable in the module to run"
         }
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, Datasette should be available on the listener’s IP
   address and port:

   ![Datasette on Unit - Query Screen](/unit/images/datasette.png)
