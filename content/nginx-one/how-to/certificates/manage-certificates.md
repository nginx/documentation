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

This guide explains how you can manage SSL/TLS certificates with the F5 NGINX One Console. Valid certificates support encrypted connections between NGINX and your users. 

From the NGINX One Console you can:

- Monitor all certificates configured for use by your connected NGINX Instances.
- Ensure that your certificates are current and correct.
- Manage your certificates from a central location. This can help you simplify operations and remotely update, rotate, and deploy those certificates.

For more information on how you can use these certificates to secure your servers, refer to the section on [NGINX SSL termination]({{< relref "../../../nginx/admin-guide/security-controls/terminating-ssl-http.md" >}}).

## Before you start

Before you add and manage certificates with the NGINX One Console make sure:

- You have access to the NGINX One Console
- You have access through the F5 Distributed Cloud role, as described in the [Authentication]({{< relref "../../api/authentication.md" >}}) guide, to manage SSL/TLS certificates
  - You have the `f5xc-nginx-one-user` role for your account
- Your SSL/TLS certificates and keys match

### SSL/TLS certificates and more

NGINX One Console supports certificates for access to repositories. You may need a copy of these files from your Certificate Authority (CA)  to upload them to NGINX One Console:

- SSL Certificate (with a `.cer` or `.pem` file extension)
- Privacy certificate (with a `.pem` file extension)

The NGINX One Console allows you to upload these certificates as text and as files. You can also upload your own certificate files (with .crt and .key file extensions).

Make sure your certificates, keys, and pem files are encrypted to one of the following standards:

- RSA
- ECDSA

If you use one of these keys, the US National Institute of Standards and Technology, in [Publication 800-57 Part 3 (PDF)](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-57Pt3r1.pdf), recommends a key size of at least
2048 bits. It also has recommnedations for ECDSA.

### Include certificates in NGINX configuration

For NGINX configuration, these files are typically associated with the following NGINX directives:

- [`ssl_certificate`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_certificate)
- [`ssl_certificate_key`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_certificate_key)
- [`ssl_trusted_certificate`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html#ssl_trusted_certificate)
- [`ssl_client_certificate`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_client_certificate)
- [`proxy_ssl_certificate`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_certificate)
- [`proxy_ssl_certificate_key`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_certificate_key)

## Important considerations

Most websites include valid information from public keys and certificates or CA bundles. However,the NGINX One Console accepts, but provides warnings for these use cases:

- When the public certificate is expired
- When the leaf certificate part of a certificate chain is expired
- When any of the components of a CA bundle are expired
- When the public key does not match the private certificate

In such cases, you may get websites that present "Your connection is not private" warning messages in client web browsers.

## Review existing certificates

Follow these steps to review existing certificates for your instances. 

On the left-hand pane, select **Certificates**. In the window that appears, you see:

- **Certificate Status** 

  - Total number of certificates in one of these categories;
    - Managed by NGINX One Console
    - Detected on connected NGINX instances
  - Valid certificates that expire more than 30 days from now
  - Valid certificates that expire within the next 30 days
  - Expired certificates
- Certificates that are not yet valid

- **Management Status**

  - Managed certificates are stored on NGINX One Console.
    - You can use NGINX One Console to deploy, administer, and update certificates remotely.
  - Unmanaged certificates are detected by NGINX One Console through the connected NGINX instance configuration. 
    - If you choose to convert an unmanaged certificate to managed, you may need to upload the certificate and the key during the conversion.

You can **Add Filter** to filter certificates by:

- Name
- Status
- Subject Name
- Type

The Export option supports exports of basic certification file information to a CSV file. It does _not_ include the content of the public certificate or the private key.

## Add a new certificate or bundle

To add a new certificate, select **Add Certificate**. 

<!-- Candidate for an "include". Common content with add-file.md -->
In the screen that appears, you can add a certificate name. If you don't add a name, NGINX One will add a name for you, based on the expiration date for the certificate.

You can add certificates in the following formats:

- **SSL Certificate and Key**
- **CA Certificate Bundle**

In each case, you can upload files directly, or enter the content of the certificates in a text box. Once you upload these certificates, you'll see:

- **Certificate Details**, with the Subject Name, start and end dates. 
- **Key Details**, with the encryption key size and algorithm, such as RSA
<!-- end potential "include" -->

## Edit an existing certificate or bundle

You can modify existing certificates from the **Certificates** screen. Select the certificate of your choice. Depending on the type of certificate, you'll then see either a **Edit Certificate** or **Edit CA Bundle** option. The NGINX One Console then presents a window with the same options as shown when you [Add a new certificate](#add-a-new-certificate).

## Delete a certificate

To delete a certificate, find the name in the **Certificates** screen. Find the **Actions** column associated with the certificate. Select the ellipsis and then select **Delete**.

## Managed and unmanaged certificates

If you register an instance to NGINX One Console, as described in [Add your NGINX instances to NGINX One]({{< relref "../../getting-started.md#add-your-nginx-instances-to-nginx-one" >}}), and the associated SSL/TLS certificates:

- Are used in their NGINX configuration
- Do _not_ match an existing managed SSL certificate/CA bundle

These certificates will appear in the list of unmanaged certificates.

We recommend that you convert your unmanaged certificates. Converting to a managed certificate allows you to centrally manage, update, and deploy a certificate to your NGINX instances from the NGINX One Console.

To convert these cerificates to managed, start with the Certificates menu, and select **Unmanaged**. You should see a list of **Unmanaged Certificates or CA Bundles**. Then:

- Select a certificate
- Select **Convert to Managed**
- In the window that appears, you can now include the same information as shown in the [Add a new certificate](#add-a-new-certificate) section

<!-- Once you've completed the process, NGINX One reassigns this as a managed certificate, and assigns it to the associated instance or config sync group. -->

## See also

- [Create and manage data plane keys]({{< relref "/nginx-one/how-to/data-plane-keys/create-manage-data-plane-keys.md" >}})
- [View and edit NGINX configurations]({{< relref "/nginx-one/how-to/nginx-configs/view-edit-nginx-configurations.md" >}})
- [Add a file in a configuration]({{< relref "/nginx-one/how-to/nginx-configs/add-file.md" >}})
