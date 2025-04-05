---
title: Redmine
toc: true
weight: 1900
---

To run the [Redmine](https://www.redmine.org) project management system using
Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Ruby language module.

2. Install and configure Redmine's [prerequisites](https://www.redmine.org/projects/redmine/wiki/RedmineInstall#Installation-procedure)

3. Install Redmine's [core files](https://www.redmine.org/projects/redmine/wiki/RedmineInstall#Step-1-Redmine-application).
   Here we install them at **/path/to/app**; use a real path in your configuration.

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-ruby" >}})
 the Redmine configuration for Unit (use a real value for **working_directory**):

   ```json
   {
      "listeners": {
         "*:80": {
               "pass": "applications/redmine"
         }
      },

      "applications": {
         "redmine": {
               "type": "ruby",
               "working_directory": "/path/to/app/",
               "_comment_working_directory": "Path to the application directory; use a real path in your configuration",
               "script": "config.ru",
               "_comment_script": "Entry point script name, including the file name extension",
               "environment": {
                  "RAILS_ENV": "production"
               },
               "_comment_environment": "Environment name in the Redmine configuration file"
         }
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, Redmine should be available on the listener's IP
   and port:

   ![Redmine on Unit - Sample Screen](/unit/images/redmine.png)
