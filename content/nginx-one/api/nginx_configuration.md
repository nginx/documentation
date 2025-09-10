---
description: ''
nd-docs: DOCS-1063
title: Working with NGINX Configs
toc: true
weight: 10
type:
- how-to
---

In this guide, we'll show you how to use API requests to update NGINX Configs for Instances or Config Sync Groups in the F5 NGINX One Console.

## Getting ready

Before you begin, make sure you can properly authenticate your API requests with either an API Token or API Certificate, following the instructions in the [Authentication]({{<ref "/nginx-one/api/authentication.md" >}}) guide. Ensure you have registered or created your NGINX Instance, Config Sync Group, or Staged Config in the F5 NGINX One Console, follow the instructions in the [Manage your NGINX instances]({{<ref "/nginx-one/nginx-configs/" >}}) guide.

{{< call-out "note" >}}
The workflows for managing NGINX Configs for Instances, Config Sync Groups, and Staged Configs in the F5 NGINX One Console are quite similar. This guide focuses on the steps for updating NGINX Configs for Instances. If you're working with Config Sync Groups, you'll follow a similar process but will need to update the API endpoints appropriately.
{{< /call-out>}}

## Getting the current NGINX Config

You can retrieve the current NGINX Config for an Instance, Config Sync Group, or Staged Config using a `GET` request. This is useful for making updates based on the existing configuration.

Use the following curl command to retrieve the current NGINX Config for a specific Instance. Replace `<tenant>`, `<namespace>`, `<instance-object-id>`, and `<token-value>` with your actual values.

   ```shell
   curl -X GET "https://<tenant>.console.ves.volterra.io/api/nginx/one/namespaces/<namespace>/instances/<instance-object-id>/config" \
   -H "Authorization: APIToken <token-value>" -o current_config.json
   ```
   - `<tenant>`: Your tenant name for organization plans.
   - `<namespace>`: The namespace your Instance belongs to.
   - `<instance-object-id>`: The object_id of the NGINX Instance you want to retrieve the NGINX Config for.
   - `<token-value>`: Your API Token.

{{< call-out "note" >}}
To update the NGINX Config for a Config Sync Group or Staged Config, replace `instances` with `config-sync-groups` or `staged-configs` and use the object_id of the Config Sync Group or Staged Config in the URL.
{{< /call-out>}}

 The response will include the current NGINX Config in JSON format. This response is saved to a file (e.g., `current_config.json`) for editing.

## Updating the NGINX Config

You can modify the NGINX Config using either `PUT` or `PATCH` requests. The `PUT` method replaces the entire NGINX Config, while the `PATCH` method allows you to update specific fields without affecting the rest of the configuration.

1. **Update the NGINX Config for an Instance using `PUT`**:

    When using the `PUT` method, ensure that your request body includes all necessary contents, as it will overwrite the existing configuration.
    The following example demonstrates how to update the NGINX Config for a specific Instance using `PUT`. Replace `<tenant>`, `<namespace>`, `<instance-object-id>`, and `<token-value>` with your actual values. The request body should contain the complete NGINX Config in JSON format.
    ```shell
    curl -X PUT "https://<tenant>.console.ves.volterra.io/api/nginx/one/namespaces/<namespace>/instances/<instance-object-id>/config" \
    -H "Authorization : APIToken <token-value>" \
    -H "Content-Type: application/json" \
    -d @updated_config.json
    ```
    - `<tenant>`: Your tenant name for organization plans.
    - `<namespace>`: The namespace your Instance belongs to.
    - `<instance-object-id>`: The object_id of the NGINX Instance you want to update the NGINX Config for.
    - `<token-value>`: Your API Token.
   
2. **Update the NGINX Config for an Instance using `PATCH`**:

    When using the `PATCH` method, you only need to include the files you want to update in your request body.
    The following example demonstrates how to update the NGINX Config for a specific Instance using `PATCH`. Replace `<tenant>`, `<namespace>`, `<instance-object-id>`, and `<token-value>` with your actual values. The request body should contain only the fields you want to update in JSON format.
    ```shell
    curl -X PATCH "https://<tenant>.console.ves.volterra.io/api/nginx/one/namespaces/<namespace>/instances/<instance-object-id>/config" \
    -H "Authorization : APIToken <token-value>" \
    -H "Content-Type: application/json" \
    -d @partial_update_config.json
    ```
    - `<tenant>`: Your tenant name for organization plans.
    - `<namespace>`: The namespace your Instance belongs to.
    - `<instance-object-id>`: The object_id of the NGINX Instance you want to update the NGINX Config for.
    - `<token-value>`: Your API Token.

    With `PATCH`, you can update specific parts of the NGINX Config without needing to resend the entire configuration. The following file `contents` disposition is observed:
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
   {{< call-out "note" >}}
   To encode files in base64, you can use the following command in a Unix-like terminal:
   ```shell
   base64 /path/to/your/file
   ```
   Replace `/path/to/your/file` with the actual path to the file you want to encode.
   {{< /call-out>}}
   To remove a file, simply omit the `contents` field for that file in your `PATCH` request body, your `partial_update_config.json` might look like this to remove `/etc/nginx/conf.d/default.conf` from the NGINX Config:
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
   Multiple updates can be made in a single `PATCH` request. For example, to update `/etc/nginx/nginx.conf` and remove `/etc/nginx/conf.d/default.conf`, your `partial_update_config.json` might look like this:
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