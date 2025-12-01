---
title: Edit WAF configuration
description: Apply F5 WAF for NGINX directives in your NGINX configuration files.
toc: true
weight: 200
nd-content-type: how-to
nd-product: NIMNGR
nd-docs:
---

After you’ve added a WAF configuration to your instances, edit your NGINX configuration files to apply the required F5 WAF for NGINX directives. This step ensures that protection is enabled and that your configuration references the correct policy and log profile bundles. You can complete this task using the **F5 NGINX Instance Manager** web interface or REST API.

## Example configuration

Add the F5 WAF for NGINX directives in the appropriate context (`http`, `server`, or `location`). The following example shows a typical configuration:

```nginx
server {
  ...

  location / {
    # Enable F5 WAF for NGINX
    app_protect_enable on;

    # Reference a custom security policy bundle
    app_protect_policy_file /etc/nms/ignore-xss.tgz;

    # Enable security logging
    app_protect_security_log_enable on;

    # Reference the log profile bundle
    app_protect_security_log /etc/nms/log-default.tgz /var/log/nginx/security-violations.log;

    ...
  }
}
```

If you’re using **NGINX Instance Manager** with Security Monitoring, your configuration may already include the following directive:

```nginx
app_protect_security_log "/etc/nms/secops_dashboard.tgz" syslog:server=127.0.0.1:514;
```

**Don’t change this value.** For details, see the [Security Monitoring setup guide]({{< ref "/nim/security-monitoring/set-up-app-protect-instances.md" >}}).

If you’re running **F5 WAF for NGINX Docker Compose**, note the following:

- Add the `app_protect_enforcer_address` directive to the `http` context:

    ```nginx
    app_protect_enforcer_address 127.0.0.1:50000;
    ```

- JSON policies and log profiles aren’t supported. You must precompile and publish them using **NGINX Instance Manager**. Make sure the `precompiled_publication` setting in the NGINX Agent configuration is set to `true`.  
  See the [F5 WAF for NGINX configuration guide]({{< ref "/waf/configure/" >}}) for details.

## Use the web interface or API

{{<tabs name="add_security">}}
{{%tab name="Web interface"%}}

1. {{< include "nim/webui-nim-login.md" >}}
2. In the left menu, select **Instances** or **Instance Groups**.
3. From the **Actions** menu (**…**), select **Edit Config** for the instance or group.
4. If you’re using precompiled publication, change any `.json` file extensions to `.tgz`.
5. To apply a default policy, select **Apply Security**, then copy the policy snippet and paste it into your configuration.
6. Add the directives inside an `http`, `server`, or `location` block.
7. Select **Publish** to push the configuration.

{{%/tab%}}

## Use the API

{{%tab name="API"%}}

{{< call-out "note" >}}{{< include "nim/how-to-access-nim-api.md" >}}{{< /call-out>}}

You can use the **NGINX Instance Manager** REST API to deploy your F5 WAF for NGINX configuration.

{{<bootstrap-table "table">}}

| Method | Endpoint |
|--------|-----------|
| GET | `/api/platform/v1/systems/{systemUID}/instances` |
| POST | `/api/platform/v1/security/{systemUID}/instances/{nginxUID}/config` |

{{</bootstrap-table>}}

{{< call-out "important" "Important:" >}}Before deploying a configuration to an instance group, make sure all instances in the group run the same version of F5 WAF for NGINX. Otherwise, deployment may fail.{{< /call-out >}}

1. Send a `GET` request to list all instances. The response includes the unique identifier (UID) of the instance you want to update.

    ```shell
    curl -X GET https://{{NIM_FQDN}}/api/platform/v1/systems/{systemUID}/instances \
     -H "Authorization: Bearer <access token>"
    ```

2. Add the F5 WAF for NGINX configuration to your NGINX config file (`nginx.conf` or another file in a valid `config_dirs` path):

    - At a minimum, add the following directive:

        ```nginx
        app_protect_enable on;
        ```

    - If precompiled publication is enabled, change any `.json` policy references to `.tgz`.
    - To apply a default policy, use:

        ```nginx
        app_protect_policy_file /etc/nms/NginxDefaultPolicy.tgz;
        ```

        or

        ```nginx
        app_protect_policy_file /etc/nms/NginxStrictPolicy.tgz;
        ```

    - Add the directives to an `http`, `server`, or `location` context.

3. Encode the updated NGINX configuration file using base64.

    ```shell
    base64 -i /etc/nginx/nginx.conf
    ```

4. Send a `POST` request to deploy the configuration. Replace `<base64-encoded-content>` with your encoded config.

    ```shell
    curl -X POST https://{{NIM_FQDN}}/api/platform/v1/security/{systemUID}/instances/{nginxUID}/config \
    -H "Authorization: Bearer <access token>" \
    --header "Content-Type: application/json" \
    -d '{
    "configFiles": {
      "rootDir": "/etc/nginx",
      "files": [
        {
          "name": "nginx.conf",
          "contents": "<base64-encoded-content>"
        }
      ]
    },
    "validateConfig": true
    }'
    ```

{{%/tab%}}
{{</tabs>}}

## Next steps

After publishing the configuration, [verify the WAF configuration]({{< ref "verify-configuration.md" >}}) to confirm that protection is active on your instances.
