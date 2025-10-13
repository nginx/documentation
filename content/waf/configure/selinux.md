---
# We use sentence case and present imperative tone
title: "Configure SELinux"
# Weights are assigned in increments of 100: determines sorting order
weight: 500
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

The default settings for Security-Enhanced Linux (SELinux) on modern Red Hat Enterprise Linux (RHEL) and related distros can be very strict, prioritizing security over user convenience.

To ensure F5 WAF for NGINX operates smoothly without compromising security, consider setting up a custom SELinux policy or AppArmor profile. 

For troubleshooting, you may use permissive (SELinux) or complain (AppArmor) mode to avoid these restrictions, but this is inadvisable for prolonged use.

Although F5 WAF for NGINX provides an optional package with prebuilt a SELinux policy (`app-protect-selinux`), your specific configuration might be blocked unless you adjust the policy or modify file labels.

{{< call-out "note" >}}

You may want to read the [Using NGINX and NGINX Plus with SELinux](https://www.f5.com/company/blog/nginx/using-nginx-plus-with-selinux) blog post for more information.

{{< /call-out >}}

## Modifying file labels

If you plan to store your security policy files in an alternative folder such as _/etc/security_policies_, you should change the default SELinux file context:

```shell
semanage fcontext -a -t nap-compiler_conf_t /etc/security_policies
restorecon -Rv /etc/security_policies
```

## Redirecting syslog to a custom port

If you want to send logs to a custom, unreserved port, you can use `semanage` to add the desired port to the syslogd_port_t type:

```shell
semanage port -a -t syslogd_port_t -p tcp <your-port>
```

Review the syslog ports by entering the following command:

```shell
semanage port -l | grep syslog
```

For more information related to syslog, see the [Security logs]({{< ref "/waf/logging/security-logs.md" >}}) topic.

## Review audits

F5 WAF for NGINX files and processes are labelled with the `nap-compiler_t` and `nap-engine_t` contexts. NGINX Plus is labelled with `httpd_t`.

If SELinux denies access to something, you can search audit denials using one of the above contexts.

```shell
ausearch --start recent -m avc --raw -se nap-engine_t
```

The _--start recent_ argument searches the previous 10 minutes.