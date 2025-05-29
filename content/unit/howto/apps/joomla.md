---
title: Joomla
toc: true
weight: 800
---

To run the [Joomla](https://www.joomla.org) content management system using
Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.


2. Install and configure Joomla's [prerequisites](https://downloads.joomla.org/technical-requirements)

3. Install Joomla's [core files](https://docs.joomla.org/Special:MyLanguage/J3.x:Installing_Joomla).
Here we install them at **/path/to/app**; use a real path in your configuration.

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}}) the Joomla configuration for
   Unit (use real values for **share** and **root**):

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
                  "uri": [
                     "*.php",
                     "*.php/*",
                     "/administrator/"
                  ]
               },
               "_comment_match": "Matches direct URLs and the administrative section of the site",
               "action": {
                  "pass": "applications/joomla/direct"
               }
         },
         {
               "action": {
                  "share": "/path/to/app$uri",
                  "_comment_share": "Serves matching static files",
                  "fallback": {
                     "pass": "applications/joomla/index"
                  },
                  "_comment_fallback": "Unconditionally matches all remaining URLs, including rewritten ones"
               }
         }
      ],

      "applications": {
         "joomla": {
               "type": "php",
               "targets": {
                  "direct": {
                     "root": "/path/to/app/",
                     "_comment_root": "Path to the application directory; use a real path in your configuration"
                  },
                  "index": {
                     "root": "/path/to/app/",
                     "_comment_root": "Path to the application directory; use a real path in your configuration",
                     "script": "index.php",
                     "_comment_script": "All requests are handled by a single script"
                  }
               }
         }
      }
   }
   ```

   The first route step handles the admin section and all URLs that specify a
   PHP script; the **direct** target doesn't set the **script** option
   to be used by default, so Unit looks for the respective **.php** file.

   The next step serves static files via a **share**. Its **fallback**
   enables rewrite mechanics for [search-friendly URLs](https://docs.joomla.org/Enabling_Search_Engine_Friendly_(SEF)_URLs). All
   requests go to the **index** target that runs the **index.php**
   script at Joomla's directory root.

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, Joomla should be available on the listener’s IP
   and port to finish the [setup](https://docs.joomla.org/J3.x:Installing_Joomla#Main_Configuration):

   ![Joomla on Unit - Setup Screen](/unit/images/joomla.png)

