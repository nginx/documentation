---
title: Use a certificate from Google Cloud Secret Manager
weight: 50
toc: true
url: /nginxaas/google/quickstart/security-controls/certificates/
type:
- how-to
---


## Overview

This guide describes how to use a TLS/SSL certificate stored in Google Cloud Secret Manager with NGINXaaS for Google Cloud.

## Before you begin

- [Create a secret in Google Cloud Secret Manager](https://cloud.google.com/secret-manager/docs/creating-and-accessing-secrets)
that contains your TLS/SSL certificate and private key.
- Ensure that the NGINXaaS for Google Cloud service account has permission to access the secret. For more information, see
[Granting, changing, and revoking access to secrets] (https://cloud.google.com/iam/docs/granting-changing-revoking-access).


## Configure NGINXaaS to use the certificate

TBD