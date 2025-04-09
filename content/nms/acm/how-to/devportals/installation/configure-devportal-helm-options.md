---
description: 'This guide lists and describes the parameters you can set when deploying
  the Developer Portal from a Helm chart. '
docs: DOCS-1171
title: Deployment Options for Developer Portal Helm
toc: true
weight: 25
type:
- how-to
---

{{< shortversions "1.3.0" "latest" "acmvers" >}}

## Default Developer Portal Helm Settings {#default-devportal-helm-settings}

This topic lists the default values that are used when [installing the Developer Portal from a Helm chart]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md" >}}). You can change these values to meet your specific needs.

{{< include "installation/helm/acm/dev-portal-helm-configurations/configuration-options.md" >}}

---

## Common Deployment Configurations {#common-deployment-configs}

### Deploy Developer Portal with an SQLite database

{{< include "installation/helm/acm/dev-portal-helm-configurations/configure-helm-devportal-sqlite.md" >}}

### Deploy Developer Portal with an embedded PostgreSQL database

{{< include "installation/helm/acm/dev-portal-helm-configurations/configure-devportal-helm-embedded-postgres.md" >}}

### Deploy Developer Portal with an external PostgreSQL database

{{< include "installation/helm/acm/dev-portal-helm-configurations/configure-devportal-helm-external-postgres.md" >}}

### Deploy Developer Portal using TLS for the backend API service

{{< include "installation/helm/acm/dev-portal-helm-configurations/configure-devportal-helm-api-mtls.md" >}}
