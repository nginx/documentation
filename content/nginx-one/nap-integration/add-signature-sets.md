---
title: "Add signature sets and exceptions"
weight: 300
toc: true
nd-content-type: how-to
nd-product: NGINX One Console
---

This document describes how you can configure signature sets and signature exceptions in F5 WAF for NGINX policies. When you add a policy, NGINX One Console provides options to customize attack signatures to better protect your applications.

## Understanding signature sets and exceptions

Attack signatures are rules or patterns that identify attack sequences or classes of attacks on a web application. F5 WAF for NGINX includes predefined attack signatures grouped into signature sets.

### Signature set

A **signature set** is a collection of attack signatures with a specific name and purpose. These sets are predefined and can be enabled or disabled in your policy. 

For example, you might have sets for SQL Injection Signatures, Cross-Site Scripting Signatures, or Buffer Overflow Signatures.

### Signature exception

A **signature exception** allows you to explicitly enable or disable individual attack signatures within a set. This gives you granular control over your policy. For example:
- If a signature in a set causes false positives (blocking legitimate traffic), you can create an exception to disable just that signature while keeping the rest of the set active.
- If you want to enable blocking for one specific attack signature rather than an entire set, you can create an exception to enable just that signature.

## Add signature sets

From NGINX One Console, select **App Protect > Policies**. In the screen that appears, select **Add Policy**. That action opens a screen where you can:

1. In **General Settings**, name and describe the policy.
1. Go to the **Web Protection** section and select **Attack Signature Sets**. Here, you can:
   - View all enabled attack signature sets, including the default ones
   - Add new signature sets
   - Modify existing signature sets

### Configure signature sets

For each signature set, you can configure:
- **Alarm**: When enabled, matching requests are logged
- **Block**: When enabled, matching requests are blocked

For example, to configure Buffer Overflow Signatures to log but not block:

```json
{
    "policy": {
        "name": "buffer_overflow_signature",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "signature-sets": [
            {
                "name": "Buffer Overflow Signatures",
                "alarm": true,
                "block": false
            }
        ]
    }
}
```

### Remove signature sets

To remove a signature set from your policy, you have two options:

1. Disable the set by setting both `alarm` and `block` to `false`:

    ```json
    {
        "policy": {
            "name": "no_xpath_policy",
            "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
            "signature-sets": [
                {
                    "name": "XPath Injection Signatures",
                    "block": false,
                    "alarm": false
                }
            ]
        }
    }
    ```

1. Use the `$action` meta-property to delete the set (preferred for better performance):

    ```json
    {
        "policy": {
            "name": "no_xpath_policy",
            "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
            "signature-sets": [
                {
                    "name": "XPath Injection Signatures",
                    "$action": "delete"
                }
            ]
        }
    }
    ```

## Add signature exceptions

From the **Web Protection** section, select **Attack Signature Exceptions**. This allows you to override settings for individual signatures.

1. Click **Add Item** to create a new exception.
1. Select the signature(s) you want to modify.
1. Configure the exception. For example, to disable a specific signature:

    ```json
    {
        "signatures": [
            {
                "name": "_mem_bin access",
                "enabled": false,
                "signatureId": 200100022
            }
        ]
    }
    ```

## Add and deploy your policy

After configuring signature sets and exceptions:

1. Select **Add Policy**. The policy JSON will be updated with your changes.
1. Your policy will appear in the list under the name you provided.
1. You can then [deploy]({{< ref "/nginx-one/nap-integration/deploy-policy.md/" >}}) the policy to either:
   - An instance
   - A Config Sync Group

From NGINX One Console, you can [review and modify]({{< ref "/nginx-one/nap-integration/review-policy.md/" >}}) your saved policies at any time by selecting **App Protect > Policies**.

For a complete list of available signature sets and detailed information about attack signatures, see the [Attack Signatures]({{< ref "/waf/policies/attack-signatures.md" >}}) documentation.
