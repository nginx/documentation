---
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: NIMNGR
title: Configure and deploy log profiles
description: "Configure F5 WAF for NGINX security log profiles in F5 NGINX Instance Manager, controlling request filtering, log format, size limits, and deployment to NGINX instances."
weight: 100
toc: true
f5-keywords: "log profiles, WAF, NGINX Instance Manager, NIM, security logs, app protect, request logs, traffic logs, Splunk, ArcSight, syslog"
f5-summary: >
  Configure log profiles for F5 WAF for NGINX security logs in F5 NGINX Instance Manager.
  Log profiles define which HTTP requests are captured, how log messages are formatted, where logs are sent, and what security event details are included.
  Log profiles must be compiled into a bundle before deployment to NGINX instances.
f5-audience: operator
---

## Overview

Use this guide to configure log profiles for F5 WAF for NGINX security logs in F5 NGINX Instance Manager. Security logs (also called Request logs or Traffic logs) provide visibility into what F5 WAF for NGINX detects and how F5 WAF for NGINX processes traffic according to your policies. F5 WAF for NGINX uses its own logging mechanism rather than NGINX's default access logging.

With log profiles, you control:

- **Filtering**: Which requests are logged (all requests, requests with violations, or blocked requests only)
- **Format**: How log messages are structured (default, custom, Splunk, ArcSight, or BIG-IQ formats)
- **Destination**: Where logs are sent (file or syslog server)
- **Content**: What information is included in each log message (request details, violations, attack signatures, and more)
- **Size limits**: Maximum sizes for log messages and request data

For detailed information about security logging capabilities and available log attributes, see [Security Logs]({{< ref "/waf/logging/security-logs.md" >}}) and [Security logs examples]({{< ref "/waf/logging/security-logs.md#examples" >}}).

---

## Before you begin

Before you begin, make sure you have:

- **NGINX Instance Manager access**: An account with sufficient permissions to create and manage WAF log profiles. See [Manage roles and permissions]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}).
- **F5 WAF for NGINX license**: A valid license with WAF capabilities for your NGINX Instance Manager deployment.
- **NGINX instances**: One or more NGINX instances registered in NGINX Instance Manager. You'll deploy the log profile to these.

---

## Add a log profile

1. In NGINX Instance Manager, select **WAF** > **Log Profiles**.
1. Select **Add Log Profile**.
   The log profile configuration screen opens.
1. In **General Settings**, enter a name and optional description for the log profile.

Next, configure the filter settings to determine which requests are logged.

### Configure filter settings

The **Request Type** filter determines which requests are logged based on what F5 WAF detects:

- **All**: Logs all requests, both legal and illegal.
- **Illegal**: Logs requests with violations (alerted or blocked).
- **Blocked**: Logs requests with violations that were blocked.

Select the filter option that matches your monitoring and compliance needs. For production environments, start with **Blocked** to reduce log volume, then expand to **Illegal** or **All** as needed for troubleshooting.

Next, configure the content format and options for how log messages are structured.

### Configure content settings

The content section specifies the format and structure of log messages.

#### Select a format

Select one of the following log formats:

- **Default**: Default format for F5 WAF with comma-separated key-value pairs.
- **GRPC**: Variant of the default format suited for gRPC traffic.
- **User-defined**: Custom format that you define using a format string with placeholders.
- **Splunk**: Formatted for Splunk SIEM with F5 plugin.
- **ArcSight**: Formatted according to ArcSight Common Event Format (CEF) with custom fields adapted for F5.
- **BIG-IQ**: Formatted for BIG-IQ, the F5 centralized management platform for BIG-IP.

#### Set size limits

Configure size restrictions for log messages:

- **Max request size**: Limit in bytes for the `request` and `request_body_base64` fields. The accepted range is 1–10240 bytes, with a default of 2000 bytes. You can also set this to `any`, which is equivalent to 10240 bytes.
- **Max message size**: Total size limit in KB for the entire log message. The accepted range is 1k–64k, with a default of 2k. This value must not be smaller than `max_request_size`.

