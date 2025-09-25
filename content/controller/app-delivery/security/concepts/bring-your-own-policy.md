---
description: Learn how to use your own F5 WAF for NGINX policies with NGINX
  Controller.
nd-docs: DOCS-481
title: Bring Your Own WAF Policy
toc: true
weight: 300
type:
- concept
---

## Overview

You can use the App Security Add-on for F5 NGINX Controller ADC to bring your own ("BYO") NGINX App Protect policies into NGINX Controller. This lets you use your existing declarative JSON policies from NGINX App Protect to protect your ADC app components.

A BYO NGINX App Protect policy lets you maintain consistent Security Policies across your F5 WAF and NGINX WAF deployments. For example, say you already use F5 BIG-IP Application Security Manager (ASM) or F5 Advanced WAF and are now adopting NGINX Controller App Security. You can convert your XML Security Policies to an NGINX App Protect policy by using the [NGINX App Protect Policy Converter tool](https://docs.nginx.com/nginx-app-protect/configuration/#policy-converter).

To export a policy from F5 Advanced WAF or ASM, take the following steps:

1. Convert your F5 XML security policy to an F5 WAF for NGINX declarative JSON policy using the [NGINX App Protect Policy Converter tool](https://docs.nginx.com/nginx-app-protect/configuration/#policy-converter).
   {{< call-out "note" >}}We recommend using the Converter tool that corresponds with the most recent NGINX App Protect version.{{< /call-out >}}

2. Use the NGINX App Protect declarative JSON policy as the WAF policy in NGINX Controller for your app component(s).

&nbsp;

With a BYO NGINX App Protect policy, you can also provide customized security by crafting an F5 WAF for NGINX policy that specifies the security controls appropriate for your apps. For more information on how to configure an F5 WAF for NGINX policy, refer to the [NGINX App Protect Configuration Guide](https://docs.nginx.com/nginx-app-protect/configuration/).

## Security Strategy for BYO NGINX App Protect Policy

The BYO NGINX App Protect policy uses the concept of a [Security Strategy]({{< ref "/controller/app-delivery/security/concepts/what-is-waf.md#security-policy-and-security-strategy" >}})

With the BYO NGINX App Protect policy feature, you can specify the exact NGINX App Protect policy for the Security Strategy. Then, the Security Strategy can be shared across -- and referenced by -- multiple app components.
A Security Strategy can be comprised of various app-security-related Security Policies. NGINX Controller includes a custom F5 WAF for NGINX policy, which can be assigned to a Security Strategy.

You can also add a BYO F5 WAF for NGINX policy in JSON format to NGINX Controller "as-is" for use in a Security Strategy.


An **App Component** contains a reference to a **Security Strategy**, which, in turn, references a Security Policy. This Security Policy contains the **F5 WAF for NGINX policy**.

Refer to the topic [Enable WAF for a Component Using Your Own NGINX App Protect Policy]({{< ref "/controller/app-delivery/security/tutorials/add-app-security-with-waf.md#enable-waf-for-a-component-using-your-own-nap-policy-beta" >}}) to get started.

## Limitations

BYO NAP WAF policy currently has the following limitations:

- The size of the BYO F5 WAF for NGINX policy that's referenced by app components may affect application performance.
- References to external files, such as the following, in the F5 WAF for NGINX JSON declarative policy are not supported:
  - User Defined Signatures
  - Security controls in external references
  - Referenced OpenAPI spec files
- Cookie modification (`VIOL_COOKIE_MODIFIED`) is not supported.
- gRPC protection is not supported.
- Protection with partial security visibility:
  - Not all security metrics dimensions are available for the following:
    - Bot violations
    - CSRF origin validation violations
    - User-defined browser violations

{{< versions "3.20" "latest" "adcvers" >}}
