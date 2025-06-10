---
description: ''
docs: DOCS-470
title: NGINX Plus FIPS Compliance
toc: true
weight: 600
type:
- concept
---

When used with a FIPS 140-2 validated build of OpenSSL operating in FIPS mode, NGINX Plus is compliant with the requirements of FIPS 140-2 (Level 1) with respect to the decryption and encryption of SSL/TLS‑encrypted network traffic.

## Introduction

[FIPS 140-2](https://csrc.nist.gov/publications/detail/fips/140/2/final) is a United States Federal Standard that relates to the integrity and security of cryptographic modules. FIPS 140-2 Level 1 relates specifically to software cryptographic modules and makes stipulations about the cryptographic algorithms that may be used and the self‑tests that must be conducted to verify their integrity.

Several operating system vendors have obtained FIPS 140-2 Level 1 validation for the OpenSSL Cryptographic Module shipped with their respective operating systems:

- [Canonical Ltd.: Ubuntu 18.04 OpenSSL Cryptographic Module](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/4540)
- [Oracle Corporation: Oracle OpenSSL FIPS Provider](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/4506)
- [Red Hat, Inc.: Red Hat Enterprise Linux 7 NSS Cryptographic Module](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/4498)
- [SUSE, LLC: SUSE Linux Enterprise Server Kernel Crypto API Cryptographic Module](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/4508)

NGINX Plus uses the OpenSSL cryptographic module exclusively for all operations relating to the decryption and encryption of SSL/TLS and HTTP/2 traffic.

When NGINX Plus is executed on an operating system where a FIPS‑validated OpenSSL cryptographic module is present and FIPS mode is enabled, NGINX Plus is compliant with FIPS 140-2 with respect to the decryption and encryption of SSL/TLS and HTTP/2 traffic.

## Definition of Terms

This statement uses the following terms:

- **Cryptographic module**: The OpenSSL software, comprised of libraries of FIPS‑validated algorithms that can be used by other applications.

- **Cryptographic boundary**: The operational functions that use FIPS‑validated algorithms. For NGINX Plus, the cryptographic boundary includes all functionality that is implemented by the [http_ssl](http://nginx.org/en/docs/http/ngx_http_ssl_module.html), [http_v2](http://nginx.org/en/docs/http/ngx_http_v2_module.html), [stream_ssl](http://nginx.org/en/docs/stream/ngx_stream_ssl_module.html), [mail_ssl](http://nginx.org/en/docs/mail/ngx_mail_ssl_module.html), and [http_auth_jwt](http://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html) modules. These modules implement SSL and TLS operations for inbound and outbound connections which use HTTP, HTTP/2, TCP, and mail protocols.

- **NGINX Plus**: The NGINX Plus software application developed by NGINX, Inc. and delivered in binary format from NGINX servers.

- **FIPS mode**: When the operating system is configured to run in FIPS mode, the OpenSSL cryptographic module operates in a mode that has been validated to be in compliance with FIPS 140-2 Level 2. Most operating systems do not run in FIPS mode by default, so explicit configuration is necessary to enable FIPS mode.

- **FIPS validated**: A component of the OpenSSL cryptographic module (the OpenSSL FIPS Object Module) is formally validated by an authorized certification laboratory. The validation holds if the module is built from source with no modifications to the source or build process. The implementation of FIPS mode that is present in operating system vendors’ distributions of OpenSSL contains this validated module.

- **FIPS compliant**: NGINX Plus is compliant with FIPS 140-2 Level 1 within the cryptographic boundary when used with a FIPS‑validated OpenSSL cryptographic module on an operating system running in FIPS mode.

## Verification of Correct Operation of NGINX Plus

The following process describes how to deploy NGINX Plus in a FIPS‑compliant fashion and then verify that the FIPS operations are correctly performed.

The process uses Red Hat Enterprise Linux (RHEL) version 7.4 as an example, and can be adapted for other Linux operating systems that can be configured in FIPS mode.

### Step 1: Configure the Operating System to Use FIPS Mode

For the purposes of the following demonstration, we installed and configured a RHEL 7.4 server. The [Red Hat FIPS documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/chap-federal_standards_and_regulations#sec-Enabling-FIPS-Mode) explains how to switch the operating system between FIPS mode and non‑FIPS mode by editing the boot options and restarting the system.

For instructions for enabling FIPS mode on other FIPS‑compliant Linux operating systems, see the operating system documentation (for example, [Oracle Linux](https://docs.oracle.com/cd/E52668_01/E54670/html/ol7-fips-enable.html), [Ubuntu](https://ubuntu.com/security/certifications/docs/fips-faq)).

### Step 2: Verify the Operating System and OpenSSL Are in FIPS Mode

You can verify that the operating system is in FIPS mode and that the version of OpenSSL provided by the operating system vendor is FIPS‑compliant by using the following tests.

**Check operating system flags**: When the operating system is in FIPS mode, ```crypto.fips_enabled``` is ```1```; otherwise, it is ```0```:

```shell
sudo sysctl –a | grep fips
crypto.fips_enabled = 1
```

**Determine whether OpenSSL can perform SHA1 hashes**: This test verifies the correct operation of OpenSSL. The SHA1 hash algorithm is permitted in all modes, so failure of this command indicates that the OpenSSL implementation does not work properly:

```shell
openssl sha1 /dev/null
SHA1(/dev/null)= da39a3ee5e6b4b0d3255bfef95601890afd80709
```

**Determine whether OpenSSL can perform MD5 hashes**: This test verifies that OpenSSL is running in FIPS mode. MD5 is not a permitted hash algorithm in FIPS mode, so an attempt to use it fails:

```shell
openssl md5 /dev/null
Error setting digest md5
140647163811744:error:060800A3:digital envelope routines:EVP_DigestInit _ex:disabled for fips:digest.c:251:
```

If OpenSSL is not running in FIPS mode, the MD5 hash functions normally:

```shell
openssl md5 /dev/null
MD5(/dev/null)= d41d8cd98f00b204e9800998ecf8427e
```

### Step 3: Install NGINX Plus on the Operating System

Follow the [F5 NGINX documentation](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/) to install NGINX Plus on the host operating system, either directly from the [NGINX Plus repository](https://account.f5.com/myf5), or by downloading the **nginx-plus** package (**rpm** or **deb** package) onto another system and manually installing it on the host operating system.

**Verify that NGINX Plus is correctly installed**: Run the following command to confirm that NGINX Plus is installed and is using the expected OpenSSL cryptographic module:

```shell
nginx -V
nginx version: nginx/1.15.2 (nginx-plus-r16)
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC)
built with OpenSSL 1.0.2k-fips  26 Jan 2017
```

Observe that the version number of the OpenSSL library includes the `–fips` suffix. This indicates that the library is FIPS‑validated, but does not confirm that it is running in FIPS mode.

**Configure NGINX Plus to serve a simple SSL/TLS‑protected website**: Add the following simple configuration to NGINX Plus:

```nginx
server {
    listen 443 ssl;

    ssl_certificate     /etc/nginx/ssl/test.crt;
    ssl_certificate_key /etc/nginx/ssl/test.key;

    ssl_protocols   	TLSv1 TLSv1.1 TLSv1.2;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```

If necessary, you can generate a self‑signed certificate for test purposes:

```shell
mkdir -p /etc/nginx/ssl
openssl req -newkey rsa:2048 -nodes -keyout /etc/nginx/ssl/test.key -x509 -days 365 -out /etc/nginx/ssl/test.crt
```

Verify that you can access the website using HTTPS from a remote host. Connect to the NGINX IP address using the `openssl s_client` command, and enter the HTTP message `GET /`:

```shell
(echo "GET /" ; sleep 1) | openssl s_client -connect <NGINX-Plus-address>:443
```

Use `openssl s_client` for this test because it unambiguously confirms which SSL/TLS cipher was negotiated in the connection. After some debugging information (including the cipher selected), the body of the default “Welcome to nginx!” greeting page is displayed.

### Step 4: Verify Compliance with FIPS 140-2

FIPS 140-2 disallows the use of some cryptographic algorithms, including the Camellia block cipher. We can test compliance with FIPS 140-2 by issuing SSL/TLS requests with known ciphers on another (non-FIPS-mode) server:

#### RC4-MD5

```shell
(echo "GET /" ; sleep 1) | openssl s_client -connect <NGINX-Plus-address>:443 -cipher RC4-MD5
```

This cipher is insecure and is disabled by NGINX Plus by default. The SSL handshake always fails.

#### CAMELLIA-SHA

```shell
(echo "GET /" ; sleep 1) | openssl s_client -connect <NGINX-Plus-address>:443 -cipher CAMELLIA256-SHA
```

This cipher is considered secure but is not permitted by the FIPS standard. The SSL handshake fails if the target system is compliant with FIPS 140-2, and succeeds otherwise.

Note that if you attempt to issue the client request on a host running in FIPS mode, it fails because the OpenSSL client cannot use this cipher.

#### AES256-SHA

```shell
(echo "GET /" ; sleep 1) | openssl s_client -connect <NGINX-Plus-address>:443 -cipher AES256-SHA
```

This cipher is considered secure by NGINX Plus and is permitted by FIPS 140-2. The SSL handshake succeeds.

## Which Ciphers Are Disabled in FIPS Mode?

The FIPS 140-2 standard only permits a [subset of the typical SSL and TLS ciphers](https://csrc.nist.gov/csrc/media/publications/fips/140/2/final/documents/fips1402annexa.pdf).

In the following test, the ciphers presented by NGINX Plus are surveyed using the [Qualys SSL server test](https://www.ssllabs.com/ssltest). In its default configuration, with the `ssl_ciphers HIGH:!aNULL:!MD5` directive, NGINX Plus presents the following ciphers to SSL/TLS clients:

<a href="/nginx/images/nginx-plus-ciphers-nonfips.png"><img src="/nginx/images/nginx-plus-ciphers-nonfips.png" alt="Ciphers presented by NGINX Plus to clients when in non-FIPS mode" width="1024" height="521" class="aligncenter size-full wp-image-62740" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

When FIPS mode is enabled on the host operating system, the two ciphers that use the Camellia block cipher (`TLS_RSA_WITH_CAMELLIA_128_CBC_SHA` and `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA`) are removed:

<a href="/nginx/images/nginx-plus-ciphers-fips.png"><img src="/nginx/images/nginx-plus-ciphers-fips.png" alt="Ciphers presented by NGINX Plus to clients when in FIPS mode" width="1024" height="466" class="aligncenter size-full wp-image-62738" style="border:2px solid #666666; padding:2px; margin:2px;" /></a>

When you configure NGINX Plus with the `ssl_ciphers ALL` directive, NGINX Plus presents all the relevant ciphers available in the OpenSSL cryptographic module to the client. FIPS mode disables the following ciphers:

- `TLS_ECDH_anon_WITH_RC4_128_SHA`
- `TLS_ECDHE_RSA_WITH_RC4_128_SHA`
- `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA`
- `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA`
- `TLS_RSA_WITH_IDEA_CBC_SHA`
- `TLS_RSA_WITH_RC4_128_MD5`
- `TLS_RSA_WITH_RC4_128_SHA`
- `TLS_RSA_WITH_SEED_CBC_SHA`

## Conclusion

NGINX Plus can be used to decrypt and encrypt SSL/TLS‑encrypted network traffic in deployments that require FIPS 140-2 Level 1 compliance.

The process described above may be used to verify that NGINX Plus is operating in conformance with the FIPS 140-2 Level 1 standard.


