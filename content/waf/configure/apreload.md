---
# We use sentence case and present imperative tone
title: "Use apreload to apply configuration updates"
# Weights are assigned in increments of 100: determines sorting order
weight: 200
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This document describes how to use `apreload`, a tool for updating F5 WAF for NGINX configuration without reloading NGINX.

It interacts independently to NGINX, and can be used when any F5 WAF for NGINX files are modified, such as policies, logging profiles or global settings.

_apreload_ can handle changes in policy content, with the exception of policy names.

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

In a Kubernetes environment, you can invoke it using _kubectl_:

```shell
kubectl -n <namespace> exec -it <podname> -c waf-nginx -- bash /opt/app_protect/bin/apreload
```

The result can then be viewed in the `waf-config-mgr` container logs.

```shell
kubectl -n <namespace> logs <podname> -c config-mgr
sudo docker logs waf-config-mgr
```

## Concurrent apreload executions

Concurrent NGINX reloads are enqueued and so are calls to _apreload_ by the F5 NGINX for WAF.

When calling _apreload_ directly, it is possible to run it while the previous execution is still in progress. In this case, _apreload_ will wait until the current execution completes.

The new execution will will apply a new configuration, and the most recent configuration will only apply during during the execution period.

In a scenario where an execution from an NGINX reload is followed by a direct _ap_reload_ call, the NGINX workers with the new NGINX configuration will be loaded as soon as the Enforcer finishes processing the existing configuration. 

Once complete, the most recent F5 WAF for NGINX configuration will be loaded using with the same NGINX worker instances.

## Limitations with HTTP and XFF header modifications

_apreload_ will not apply these two policy modifications:

- New [user-defined HTTP headers]({{< ref "/waf/policies/user-headers.md" >}})
- - It **will** apply changes to _existing_ user-defined headers.
- [XFF trust modifications]({{< ref "/waf/policies/xff-headers.md" >}})

If you want to apply either of the two, reload NGINX instead of using _apreload_.

## apreload events

_apreload_ events use the same format as operation log events written in the NGINX error log, reporting `configuration_load_success` or `configuration_load_failure` with JSON formatted details. 

If any of the configuration files are invalid, _apreload_ will discover that and return the proper error message in the `configuration_load_failure event`. 

The enforcer will continue to run with the previous working configuration. 

For more information, see the [Operation logs]({{< ref "/waf/logging/operation-logs.md">}}) topic.