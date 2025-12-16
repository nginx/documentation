---
title: "Add signature sets and exceptions"
description: Configure attack signature sets and exceptions in F5 WAF for NGINX policies to fine-tune protection and reduce false positives.
weight: 400
toc: true
nd-content-type: how-to
nd-product: NIMNGR
---

This topic describes how to configure signature sets and signature exceptions in F5 WAF for NGINX policies. When you add or edit a policy, NGINX Instance Manager provides options to customize attack signatures to better protect your applications.

## Understanding signature sets and exceptions

Attack signatures are rules or patterns that identify known attack sequences or classes of attacks on a web application. F5 WAF for NGINX includes predefined attack signatures grouped into signature sets.

### Signature sets

A **signature set** is a collection of attack signatures with a specific name and purpose. These sets are predefined and can be enabled or disabled in your policy.

For example, you might have sets for SQL Injection Signatures, Cross-Site Scripting Signatures, or Buffer Overflow Signatures.

### Signature exceptions

A **signature exception** allows you to explicitly enable or disable individual attack signatures within a set. This gives you fine-grained control over your policy. For example:

- If a signature in a set causes false positives (blocking legitimate traffic), you can create an exception to disable that signature while keeping the rest of the set active.
- If you want to enable blocking for a single attack signature rather than an entire set, you can create an exception to enable just that signature.

## Add signature sets

From the NGINX Instance Manager web interface, go to **WAF** > **Policies** and select **Add policy**. The policy editor opens, where you can:

1. In **General Settings**, name and describe the policy.
2. Go to the **Web Protection** section and select **Attack Signature Sets**. Here, you can:
   - View all enabled attack signature sets, including the defaults.
   - Add new signature sets.
   - Modify existing signature sets.

### Configure signature sets

For each signature set, you can configure the following options:

- **Alarm** – When enabled, matching requests are logged.
- **Block** – When enabled, matching requests are blocked.

For example, to configure the Buffer Overflow Signatures set to log but not block requests:

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

To remove a signature set from your policy, you can:

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

2. Use the `$action` meta-property to delete the set (preferred for better performance):

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

1. Select **Add item** to create a new exception.  
2. Choose the signature or signatures you want to modify.  
3. Configure the exception. For example, to disable a specific signature:

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

4. Select **Add policy**. The policy JSON updates with your changes, and the new policy appears in the list under the name you provided.

From the **NGINX Instance Manager** web interface, you can review and modify saved policies at any time. Go to **WAF** > **Policies** to view or edit an existing policy.

For a complete list of available signature sets and detailed information about attack signatures, see the [Attack Signatures]({{< ref "/waf/policies/attack-signatures.md" >}}) documentation.