#### (Optional) Create a custom format string

If you select **User-defined** format, create a custom format string using placeholders for log attributes. Each attribute name is delimited by percent signs. For example:

``` text
Request ID %support_id%: %method% %uri% received on %date_time% from IP %ip_client% had the following violations: %violations%
```

Available placeholders include attributes such as `%ip_client%`, `%request%`, `%violations%`, `%attack_type%`, and others. See [Available security log attributes]({{< ref "/waf/logging/security-logs.md#available-security-log-attributes" >}}).

#### (Optional) Configure advanced formatting options

Configure additional options for how list values appear in your logs:

- **List delimiter**: Character or string that separates list elements (default: comma).
- **List prefix**: Character or string that starts a list (default: none).
- **List suffix**: Character or string that ends a list (default: none).
- **Escaping characters**: Replace specific characters in log values with alternative characters. Configure the `from` character to be replaced and the `to` result character.

For detailed information about the JSON structure of security log configuration files, see [Security log configuration file]({{< ref "/waf/logging/security-logs.md#security-log-configuration-file" >}}).

---

Finally, select **Add Profile** to save the log profile. Next, you can optionally compile the log profile into a bundle before deploying it to your NGINX instances.

## Compile the log profile

Before deploying a log profile, you can optionally compile the JSON configuration file into a bundle. If you do not compile manually, the deployment process automatically compiles the log profile.

The compiled bundle is in compressed tar format (.tgz) and contains all the necessary configuration to enable security logging on your NGINX instances.

### Manage bundles for different compiler versions

1. Go to **WAF** > **Log Profiles**.

   A list of all log profiles appears.

2. In the **Actions** column for a log profile, select one of the following:

   - **Edit**: Open the log profile configuration editor to reconfigure settings.
   - **Make a Copy**: Create a new log profile by copying the JSON content.
   - **Export as JSON**: Download the log profile JSON configuration.
   - **Manage Bundles**: View and manage compiled bundles for different WAF compiler versions.
   - **Delete**: Remove the log profile.

3. Select **Manage Bundles** to view all supported WAF compiler versions.

   For each version, you can see whether the log profile is compiled for that version.

4. For a specific compiler version, select one of the following:

   - **Compile**: Compile the log profile into a bundle for that compiler version.
   - **Download**: Download an existing compiled bundle for that compiler version.

Use this to maintain compatibility with different versions of F5 WAF across your infrastructure.

---

## Deploy the log profile

After saving a log profile, deploy it to your NGINX instances to enable logging of WAF security events. See [Deploy log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/deploy-log-profile/" >}}) for detailed deployment steps.

The deployment process configures the required NGINX directives (`app_protect_security_log_enable` and `app_protect_security_log`) and ensures the log profile bundle is accessible to your instances. For detailed information about these directives and their configuration options, see [Security log directives]({{< ref "/waf/logging/security-logs.md#directives-in-nginxconf" >}}).

For container-specific setup requirements, see the [Log profiles]({{< ref "/nim/waf-integration/overview.md#log-profiles" >}}) configuration section in the overview.

---

## Review and manage log profiles

From NGINX Instance Manager, you can review the log profiles you've saved. For detailed information about reviewing and managing log profiles, see [Update log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/update-log-profile.md" >}}).

---

## References

For more information, see:

- [Deploy log profiles]({{< ref "/nginx-one-console/waf-integration/log-profiles/deploy-log-profiles.md" >}})
- [Update log profiles]({{< ref "/nim/waf-integration/policies-and-logs/log-profiles/update-log-profile.md" >}})
- [Security Logs]({{< ref "/waf/logging/security-logs.md" >}})
- [Security log configuration file]({{< ref "/waf/logging/security-logs.md#security-log-configuration-file" >}})
- [Available security log attributes]({{< ref "/waf/logging/security-logs.md#available-security-log-attributes" >}})
- [Security log directives]({{< ref "/waf/logging/security-logs.md#directives-in-nginxconf" >}})
- [Log profiles overview]({{< ref "/nim/waf-integration/overview.md#log-profiles" >}})