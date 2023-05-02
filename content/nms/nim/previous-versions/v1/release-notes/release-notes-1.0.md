---
title: "Release Notes 1.0"
date: 2021-06-28T10:46:11-07:00
draft: false
toc: true
description: "Release information for NGINX Instance Manager, v1.0. Lists of new features and known issues are provided."
weight: 500
categories: ["support", "known issues", "release notes"]
versions: ["v1"]
docs: "DOCS-641"
aliases:
    - /v1/releases/release-notes-1.0.0/
    - /v1/releases/release-notes-1.0.1/
    - /v1/releases/release-notes-1.0.2/
    - /v1/releases/release-notes-1.0.3/
    - /v1/releases/release-notes-1.0.4/
    - /releases/release-notes-1.0.0/
    - /releases/release-notes-1.0.1/
    - /releases/release-notes-1.0.2/
    - /releases/release-notes-1.0.3/
    - /releases/release-notes-1.0.4/
---

## NGINX Instance Manager Version 1.0.4

<span id="104-updates"></a>

### Updates

NGINX Instance Manager 1.0.4 includes the following updates:

- Bug fixes and improvements

- **Plus Zone metrics for 4xx and 5xx counts.**:
  <br/><br/>
  NGINX Plus instances now collect 4xx and 5xx metrics by defined zones.

## NGINX Instance Manager Version 1.0.3

<span id="103-updates"></a>

### Updates

NGINX Instance Manager 1.0.3 includes the following updates:

<span id="103-resolved"></a>

### Resolved Issues

This release includes fixes for the following issues. You can search by the issue ID to locate the details for an issue.

- *UI can crash with RBAC enabled in some circumstances. (692)*
  <br/><br/>
  When enabling rbac, the server would crash if a username wasn’t supplied. The server now displays an appropriate error.

- *Support script fixed to include nginx-manager.log. (693)*
  <br/><br/>
  The support script now handles scenarios that would skip including the nginx-manager.log file.

## NGINX Instance Manager Version 1.0.2

<span id="102-updates"></a>

### Updates

NGINX Instance Manager 1.0.2 includes the following updates:

- Bug fixes and improvements

- **Export scan results as a CSV file.**:
  <br/><br/>
  Scan results can be exported to .csv format. Select the Export button and the download file prompt appears.

- **Add File and Upload File button is merged.**:
  <br/><br/>
  The Add File button and Upload File buttons had similar behavior and were confusing as two buttons. They are now grouped under a “plus sign” button and accessible there in the configuration editor.

- **Handle large IP fields in scan UI.**:
  <br/><br/>
  In the scan UI, IP addresses that were long would get cut off. The display field now accommodates large IP files and IPv6 addresses fully.

<span id="102-resolved"></a>

### Resolved Issues

This release includes fixes for the following issues. You can search by the issue ID to locate the details for an issue.

- *Scan not running on newer Linux versions (RHEL8). (615)*
  <br/><br/>
  Scan is now able to run on RHEL8 and Centos8 Linux distributions and leverages a native method. We replaced NMAP with a faster and more compatible method to scan that retains the same method to probe listeners.

- *Example files missing in nginx-manager installer. (674)*
  <br/><br/>
  Example files were missing from /usr/share/nginx-manager package installers.

- *Unable to delete an instance from certificate scan inventory. (680)*
  <br/><br/>
  When you run a certificate scan, you can now clear the results by using the Delete All button.

- *Delete disconnected instances with RBAC enabled. (684)*
  <br/><br/>
  Deleting a disconnected instance now works when using RBAC.

- *Reset button in UI doesn't add back includes that were removed. (688)*
  <br/><br/>
  When using the reset to current button in the editor, include files that were added but not published are added to the instance incorrectly. This is now resolved and any include files not present on disk will not be added but removed as expected. The button is now named ‘reset’ to indicate the function correctly.

- *Deleting an instance incorrectly prevented registration. (689)*
  <br/><br/>
  When you delete an instance but the agent is running, it would not re-register as expected. This is now fixed and agents that are running will register if they are new or deleted. To remove an instance, you must first stop the agent, then remove the instance.

## NGINX Instance Manager Version 1.0.1

These release notes provide general information and describe known issues for NGINX Instance Manager version 1.0.1, in the following categories:

<span id="101-updates"></a>

### Updates

NGINX Instance Manager 1.0.1 includes the following updates:

- Bug fixes and improvements

- **Read only users are notified about instance configuration read only access.**:
  <br/><br/>
  Read-only users now get notified about read only access when  reviewing instance configurations.

<span id="101-resolved"></a>

### Resolved Issues

This release includes fixes for the following issues. You can search by the issue ID to locate the details for an issue.

- *"Connections Handled" metric is not reported for NGINX Plus instances (565)*
  <br/><br/>
  When using NGINX Plus instances, the metric for `connections handled` is not reported, even when configuring the `stub_status`.
  <br/><br/>
  Workaround:
  <br/>
  Define both `plus_api` and `stub_status` on the `nginx-agent.conf` file for `connections handled` to show for NGINX Plus instances.<br/><br/>

- *Updated in-line documentation (651)*
  <br/><br/>
  In-line documentation referred to v0.9.2 in the v1.0.0 release. This has been updated to the correct version.
  <br/><br/>
  Workaround:
  <br/>
  Use the documentation from the public website until you update to v1.0.1<br/><br/>

