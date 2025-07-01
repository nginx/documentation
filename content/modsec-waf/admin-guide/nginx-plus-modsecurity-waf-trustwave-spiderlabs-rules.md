---
nd-docs: DOCS-728
title: Using the ModSecurity Rules from Trustwave SpiderLabs with the NGINX ModSecurity
  WAF
toc: true
weight: 300
---

{{< important >}}
{{% modsec-eol-notice %}}
{{< /important >}}

This chapter explains how to configure the Commercial ModSecurity Rules from Trustwave SpiderLabs for use with the F5 NGINX ModSecurity web application firewall (WAF)).

<span id="waf-trustwave_overview"></span>

## Overview

<a target="_blank" href="https://docs.nginx.com/nginx/releases/#nginx-plus-release-12-r12">NGINX Plus Release 12</a> and later supports the [NGINX ModSecurity WAF](https://www.nginx.com/products/nginx/modules/nginx-waf/), which protects web applications against SQL Injection (SQLi), Remote Code Execution (RCE), Local File Include (LFI), cross -site scripting (XSS), and many other types of attack.

The Commercial ModSecurity Rules from Trustwave SpiderLabs (which we refer to as the Trustwave Rules in this chapter) complement the [Open Web Application Security Project Core Rule Set](https://www.owasp.org/index.php/Category:OWASP_ModSecurity_Core_Rule_Set_Project) (OWASP CRS) with protection against specific attacks for many common applications including ASP.NET, Joomla, and WordPress. Additionally, the Trustwave SpiderLabs Rules provide IP reputation along with other capabilities, and are updated daily.

This chapter builds on the basic configuration created in the [Installing the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-installation-logging.md" >}}) chapter, showing how to configure the Trustwave Rules to protect the demo web application configured in that chapter.

The NGINX ModSecurity WAF also supports the OWASP CRS as described in [Using the OWASP CRS with the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-owasp-crs.md" >}}).

<span id="waf-trustwave_prerequisites"></span>

## Prerequisites

The NGINX ModSecurity WAF is available to NGINX Plus customers as a downloaded dynamic module at an additional cost. You can [try the NGINX ModSecurity WAF free for 30 days](https://www.nginx.com/free-trial-request/). To purchase or add the NGINX ModSecurity WAF to an existing NGINX Plus subscription, [contact the NGINX sales team](https://www.nginx.com/contact-sales/).

You must purchase the Trustwave Rules directly from Trustwave SpiderLabs.

As noted above, this chapter builds on [Installing the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-installation-logging.md" >}}) and assumes you have followed the instructions there to configure both the demo application and NGINX Plus as a reverse proxy.

<span id="waf-trustwave_configure"></span>

## Configuring the Trustwave SpiderLabs Rules

Purchasing the Trustwave Rules gives you access to the ModSecurity Dashboard, which is a web portal where you can customize the Trustwave Rules on individual instances of the NGINX ModSecurity WAF (and other ModSecurity installations). The Dashboard simplifies configuration compared to the OWASP CRS, in two ways:

- You don’t need to download rules onto individual NGINX Plus instances, because the NGINX ModSecurity WAF dynamic module downloads them automatically when the `SecRemoteRules` directive is included in the NGINX ModSecurity WAF configuration (see [Step 3](#waf-trustwave_configure-your-server) in the next section).
- You enable and disable rules -- a significant part of the configuration process -- with a GUI on the Dashboard instead of in NGINX ModSecurity WAF configuration files.

To configure the Trustwave Rules for the demo application, first create a profile (or use the default one) that includes selected rules for protecting the application. The following instructions use the Dashboard's Configuration Wizard to create a profile. You then modify the local NGINX ModSecurity WAF configuration to make the NGINX ModSecurity WAF dynamic module download and apply the rules.

Detailed instructions for using the Dashboard are not provided here. For more information, log in to the Dashboard and access the Dashboard FAQ.

<span id="waf-trustwave_configure_wizard"></span>

### Using the Configuration Wizard

To configure the Trustwave Rules for the demo application, perform the following steps:

1. Log in to the ModSecurity Dashboard and start the Configuration Wizard.

2. Create a profile, enabling rules that are relevant for your application. None of the existing rules actually apply to our demo application, but for the purposes of this step select the WordPress‑related rules. You can also enable additional options, such as IP reputation.

    <span id="waf-trustwave_configure-your-server"></span>
3. At the **Configure your server** step, the Wizard presents the [`SecRemoteRules`](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v2.x)#SecRemoteRules) directive that must be added to the  NGINX ModSecurity WAF configuration, similar to this:

    ```nginx
    SecRemoteRules <license‑key> https://<url>
    ```

    Here, the `SecRemoteRules` directive configures the NGINX ModSecurity WAF to download rules from the remote server, represented by the `<url>`, using the provided `<license‑key>`.

    The Wizard does not provide an interface for adding the directive, so you need to edit **/etc/nginx/modsec/main.conf** manually and add the `SecRemoteRules` directive presented by the Wizard (we created the **main.conf** file in Step 4 of [Protecting the Demo Web Application]({{< ref "nginx-plus-modsecurity-waf-installation-logging.md#protecting-the-demo-web-application" >}}) in the installation chapter). Comment out any other rules that might already exist in the file, such as the `SecRule` directive defined in that step.

    ```nginx
    # Include the recommended configuration
    Include "/etc/nginx/modsec/modsecurity.conf"
    SecRemoteRules <license‑key> https://<url>
    ```

4. By default, the Trustwave Rules only detect malicious requests and don’t block them. To block the requests, add the following lines to **/etc/nginx/modsec/main.conf** below the `SecRemoteRules` directive you added in the previous step:

    ```nginx
    SecDefaultAction "phase:2,log,auditlog,deny,status:403"
    SecDefaultAction "phase:1,log,auditlog,deny,status:403"
    ```

    The [`SecDefaultAction`](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v2.x)#SecDefaultAction) directive defines the default list of actions for the rules, with the `deny` action blocking malicious requests and returning status code `403`.

5. Reload the NGINX Plus configuration:

    ```none
    sudo nginx -s reload
    ```

    Reloading takes time as the rules are being downloaded from the remote server.

6. Once the Wizard reports that NGINX Plus downloaded the rules, you can close the Wizard and start testing the rules.

<span id="waf-trustwave_configure_test"></span>

### Testing the Rules

In the [Using the OWASP CRS with the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-owasp-crs.md" >}}) chapter, we use the Nikto scanning tool to test how the CRS blocks malicious requests. You cannot use a similar approach to test the Trustwave Rules, because they are specific rules that do not detect the generic attacks sent by Nikto.

The Dashboard describes each Trustwave ModSecurity Rule. You can use that information to test how the rule behaves, by constructing and sending NGINX Plus malicious requests that trigger the rules.

<span id="waf-trustwave_caveats"></span>

## Caveats for the `SecRemoteRules` Directive

Currently, the only way to download the Trustwave Rules is with the `SecRemoteRules` directive. While the directive simplifies the process of getting the rules onto an instance of NGINX Plus where the NGINX ModSecurity WAF is dynamically loaded, the following caveats apply:

- Every time you reload the NGINX Plus configuration or restart NGINX Plus, the rules are freshly downloaded from a remote server. To control what happens when the download fails, for example when connectivity to the remote server is lost, include the [`SecRemoteRulesFailAction`](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v2.x)#SecRemoteRulesFailAction) directive in the NGINX ModSecurity WAF configuration. The `SecRemoteRulesFailAction` directive must appear above the `SecRemoteRules` directives in a NGINX ModSecurity WAF configuration file.

   The directive supports two values:

  - `Abort` forces the reload or restart of NGINX Plus to fail when the download of rules fails
  - `Warn` lets NGINX Plus reload or restart successfully but with _no remote rules_ enabled

- Downloading the rules takes some time, which delays the reload or restart operation.

- Each `SecRemoteRules` definition leads to a separate download, further increasing the reload/restart time. To avoid that, try to minimize the number of `SecRemoteRules` definitions. Note that even if you define `SecRemoteRules` only in one file (such as the **/etc/nginx/modsec/main.conf** file modified in [Step 3](#waf-trustwave_configure-your-server) above), each time you read this file into NGINX Plus configuration using the [`modsecurity_rules_file`](https://github.com/SpiderLabs/ModSecurity-nginx#modsecurity_rules_file) directive (as in the **/etc/nginx/conf.d/proxy.conf** file created in [Configuring NGINX Plus as a Reverse Proxy]({{< ref "nginx-plus-modsecurity-waf-installation-logging/#configuring-nginx-plus-as-a-reverse-proxy" >}}) in the installation chapter), the NGINX ModSecurity WAF treats it as a separate definition.

- Merging rules from different NGINX Plus configuration contexts ([`http {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#http), [`server {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server), [`location {}`](http://nginx.org/en/docs/http/ngx_http_core_module.html#location)) also adds time to the reload/restart operation and consumes a lot of CPU, especially for a huge rule set such as the Trustwave Rules. In addition to minimizing the number of `SecRemoteRules` definitions, try to include all rule definitions in a single context.

The Trustwave rule set contains more than 16,000 rules for protecting various applications. The more rules there are, the worse the NGINX ModSecurity WAF performs, so it is crucial that you enable only rules that are relevant for your application.

<span id="waf-trustwave_limitations"></span>

## Limitations

Inspecting the response body is not supported, so rules that do so have no effect.

<span id="waf-trustwave_conclusion"></span>

## Conclusion

We configured Commercial ModSecurity Rules from Trustwave SpiderLabs to protect our application against WordPress‑related attacks. We also reviewed caveats for the `SecRemoteRules` directive.

For information about using the OWASP CRS with the NGINX ModSecurity WAF, see [Using the OWASP CRS with the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-owasp-crs.md" >}}).

<span id="waf-trustwave_resources"></span>

## Resources

- [Commercial ModSecurity Rules from Trustwave SpiderLabs](http://modsecurity.org)
- [ModSecurity Dashboard](https://modsecurity.org/)
- [ModSecurity Reference Manual](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v2.x)#ModSecurityreg_Reference_Manual)
