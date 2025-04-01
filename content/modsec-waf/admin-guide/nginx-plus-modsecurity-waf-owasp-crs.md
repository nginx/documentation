---
docs: DOCS-727
title: Using the OWASP CRS with the NGINX ModSecurity WAF
toc: true
weight: 200
---

{{< important >}}
{{% modsec-eol-notice %}}
{{< /important >}}

This chapter explains how to enable and test the Open Web Application Security Project Core Rule Set (OWASP CRS) for use with the NGINX ModSecurity web application firewall (WAF).

<span id="waf-owasp_overview"></span>

## Overview

<a target="_blank" href="https://docs.nginx.com/nginx/releases/#nginx-plus-release-12-r12">F5 NGINX Plus Release 12</a> and later supports the [NGINX ModSecurity WAF](https://www.nginx.com/products/nginx/modules/nginx-waf/). The OWASP CRS provides the rules for the NGINX ModSecurity WAF to block SQL Injection (SQLi), Remote Code Execution (RCE), Local File Include (LFI), cross&#8209;site scripting (XSS), and many other attacks.

This chapter explains how to enable and test the [Open Web Application Security Project Core Rule Set](https://owasp.org/www-project-modsecurity-core-rule-set/) (OWASP CRS) for use with the NGINX ModSecurity WAF. The OWASP CRS includes signatures and patterns that detect many types of generic attacks. The latest version (CRS 3) includes significant improvements, including a reduction in false positives.

This chapter builds on the basic configuration in [Installing the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-installation-logging.md" >}}), showing how the CRS protects the demo web application created in that chapter. Before enabling the CRS, we run a scanning tool that generates attack traffic and reports the vulnerabilities it finds. We then enable the CRS and observe how it blocks most malicious requests, protecting our application against common attacks.

For information about another supported ModSecurity rule set, see [Using the ModSecurity Rules from Trustwave SpiderLabs with the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-trustwave-spiderlabs-rules.md" >}}).

<span id="waf-owasp_prerequisites"></span>

## Prerequisites

The NGINX ModSecurity WAF is available to NGINX Plus customers as a downloaded dynamic module at an additional cost. You can [try the NGINX ModSecurity WAF free for 30 days](https://www.nginx.com/free-trial-request/). To purchase or add the NGINX ModSecurity WAF to an existing NGINX Plus subscription, [contact the NGINX sales team](https://www.nginx.com/contact-sales).

As noted above, this chapter builds on [Installing the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-installation-logging.md" >}}) and assumes you have followed the instructions there to configure the demo application and NGINX Plus as a reverse proxy.

It is assumed that the [`git`](https://github.com/git/git) and [`perl`](https://www.perl.org/get.html) command binaries are installed.

<span id="waf-owasp_nikto"></span>

## Running the Nikto Scanning Tool

We begin by sending attack traffic to the demo web application created in [Installing the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-installation-logging.md#creating-the-demo-web-application" >}}). Many attackers run vulnerability scanners to identify security vulnerabilities in a target website or app. Once they learn what vulnerabilities are present, they can launch the appropriate attacks.

We’re using the [Nikto](https://github.com/sullo/nikto) scanning tool to generate malicious requests, including probes for the presence of files known to be vulnerable, XSS, and other types of attack. The tool also reports which requests passed through to the application, revealing potential vulnerabilities in the application.

Run the following commands to get the Nikto code and run it against the web application. The `324 items` in the output are potential vulnerabilities, revealed by requests that passed through to the application.

```none
$ git clone https://github.com/sullo/nikto
Cloning into 'nikto'...
$ cd nikto
$ perl program/nikto.pl -h localhost
- Nikto v2.1.6
...
+ 7531 requests: 0 error(s) and 324 item(s) reported on remote host
```

Next we enable the CRS, and then test how it blocks most of Nikto’s requests and so decreases the number of items reported.

<span id="waf-owasp_enable"></span>

## Enabling the OWASP CRS

To enable the OWASP CRS, perform the following steps:

1. Download the latest OWASP CRS from GitHub and extract the rules into **/usr/local** or another location of your choice.

    ```none
    wget https://github.com/SpiderLabs/owasp-modsecurity-crs/archive/v3.0.2.tar.gz
    tar -xzvf v3.0.2.tar.gz
    sudo mv owasp-modsecurity-crs-3.0.2 /usr/local
    ```

2. Create the **crs‑setup.conf** file as a copy of **crs‑setup.conf.example**.

    ```none
    cd /usr/local/owasp-modsecurity-crs-3.0.2
    sudo cp crs-setup.conf.example crs-setup.conf
    ```

3. Add `Include` directives in the main NGINX ModSecurity WAF configuration file (**/etc/nginx/modsec/main.conf**, created in Step 4 of [Installing the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-installation-logging.md#protecting-the-demo-web-application" >}}) in the installation chapter, to read in the CRS configuration and rules. Comment out any other rules that might already exist in the file, such as the sample `SecRule` directive created in that step.

    ```nginx
    # Include the recommended configuration
    Include /etc/nginx/modsec/modsecurity.conf
    # OWASP CRS v3 rules
    Include /usr/local/owasp-modsecurity-crs-3.0.2/crs-setup.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-901-INITIALIZATION.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-905-COMMON-EXCEPTIONS.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-910-IP-REPUTATION.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-911-METHOD-ENFORCEMENT.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-912-DOS-PROTECTION.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-913-SCANNER-DETECTION.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-920-PROTOCOL-ENFORCEMENT.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-921-PROTOCOL-ATTACK.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-930-APPLICATION-ATTACK-LFI.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-931-APPLICATION-ATTACK-RFI.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-932-APPLICATION-ATTACK-RCE.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-933-APPLICATION-ATTACK-PHP.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-941-APPLICATION-ATTACK-XSS.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-942-APPLICATION-ATTACK-SQLI.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/REQUEST-949-BLOCKING-EVALUATION.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/RESPONSE-950-DATA-LEAKAGES.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/RESPONSE-951-DATA-LEAKAGES-SQL.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/RESPONSE-952-DATA-LEAKAGES-JAVA.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/RESPONSE-953-DATA-LEAKAGES-PHP.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/RESPONSE-954-DATA-LEAKAGES-IIS.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/RESPONSE-959-BLOCKING-EVALUATION.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/RESPONSE-980-CORRELATION.conf
    Include /usr/local/owasp-modsecurity-crs-3.0.2/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
    ```

4. Reload the NGINX Plus configuration.

    ```none
    sudo nginx -s reload
    ```

<span id="waf-owasp_test"></span>

## Testing the CRS

In this section, we explore how rules in the CRS block Nikto’s requests based on particular characteristics of the requests. Our ultimate goal is to show that the CRS blocks all of Nikto’s requests, so that none of the vulnerabilities Nikto detects are left open for attackers to exploit.

<span id="waf-owasp_test-user-agent"></span>

### Disabling Blocking of Requests Based on the `User‑Agent` Header

The CRS recognizes requests from scanners, including Nikto, by inspecting the <span style="white-space: nowrap;">`User-Agent`</span> header. As shown in the following output, the CRS comes preconfigured to block requests that have the default <span style="white-space: nowrap;">`User-Agent`</span> header for Nikto (`Nikto`).

```none
$ curl -H "User-Agent: Nikto" http://localhost/
<html>
<head><title>403 Forbidden</title></head>
<body bgcolor="white">
<center><h1>403 Forbidden</h1></center>
<hr><center>nginx/1.17.10</center>
</body>
</html>
```

(If you want to see exactly how the CRS ranks and blocks requests based on the `User‑Agent` header and related characteristics of requests from scanners, you can correlate the rule ID numbers found in the NGINX error log with the rules in the CRS’s Scanner Detection rule set, <span style="white-space: nowrap;">**REQUEST-913-SCANNER-DETECTION.conf**</span>.)

During this testing phase we don’t want to block all requests from Nikto, because we’re using them to detect possible vulnerabilities in our demo app. To stop the CRS from blocking requests just because their <span style="white-space: nowrap;">`User-Agent`</span> header is `Nikto`, we reconfigure Nikto not to include `Nikto` and related values in the header. Comment out the current setting for `USERAGENT` in **program/nikto.conf** and replace it with the value shown:

```nginx
# USERAGENT=Mozilla/5.00 (Nikto/@VERSION) (Evasions:@EVASIONS) (Test:@TESTID)
USERAGENT=Mozilla/5.00
```

<span id="waf-owasp_test-files"></span>

### Eliminating Requests for Vulnerable Files

When we rerun Nikto against the web application, we see that only 116 of Nikto’s requests get through to the application server, compared to 324 when the CRS wasn’t enabled. This indicates that the CRS is protecting our application from a large proportion of the vulnerabilities exposed by Nikto’s requests.

```none
$ perl program/nikto.pl -h localhost
...
+ 7531 requests: 0 error(s) and 116 item(s) reported on remote host
```

The output from Nikto is very long and so far we have been truncating it to show just the final line, where the number of items is reported. When we look at the output more closely, we see that many of the remaining 116 items refer to a vulnerable file in the application, as in this example:

```none
$ perl program/nikto.pl -h localhost
...
+ /site.tar: Potentially interesting archive/cert file found.
...
+ 7531 requests: 0 error(s) and 116 item(s) reported on remote host
```

Recall that in [Installing the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-installation-logging.md" >}}), we configured our demo application to return status code `200` for every request, without actually ever delivering a file. Nikto is interpreting these `200` status codes to mean that the file it is requesting actually exists, which in the context of our application is a false positive.

Now we eliminate such requests so we can better see where actual vulnerabilities might exist. Disable the requests by adding `‑sitefiles` in **program/nikto.conf** as shown:

```nginx
# Default plug-in macros
# Remove plug-ins designed to be run standalone
@@EXTRAS=dictionary;siebel;embedded
@@DEFAULT=@@ALL;-@@EXTRAS;tests(report:500);-sitefiles
```

<span id="waf-owasp_test-xss"></span>

### Blocking Requests with XSS Attempts

When we rerun Nikto again, it reports only 26 items:

```none
$ perl program/nikto.pl -h localhost
- Nikto v2.1.6
...
+ 7435 requests: 0 error(s) and 26 item(s) reported on remote host
```

Most of the 26 items arise because the OWASP CRS is not currently configured to block requests that contain XSS attempts in the request URL, such as

```html
<script>alert('Vulnerable')</script>
```

To block requests with XSS attempts, edit rules 941160 and 941320 in the CRS’s XSS Application Attack rule set <span style="white-space: nowrap;">(**REQUEST-941-APPLICATION-ATTACK-XSS.conf**)</span> by adding `REQUEST_URI` at the start of the variables list for each rule:

```nginx
SecRule REQUEST_URI|REQUEST_COOKIES|!REQUEST_COOKIES:/__utm/ ...
```

Reload the NGINX Plus configuration to read in the revised rule set:

```none
sudo nginx -s reload
```

When we rerun Nikto, it reports only four items, and they are false positives for our application.

```none
$ perl program/nikto.pl -h localhost
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ /smg_Smxcfg30.exe?vcc=3560121183d3: This may be a Trend Micro Officescan 'backdoor'.
+ 7435 requests: 0 error(s) and 4 item(s) reported on remote host
```

<span id="waf-owasp_limitations"></span>

## Limitations

Inspecting the response body is not supported, so rules that do so have no effect.

<span id="waf-owasp_conclusion"></span>

## Conclusion

We used the OWASP ModSecurity Core Rule Set to protect our web application against a wide range of generic attacks and saw how the CRS blocks malicious requests generated by the Nikto scanning tool.

For imformation about another supported ModSecurity rule set, see [Using the ModSecurity Rules from Trustwave SpiderLabs with the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-trustwave-spiderlabs-rules.md" >}}).

<span id="waf-owasp_resources"></span>

## Resources

- [OWASP ModSecurity Core Rule Set (CRS)](https://owasp.org/www-project-modsecurity-core-rule-set/)
- [Nikto scanning tool](https://github.com/sullo/nikto)
- [ModSecurity Reference Manual](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-v2.x#ModSecurityreg_Reference_Manual)
