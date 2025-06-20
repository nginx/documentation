---
title: Bugzilla
weight: 200
toc: true
---

To run the [Bugzilla](https://www.bugzilla.org) bug tracking system using
Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Perl language module.


2. Install and configure Bugzilla's [prerequisites](https://bugzilla.readthedocs.io/en/latest/installing/linux.html#install-packages).

3. Install Bugzilla`s [core files](https://bugzilla.readthedocs.io/en/latest/installing/linux.html#bugzilla).
   Here we install them at **/path/to/app**; use a real path in your configuration.

   {{< note >}}
   Unit uses [PSGI](https://metacpan.org/pod/PSGI) to run Perl
   applications; Bugzilla natively supports PSGI since version 5.1.
   {{< /note >}}

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}


5. Next,
   [prepare]({{{< relref "/unit/configuration.md#configuration-perl" >}}})
   the Bugzilla configuration for Unit. The default **.htaccess** scheme roughly
   translates into the following (use real values for **share**, **script**,
   and **working_directory**):

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
                  "source": "192.20.225.0/24",
                  "_comment_source": "Well-known IP range",
                  "uri": "/data/webdot/*.dot"
               },
               "_comment_match": "Restricts access to .dot files to the public webdot server at research.att.com",

               "action": {
                  "share": "/path/to/app$uri",
                  "_comment_share": "Serves static files that match the conditions above"
               }
         },
         {
               "action": {
                  "share": "/path/to/app$uri",
                  "_comment_share": "Unconditionally serves remaining requests that target static files",
                  "types": [
                     "text/css",
                     "image/*",
                     "application/javascript"
                  ],
                  "_comment_types": "Enables sharing only for certain file types",
                  "fallback": {
                     "pass": "applications/bugzilla"
                  },
                  "_comment_fallback": "Serves any requests not served with the 'share' immediately above"
               }
         }
      ],

      "applications": {
         "bugzilla": {
               "type": "perl",
               "working_directory": "/path/to/app/",
               "_comment_working_directory": "Path to the application directory; use a real path in your configuration",
               "script": "/path/to/app/app.psgi",
               "_comment_script": "Path to the application directory; use a real path in your configuration"
         }
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, browse to <http://localhost> and [set up](https://bugzilla.readthedocs.io/en/latest/installing/essential-post-install-config.html)
   your Bugzilla installation:

   ![Bugzilla on Unit - Setup Screen](/unit/images/bugzilla.png)