- *Publish action fixed for cloning configurations (653)*
  <br/><br/>
  An error indicating that configurations have changed was preventing publishing cloned configurations. This has been resolved.

- *Regular and read-only users can't edit configurations. (656)*
  <br/><br/>
  Regular and read-only users were unable to view or edit configurations when RBAC was enabled. This is now fixed.

- *SELinux contexts updated. (662)*
  <br/><br/>
  SELinux contexts were missing the ability to open tmp files and interact with nginx contexts. This is now resolved.

- *"Display name" is required for roles (665)*
  <br/><br/>
  If the “Display name” for a role was left blank, the role wasn’t visible when creating or editing users. “Display name” is now a required field.

<span id="101-issues"></a>

### Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Instance Manager release notes.

- *nginx-agent can restart unexpectedly using grpc and SSL with NGINX proxy (664)*:
  <br/><br/>
  When using NGINX Plus as a proxy with SSL and grpcs, `nginx-agent` is unexpectedly restarting itself in some scenarios.
  Workaround:
  <br/><br/>
  If you are experiencing `nginx-agent` restarts in the set up described here, using the stream context for grpcs will resolve the issue.

## NGINX Instance Manager Version 1.0.0

These release notes provide general information and describe known issues for NGINX Instance Manager version 1.0.0, in the following categories:

<span id="100-updates"></a>

### Updates

NGINX Instance Manager 1.0.0 includes the following updates:

- Bug fixes and improvements

- **Scan for expired certificates**:
  <br/><br/>
  Now you can find expired certificates using a CIDR (subnet and mask). This works without an agent installed but will only grab the default certificate on the IP listening. You can use the API to limit the days or date the certificates will expire.

- **Push new certificates and keys through API**:
  <br/><br/>
  Now it’s possible to update certificates and keys using the API. Now you can push files that are referred to in the {{nginx.conf}} such as certificates and keys. Use the API to update or add new encryption when required.

- **Use tagging to group instances**:
  <br/><br/>
  Now you can add tags to group large numbers of instances together any way that makes sense for you. Tags can be applied to multiple instances and a single instance can contain multiple tags. Tags can then be used to control access to the instances, to push changes to the instances, and also to group metrics. You can add tags in the API, Web UI, or through the agent configuration file.

- **UI List Views Updated**:
  <br/><br/>
  NGINX Instance Manager now uses a datagrid format to handle large numbers of instances. We have simplified the layout, included icons, and improved the workflow of the UI.

<span id="100-issues"></a>

### Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Instance Manager release notes.

- *Quickstart Documentation generates incorrect certificates (648)*:
  <br/><br/>
  The quickstart guide gives certificate generation instructions but they are not able to be used with grpc communication.
  <br></br>
  Workaround:<br/>
  Use the updated documentation or your own certificate generation method instead.

<span id="100-resolved"></a>

### Resolved Issues

This release includes fixes for the following issues. You can search by the issue ID to locate the details for an issue.

- *Configuration Files Update (399)*:
  <br/><br/>
  NGINX Instance Manager now supports customization in the configuration files. These include separating the encryption needed for the grpc communication, the metrics and the UI if necessary. The package script will correct 0.9 configurations for you.
  <br/><br/>
  Workaround:
  - Edit the `nginx-agent.conf` file manually and replace the following option names:
    - `basic_status_url` -> `stub_status`
    - `plus_api_url` -> `plus_api`
    - Change the format of any tags to a yaml list. An example of the new format is below.
      ```yaml
      tags:
        - Development
        - test
      ```
  - Edit the `nginx-manager.conf` file manually and replace the following option names:
    - `bind-address` -> `bind_address`
    - `grpc-port` -> `grpc_port`
    - `gateway-port` -> `gateway_port`
    - `server-name` -> `server_name`
    - `storage-path` -> `storage_path`
    - `audit-log` -> `audit_log`
  <br/><br/>
  
- *SELinux fixed for nginx-agent (544)*:
  <br/><br/>
  SELinux was missing 2 contexts for the Nginx-agent selinux package. This release adds them so the module can be used without troubleshooting and customizing for standard environments.<br/>
  
- *Scan not working for CIDR and ranges (562)*:
  <br/><br/>
  Scan didn’t work when using a 31 or 32 mask in the UI. Scan also didn’t work with port ranges, which are not present in the API. This has been fixed.<br/>
  
- *Version displayed under settings (579)*:
  <br/><br/>
  NGINX Instance Manager displays the version running in the UI under settings.<br/>
  
- *Memory Leak in NGINX Agent (592)*:
  <br/><br/>
  The agent had a memory leak that would cause memory consumption to grow over time. This issue has been fixed.<br/>
  
- *Updated grpc timeouts for proxying nginx-agent (637)*:
  <br/><br/>
  Using NGINX to proxy grpc connections would timeout if the body_size or timeout was exceeded. The recommended settings for grpc proxying are not updated in the documentation.<br/><br/>
  Workaround:<br/>
  Change the grpc location settings in nginx.conf from

```nginx
location / {
            grpc_pass grpc://nginx-manager_grpc_servers;
            client_max_body_size 10m;
            client_body_timeout 3000s;
}
```

to

```nginx
location / {
            grpc_pass grpc://nginx-manager_grpc_servers;
            client_max_body_size 0;
            client_body_timeout 7d;
}
```

- *Scan not showing all servers (642)*:
  <br/><br/>
  Scan was not listing instances that couldn’t be identified. If a server couldn’t be identified, the ngxscan program was not listing it as found. This issue has been resolved.
