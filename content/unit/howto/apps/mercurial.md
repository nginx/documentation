---
title: Mercurial
weight: 1100
toc: true
---

To install and run the [Mercurial](https://www.mercurial-scm.org) source
control system using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Python language module.

2. Install Mercurial's [core files](https://www.mercurial-scm.org/wiki/UnixInstall).
   Here we install them at **/path/to/app**; use a real path in your configuration.

3. Optionally, configure a [repository](https://www.mercurial-scm.org/wiki/TutorialInit) or choose an existing
   one, noting its directory path.

4. Unit [uses WSGI]({{< relref "/unit/configuration.md#configuration-python" >}}) to run Python apps, so it
   requires a [wrapper](https://www.mercurial-scm.org/repo/hg/file/default/contrib/hgweb.wsgi)
   script to publish a Mercurial repo. Here, it's **/path/to/app/hgweb.py**
   (note the extension); the **application** callable is the entry
   point:

  ```python
  from mercurial.hgweb import hgweb

   # path to a repo or a hgweb config file to serve in UTF-8 (see 'hg help hgweb')
   application = hgweb("/path/to/app/repo/or/config/file".encode("utf-8"))  # Replace with a real path in your configuration
  ```

   This is a very basic script; to elaborate on it, see the
   Mercurial repo publishing [guide](https://www.mercurial-scm.org/wiki/PublishingRepositories#hgweb).

5. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

6. Next, prepare the Mercurial [configuration]({{< relref "/unit/configuration.md#configuration-python" >}}) for Unit (use a real value for **path**):

   ```json
   {
      "listeners": {
         "*:80": {
               "pass": "applications/hg"
         }
      },

      "applications": {
         "hg": {
               "type": "python",
               "path": "/path/to/app/",
               "_comment_path": "Path to the WSGI file referenced by the module option; use a real path in your configuration",
               "module": "hgweb",
               "_comment_module": "WSGI module basename with extension omitted"
         }
      }
   }
   ```

7. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, you can proceed to work with your Mercurial
   repository as usual:

   ```console
   hg config --edit
   ```

   ```console
   hg clone http://localhost/ project/
   ```

   ```console
   cd project/
   ```

   ```console
   touch hg_rocks.txt
   ```

   ```console
   hg add
   ```

   ```console
   hg commit -m 'Official: Mercurial on Unit rocks!'
   ```

   ```console
   hg push
   ```

   ![Mercurial on Unit - Changeset Screen](/unit/images/hg.png)
