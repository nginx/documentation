---
title: MoinMoin
toc: true
weight: 1300
---

{{< warning >}}
So far, Unit doesn't support handling the **REMOTE_USER** headers directly, so
authentication should be implemented via other means. For a
full list of available authenticators, see [here](https://moinmo.in/HelpOnAuthentication).
{{< /warning >}}

To run the [MoinMoin](https://moinmo.in/MoinMoinWiki) wiki engine using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python 2 language module.

   {{< note >}}
   As of now, MoinMoin [doesn't fully support](https://moinmo.in/Python3)
   Python 3. Mind that Python 2 is officially deprecated.
   {{< /note >}}

2. Install and configure MoinMoin's [prerequisites](https://moinmo.in/MoinMoinDependencies)

3. Install MoinMoin's [core files](https://moinmo.in/MoinMoinDownload). Here we install them at **/path/to/app**;
   use a real path in your configuration.

   For example:

   ```console
   tar xzf moin-X.Y.Z.tar.gz --strip-components 1 -C /path/to/app/  # MoinMoin version | Path to the application directory; use a real path in your configuration
   ```

4. Configure your wiki instances:

   {{<tabs name="instance">}}
   {{%tab name="Single Wiki"%}}
   See the 'Single Wiki' section [here](https://master.moinmo.in/InstallDocs/ServerInstall) for an explanation of these commands:

   ```console
   cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   ```

   ```console
   mkdir single/
   ```

   ```console
   cp wiki/config/wikiconfig.py single/  # Wiki instance configuration
   ```

   ```console
   cp -r wiki/data/ single/data/
   ```

   ```console
   cp -r wiki/underlay/ single/underlay/
   ```

   ```console
   cp wiki/server/moin.wsgi single/moin.py  # WSGI module to run, extension should be changed for proper discovery
   ```

   Next, [edit](https://moinmo.in/HelpOnConfiguration#Configuring_a_single_wiki)
   the wiki instance configuration in **wikiconfig.py** as appropriate.
   {{%/tab%}}

   {{%tab name="Multiple Wikis"%}}


      See the 'Multiple Wikis' section [here](https://master.moinmo.in/InstallDocs/ServerInstall) for an explanation of these commands:

   ```console
   cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   ```

   ```console
   mkdir multi/ multi/wiki1/ multi/wiki2/
   ```

   ```console
   cp wiki/config/wikifarm/* multi/
   ```

   ```console
   cp wiki/config/wikiconfig.py multi/wiki1.py  # Wiki instance configuration

   ```

   ```console
   cp wiki/config/wikiconfig.py multi/wiki2.py  # Wiki instance configuration

   ```

   ```console
   cp -r wiki/data/ multi/wiki1/data/
   ```

   ```console
   cp -r wiki/data/ multi/wiki2/data/
   ```

   ```console
   cp -r wiki/underlay/ multi/wiki1/underlay/
   ```

   ```console
   cp -r wiki/underlay/ multi/wiki2/underlay/
   ```

   ```console
   cp wiki/server/moin.wsgi multi/moin.py  # WSGI module to run, extension should be changed for proper discovery
   ```

   Next, [edit](https://moinmo.in/HelpOnConfiguration#Configuration_of_multiple_wikis)
   the farm configuration in **farmconfig.py** and the wiki instance
   configurations, shown here as **wiki1.py** and **wiki2.py**, as appropriate.

   {{%/tab%}}
   {{</tabs>}}


5. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

6. Next, [prepare]({{< relref "/unit/configuration.md#configuration-python" >}}) the MoinMoin configuration for
   Unit (use real values for **path**):

   ```json
   {
      "listeners": {
         "*:80": {
               "pass": "applications/moin"
         }
      },

      "applications": {
         "moin": {
               "type": "python 2",
               "path": [
                  "/path/to/app/wsgi/module/",
                  "/path/to/app/"
               ],
               "_comment_path": "Path where the WSGI module was stored at Step 4 | Path where the MoinMoin directory was extracted at Step 3",
               "module": "moin",
               "_comment_module": "WSGI file basename"
         }
      }
   }
   ```

7. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, MoinMoin should be available on the listener’s IP
   address and port:

   ![Moin on Unit - Welcome Screen](/unit/images/moin.png)
