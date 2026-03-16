---
# We use sentence case and present imperative tone
title: "Configure log profiles"
# Weights are assigned in increments of 100: determines sorting order
weight: 650
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NONECO
---

This document describes how to configure log profiles for F5 WAF for NGINX security logs in F5 NGINX One Console. Security logs contain information about HTTP requests and responses, how F5 WAF for NGINX processes them, and the final decision made based on your configured policy. Log profiles define which information is captured, the format of log messages, the destination for logs, and the filtering criteria for security events.

## Overview

In NGINX One Console, you configure **Log Profiles** to control security logging for F5 WAF for NGINX. Security logs (also called Request logs or Traffic logs) provide visibility into what F5 WAF for NGINX detects and how it processes traffic according to your policies. F5 WAF for NGINX uses its own logging mechanism rather than NGINX's default access logging.

With Log Profiles, you control:

- **Filtering**: Which requests are logged (all requests, requests with violations, or blocked requests only)
- **Format**: How log messages are structured (default, custom, Splunk, ArcSight, or BIG-IQ formats)
- **Destination**: Where logs are sent (file or syslog server)
- **Content**: What information is included in each log message (request details, violations, attack signatures, and more)
- **Size limits**: Maximum sizes for log messages and request data


For detailed information about security logging capabilities and available log attributes, see [Security Logs]({{< ref "/waf/logging/security-logs.md" >}}) and [Security logs examples]({{< ref "/waf/logging/security-logs.md#examples" >}}).

## Add a log profile

From NGINX One Console, select **WAF** > **Log Profiles**. In the screen that appears, select **Add Log Profile**. This action opens a screen where you can:

- In **General Settings**, name and describe the log profile
- Configure the filter settings to determine which requests are logged
- Set the content format and options for how log messages are structured

After you finish configuring all the settings, select **Add Profile** to save your log profile.

## Configure filter settings

The **Request Type** filter determines which requests are logged based on what F5 WAF for NGINX detects:

- **All**: Logs all requests, both legal and illegal
- **Illegal**: Logs requests with violations (alerted or blocked)
- **Blocked**: Logs requests with violations that were blocked

Select the filter option that matches your monitoring and compliance needs. For production environments, you might start with **Blocked** to reduce log volume, then expand to **Illegal** or **All** as needed for troubleshooting.

## Configure content settings

The content section specifies the format and structure of log messages.

### Format options

Select one of the following log formats:

- **Default**: Default format for F5 WAF for NGINX with comma-separated key-value pairs
- **GRPC**: Variant of the default format suited for gRPC traffic
- **User-defined**: Custom format that you define using a format string with placeholders
- **Splunk**: Formatted for Splunk SIEM with F5 plugin
- **ArcSight**: Formatted according to ArcSight Common Event Format (CEF) with custom fields adapted for F5
- **BIG-IQ**: Formatted for BIG-IQ, the F5 centralized management platform for BIG-IP

### Size limits

Configure size restrictions for log messages:

- **Max request size**: Limit in bytes for the `request` and `request_body_base64` fields (range: 1-10240 bytes, default: 2000 bytes). You can also set this to `any`, which is synonymous with 10240 bytes.
- **Max message size**: Total size limit in KB for the entire log message (range: 1k-64k, default: 2k). Must not be smaller than `max_request_size`.

### Custom formatting

If you select **User-defined** format, you can create a custom format string using placeholders for log attributes. For example:

```
Request ID %support_id%: %method% %uri% received on %date_time% from IP %ip_client% had the following violations: %violations%
```

Each attribute name is delimited by percent signs (for example, `%violation_rating%`). Available placeholders include attributes like `%ip_client%`, `%request%`, `%violations%`, `%attack_type%`, and many others. See the [Available security log attributes]({{< ref "/waf/logging/security-logs.md#available-security-log-attributes" >}}).

### Advanced options

You can configure additional formatting options for how list values appear in your logs:

- **List delimiter**: Character or string that separates list elements (default: comma)
- **List prefix**: Character or string that starts a list (default: none)
- **List suffix**: Character or string that ends a list (default: none)
- **Escaping characters**: Replace specific characters in log values with alternative characters. Configure the `from` character to be replaced and the `to` result character.

For detailed information about the JSON structure of security log configuration files (used in the Log Profile JSON section), see [Security log configuration file]({{< ref "/waf/logging/security-logs.md#security-log-configuration-file" >}}).

## Compile the log profile

Before deploying a log profile, you can optionally compile the JSON configuration file into a bundle. If you don't compile manually, the deployment process will automatically compile the log profile.

The compiled bundle is in compressed tar format (.tgz) and contains all the necessary configuration to enable security logging on your NGINX instances.

### Manage bundles for different compiler versions

From the Log Profiles list, you can manage compiled bundles for your log profiles:

1. Go to **WAF** > **Log Profiles**. You'll see a list of all log profiles.
2. In the **Actions** column for a log profile, you can:
   - **Edit**: Open the log profile configuration editor to reconfigure settings
   - **Make a Copy**: Create a new log profile by copying the JSON content
   - **Deploy**: Deploy the log profile to instances or Config Sync Groups
   - **Download JSON**: Download the log profile JSON configuration
   - **Manage Bundles**: View and manage compiled bundles for different WAF compiler versions
   - **Delete**: Remove the log profile

When you select **Manage Bundles**, you'll see all supported WAF compiler versions. For each version, you can see whether the log profile is compiled for that version. You can:

- **Compile**: Compile the log profile into a bundle for a specific compiler version
- **Download**: Download an existing compiled bundle for a specific compiler version

This allows you to maintain compatibility with different versions of F5 WAF for NGINX across your infrastructure.

## Deploy the log profile

After saving a log profile, deploy it to your NGINX instances to enable logging of WAF security events. See [Deploy log profiles]({{< ref "/nginx-one-console/waf-integration/log-profiles/deploy-log-profiles.md" >}}) for detailed deployment steps.

The deployment process configures the required NGINX directives (`app_protect_security_log_enable` and `app_protect_security_log`) and ensures the log profile bundle is accessible to your instances. For detailed information about these directives and their configuration options, see [Security log directives]({{< ref "/waf/logging/security-logs.md#directives-in-nginxconf" >}}).

For container-specific setup requirements, see the [Log profiles]({{< ref "/nginx-one-console/waf-integration/overview.md#log-profiles" >}}) configuration section in the overview.

## Review and manage log profiles

From NGINX One Console, you can review the log profiles you've saved. For detailed information about reviewing and managing log profiles, see [Review log profiles]({{< ref "/nginx-one-console/waf-integration/log-profiles/review-log-profiles.md" >}}).
