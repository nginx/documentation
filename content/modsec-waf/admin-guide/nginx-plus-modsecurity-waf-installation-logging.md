---
docs: DOCS-726
title: Installing the NGINX ModSecurity WAF
toc: true
weight: 100
---

{{< important >}}
{{% modsec-eol-notice %}}
{{< /important >}}

This chapter explains how to install the F5 NGINX ModSecurity web application firewall (WAF), configure a simple rule, and set up logging. The NGINX ModSecurity WAF is the NGINX Plus build of ModSecurity. The NGINX ModSecurity WAF was previously called the NGINX WAF, and the NGINX Plus with ModSecurity WAF before that.

<span id="waf-install_overview"></span>

## Overview


<a href="https://docs.nginx.com/nginx/releases/#nginx-plus-release-12-r12">NGINX Plus Release 12</a> and later supports the NGINX ModSecurity WAF. The NGINX ModSecurity WAF protects web applications against SQL Injection (SQLi), Remote Code Execution (RCE), Local File Include (LFI), cross&#8209;site scripting (XSS), and many other attacks.

This chapter explains how to install the NGINX ModSecurity WAF, presents a sample configuration of a simple rule, and sets up logging. For information about rule sets, see:

- [Using the OWASP CRS with the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-owasp-crs.md" >}})
- [Using the ModSecurity Rules from Trustwave SpiderLabs with the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-trustwave-spiderlabs-rules.md" >}})

<span id="waf-install_prereq"></span>

## Prerequisites

The NGINX ModSecurity WAF is available to NGINX Plus customers as a downloaded dynamic module at an additional cost. You can [try the NGINX ModSecurity WAF free for 30 days](https://www.nginx.com/free-trial-request/). To purchase or add the NGINX ModSecurity WAF to an existing NGINX Plus subscription, [contact the NGINX sales team](https://www.nginx.com/contact-sales).

<span id="waf-install_installing"></span>

## Installing the NGINX ModSecurity WAF

To install the NGINX ModSecurity WAF dynamic module, perform the following steps.

1. Your package management software uses a repo key to access the NGINX Plus repositories. Follow our [instructions](https://cs.nginx.com/repo_setup) to install a repo key that enables access to the **nginx-plus-module-modsecurity** repository.

2. Update your package manager’s view of the NGINX Plus repository:

    - Ubuntu and Debian systems:

      ```none
      sudo apt-get clean ; sudo apt-get update
      ```

    - Red Hat Enterprise Linux (RHEL) and CentOS systems:

      ```none
      sudo yum clean expire-cache
      ```

3. Use the OS package management utility to install the dynamic module from the NGINX Plus module repository:

    - Ubuntu and Debian systems:

      ```none
      sudo apt-get install nginx-plus-module-modsecurity
      ```

    - RHEL and CentOS systems:

      ```none
      sudo yum install nginx-plus-module-modsecurity
      ```

4. Add the following line in the top‑level (“main”) context of **/etc/nginx/nginx.conf** :

    ```none
    load_module modules/ngx_http_modsecurity_module.so;
    ```

5. Run the following command to verify that the module loads successfully, as confirmed by the indicated output:

    ```none
    $ sudo nginx -t
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    ```

<span id="waf-install_example"></span>

## Example: Configuring the NGINX ModSecurity WAF with a Simple Rule

In this example we configure a simple ModSecurity rule to block certain requests to a demo application. NGINX Plus acts as the reverse proxy in the example, but the same configuration applies to load balancing. The demo application is simply an NGINX Plus virtual server that returns status code `200` and a text message. It serves as the demo application in the [chapters about using rule sets](#waf-install_overview) with the NGINX ModSecurity WAF as well.

<span id="waf-install_demo-app"></span>

### Creating the Demo Web Application

Create the demo web application by configuring an NGINX Plus virtual server.

1. Create the file **/etc/nginx/conf.d/echo.conf** with the following content. It configures a “web server” that listens on localhost port 8085 and returns status code `200` and a message containing the requested URI.

    ```nginx
    server {
        listen localhost:8085;
        location / {
            default_type text/plain;
            return 200 "Thank you for requesting ${request_uri}\n";
        }
    }
    ```

2. Test the application by reloading the NGINX Plus configuration and making a request.

    ```none
    $ sudo nginx -s reload
    $ curl -D - http://localhost:8085
    HTTP/1.1 200 OK
    Server: nginx/1.17.10
    Date: Wed, 6 May 2020 08:55:29 GMT
    Content-Type: text/plain
    Content-Length: 27
    Connection: keep-alive
    Thank you for requesting /
    ```

<span id="waf-install_reverse-proxy"></span>

### Configuring NGINX Plus as a Reverse Proxy

Configure NGINX Plus as a reverse proxy for the demo application.

1. Create the file **/etc/nginx/conf.d/proxy.conf** with the following content. It configures a virtual server that listens on port 80 and proxies all requests to the [demo application](#waf-install_demo-app).

    ```nginx
    server {
        listen 80;
        location / {
            proxy_pass http://localhost:8085;
            proxy_set_header Host $host;
        }
    }
    ```

    **Note:** If any other virtual servers ([`server {}`](https://nginx.org/en/docs/http/ngx_http_core_module.html#server) blocks) in your NGINX Plus configuration listen on port 80, you need to disable them for the reverse proxy to work correctly. For example, the **/etc/nginx/conf.d/default.conf** file provided in the **nginx‑plus** package includes such a `server {}` block. Comment out or remove the `server {}` block, but do not remove or rename the **default.conf** file itself – if the file is missing during an upgrade, it is automatically restored, which can break the reverse&#8209;proxy configuration.

2. Reload the NGINX Plus configuration.

    ```none
    sudo nginx -s reload
    ```

3. Verify that a request succeeds, which confirms that the proxy is working correctly.

    ```none
    $ curl -D - http://localhost
    HTTP/1.1 200 OK
    Server: nginx/1.17.10
    Date: Wed, 6 May 2020 08:58:02 GMT
    Content-Type: text/plain
    Content-Length: 27
    Connection: keep-alive
    Thank you for requesting /
    ```

<span id="waf-install_protect-demo"></span>

### Protecting the Demo Web Application

Configure the NGINX ModSecurity WAF to protect the demo web application by blocking certain requests.

1. Create the folder **/etc/nginx/modsec** for storing NGINX ModSecurity WAF configuration:

    ```none
    sudo mkdir /etc/nginx/modsec
    ```

2. Download the file of recommended ModSecurity configuration from the **v3/master** branch of the ModSecurity GitHub repo and name it **modsecurity.conf**:

    ```none
    cd /etc/nginx/modsec
    sudo wget https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended
    sudo mv modsecurity.conf-recommended modsecurity.conf
    ```

3. Enable execution of rules by commenting out the existing `SecRuleEngine` directive in **modsecurity.conf** and adding the indicated directive. We will define the sample rule in the next step.

    ```nginx
    # SecRuleEngine DetectionOnly
    SecRuleEngine On
    ```

    For more information about the `SecRuleEngine` directive, see the [ModSecurity documentation](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v2.x)#SecRuleEngine).

    <span id="waf-install_rule-1234"></span>
4. Create the main NGINX ModSecurity WAF configuration file, **/etc/nginx/modsec/main.conf**, and define a rule in it:

    ```nginx
    # Include the recommended configuration
    Include /etc/nginx/modsec/modsecurity.conf
    # A test rule
    SecRule ARGS:testparam "@contains test" "id:1234,deny,log,status:403"
    ```

    - `Include` – Includes the recommended configuration from the **modsecurity.conf** file.
    - `SecRule` – Creates a rule that protects the application by blocking requests and returning status code `403` when the `testparam` parameter in the query string contains the string `test`.

    For more information about the `SecRule` directive, see the [ModSecurity documentation](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v2.x)#SecRule).

5. Change the reverse proxy configuration file (**/etc/nginx/conf.d/proxy.conf**) to enable the NGINX ModSecurity WAF:

    ```nginx
    server {
        listen 80;
        modsecurity on;
        modsecurity_rules_file /etc/nginx/modsec/main.conf;
        location / {
            proxy_pass http://localhost:8085;
            proxy_set_header Host $host;
        }
    }
    ```

    - `modsecurity on` – Enables the NGINX ModSecurity WAF.
    - `modsecurity_rules_file` – Specifies the location of the NGINX ModSecurity WAF configuration file.

    Documentation for `modsecurity*` directives in the NGINX Plus configuration file is available on [GitHub](https://github.com/SpiderLabs/ModSecurity-nginx#usage).

6. Reload the NGINX Plus configuration:

    ```none
    sudo nginx -s reload
    ```

7. Verify that the rule configured in Step 4 works correctly, by making a request that includes the string `test` in the value of the query string `testparam` parameter.

    ```none
    $ curl -D - http://localhost/foo?testparam=thisisatestofmodsecurity
    HTTP/1.1 403 Forbidden
    Server: nginx/1.17.10
    Date: Wed, 6 May 2020 09:00:48 GMT
    Content-Type: text/html
    Content-Length: 170
    Connection: keep-alive
    <html>
    <head><title>403 Forbidden</title></head>
    <body bgcolor="white">
    <center><h1>403 Forbidden</h1></center>
    <hr/><center>nginx/1.11.10</center>
    </body>
    </html>
    ```

    The request returns status code `403`, confirming that the NGINX ModSecurity WAF is enabled and executing the rule.

<span id="waf-install_logging"></span>

## Setting Up Logging

By default, the NGINX ModSecurity WAF logs its activity to the NGINX Plus error log, at the `warn` level for blocked requests and the `info` level for other messages. The [`error_log`](https://nginx.org/en/docs/ngx_core_module.html#error_log) directive in the main **/etc/nginx/nginx.conf** file provided with NGINX Plus is configured to write messages to **/var/log/nginx/error.log** at the `warn` level and higher. If you want to capture all messages from the NGINX ModSecurity WAF, you need to set the logging level to `info` instead.

```nginx
error_log /var/log/nginx/error.log info;
```

**Note:** Your existing configuration might include definitions for multiple error logs, in files other than **nginx.conf** and placed in more specific contexts, such as a [`location`](http://nginx.org/en/docs/http/ngx_http_core_module.html#location) block. Make sure to update all the relevant `error_log` directives.

For the request blocked by the rule defined in [Step 4](#waf-install_rule-1234) of the previous section, the following message appears in the error log. The <span style="white-space: nowrap;">`[id "1234"]`</span> field identifies the rule that blocked the request.

```none
2020/05/06 09:00:48 [warn] 1504#1504: *5 [client 127.0.0.1] ModSecurity: Access denied with code 403 (phase 1). Matched "Operator `Contains' with parameter `test' against variable `ARGS:testparam' (Value: `thisisatestofmodsecurity' ) [file "/etc/nginx/modsec/main.conf"] [line "207"] [id "1234"] [rev ""] [msg ""] [data ""] [severity "0"] [ver ""] [maturity "0"] [accuracy "0"] [hostname "127.0.0.1"] [uri "/foo"] [unique_id "14931972481.000000"] [ref "o7,4v19,24"], client: 127.0.0.1, server: , request: "GET /foo?testparam=thisisatestofmodsecurity HTTP/1.1", host: "localhost"
```

<span id="waf-install_audit-debug"></span>

## Controlling Audit and Debug Logging

The NGINX ModSecurity WAF also supports audit logging as configured with the [`SecAudit*`](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v2.x)#SecAuditEngine) set of directives. Audit logging is enabled in the recommended configuration that we downloaded to **/etc/nginx/modsec/modsecurity.conf** (in Step 2 of the [previous section](#waf-install_protect-demo)), but we recommend disabling it in production environments, both because audit logging affects NGINX ModSecurity WAF performance and because the log file can grow large very quickly and exhaust disk space. To disable audit logging, change the value of the [`SecAuditEngine`](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v2.x)#SecAuditEngine) directive in **modsecurity.conf** to `off`.

```nginx
SecAuditEngine off
```

If you experience problems with the NGINX ModSecurity WAF, you can enable [debug logging](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-(v2.x)#SecDebugLog) by changing the `SecDebugLog` and `SecDebugLogLevel` directives in **modsecurity.conf** to the following values. Like audit logging, debug logging generates a large volume of output and affects NGINX ModSecurity WAF performance, so we recommend disabling it in production.

```nginx
SecDebugLog /tmp/modsec_debug.log
SecDebugLogLevel 9
```

<span id="waf-install_limitations"></span>

## Limitations

Please be aware of the following limitations:

- Rules that inspect the response body are not supported and are ignored if included in the configuration.
- Inclusion of the request and response body in the audit log is not supported.

<span id="waf-install_conclusion"></span>

## Conclusion

In this chapter, we installed the NGINX ModSecurity WAF for NGINX Plus, created a simple rule for quick testing, and set up logging of NGINX ModSecurity WAF activity.

The simple rule works correctly, but doesn’t provide any real protection to an application. See the following chapters for instructions on configuring rules for comprehensive application protection:

- [Using the OWASP CRS with the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-owasp-crs.md" >}})
- [Using the ModSecurity Rules from Trustwave SpiderLabs with the NGINX ModSecurity WAF]({{< ref "nginx-plus-modsecurity-waf-trustwave-spiderlabs-rules.md" >}})

<span id="waf-install_resources"></span>

## Resources

- [ModSecurity Reference Manual](https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-v2.x#ModSecurityreg_Reference_Manual)
- [ModSecurity v3 NGINX Connector](https://github.com/SpiderLabs/ModSecurity-nginx)
