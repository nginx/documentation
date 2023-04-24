---
authors: []
categories:
- installation
description: Follow these steps to license your NGINX Controller
docs: DOCS-787
doctypes:
- task
draft: false
journeys:
- getting started
- using
- renewing
personas:
- devops
roles:
- admin
tags:
- docs
title: License NGINX Controller
toc: true
weight: 120
---

## Overview

This topic explains how to upload and manage licenses for NGINX Controller.

&nbsp;

---

## License Types

NGINX Controller licenses can be either connected or disconnected licenses:

- A **connected license** sends telemetry data to F5, which enables pricing based on usage. When adding a connected license, you must provide a customer Association Token, which you can get from the [MyF5 Customer Portal](https://account.f5.com/myf5).
- A **disconnected license** doesn't send telemetry data to F5. To add a disconnected license, you can upload the license file using the NGINX Controller web interface or the NGINX Controller API.

&nbsp;

---

## Get Your License

To access your license, get your Customer Access Token, or sign up for a trial license, visit the [MyF5 Customer Portal](https://account.f5.com/myf5).

&nbsp;

---

## Add or Update a License

{{< include "licensing/add-update-license.md" >}}

&nbsp;

---

## View License Details

{{< include "licensing/get-license-info.md" >}}

&nbsp;

---

## Delete a License

{{< include "licensing/delete-license.md" >}}

&nbsp;

---

## License Features

{{< include "licensing/license-features.md" >}}

&nbsp;

---

## Licensing FAQs

{{< include "licensing/licensing-faq.md" >}}

&nbsp;

---

## Troubleshoot Licensing Issues

{{< include "licensing/troubleshoot-license.md" >}}

&nbsp;

---

## What's Next

- [Download the NGINX Plus Cert and Key Bundle]({{< relref "/admin-guides/install/get-n-plus-cert-and-key.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
