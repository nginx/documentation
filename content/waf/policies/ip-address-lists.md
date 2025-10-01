---
title: IP address lists
weight: 1500
toc: true
nd-content-type: reference
nd-product: NAP-WAF
nd-docs: DOCS-000
---

IP address lists are a feature that let you organize allowed and forbidden IP addresses into reusable lists with common attributes.

They make it possible to apply specific policy settings to incoming requests based on the source IP address.

Each IP address list includes:
- A unique name
- An enforcement type (`always`, `never`, or `policy-default`)
- A list of IP addresses

Here is an example of a declarative policy using an IP address lists configuration:

```json
{
  "policy": {
    "name": "IpGroups_policy",
    "template": {
       "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "caseInsensitive": false,
    "enforcementMode": "blocking",
    "ip-address-lists": [
       {
         "name": "Standalone",
         "description": "Optional Description",
         "blockRequests": "policy-default",
         "setGeolocation": "IN",
         "ipAddresses": [
          {
             "ipAddress": "1.2.3.4/32"
          },
          {
             "ipAddress": "1111:fc00:0:112::2"
          }
        ]
      }
    ]
  }
}
```

The following example shows an IP group definition stored in an external file `external_ip_groups.json`:

```json
{
  "policy": {
    "name": "IpGroups_policy2",
    "template": {
       "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "caseInsensitive": false,
    "enforcementMode": "blocking",
    "ip-address-lists": [
      {
        "name": "external_ip_groups",
        "description": "Optional Description",
        "blockRequests": "always",
        "setGeolocation": "IL",
        "$ref": "file:///tmp/policy/external_ip_groups.json"
      }
    ]
  }
}
```

Example of the file `external_ip_groups.json`:

```json
{
    "name": "External IP address lists",
    "description": "Optional Description",
    "blockRequests": "always",
    "setGeolocation": "IR",
    "ipAddresses": [
      {
        "ipAddress": "66.51.41.21"
      },
      {
        "ipAddress": "66.52.42.22"
      }
    ]
}
```

## IP address lists in policy override rules conditions

The **Override Rules** feature allows you to override original or parent policy settings.

Rules are defined using specific conditions, which can include an IP address list based on the declarative policy JSON schema.

When triggered, the rule is applied to the `clientIp` attribute using the `matches` function:

`clientIp.matches(ipAddressLists["standalone"])`

Here is a policy example:

```json
{
  "policy": {
    "name": "ip_group_override_rule",
    "template": {
      "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "caseInsensitive": false,
    "enforcementMode": "blocking",
    "ip-address-lists": [
      {
        "name": "standalone",
        "ipAddresses": [
          {
            "ipAddress": "1.1.1.1/32"
          }
        ]
      }
     ],
     "override-rules": [
      {
        "name": "myRule1",
        "condition": "clientIp.matches(ipAddressLists['standalone'])",
        "actionType": "extend-policy",
        "override": {
          "policy": {
            "enforcementMode": "transparent"
          }
        }
      }
    ]
  }
}
```

The previous example policy contains an IP address list named `standalone`, which is used in the override rule condition `clientIp.matches(ipAddressLists['standalone'])`.

This condition means that the rule enforcement is applied and overrides the base policy enforcement whenever the `clientIp` matches one of the `ipAddresses` in the `ip-address-list` named `standalone`.

The value used in the override condition must exist and exactly match the name defined in `ip-address-lists`.

### Possible errors

| Error text                              | Input                                             | Explanation                                               |
|-----------------------------------------|---------------------------------------------------|-----------------------------------------------------------|
| Invalid field `invalidList`             | `clientIp.matches(invalidList['standalone']);`    | An incorrect keyword was used instead of `ipAddressLists` |
| Invalid value empty string              | `clientIp.matches(ipAddressLists[''])`            | An empty name was provided                                |
| Failed to compile policy - `ipGroupOverridePolicy` | `uri.matches(ipAddressLists['standalone']);`     | Used `ipAddressLists` without the `clientIp` attribute    |
