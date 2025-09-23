---
# We use sentence case and present imperative tone
title: "Brute force attack preventions"
# Weights are assigned in increments of 100: determines sorting order
weight: 600
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This topic describes the brute force attack prevention feature of F5 WAF for NGINX.

Brute force attacks are attempts to break in to secured areas of a web application by trying exhaustive, systematic, username/password combinations to discover legitimate authentication credentials. 

To prevent brute force attacks, F5 WAF for NGINX monitors IP addresses, usernames, and the number of failed login attempts beyond a maximum threshold. 

When brute force patterns are detected, F5 WAF for NGINX policy either triggers an alarm or blocks the attack if the failed login attempts reached a maximum threshold for a specific username or coming from a specific IP address. 

## User-defined URLs

In order to create a brute force configuration for a specific URL in F5 WAF for NGINX you must first create a user-defined URL, a login page, and then define the URL element in the brute force configuration section.

```JSON
"urls": [
      {
        "method": "*",
        "name": "/html_login",
        "protocol": "http",
        "type": "explicit"
      }
    ],
```

## Login pages

A login page specifies the URL that users must pass through to get authenticated. 

The configuration of a login-pages includes the URL itself, the username and password parameters, and the validation criteria (Defining if a login was successful or failed).

```json
"login-pages": [
            {
               "accessValidation" : {
                  "responseContains": "Success"
               },
               "authenticationType": "form",
               "url" : {
                  "method" : "*",
                  "name" : "/html_login",
                  "protocol" : "http",
                  "type" : "explicit"
               },
               "usernameParameterName": "username",
               "passwordParameterName": "password"
            }
        ]
```

{{< call-out "note" >}}

For more information, see the [login-pages section]({{< ref "/waf/policies/parameter-reference.md#policy/login-pages" >}}) of the parameter reference.

{{< /call-out >}}

## Examples

This example shows a configuration applied to all login pages:

```json
"brute-force-attack-preventions" : [
            {
               "bruteForceProtectionForAllLoginPages" : true,
               "loginAttemptsFromTheSameIp" : {
                  "action" : "alarm",
                  "enabled" : true,
                  "threshold" : 20
               },
               "loginAttemptsFromTheSameUser" : {
                  "action" : "alarm",
                  "enabled" : true,
                  "threshold" : 3
               },
               "reEnableLoginAfter" : 3600,
               "sourceBasedProtectionDetectionPeriod" : 3600
            }
        ]
```

Brute force can be configured on an individual login page basis:

```json
"brute-force-attack-preventions" : [
            {
               "bruteForceProtectionForAllLoginPages" : false,
               "loginAttemptsFromTheSameIp" : {
                  "action" : "alarm",
                  "enabled" : true,
                  "threshold" : 20
               },
               "loginAttemptsFromTheSameUser" : {
                  "action" : "alarm",
                  "enabled" : true,
                  "threshold" : 3
               },
               "reEnableLoginAfter" : 3600,
               "sourceBasedProtectionDetectionPeriod" : 3600,
               "url": {
                 "method": "*",
                 "name": "/html_login",
                 "protocol": "http"
               }
            }
        ]
```

This example includes both configuration for all pages and configuration for individual pages:

```json
{
  "policy": {
    "name": "BruteForcePolicy",
    "template": {
      "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "urls": [
      {
        "method": "*",
        "name": "/html_login",
        "protocol": "http",
        "type": "explicit"
      }
    ],
    "login-pages": [
      {
        "accessValidation": {
          "responseContains": "Success"
        },
        "authenticationType": "form",
        "url": {
          "method": "*",
          "name": "/html_login",
          "protocol": "http",
          "type": "explicit"
        },
        "usernameParameterName": "username",
        "passwordParameterName": "password"
      }
    ],
    "brute-force-attack-preventions": [
      {
        "bruteForceProtectionForAllLoginPages": false,
        "loginAttemptsFromTheSameIp": {
          "action": "alarm",
          "enabled": true,
          "threshold": 20
        },
        "loginAttemptsFromTheSameUser": {
          "action": "alarm",
          "enabled": true,
          "threshold": 3
        },
        "reEnableLoginAfter": 3600,
        "sourceBasedProtectionDetectionPeriod": 3600,
        "url": {
          "method": "*",
          "name": "/html_login",
          "protocol": "http"
        }
      }
    ]
  }
}
```

{{< call-out "note" >}}

For more information, see the [brute-force-attack-preventions section]({{< ref "/waf/policies/parameter-reference.md#policy/brute-force-attack-preventions" >}}) of the parameter reference.

{{< /call-out >}}