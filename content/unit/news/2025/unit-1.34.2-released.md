---
title: Unit 1.34.2 Released
weight: 900
---

We are pleased to announce the release of NGINX Unit 1.34.2. This is a maintenance release that fixes a couple of issues in the Java WebSocket code within the Java language module.

- Security: When the NGINX Unit Java Language module is in use, undisclosed requests can lead to an infinite loop and cause an increase in CPU resource utilization (CVE-2025-1695).

## Full Changelog

```none
Changes with Unit 1.34.2                                         26 Feb 2025

    *) Security: fix missing websocket payload length validation in the Java
       language module which could lead to Java language module processes
       consuming excess CPU. (CVE-2025-1695).

    *) Bugfix: fix incorrect websocket payload length calculation in the
       Java language module.
```
