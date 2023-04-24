---
authors: []
categories:
- installation
- infrastructure
date: "2020-10-26T15:32:41-06:00"
description: Learn how to deploy an AWS NGINX instance using NGINX Controller.
docs: DOCS-768
doctypes:
- tutorial
draft: false
journeys:
- getting started
- using
personas:
- devops
roles:
- admin
tags:
- docs
title: Add an AWS NGINX Instance
toc: true
weight: 30
---

## Overview



You can use NGINX Controller to deploy and manage NGINX instances on Amazon Web Services (AWS).

This tutorial explains how to deploy NGINX Plus on AWS by defining an AWS Integration, a Location, and an Instance Template in NGINX Controller.

{{< important >}}

You are responsible for applying software and security updates on your data plane Instances. NGINX Controller does not manage these updates for you.

{{< /important >}}

&nbsp;


---

## Create an AWS Integration



Integrations give NGINX Controller permission to deploy and manage NGINX instances on external systems, such as cloud providers like AWS.

### Prerequisites

{{< include "integrations/aws-integration-requirements.md" >}}

### Steps

{{< include "integrations/add-aws-integration.md" >}}

&nbsp;


---

## Create a Location

After you've [created an Integration for AWS](#create-an-aws-integration), the next step is to create a Location. Locations are a way to logically group your NGINX Plus instances by their physical locations.



{{< include "locations/add-aws-location.md" >}}

&nbsp;


---

## Create an Instance Template for AWS NGINX Instances



An [Instance Template]({{< relref "/infrastructure/instances/manage-instance-templates.md" >}}) defines the parameters to use when creating an NGINX instance. Instance templates are ideal for cloud orchestration and make managing your cloud resources easy and quick.

### Prerequisites

{{< include "instance-templates/aws-instance-template-requirements.md" >}}

### Steps

{{< include "instance-templates/add-aws-instance-template.md" >}}

&nbsp;


---

## Add an AWS NGINX Instance to NGINX Controller

Now that you've [defined a Location](#create-a-location) and [made an Instance Template](#create-an-instance-template-for-aws-nginx-instances) for an  NGINX instance on AWS, you're ready to add the instance to  NGINX Controller.



{{< include "instances/add-aws-nginx-instance.md" >}}

&nbsp;


---

## Troubleshooting



{{< include "support/failed-to-download-install-script-for-agent.md" >}}

&nbsp;


---

## What's Next

- [Manage Your NGINX Instances]({{< relref "/infrastructure/instances/manage-instances.md#add-an-existing-instance" >}})
- [Add, Edit, and Update Locations]({{< relref "/infrastructure/locations/manage-locations.md" >}})
- [View Performance Reports for Your Instances]({{< relref "/infrastructure/instances/analyzer.md" >}})
- [Deploy an App]({{< relref "/app-delivery/deploy-simple-app.md" >}})

{{< versions "3.6" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
