---
description: Learn how to extend your App Security configurations using F5 NGINX Controller
  Snippets.
nd-docs: DOCS-338
title: Extend App Security with Snippets
toc: true
weight: 400
type:
- concept
- reference
---

## Overview

F5 NGINX Controller [Snippets]({{< ref "/controller/app-delivery/about-snippets.md" >}}) let you customize your NGINX configuration by adding NGINX directives that aren't represented by the NGINX Controller API.

Snippets also let you customize App Security for your Components by adding NGINX App Protect directives that aren't present in the NGINX Controller API. You can use Snippets when [tuning your NGINX App Protect WAF performance]({{< ref "/controller/app-delivery/security/tutorials/tune-waf-for-app" >}}) as well.

{{< call-out "caution"  >}}
When you use Snippets to customize your NGINX configuration, your changes are applied to the `nginx.conf` file *as is*. NGINX Controller does not verify that your configuration is valid before applying the Snippet.

We strongly recommend verifying Snippets in a lab environment before making any changes in production.
{{< /call-out >}}

## App Security Usage Examples

{{< call-out "caution"  >}}
The examples provided here are intended for demonstration purposes only.
We strongly recommend verifying Snippets in a lab environment before making any changes in production.
{{< /call-out >}}

### Define a Backup Location for Security Event Logs

When you [enable WAF on a Component]({{< ref "/controller/app-delivery/security/tutorials/add-app-security-with-waf" >}}), all Security Events are sent to NGINX Controller logs via syslog. The following example uses the `app_protect_security_log` directive in a URI Snippet to define a local backup location for Security Event logs. You can also send Security Events to another syslog server or to `stderr` by inserting an additional URI Snippet with the `app_protect_security_log` directive.

{{< call-out "caution"  >}}
Using local files as a backup for Security Events may use up disk space and affect your system performance. In production environments, setting up a remote file or a remote syslog server for backup purposes are good alternatives to using a local backup.
{{< /call-out >}}

```json
{
    "metadata": {
        "name": "<component-name>"
    },
    "desiredState": {
        "ingress": {
            "uris": {
                "/": {
                }
            },
            "gatewayRefs": [
                    {
                        "ref": "/services/environments/environment-name/gateways/<gateway-name>"
                    }
                ]
        },
        "security": {
            "strategyRef": {
                "ref": "/security/strategies/balanced_default"
            },
            "waf": {
                "isEnabled": true
            }
        },
        "backend": {
            "workloadGroups": {
                "servers": {
                    "uris": {
                        "https://test-01.example.com": {
                        },
                        "https://test-02.example.com": {
                        }
                    }
                }
            }
        },
        "configSnippets": {
            "uriSnippets": [
                {
                    "directives": [
                        {
                            "directive":"app_protect_security_log",
                            "args": ["/etc/controller-agent/configurator/auxfiles/log-default.json", "/var/log/app_protect/security.log"]
                        }
                    ]
                }
            ]
        }
    }
}
```

### Add Location of User-Defined Signature Definition File

When using [Bring Your Own WAF Policy]({{< ref "/controller/app-delivery/security/concepts/bring-your-own-policy" >}}) in NGINX Controller, you can define a URI Snippet for a Gateway API to define the location for your User-Defined Signature Definition file. The User-Defined Signature can then be referenced in the custom NGINX App Protect WAF policy that you use for your Components.

{{< call-out "note" >}}
The file that contains the signature definition must already exist on your NGINX App Protect WAF instances. For more information regarding User-Defined Signatures, refer to the [NGINX App Protect WAF Configuration Guide](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#user-defined-signatures).
{{< /call-out >}}

The following example adds a URI snippet to the Gateway API definition that provides the location of the User-Defined Signature Definition file.

```json
{
    "metadata": {
        "name": "<gateway-name>"
    },
    "desiredState": {
        "configSnippets": {
            "httpSnippet": {
                "directives": [
                    {
                        "directive": "app_protect_user_defined_signatures",
                        "args": ["app_protect_user_defined_signature_def_01"]
                    }
                ]
            }
        },
        "ingress": {
            "uris": {
                "<gateway-uri>": {}
            },
            "placement":  {
                "instanceRefs": [
                    {
                        "ref": "/infrastructure/locations/unspecified/instances/<instance-name>"
                    }
                ]
            }
        }
    }
}

```

### Harden Security using Fail-Closed

Setting NGINX App Protect to "fail-closed" drops application traffic when certain conditions exist. This setting lets you err on the side of greater security as opposed to convenience, providing better protection for your applications when NGINX App Protect is not available.

The example below adds HTTP Snippets to the Gateway that set the following NGINX App Protect directives to `drop`, or "fail-closed":

- `app_protect_failure_mode_action`
- `app_protect_compressed_requests_action`
- `app_protect_request_buffer_overflow_action`

Refer to the [NGINX App Protect Configuration Guide](https://docs.nginx.com/nginx-app-protect/configuration-guide/configuration/#global-directives) for more information about these directives and the conditions to which each applies.

```json
{
    "metadata": {
        "name": "gateway-name"
    },
    "desiredState": {
        "configSnippets": {
            "httpSnippet": {
                "directives": [
                    {
                        "directive": "app_protect_failure_mode_action",
                        "args": ["drop"]
                    },
                    {
                        "directive": "app_protect_compressed_requests_action",
                        "args": ["drop"]
                    },
                    {
                        "directive": "app_protect_request_buffer_overflow_action",
                        "args": ["drop"]
                    }
                ]
            }
        },
        "ingress": {
            "uris": {
                "http://example.com:8000": {}
            },
            "placement":  {
                "instanceRefs": [
                    {
                        "ref": "/infrastructure/locations/unspecified/instances/<instance-name>"
                    }
                ]
            }
        }
    }
}

```

## Tuning WAF Performance Usage Examples

{{< call-out "caution"  >}}
The examples provided here are intended for demonstration purposes only.
We strongly recommend verifying Snippets in a lab environment before making any changes in production.
{{< /call-out >}}

## Set the Memory and CPU Threshold Values

This example adds an HTTP Snippet to a Gateway to control the memory and CPU threshold values which determine when NGINX App Protect enters and exits failure mode.

In *failure mode*, App Protect WAF stops processing app traffic. Traffic is either dropped or passed through, as determined by the `app_protect_failure_mode_action` directive.

The example below directs NGINX App Protect WAF to enter failure mode when memory utilization or CPU utilization reaches 85% and to exit failure mode when memory or CPU utilization drops to 60%.

```json
{
    "metadata": {
        "name": "<gateway-name>"
    },
    "desiredState": {
        "configSnippets": {
            "httpSnippet": {
                "directives": [
                    {
                        "directive": "app_protect_physical_memory_util_thresholds",
                        "args": ["high=85 low=60"]
                    },
                    {
                        "directive": "app_protect_cpu_thresholds",
                        "args": ["high=85 low=60"]
                    }
                ]
            }
        },
        "ingress": {
            "uris": {
                "http://example.com:8000": {}
            },
            "placement":  {
                "instanceRefs": [
                    {
                        "ref": "/infrastructure/locations/unspecified/instances/<instance-name>"
                    }
                ]
            }
        }
    }
}
```

{{< versions "3.22" "latest" "adcvers" >}}
