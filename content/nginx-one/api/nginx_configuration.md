---
description: ''
nd-docs: DOCS-000
title: Manage NGINX configurations with API requests
toc: true
weight: 100
type:
- how-to
---

In this guide, we'll show you how to use API requests to update NGINX Configurations for Instances, Config Sync Groups, or Staged Configs in the F5 NGINX One Console.

## Before you begin

Before you begin, make sure you can properly authenticate your API requests with either an API Token or API Certificate, following the instructions in the [Authentication]({{<ref "/nginx-one/api/authentication.md" >}}) guide. To ensure you have registered or created your NGINX Instance, Config Sync Group, or Staged Config in the F5 NGINX One Console, follow the instructions in the [Manage your NGINX instances]({{<ref "/nginx-one/nginx-configs/" >}}) guide.

{{< call-out "note" >}}
The workflows for managing NGINX Configs for Instances, Config Sync Groups, and Staged Configs in the F5 NGINX One Console are quite similar. This guide focuses on the steps for updating NGINX Configs for Instances. If you're working with Config Sync Groups, you'll follow a similar process but will need to update the API endpoints appropriately.
{{< /call-out>}}

## Get the current NGINX configuration

You can retrieve the current NGINX configuration for an Instance, Config Sync Group, or Staged Config using a `GET` request. This is useful for making updates based on the existing configuration.

Use the following `curl` command to retrieve the current NGINX configuration for a specific Instance. Replace `<tenant>`, `<namespace>`, `<instance-object-id>`, and `<token-value>` with your actual values.

   ```shell
   curl -X GET "https://<tenant>.console.ves.volterra.io/api/nginx/one/namespaces/<namespace>/instances/<instance-object-id>/config" \
   -H "Authorization: APIToken <token-value>" -o current_config.json
   ```

   - `<tenant>`: Your tenant name for organization plans.
   - `<namespace>`: The namespace your Instance belongs to.
   - `<instance-object-id>`: The object_id of the NGINX Instance you want to retrieve the NGINX configuration for.
   - `<token-value>`: Your API Token.

{{< call-out "note" >}}
To update the NGINX configuration for a Config Sync Group or Staged Config, replace `instances` with `config-sync-groups` or `staged-configs` and use the object_id of the Config Sync Group or Staged Config in the URL.
{{< /call-out>}}

 The response will include the current NGINX configuration in JSON format. This response is saved to a file (with a name like `current_config.json`) for editing.

You can modify the NGINX configuration using either `PUT` or `PATCH` requests. The `PUT` method replaces the entire NGINX configuration, while the `PATCH` method allows you to update specific fields without affecting the rest of the configuration.

## How to base64 encode a file for JSON request

When updating the NGINX Config, file `contents` must be base64 encoded. You can use the following command to base64 encode a file:

```shell
base64 -w 0 -i <path-to-your-file>
```

This command reads the file at `<path-to-your-file>` and outputs its base64 encoded content in a single line (due to the `-w 0` option). You can then copy this encoded string and include it in your JSON request body. On some systems the `-w` option may not be available, in which case you can use:

```shell
base64 -i <path-to-your-file> | tr -d '\n'
``` 

## Update the NGINX configuration for an Instance using `PUT`

When using the `PUT` method, ensure that your request body includes all necessary contents, as it will overwrite the existing configuration.
The following example demonstrates how to update the NGINX configuration for a specific Instance using `PUT`. Replace `<tenant>`, `<namespace>`, `<instance-object-id>`, and `<token-value>` with your actual values. The request body should contain the complete NGINX configuration in JSON format.

   ```shell
   curl -X PUT "https://<tenant>.console.ves.volterra.io/api/nginx/one/namespaces/<namespace>/instances/<instance-object-id>/config" \
   -H "Authorization : APIToken <token-value>" \
   -H "Content-Type: application/json" \
   -d @updated_config.json
   ```
 
   - `<tenant>`: Your tenant name for organization plans.
   - `<namespace>`: The namespace your Instance belongs to.
   - `<instance-object-id>`: The object_id of the NGINX Instance you want to update the NGINX configuration for.
   - `<token-value>`: Your API Token.

## Update the NGINX configuration for an Instance using `PATCH`

When using the `PATCH` method, you only need to include the files you want to update in your request body.
The following example demonstrates how to update the NGINX configuration for a specific Instance using `PATCH`. Replace `<tenant>`, `<namespace>`, `<instance-object-id>`, and `<token-value>` with your actual values. The request body should contain only the fields you want to update in JSON format.
   ```shell
    curl -X PATCH "https://<tenant>.console.ves.volterra.io/api/nginx/one/namespaces/<namespace>/instances/<instance-object-id>/config" \
    -H "Authorization : APIToken <token-value>" \
    -H "Content-Type: application/json" \
    -d @partial_update_config.json
   ```

   - `<tenant>`: Your tenant name for organization plans.
   - `<namespace>`: The namespace your Instance belongs to.
   - `<instance-object-id>`: The object_id of the NGINX Instance you want to update the NGINX configuration for.
   - `<token-value>`: Your API Token.

With `PATCH`, you can update specific parts of the NGINX Instance configuration without needing to resend the entire configuration. The following file `contents` disposition is observed:
   - Leave out file `contents` to remove the file from the NGINX Config.
   - Include file `contents` to add or update the file in the NGINX Config. File `contents` must be base64 encoded. File `contents` can be an empty string to create an empty file.
   - `config_version` should be included to ensure you're updating the correct version of the configuration. You can get the current `config_version` from the response of the `GET` request.

For example, to update only the `/etc/nginx/nginx.conf` file in the NGINX Config, your `partial_update_config.json` might look like this:
   ```json
    {
        "conf_path": "/etc/nginx/nginx.conf",
        "config_version": "<config_version from GET response>",
        "configs": [
            {
                "name": "/etc/nginx",
                "files": [
                    {
                        "name": "nginx.conf",
                        "contents": "<base64-encoded-content-here>"
                    }
                ]
            }
        ]
    }
   ```

To remove a file, omit the `contents` field for that file in your `PATCH` request body, your `partial_update_config.json` might look like this to remove `/etc/nginx/conf.d/default.conf` from the NGINX Instance configuration:
   ```json
    {
        "conf_path": "/etc/nginx/nginx.conf",
        "config_version": "<config_version from GET response>",
        "configs": [
            {
                "name": "/etc/nginx/conf.d",
                "files": [
                    {
                        "name": "default.conf"
                    }
                ]
            }
        ]
    }
   ```

## Set up multiple updates with `PATCH`

You can make multiple updates can be made in a single `PATCH` request. For example, to update `/etc/nginx/nginx.conf` and remove `/etc/nginx/conf.d/default.conf`, your `partial_update_config.json` might look like this:
   ```json
    {
        "conf_path": "/etc/nginx/nginx.conf",
        "config_version": "<config_version from GET response>",
        "configs": [
            {
                "name": "/etc/nginx/conf.d",
                "files": [
                    {
                        "name": "default.conf"
                    }
                ]
            },
            {
                "name": "/etc/nginx",
                "files": [
                    {
                        "name": "nginx.conf",
                        "contents": "<base64-encoded-content-here>"
                    }
                ]
            }
        ]
    }
   ```