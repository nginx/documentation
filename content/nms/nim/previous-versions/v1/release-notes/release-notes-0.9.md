---
title: "Release Notes 0.9"
date: 2021-03-08T10:46:11-07:00
draft: false
toc: true
description: Release information for NGINX Instance Manager, v0.9. Lists of new features and known issues are provided.
weight: 500
categories: ["support", "known issues", "release notes"]
aliases:
    - /v1/releases/release-notes-0.9.0/
    - /v1/releases/release-notes-0.9.1/
    - /v1/releases/release-notes-0.9.2/
    - /v1/releases/release-notes-0.9/
    - /releases/release-notes-0.9/
    - /releases/release-notes-0.9.0/
    - /releases/release-notes-0.9.1/
    - /releases/release-notes-0.9.2/
    
versions: ["v1"]
docs: "DOCS-640"
---

## NGINX Instance Manager Version 0.9.2

May 14, 2021

### Fixed in 0.9.2

- NGINX OSS non-standard access log locations may not show requests in metrics (530)
- Scan had issues with smaller subnet masks and the default network (562)
- Formatting alignment issues resolved (591)
- Agent reconnection issue resolved (592)

## NGINX Instance Manager Version 0.9.1

March 22, 2021

### Fixed in 0.9.1

- NGINX OSS non-standard access log locations may not show requests in metrics (530)

### Supported Versions

NGINX Plus Versions:

- R21
- R22
- R23

NGINX Open Source Versions:

- 1.16
- 1.18
- 1.19

## NGINX Instance Manager Version 0.9.0

March 16, 2021

These release notes provide general information and describe known issues for NGINX Instance Manager version 0.9.0, in the following categories:

- [What's New](#whats-new)
- [Known Issues](#known-issues)
- [Supported Versions](#supported-versions)

### What's New

Everything is new, as v0.9.0 is our first public release.

NGINX Instance Manager version 0.9.0 includes the following features:

- Support for NGINX Open Source
- Scanning tool for existing web servers
- Configuration editor
- Analyzer functionality
- Advanced authentication options

#### Support for NGINX Open Source

Introduces support for NGINX Open Source. Non-standard configurations, compiled version, and more can be used with the [nginx-agent]({{<relref "/nms/nim/previous-versions/v1/getting-started/agent.md">}}) included with NGINX Instance Manager. Best practices, such as multiple NGINX conf files, are supported as well.

#### Scanning tool for existing web servers

Includes a [scanning tool]({{<relref "/nms/nim/previous-versions/v1/guides/scan-v1.md">}}) (optional) which helps identify web and proxy servers in your environment. It uses nmap stealth scan technology to inspect ports and subnet range as requested. The tool also calls out NGINX CVEs (common vulnerabilities and exposures) of older versions and suggests possible upgrades.

#### Configuration Editor

The configuration editor is the highlight of NGINX Instance Manager. You can use the built-in user interface or call the API to read and push config changes. Tying this into your existing pipeline is as simple as making the API call.

#### Analyzer Functionality

The analyzer functionality is included with NGINX Instance Manager. Built upon the best practices taken from support and services, it checks for common misconfurations that can affect your running NGINX instances. No more mistakes that slip through `nginx -t`.

#### Advanced Authentication options

Like all web applications with an API, we do what all web applications should: use NGINX! NGINX Plus is included to front-end NGINX Instance Manager and instantly gives you the ability to use [OpenID Connect]({{<relref "/nms/nim/previous-versions/v1/getting-started/auth.md">}}) and other methods to secure your infrastructure. Support is also available for [mTLS]({{<relref "/nms/nim/previous-versions/v1/getting-started/encrypt.md">}}) using the gRPC nginx-agent and other encryption methods. [SELinux]({{<relref "/nms/nim/previous-versions/v1/getting-started/install.md">}}) modules for rpm-based distributions of the nginx-agent and nginx-manager are included as well.

### Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future NGINX Instance Manager release notes.

- Plus or Open Source nginx-agent reports constant 4xx errors (495):

  The `nginx-agent` polls the wrong `stub_status` or API for NGINX if you don't change the `nginx-agent.conf` file. To resolve this, comment or remove the appropriate line in `nginx-agent.conf`. For example, the proper `nginx-agent.conf` for an NGINX Plus instance should look similar to the following:

  ```conf {hl_lines=[34,36]}
  #
  # /etc/nginx-agent/nginx-agent.conf
  #

  # Configuration file for NGINX Agent

  # specify the server grpc port to connect to
  server: nginx-manager.example.com:10443

  # tls options
  tls:
    # enable tls in the nginx-manager setup for grpcs
    enable: true
    # path to certificate
    cert: /etc/ssl/nginx-manager/agent.crt
    # path to certificate key
    key: /etc/ssl/nginx-manager/agent.key
    # path to CA cert
    ca: /etc/ssl/nginx-manager/ca.pem
  log:
    # set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
    level: info
    # set log path. if empty, don't log to file.
    path: /var/log/nginx-agent/
  # (optional) tags for this specific instance / machine for inventory purposes
  tags:
    # instance:
    location: unspecified
  # nginx configuration options
  nginx:
    # path of nginx to manage
    bin_path: /usr/sbin/nginx
    # specify stub status URL (see: nginx.org/r/stub_status)
    # stub_status: "http://127.0.0.1:80/nginx_status"
    # specify plus status api url (see nginx.org/r/api)
    plus_api: "http://127.0.0.1:8080/api"
    # specify metrics poll interval
    metrics_poll_interval: 1000ms
  ```

- Analyzer Rule Exceptions (497):

  NGINX Instance Manager has a built-in rule set for our Analyzer rules which we list and can be viewed on the [Metrics page]({{<relref "/nms/nim/previous-versions/v1/guides/metrics.md">}}). Customization will be added in a future release, but for the current version, the rules are static.

- Configuration Editing outside standard conf files (523)

  NGINX Instance Manager only supports adding and removing files that are standard to conf locations. These include all nested conf files and mime.types. They do not include certificates and private keys, js_include files, lua scripts, etc. We will be introducing additional types in upcoming releases.

- Formatting changes when copy/paste is used in the editor (258)

  NGINX Instance Manager uses the monaco-editor but tabs and spaces may be offset when copy/paste functions are used. We recommend using the API (which uses base64 encoding) if this is an issue or verifying the formatting before you publish. This will be addressed in a future release.

- Configs with empty location blocks are not renedered properly (286):

  When pasting a config, the empty location block may cause an error in the user interface. Use the API (which uses base64 encoding) for this type in the current version.

  ```nginx
  location /app1 {
  }
  ```

  get translated to

  ```nginx
  location /app1;
  ```

- No display message when trying to add a file that already exists (300):

  When adding a new file that already exists, the system doesn't display an error message. We will add a message to show this in the user interface in a future release. You can disable this API call if desired using the NGINX proxy.

- Analyzer does not identify a missing semicolon at the end of a config (301):

  Analyzer may miss a line without a semicolon near the end of a conf file.

- NGINX OSS non-standard access log locations may not show requests in metrics (530):

  NGINX Open Source installations use the compiled access log location by default and may ignore custom access log locations for http request metrics. Use the binary compiled access location or recompile with the alternative location as a workaround.
