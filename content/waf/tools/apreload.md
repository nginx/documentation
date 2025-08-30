---
# We use sentence case and present imperative tone
title: "Use apreload to configure F5 WAF for NGINX"
# Weights are assigned in increments of 100: determines sorting order
weight: 100
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

This page is for the apreload detail included on the following two pages:

- [V4]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#apreload" >}})
- [V5]({{< ref "/nap-waf/v5/configuration-guide/configuration.md#apreload" >}})

{{</ call-out >}}

This document describes how to use `apreload`, a tool for updating F5 WAF for NGINX configuration without reloading NGINX.

It interacts independently to NGINX, and can be used when any F5 WAF for NGINX files are modified, such as policies, logging profiles or global settings.

_apreload_ can handle changes in policy content, with the exception of a policy name.

While _apreload_ can update F5 WAF for NGINX configuration alone, an NGINX reload will update both NGINX and F5 WAF for NGINX configuration.

`apreload` should be ran as the same user as NGINX to avoid file access errors.

```text
USAGE:
    /opt/app_protect/bin/apreload:

Optional arguments with default values:
  -apply
        Apply new configuration in enforcer (default true)
  -i string
        Path to the config set. Ex. /opt/app_protect/config/config_set.json (default "/opt/app_protect/config/config_set.json")
  -policy-map-location string
        Path to policy map location (default "/opt/app_protect/bd_config/policy_path.map")
  -t    Test and prepare configuration without updating enforcement
  -wait-for-enforcer
        Wait until updated config is loaded (default true)

Optionally, using --help will issue this help message.
```

## Concurrent apreload executions

Concurrent NGINX reloads are enqueued and so are the entailed invocations to apreload by the NGINX App Protect WAF module.

However, when invoking apreload directly, it is possible to invoke it while the previous invocation is still in progress. In this case, apreload will wait until the current invocation completes. The new invocation will bring a new configuration and the most recent configuration will only happen when the previous one is loaded.

In a special scenario, when the first invocation comes from the NGINX reload followed immediately by a direct call to apreload. The NGINX workers with the new nginx.conf will be launched as soon as the Enforcer finishes the first configuration. Later, the most recent NGINX App Protect WAF configuration will be loaded (using with the same NGINX worker instances).

## Limitations with HTTP Header and XFF Modification

_apreload_ will not apply these two policy modifications:

- New user defined HTTP headers, refer to User-defined HTTP Headers section. Note that modifications to existing user-defined headers will take effect in apreload.
- XFF trust modifications, refer to XFF Headers and Trust section for more details.

If you want to apply either of the above modifications, reload NGINX instead of using _apreload_.

## apreload events

_apreload_ events use the same format as operation log events written in the NGINX error log, reporting `configuration_load_success` or `configuration_load_failure` with JSON formatted details. 

If any of the configuration files are invalid, _apreload_ will discover that and return the proper error message in the `configuration_load_failure event`. 

The enforcer continues to run with the previous working configuration. 

For more information, see the [Operation logs]({{< ref "/waf/logging/operation-logs.md">}}) topic.