---
title: "Brute force attack preventions"
weight: 600
toc: true
f5-content-type: reference
f5-product: F5 WAF for NGINX
---

This topic describes how to configure brute force attack prevention in F5 WAF for NGINX.

Brute force attacks try many username and password combinations to gain access to a protected application. To detect these attacks, F5 WAF for NGINX tracks failed login attempts for configured login pages.

When a threshold is reached, the policy can log the attack, challenge the client with Client-side integrity, or challenge the client with CAPTCHA.

## User-defined URLs

To protect a login endpoint, first define it as a user-defined URL.

```json
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

A login page identifies the endpoint that users submit credentials to. It also defines how F5 WAF for NGINX determines whether a login attempt succeeded or failed.

The `accessValidation` object is required for brute force protection. You can use fields such as `responseContains`, `responseOmits`, or HTTP status checks to classify the login result.

```json
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
]
```

{{< call-out class="note" >}}

For more information, see the [login-pages section]({{< ref "/waf/policies/parameter-reference.md#policy/login-pages" >}}) of the parameter reference.

{{< /call-out >}}

## Mitigation actions

Use these action values in your brute force configuration:

- `alarm` logs the brute force event and allows the request.
- `alarm-and-client-side-integrity` serves a JavaScript challenge to verify that the client behaves like a browser.
- `alarm-and-captcha` serves a CAPTCHA challenge to verify that the client is operated by a human user. This action requires a generated challenge pool.

## Configure brute force challenges

1. Define the login endpoint in `urls`.
2. Add the same endpoint to `login-pages` and configure `accessValidation` so F5 WAF for NGINX can classify successful and failed logins.
3. Decide whether the brute force settings apply to all login pages or only one page.
4. Set thresholds for `loginAttemptsFromTheSameUser`, `loginAttemptsFromTheSameIp`, or `loginAttemptsFromTheSameDeviceId`, depending on how you want to track failed login activity.
5. Choose a mitigation action: `alarm`, `alarm-and-client-side-integrity`, or `alarm-and-captcha`.
6. Tune the timing fields for detection, mitigation, and re-enable behavior.
7. If needed, configure bypass behavior for the selected challenge type.

## Client Side Integrity example

This example applies Client Side Integrity to all configured login pages.

```json
{
  "policy": {
    "brute-force-attack-preventions": [
      {
        "bruteForceProtectionForAllLoginPages": true,
        "loginAttemptsFromTheSameIp": {
          "action": "alarm-and-client-side-integrity",
          "enabled": true,
          "threshold": 3
        },
        "loginAttemptsFromTheSameUser": {
          "action": "alarm-and-client-side-integrity",
          "enabled": true,
          "threshold": 3
        },
        "clientSideIntegrityBypassCriteria": {
          "action": "alarm-and-captcha",
          "enabled": false,
          "threshold": 1
        },
        "measurementPeriod": 60,
        "preventionDuration": 60,
        "reEnableLoginAfter": 60,
        "sourceBasedProtectionDetectionPeriod": 60
      }
    ]
  }
}
```

In this example:

- `loginAttemptsFromTheSameUser` challenges repeated failures for the same username.
- `loginAttemptsFromTheSameIp` challenges repeated failures from the same source IP address.

## CAPTCHA example

This example protects a specific login page with CAPTCHA.

```json
{
  "policy": {
    "brute-force-attack-preventions": [
      {
        "bruteForceProtectionForAllLoginPages": false,
        "url": {
          "method": "*",
          "name": "/html_login",
          "protocol": "http"
        },
        "loginAttemptsFromTheSameIp": {
          "action": "alarm-and-captcha",
          "enabled": true,
          "threshold": 3
        },
        "loginAttemptsFromTheSameUser": {
          "action": "alarm-and-captcha",
          "enabled": true,
          "threshold": 3
        },
        "captchaBypassCriteria": {
          "action": "alarm-and-drop",
          "enabled": false,
          "threshold": 5
        },
        "measurementPeriod": 60,
        "preventionDuration": 60,
        "reEnableLoginAfter": 60,
        "sourceBasedProtectionDetectionPeriod": 60
      }
    ]
  }
}
```

Use the CAPTCHA example when you want to protect browser-based login flows with a human verification step instead of a JavaScript integrity challenge.

{{< call-out class="important" >}}

CAPTCHA actions have two requirements. A challenge pool must be available when your policy is compiled, otherwise the bundle contains no challenges. On a virtual server that serves plain HTTP, set `secureAttribute` to `never`, otherwise the browser discards the enforcer state cookie and the client can never pass the challenge. For more information, see [Cookie enforcement]({{< ref "/waf/policies/cookie-enforcement.md" >}}).

{{< /call-out >}}

## Device ID examples

Use these examples when you want to track failed logins by device identifier instead of by username or source IP address.

Set `url` when the brute force configuration applies to one login page. Omit `url` only when `bruteForceProtectionForAllLoginPages` is set to `true`.

### Client Side Integrity

```json
{
  "policy": {
    "brute-force-attack-preventions": [
      {
        "bruteForceProtectionForAllLoginPages": false,
        "url": {
          "method": "*",
          "name": "/html_login",
          "protocol": "http"
        },
        "loginAttemptsFromTheSameDeviceId": {
          "action": "alarm-and-client-side-integrity",
          "enabled": true,
          "threshold": 3
        },
        "measurementPeriod": 60,
        "preventionDuration": 60,
        "reEnableLoginAfter": 60,
        "sourceBasedProtectionDetectionPeriod": 60
      }
    ]
  }
}
```

### CAPTCHA

```json
{
  "policy": {
    "brute-force-attack-preventions": [
      {
        "bruteForceProtectionForAllLoginPages": false,
        "url": {
          "method": "*",
          "name": "/html_login",
          "protocol": "http"
        },
        "loginAttemptsFromTheSameDeviceId": {
          "action": "alarm-and-captcha",
          "enabled": true,
          "threshold": 3
        },
        "measurementPeriod": 60,
        "preventionDuration": 60,
        "reEnableLoginAfter": 60,
        "sourceBasedProtectionDetectionPeriod": 60
      }
    ]
  }
}
```

## More information

{{< call-out class="note" >}}

For more information, see the [brute-force-attack-preventions section]({{< ref "/waf/policies/parameter-reference.md#policy/brute-force-attack-preventions" >}}) of the parameter reference.

{{< /call-out >}}
