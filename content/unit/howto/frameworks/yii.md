---
title: Yii
weight: 2000
toc: true
---


To run apps based on the [Yii](https://www.yiiframework.com) framework
versions 1.1 or 2.0 using Unit:

{{< tabs name="version" >}}
{{% tab name="Yii 2.0" %}}

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.


2. Next, [install](https://www.yiiframework.com/doc/guide/2.0/en/start-installation)
   Yii and create or deploy your app.

   Here, we use Yii's [basic project template](https://www.yiiframework.com/doc/guide/2.0/en/start-installation#installing-from-composer)
   and Composer:

   ```console
   $ cd /path/to/ # Partial path to the application directory; use a real path in your configuration
   ```

   ```console
   $ composer create-project --prefer-dist yiisoft/yii2-app-basic app # Arbitrary app name
   ```

   This creates the app's directory tree at **/path/to/app/**.
   Its **web/** subdirectory contains both the root
   **index.php** and the static files; if your app requires
   additional **.php** scripts, also store them here.

3. Change ownership:
   {{< include "unit/howto_change_ownership.md" >}}

4. Next,
   [prepare]({{< relref "/unit/configuration.md#configuration-php" >}})
   the Yii configuration for Unit (use real values for **share** and **root**):

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
               "!/assets/*",
               "*.php",
               "*.php/*"
            ],
            "uri_comment": "This path stores application data that shouldn't be run as code"
            },
            "action": {
            "pass": "applications/yii/direct"
            }
         },
         {
            "action": {
            "share": "/path/to/app/web$uri",
            "share_comment": "Serves static files",
            "fallback": {
               "pass": "applications/yii/index"
            }
            }
         }
      ],
      "applications": {
         "yii": {
            "type": "php",
            "targets": {
            "direct": {
               "root": "/path/to/app/web/",
               "root_comment": "Path to the application directory; use a real path in your configuration"
            },
            "index": {
               "root": "/path/to/app/web/",
               "root_comment": "Path to the application directory; use a real path in your configuration",
               "script": "index.php",
               "script_comment": "All requests are handled by a single script"
            }
            }
         }
      }
   }
   ```

   For a detailed discussion, see [Configuring Web Servers](https://www.yiiframework.com/doc/guide/2.0/en/start-installation#configuring-web-servers)
   and [Running Applications](https://www.yiiframework.com/doc/guide/2.0/en/start-workflow) in Yii 2.0 docs.

{{< note >}}
   The difference between the **pass** targets is their usage of
   the **script**
   [setting]({{< relref "/unit/configuration.md#configuration-php" >}}):

   - The **direct** target runs the **.php** script from the
   URI or **index.php** if the URI omits it.

   - The **index** target specifies the **script** that Unit
   runs for *any* URIs the target receives.
{{< /note >}}


5. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the
   listener’s IP address and port:

   ![Yii Basic Template App on Unit](/unit/images/yii2.png)

{{% /tab %}}
{{% tab name="Yii 1.1" %}}

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a PHP language module.

2. Next, [install](https://www.yiiframework.com/doc/guide/1.1/en/quickstart.installation)
Yii and create or deploy your app.

   Here, we use Yii's [basic project template](https://www.yiiframework.com/doc/guide/1.1/en/quickstart.first-app)
   and `yiic`:

   ```console
   $ git clone git@github.com:yiisoft/yii.git /path/to/yii1.1/ # Arbitrary framework path
   ```

   ```code-block:: console
   $ /path/to/yii1.1/ framework/yiic webapp /path/to/app/ #Path to the application directory; use a real path in your configuration
   ```

   This creates the app's directory tree at **/path/to/app/**.

3. Next,
   [prepare]({{< relref "/unit/configuration.md#configuration-php" >}})
   the Yii configuration for Unit (use real values for **share** and **root**):

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
            "!/assets/*",
            "!/protected/*",
            "!/themes/*",
            "*.php",
            "*.php/*"
         ],
         "uri_comment": "This path stores application data that shouldn't be run as code"
         },
         "action": {
         "pass": "applications/yii/direct"
         }
      },
      {
         "action": {
         "share": "/path/to/app$uri",
         "share_comment": "Serves static files",
         "fallback": {
            "pass": "applications/yii/index"
         }
         }
      }
   ],
   "applications": {
      "yii": {
         "type": "php",
         "targets": {
         "direct": {
            "root": "/path/to/app/",
            "root_comment": "Path to the application directory; use a real path in your configuration"
         },
         "index": {
            "root": "/path/to/app/",
            "root_comment": "Path to the application directory; use a real path in your configuration",
            "script": "index.php",
            "script_comment": "All requests are handled by a single script"
         }
         }
      }
   }
   }
   ```

   For a detailed discussion, see Yii 1.1 [docs](https://www.yiiframework.com/doc/guide/1.1/en/quickstart.first-app).

{{< note >}}
The difference between the **pass** targets is their usage of
the **script**
[setting]({{< relref "/unit/configuration.md#configuration-php" >}}):

- The **direct** target runs the **.php** script from the
   URI or **index.php** if the URI omits it.

- The **index** target specifies the **script** that Unit
   runs for *any* URIs the target receives.
{{< /note >}}

4. Upload the updated configuration.

      {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the
   listener’s IP address and port:

   ![Yii Basic Template App on Unit](/unit/images/yii1.1.png)

{{% /tab %}}
{{< /tabs >}}
