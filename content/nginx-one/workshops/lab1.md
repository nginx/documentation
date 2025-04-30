---
# We use sentence case and present imperative tone
title: "Lab1: NGINX One Console Introduction & Access"
# Weights are assigned in increments of 100: determines sorting order
weight: i00
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: tutorial
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: nginx-one
docs:
---

## Introduction

In this lab, you will be logging into NGINX One Console and exploring various components within it. This lab requires that you have access to F5 Distributed Cloud to work with the One Console. As part of this lab, you will explore the NGINX One Console product, as a quick Overview of what it is and how to access it.

<br/>

## Learning Objectives

By the end of the lab you will be able to:

- [Introduction](#introduction)
- [Learning Objectives](#learning-objectives)
- [Prerequisites](#prerequisites)
  - [NGINX One Console Introduction](#nginx-one-console-introduction)
  - [How it works](#how-it-works)
  - [Access and navigate NGINX One Console](#access-and-navigate-nginx-one-console)
  - [Create and manage data plane keys that would be used to manage NGINX instances](#create-and-manage-data-plane-keys-that-would-be-used-to-manage-nginx-instances)
  - [(Optional Exercise): Revoke a data plane key](#optional-exercise-revoke-a-data-plane-key)
  - [(Optional Exercise): Delete a data plane key](#optional-exercise-delete-a-data-plane-key)
- [References:](#references)
  - [Authors](#authors)

## Prerequisites

- You must have an F5 Distributed Cloud(XC) Account
- You must have enabled NGINX One service on F5 Distributed Cloud(XC)
- See `Lab0` for instructions on setting up your system for this Workshop
- Familiarity with basic Linux concepts and commands
- Familiarity with basic NGINX concepts and commands

<br/>

### NGINX One Console Introduction

The F5 NGINX One Console is a service which is part of the F5 Distributed Cloud, gives all NGINX users access to a SaaS experience for managing NGINX instances. The console lets you monitor and control your NGINX fleet from one place. You can check configurations, track performance metrics, identify security vulnerabilities, manage SSL certificates, and more.

The NGINX One Console is valuable because it simplifies the complexities of modern application delivery by integrating multiple functionalities into a single platform. This reduces the need for disparate tools, lowers operational overhead and costs, and ensures robust security for your applications. You will be able to accelerate application delivery and time-to-value like never before with SaaS capabilities.

NGINX One Console offers the following key benefits:

- **Centralized control:** Manage all your NGINX instances from a single console.
- **Enhanced monitoring and risk detection:** Automatically detect critical vulnerabilities (CVEs), verify SSL certificate statuses, and identify security issues in NGINX configurations.
- **Performance optimization:** Track your NGINX versions and receive recommendations for tuning your configurations for better performance.
- **Graphical Metrics Display:** Access a dashboard that shows key metrics for your NGINX instances, including instance availability, version distribution, system health, and utilization trends.
- **Real-time alerts:** Receive alerts about critical issues.

### How it works


The NGINX One Console requires `NGINX Agent`, an open source software module written by NGINX that connects and communicates with NGINX One Console.  This NGINX Agent must be installed and running on every NGINX instance that you wish to manage with NGINX One Console.  You will use the publicly available NGINX with Agent images from Docker Hub for your NGINX OSS containers.  In addition, as part of your Docker Compose file, your NGINX Plus containers already have the required `NGINX Agent` installed for you.  NGINX Agent can also be installed using regular Linux package managers like `apt` and `yum`.  Refer to the References Section for links to the NGINX Agent installation guides.

### Access and navigate NGINX One Console

1. Login into the F5 Distributed Cloud console using your account credentials. The login page can be found at: https://console.ves.volterra.io/login/start

   {{< img src="nginx-one/labs/lab-01/lab1_xc-login.png" alt="<Alternative text>">}}

1. Once logged in, the "home" screen shows you various tiles which represent F5 Distributed Cloud console features. In this lab, we'll focus on the `NGINX One` Console tile as highlighted in the below screenshot.

    {{< img src="nginx-one/labs/lab-01/lab1_none-tile.png" alt="<Alternative text>">}}

1. Click on the `NGINX One` Console tile from the home screen. The NGINX One Console "welcome" screen will appear. Make sure the NGINX One Console status shows `green - Enabled` as highlighted in below screenshot.  Click on `Visit Service`.  If it is not enabled, you must request access from your F5 Distributed Cloud admin.

    {{< img src="nginx-one/labs/lab-01/lab1_none-service.png" alt="<Alternative text>">}}

2. By default, this will bring you to the NGINX One Console `Overview Dashboard` page. As no NGINX Instances are being managed by NGINX One Console you are seeing the blank dashboard as shown in below screenshot.

    {{< img src="nginx-one/labs/lab-01/lab1_none-empty-overview-dashboard.png" alt="<Alternative text>">}}

    Once you add different NGINX Instance in the next section, this Dashboard would get populated by useful insights as depicted in below sample dashboard screenshot.

    {{< img src="nginx-one/labs/lab-01/lab1_none-overview-dashboard.png" alt="<Alternative text>">}}

<br/>

### Create and manage data plane keys that would be used to manage NGINX instances

1. Within the NGINX One Console, click on `Manage > Data Plane Keys`. This would show all the Data Plane keys that you currently have.

    ![Dataplane key](../media/lab1/lab1_none-dataplane-key-overview.png)

1. Click on `Add Data Plane Key` to create a new Dataplane key. This should open an `Add Data Plane Key` window. Provide a name of your choice for the new key. By default, the expiration date is set for a year. You can modify the expiration data as per your preference or keep the defaults for this workshop. Click on `Generate` to create your new key.

    ![New Dataplane key](../media/lab1/lab1_none-dataplane-key-new.png)

    Once the key is generated, copy the value of this key to the clipboard using the `Copy` icon on the right side.  

    > **NOTE:**  This Dataplane Key is only shown here and NGINX One Console doesn't save this value. Save this value locally as you would be using it to register new NGINX Instances.  You can Register as many NGINX Instances as you like with the same Dataplane Key.  If you lose the value of the key then you need to generate a new one again.

    ![New Dataplane key save](../media/lab1/lab1_none-dataplane-key-save.png)

1. Once you have saved the key locally for future use, click the `Close` button to finish the Data plane key creation process.

<br/>

### (Optional Exercise): Revoke a data plane key

1. To revoke the data plane key, search the key that you would like to revoke within the Data Plane Keys Page and then click on the key. This should open a new overlay window on the right side as shown in below screenshot. Click on `Revoke` button. In the next confirmation window, again click on `Revoke` button to disable the data plane key.

    ![Revoke Dataplane Key](../media/lab1/lab1_none-dataplane-key-revoke1.png)
    ![Confirm Revoke](../media/lab1/lab1_none-dataplane-key-revoke2.png)

### (Optional Exercise): Delete a data plane key

1. Active keys cannot be directly deleted. The key must first be revoked and then can be deleted.

1. You can delete a revoked data plane key by opening the Data Plane Keys Page and then navigating to the `Revoked Keys` tab. This view should list all the revoked keys.

    ![Revoke key list](../media/lab1/lab1_none-dataplane-key-revoke-list.png)

    To delete a particular revoked key, select the key and then click on `Delete Selected` button. In the next confirmation window, again click on `Delete` button to delete the data plane key.

    ![Delete key](../media/lab1/lab1_none-dataplane-key-delete1.png)
    ![Delete key confirmation](../media/lab1/lab1_none-dataplane-key-delete2.png)

<br/>

This ends lab1.

<br/>

## References:

- [NGINX One Console](https://docs.nginx.com/nginx-one/)
- [NGINX Agent](https://docs.nginx.com/nginx-agent/overview/)

<br/>

### Authors

- Chris Akker - Solutions Architect - Community and Alliances @ F5, Inc.
- Shouvik Dutta - Solutions Architect - Community and Alliances @ F5, Inc.
- Adam Currier - Solutions Architect - Community and Alliances @ F5, Inc.

-------------

Navigate to ([Lab2](../lab2/readme.md) | [LabGuide](../readme.md))

