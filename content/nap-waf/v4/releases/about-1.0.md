---
title: F5 WAF for NGINX 1.0
weight: 1060
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-649
---

May 19, 2020

### Security Features

- OWASP Top 10 based attack signatures & CVEs
- Metacharacter checking
- HTTP protocol compliance
- Evasion techniques
- Disallowed file types (bin, cgi, cmd, com, dll, exe, msi, sys, shtm, shtml, stm & more)
- Enforcement based on risk score (Violation Rating)
- Cookie integrity check
- JSON & XML well-formedness
- Sensitive parameters & Data Guard
- gRPC protocol support

### OS Distribution

- CentOS 7.4+ (64bit)
- Debian 9 (64bit)

### Supported Versions

NGINX Plus R19 and later

### Supported Packages

#### App Protect

##### Debian

- app-protect_19+2.52.1-1~stretch_amd64.deb
- app-protect_20+2.52.1-1~stretch_amd64.deb
- app-protect_21+2.52.1-1~stretch_amd64.deb

##### CentOS

- app-protect-19+2.52.1-1.el7.ngx.x86_64.rpm
- app-protect-20+2.52.1-1.el7.ngx.x86_64.rpm
- app-protect-21+2.52.1-1.el7.ngx.x86_64.rpm

#### Attack Signatures

##### Debian

- from app-protect-attack-signatures_2019.07.16-1~stretch_amd64.deb (original installed, to allow downgrade)

##### CentOS

- from app-protect-attack-signatures-2019.07.16-1.el7.ngx.x86_64.rpm (original installed, to allow downgrade)


### Known Issues

#### 1341 - Syslog Clock

The time stamps in the NGINX and F5 WAF for NGINX log messages are presented in the local time zone of your machine. If you would like to see this in a different time zone, for example UTC, you must change the local time zone. On most systems this can be done using the command:

```shell
sudo datetimectl set-timezone Etc/UTC
```

For other options to change the timezone see your system manual.

#### General - `proxy_pass` buffering

The `proxy_pass` directive must always be used.
`proxy_request_buffering off` is not supported.
