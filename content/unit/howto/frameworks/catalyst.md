---
title: Catalyst
weight: 300
toc: true
---

To run apps based on the [Catalyst](https://metacpan.org/dist/Catalyst-Manual) 5.9+ framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Perl language module.

2. Install Catalyst's [core files](https://metacpan.org/dist/Catalyst-Manual/view/lib/Catalyst/Manual/Intro.pod#Install).

3. [Create](https://metacpan.org/dist/Catalyst-Manual/view/lib/Catalyst/Manual/Tutorial/02_CatalystBasics.pod#CREATE-A-CATALYST-PROJECT)
   a Catalyst app. Here, let's store it at **/path/to/app/**:

   ```console
   $ cd /path/to/   # Path where the application directory will be created; use a real path in your configuration
   ```

   ```console
   $ catalyst.pl app  # Arbitrary app name; becomes the application directory name
   ```

   ```console
   $ cd app
   ```

   ```console
   $ perl Makefile.PL
   ```

   Make sure the app's **.psgi** file includes the **lib/**
   directory:

   ```perl
   use lib 'lib';
   use app;
   ```

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next,
   [prepare]({{< ref "/unit/configuration.md#configuration-perl" >}})
   the Catalyst configuration for Unit
   (use real values for **script** and **working_directory**):

   ```json
   {
      "listeners": {
         "*:80": {
               "pass": "applications/catalyst"
         }
      },

      "applications": {
         "catalyst": {
               "type": "perl",
               "working_directory": "/path/to/app/",
               "_comment_working_directory": "Needed to use modules from the local lib directory; use a real path in your configuration",
               "script": "/path/to/app/app.psgi",
               "_comment_script": "Path to the application directory; use a real path in your configuration"
         }
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the listener’s IP
   address and port:

   ![Catalyst Basic Template App on Unit](/unit/images/catalyst.png)
