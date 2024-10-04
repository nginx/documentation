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

This guide explains how you can manage SSL/TLS certificates with F5 NGINX One Console. Valid certificates support encrypted connections between NGINX and your users. 

For more information on how you can use these certificates to secure your servers, refer to the section on [NGINX SSL termination]({{< relref "../../../nginx/admin-guide/security-controls/terminating-ssl-http.md" >}}).

## Before you start

Before you add and manage certificates with NGINX One Console make sure:

- You have access to NGINX One Console
- You have the necessary permissions to create and manage SSL/TLS certificates
- Your SSL/TLS certificates and keys match

When this document refers to certificates, it normally also refers to the corresponding key. If you have an NGINX subscription, 
log in to https://my.f5.com/. From there, you can download the following files:

- SSL Certificate (with a `.crt` file extension)
- Private Key (with a `.key` file extension)

Alternatively, if you have your own certificates from a Certificate Authority (CA), you can use:

- SSL Certificate (with a `.cer` file extension)
- Privacy certificate (with a `.pem` file extension)

The NGINX One Console allows you to upload these certificates as text and as files.

## Important considerations

Most websites include valid information from public keys and certificates or CA bundles. However, NGINX One Console accepts, but provides warnings for these use cases:

- When the public certificate is expired
- When the leaf certificate part of a certificate chain is expired
- When any of the components of a CA bundle are expired
- When the public key does not match the private certificate

In such cases, you may get websites that present "Your connection is not private" warning messages in client web browsers.

## Review existing certificates

Follow these steps to review existing certificates for your instances. 

On the left menu, select **Certificates**. In the window that appears, you see:

- **Certificate Status** 

  - Total number of certificates
  - Valid certificates that expire more than 30 days from now
  - Valid certificates that expire within the next 30 days
  - Expired certificates

- **Management Status**

  - Managed certificates can be administered remotely, from a deployment or through the API.
  - Unmanaged certificates are listed. While you can convert an unmanaged certificate to managed, you may have to repeat installing the certificate and key.

You can **Add Filter** to filter certificates by:

- Name
- Status
- Subject Name
- Type

The **Export** option supports exports of basic certification file information to a CSV file. It does _not_ include the content of the public certificate or the private key.

## Add a new certificate or bundle

To add a new certificate, select **Add Certificate**. In the window that appears, you can add a certificate name. If you don't add a name, NGINX One Console will add a name for you, based on the expiration date for the certificate.

You can add certificates in the following formats:

- **SSL Certificate and Key**
- **CA Certificate Bundle**

In each case, you can upload files directly, or enter the content of the certificates in a text box. Once you upload these certificates, you'll see:

- **Certificate Details**, with the Subject Name, start and end dates. 
- **Key Details**, with the encryption key size and algorithm, such as RSA.

## Edit an existing certificate or bundle

You can modify existing certificates from the **Certificates** screen. Select the certificate of your choice. Depending on the type of certificate, you'll then see either an **Edit Certificate** or **Edit CA Bundle** option. NGINX One Console then presents a window with the same options as shown when you [Add a new certificate](#add-a-new-certificate).

## Managed and unmanaged certificates

If you've added an instance to NGINX One Console, as described in [Manage config sync groups]({{< relref "../nginx-configs/manage-config-sync-groups.md" >}}) (/nginx-one/how-to/nginx-configs/manage-config-sync-groups), the associated SSL/TLS certificates may not yet be managed. To do so from the
Certificates menu, select **Unmanaged**. You should see a list of **Unmanaged Certificates or CA Bundles**. Then:

1. Select a certificate
1. Select **Convert to Managed**
1.  In the window that appears, you can now include the same information as shown in the [Add a new certificate](#add-a-new-certificate) section

Once you've completed the process, NGINX One Console reassigns this as a managed certificate, as part of a specific instance or config sync group.
