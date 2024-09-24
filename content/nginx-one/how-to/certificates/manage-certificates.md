---
docs: 
doctypes:
    - task
tags:
    - docs
title: Manage certificates
toc: true
weight: 100
---


## Overview

This guide explains how you can manage SSL/TLS certificates the F5 NGINX One Console. Valid certificates support encrypted connections between NGINX and your users. 

For more information on how you can use these certificates to secure your servers, see the [Security controls](https://docs.nginx.com/nginx/admin-guide/security-controls/) associated with F5 NGINX Plus.

## Before you start

Before you create and manage certificates at the NGINX One Console ensure:

- You have access to the NGINX One Console
- You have the necessary permissions to create and manage SSL/TLS certificates
- Your SSL/TLS certificates and keys match

When this document refers to certificates, it normally also refers to the corresponding key. If you have an NGINX subscription, 
log in to https://my.f5.com/ and download the following files:

- SSL Certificate (with a `.crt` file extension)
- Private Key (with a `.key` file extension)

## Important considerations


## Review existing certificates

Follow these steps to review existing certificates for your instances. 

On the left-hand pane, select Certificates. In the window that appears, you see:

- Certificate Status. This includes:

  - Total number of certificates
  - Valid certificates that expire more than 30 days from now
  - Valid certificates that expire within the next 30 days
  - Expired certificates

- Management Status

  - Managed certificates can be administed remotely, from a deployment or through the API
  - Unmanaged certificates are listed. While you can convert an unmanaged certificate to managed, you may have to repeat installing the certificate and key

You can **Add Filter** to filter certificates by Name, Status, Subject Name, and Type

{{<bootstrap-table "table table-striped table-bordered">}}

| Distribution                       | Version        | Architecture           |
|------------------------------------|----------------|------------------------|
| CentOS                             | 7.4+           | x86_64, aarch64        |
| Oracle Linux                       | 7.4+           | x86_64                 |
| Red Hat Enterprise Linux           | 7.4+           | x86_64, aarch64        |

{{</bootstrap-table>}}

The Export option supports exports of basic certification information to a CSV file. It does _not_ include the content of the public certificate or the private key.

## Add a new certificate

To add a new certificate, select **Add Certificate**. You can add certificates in the following formats:

- **SSL Certificate and Key**
- **CA Certificate Bundle**

In each case, you can upload files directly, or enter the content of the certificates in a text box.

## Edit an existing certificate

## Managed and unmanaged certificates

