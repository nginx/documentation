---
title: Unit 1.34.1 Released
weight: 1000
---

We are pleased to announce the release of NGINX Unit 1.34.1. This is a
maintenance release that fixes stability issues caused by the
OpenTelemetry (OTEL) support that was added in the previous release.

- It addresses instability issues resulting in Unit segmentation
  faulting when OTEL was not actually configured.
- It addresses issues of not being able to build Unit with OTEL support
  on various platforms, including macOS.

## Full Changelog

```none
Changes with Unit 1.34.1                                      10 Jan 2025

    *) Bugfix: fix instability issues due to OpenTelemetry (OTEL) support.

    *) Bugfix: fix issues with building OpenTelemetry (OTEL) support on
       various platforms, including macOS.
```
