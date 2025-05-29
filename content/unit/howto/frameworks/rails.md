---
title: Ruby on Rails
weight: 1600
toc: true
---

To run apps based on the [Ruby on Rails](https://rubyonrails.org) framework
using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Ruby language module.

2. [Install](https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project-installing-rails)
   Ruby on Rails and create or deploy your app. Here, we use  Ruby on Rails's [basic template](https://guides.rubyonrails.org/getting_started.html#creating-the-blog-application):

   ```console
   $ cd /path/to/ # Path where the application directory will be created; use a real path in your configuration
   ```

   ```console
   $ rails new app # Arbitrary app name; becomes the application directory name
   ```

   This creates the app's directory tree at **/path/to/app/**; its
   **public/** subdirectory contains the static files, while the entry
   point is **/path/to/app/config.ru**.

3. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

4. Next,
   [prepare]({{< relref "/unit/configuration.md#configuration-ruby" >}})
   the  Ruby on Rails configuration (use real values for **share** and
   **working_directory**):

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "routes"
         }
      },
      "routes": [
         {
            "action": {
            "share": "/path/to/app/public$uri",
            "share_comment": "Serves static files",
            "fallback": {
               "pass": "applications/rails"
            }
            }
         }
      ],
      "applications": {
         "rails": {
            "type": "ruby",
            "script": "config.ru",
            "script_comment": "All requests are handled by a single script, relative to working_directory",
            "working_directory": "/path/to/app/",
            "working_directory_comment": "Path to the application directory, needed here for 'require_relative' directives; use a real path in your configuration"
         }
      }
   }
   ```

5. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the listener’s IP
   address and port:

   ![Ruby on Rails Basic Template App on Unit](/unit/images/rails.png)

