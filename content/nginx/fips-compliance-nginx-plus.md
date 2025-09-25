---
description: ''
nd-docs: DOCS-470
title: NGINX Plus FIPS Compliance
toc: true
weight: 600
type:
- concept
---

## What is FIPS

The Federal Information Processing Standard (FIPS), issued by the [U.S. National Institute of Standards and Technology](https://www.nist.gov/) (NIST), defines mandatory security requirements for cryptographic modules used in federal IT systems. [FIPS 140-2](https://csrc.nist.gov/pubs/fips/140-2/upd2/final), and its successor [FIPS 140-3](https://csrc.nist.gov/pubs/fips/140-3/final), establish strict standards to protect sensitive information, including government communications and citizen data.

## Why FIPS-140 matters

FIPS 140 is a mandatory cryptographic standard in the United States and Canada for federal agencies, their contractors, and many regulated industries.

Non-compliance can result to contract loss, restricted project access, fines, or, in severe cases, data breaches compromising personal information or national security.

Some industries such as finance, healthcare, energy, also adopt FIPS to enhance data protection and operational security.

### FIPS compliance in U.S.

Currently, both FIPS 140-2 and FIPS 140-3 certifications are accepted. However, FIPS 140-2 is being phased out as part of the [FIPS 140-3 transition plan](https://csrc.nist.gov/projects/fips-140-3-transition-effort). After September 22, 2026, only FIPS 140-3 certifications will be recognized. Organizations are encouraged to migrate to FIPS 140-3 to meet updated cryptographic security requirements.

{{< table >}}
| **Sector / Program**           | **Version**    | **Status**    |
|--------------------------------|----------------|---------------|
| **Federal Programs**           |                |               |
| CJIS                           | 140-2 or 140-3 | Mandatory     |
| FedRAMP                        | 140-2 or 140-3 | Mandatory     |
| FISMA                          | 140-2 or 140-3 | Mandatory     |
| DFARS                          | 140-2 or 140-3 | Mandatory     |
| DoDIN APL                      | 140-2 or 140-3 | Mandatory     |
| FAA                            | 140-2 to 140-3 | Transitioning |
| TSA                            | 140-2 or 140-3 | Recommended   |
| **Defense & Intelligence**     |                |               |
| CMMC                           | 140-2 or 140-3 | Mandatory     |
| Intelligence Community         | 140-2 to 140-3 | Transitioning |
| NSA CSfC                       | 140-2 to 140-3 | Transitioning |
| Military & Tactical Systems    | 140-2 to 140-3 | Transitioning |
| **Healthcare & Education**     |                |               |
| HIPAA                          | 140-2 or 140-3 | Mandatory     |
| HITECH                         | 140-2 or 140-3 | Mandatory     |
| Department of Veterans Affairs | 140-2 or 140-3 | Mandatory     |
| FERPA                          | 140-2 or 140-3 | Recommended   |
| **Commercial/Private Sector**  |                |               |
| PCI DSS                        | 140-2 or 140-3 | Recommended   |
| Common Criteria                | 140-2 or 140-3 | Recommended   |
| **Infrastructure & Critical Systems** |         |               |
| Critical Infrastructure        | 140-2 or 140-3 | Recommended   |
| Nuclear Regulatory Commission  | 140-2 or 140-3 | Recommended   |
| **State & Local Government**   |                |               |
| State and Local Gov Programs   | 140-2 or 140-3 | Mandatory     |
{{< /table >}}

### FIPS compliance in other countries

Although FIPS 140 is primarily a North American government cryptographic standard, it is widely recognized as a global benchmark for cryptographic security. Numerous countries outside North America align their cryptographic requirements with FIPS, especially in regulated sectors such as finance, defense, healthcare, and critical infrastructure.

{{< table >}}
| Country/Region | FIPS Use                                                                    |
|----------------|-----------------------------------------------------------------------------|
| Australia      | Referenced for government, defense, and cryptography systems.               |
| Canada         | Mandatory for federal and sensitive systems.                                |
| Denmark        | Referenced in finance, healthcare, and NATO communications.                 |
| Estonia        | Adopted for e-governance and critical systems.                              |
| Finland        | Relied on for defense and NATO communications.                              |
| France         | Relied on for defense and secure systems.                                   |
| Germany        | Relied on for defense, critical infrastructure, and NATO communications.    |
| Israel         | Trusted in defense, government, and financial systems.                      |
| Italy          | Relied on for defense and financial cryptography.                           |
| Japan          | Referenced in government and financial cryptographic practices.             |
| Netherlands    | Referenced in finance, healthcare, and NATO communications.                 |
| New Zealand    | Referenced for government and national cryptography.                        |
| Poland         | Relied on for secure government and NATO communications.                    |
| Spain          | Referenced in NATO communications and critical systems.                     |
| Sweden         | Relied on for defense and secure NATO communications.                       |
| UAE            | Trusted in finance, energy, and interoperability with the U.S. cryptography.|
| United Kingdom | Referenced for defense, health, and procurement standards.                  |
| United States  | Mandatory for federal government systems and contractors.                   |
{{< /table >}}

## FIPS compliant vs FIPS validated

FIPS validation is a formal multistep process that certifies cryptographic modules through testing under the [Cryptographic Module Validation Program](https://csrc.nist.gov/Projects/cryptographic-module-validation-program/cmvp-flow) (CMVP). The process is managed by the [NIST](https://csrc.nist.gov/) and requires accredited third-party laboratories to evaluate the cryptographic module. Once a module passes validation, it is officially recognized as FIPS-validated (FIPS-certified).

FIPS compliance indicates that a system or a module claims to meet the FIPS requirements, however, it has not been officially tested or certified under the CMVP program.

## FIPS compliance with NGINX Plus

NGINX Plus is **FIPS 140-2 Level 1** and **FIPS 140-3 Level 1 compliant**, provided that the operating system and the OpenSSL library are operating in FIPS mode.

NGINX Plus relies exclusively on the operating system’s FIPS-validated OpenSSL library for all SSL/TLS, HTTP/2, and HTTP/3 encryption and decryption operations.

## FIPS compliance with NGINX Open Source

While NGINX Plus is tested to work on FIPS-enabled operating systems in FIPS mode, NGINX Open Source is not verified for such environments, especially when third-party builds or modules implementing custom cryptographic functions are used.

Compiling NGINX Open Source for FIPS mode may also require additional OS-level dependencies beyond its core requirements, potentially introducing unintended risks. Organizations should consult their security and compliance teams to ensure their configurations meet FIPS requirements. 

## FIPS validation of operating systems

Several operating system vendors have obtained FIPS 140-2 Level 1 and 140-3 Level 1 validation for the OpenSSL Cryptographic Module included with their respective operating systems:

- RedHat: [RedHat FIPS Certifications](https://access.redhat.com/compliance/fips)
- Ubuntu: [Overview of FIPS-certified modules](https://documentation.ubuntu.com/security/docs/compliance/fips/fips-overview/)
- Oracle: [Oracle FIPS Certifications](https://www.oracle.com/corporate/security-practices/assurance/development/external-security-evaluations/fips/certifications/)
- SUSE: [SUSE FIPS 140-3 cryptographic certificates](https://www.suse.com/c/suse-has-received-first-fips-140-3-cryptographic-certificates/)
- AWS: [FIPS 140-3 Compliance](https://aws.amazon.com/compliance/fips/)
- Amazon Linux: [Achieving FIPS 140-3 validation](https://aws.amazon.com/blogs/compute/amazon-linux-2023-achieves-fips-140-3-validation/)

You also can verify whether your operating system or cryptographic module is FIPS-validated using the [NIST database search tool](https://csrc.nist.gov/Projects/cryptographic-module-validation-program/validated-modules/search).

## FIPS validation of OpenSSL

OpenSSL 3.0 and later versions introduced a FIPS provider that enables cryptographic operations in a FIPS-compliant mode.

FIPS 140-3 validation: starting with OpenSSL 3.1.2, the library has [achieved FIPS 140-3 validation](https://openssl-library.org/post/2025-03-11-fips-140-3/) under certification [#4985](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/4985).

FIPS 140-2 validation: the FIPS provider for OpenSSL 3.0.x has been validated for FIPS 140-2 under certifications [#4811](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/4811) and [#4282](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/4282).

## Verification of correct operation of NGINX Plus

The following process describes how to deploy NGINX Plus in a FIPS‑compliant environment and verify that the FIPS operations are functioning correctly. It involves three basic steps:

- [Verify](#os-fips-check) if the operating system is running in FIPS mode. If not, [configure](#os-fips-setup) it to enable FIPS mode.

- [Verify](#openssl-fips-check) that the OpenSSL library is operating in FIPS mode.

- Run basic checks for [OpenSSL](#openssl-fips-check) and [NGINX Plus](#nginx-plus-fips-check) to confirm deployment in FIPS mode.

The process uses Red Hat Enterprise Linux (RHEL) release 9.6 as an example and can be adapted for other Linux operating systems that can be configured in FIPS mode.

### Step 1: Configure the operating system to use FIPS mode {#os-fips-setup}

For the purposes of the following demonstration, we installed and configured a RHEL 9.6 server. The [Red Hat FIPS documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/security_hardening/switching-rhel-to-fips-mode_security-hardening) explains how to switch the operating system between FIPS mode and non‑FIPS mode by editing the boot options and restarting the system.

For instructions for enabling FIPS mode on other FIPS‑compliant Linux operating systems, see the operating system documentation, for example:

- RHEL 9: [Switching to FIPS mode](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/security_hardening/switching-rhel-to-fips-mode_security-hardening)

- Ubuntu: [Switching to FIPS mode](https://documentation.ubuntu.com/security/docs/compliance/fips/how-to-install-ubuntu-with-fips/)

- SLES: [How to enable FIPS](https://www.suse.com/support/kb/doc/?id=000019432)

- Oracle Linux 9: [Configuring FIPS mode](https://docs.oracle.com/en/operating-systems/oracle-linux/9/security/configuring_fips_mode.html#configuring-fips-mode)

- Amazon Linux 2023: [Enabling FIPS mode](https://docs.aws.amazon.com/linux/al2023/ug/fips-mode.html)

- Amazon Linux 2: [Enabling FIPS mode](https://docs.aws.amazon.com/linux/al2/ug/fips-mode.html)

- AlmaLinux: [FIPS Validation for AlmaLinux](https://almalinux.org/blog/2023-09-19-fips-validation-for-almalinux/)

### Step 2: Verify the operating system is in FIPS mode {#os-fips-check}

You can verify that the operating system is in FIPS mode and that the version of OpenSSL provided by the operating system vendor is FIPS‑compliant by using the following tests.

**Check operating system flags**: When the operating system is in FIPS mode, `crypto.fips_enabled` kernlel flag is `1`; otherwise, it is `0`:

```shell
sudo sysctl -a | grep fips
```

The output of the command shows that FIPS is enabled at the kernel level:
```none
crypto.fips_enabled = 1
crypto.fips_name = Red Hat Enterprise Linux 9 - Kernel Cryptographic API
crypto.fips_version = 5.14.0-570.39.1.el9_6.aarch64
```

Check kernel logs for FIPS algorithm registration:
```shell
journalctl -k -o cat -g alg:
```

The output of the command verifies the status of algorithm self-tests and whether certain algorithms are registered, passed FIPS self-tests, or are disabled due to FIPS mode being active:

```none
alg: self-tests for pkcs1pad(rsa-generic,sha512) (pkcs1pad(rsa,sha512)) passed
alg: self-tests for pkcs1pad(rsa-generic,sha256) (pkcs1pad(rsa,sha256)) passed
alg: self-tests for cbc-aes-ce (cbc(aes)) passed
alg: self-tests for jitterentropy_rng (jitterentropy_rng) passed
alg: poly1305 (poly1305-neon) is disabled due to FIPS
alg: xchacha12 (xchacha12-neon) is disabled due to FIPS
alg: xchacha20 (xchacha20-neon) is disabled due to FIPS
```

Beyond kernel-level verification, you can ensure that the whole operating system environment is configured for FIPS compliance:
```shell
sudo fips-mode-setup --check
```
The output of the command shows that FIPS is running:
```none
FIPS mode is enabled.
```

### Step 3: Verify the OpenSSL is in FIPS mode {#openssl-fips-check}

**Determine the OpenSSL FIPS Provider is active**: This test verifies the correct version of OpenSSL and that the OpenSSL FIPS Provider is active:

```shell
openssl list -providers | grep -A3 fips
```
The output of the command shows the FIPS provider status:
```none
  fips
    name: Red Hat Enterprise Linux 9 - OpenSSL FIPS Provider
    version: 3.0.7-395c1a240fbfffd8
    status: active
```

**Determine whether OpenSSL can perform SHA1 hashes**: This test verifies the correct operation of OpenSSL. The SHA-1 hash algorithm, while considered weak, is still permitted in FIPS mode as it is included in FIPS-approved standards for certain legacy use cases. Failure of this command indicates that the OpenSSL implementation is not working properly:

```shell
openssl sha1 /dev/null
```
The result of the command, showing the SHA1 checksum of `/dev/null`:

```none
SHA1(/dev/null)= da39a3ee5e6b4b0d3255bfef95601890afd80709
```

**Determine whether OpenSSL allows MD5 hashes**: This test verifies that OpenSSL is running in FIPS mode. MD5 is not a permitted hash algorithm in FIPS mode, so an attempt to use it fails:

```shell
openssl md5 /dev/null
```
The result of the command:

```none
Error setting digest
200458BAFFFF0000:error:0308010C:digital envelope routines:inner_evp_generic_fetch:unsupported:crypto/evp/evp_fetch.c:355:Global default library context, Algorithm (MD5 : 95), Properties ()
200458BAFFFF0000:error:03000086:digital envelope routines:evp_md_init_internal:initialization error:crypto/evp/digest.c:272:
```

If OpenSSL is not running in FIPS mode, the MD5 hash functions normally:

```shell
openssl md5 /dev/null
```
The result of the command, showing the MD5 checksum of `/dev/null`:

```none
MD5(/dev/null)= d41d8cd98f00b204e9800998ecf8427e
```

### Step 4: Install NGINX Plus on the operating system {#nginx-plus-instll}

Follow the [F5 NGINX Plus Installation guide](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/) to install NGINX Plus on the host operating system, either directly from the [NGINX Plus repository](https://account.f5.com/myf5), or by downloading the **nginx-plus** package (**rpm** or **deb** package) onto another system and manually installing it on the host operating system.

**Verify that NGINX Plus is correctly installed**: Run the following command to confirm that NGINX Plus is installed and is using the expected OpenSSL cryptographic module:

```shell
nginx -V
```
Sample output from the command:

```shell
nginx version: nginx/1.29.0 (nginx-plus-r35)
built by gcc 11.5.0 20240719 (Red Hat 11.5.0-5) (GCC) 
built with OpenSSL 3.2.2 4 Jun 2024
```

**Configure NGINX Plus to serve a simple SSL/TLS‑protected website**: Add the following simple configuration to NGINX Plus:

```nginx
server {
    listen 443 ssl;

    ssl_certificate     /etc/nginx/ssl/test.crt;
    ssl_certificate_key /etc/nginx/ssl/test.key;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```

If necessary, you can generate a self‑signed certificate for test purposes:

```shell
mkdir -p /etc/nginx/ssl && \
openssl req -newkey rsa:2048 -nodes -keyout /etc/nginx/ssl/test.key -x509 -days 365 -out /etc/nginx/ssl/test.crt
```

Verify that you can access the website using HTTPS from a remote host. Connect to the NGINX IP address using the `openssl s_client` command, and enter the HTTP message `GET /`:

```shell
(echo "GET /" ; sleep 1) | openssl s_client -connect <NGINX-Plus-address>:443
```

Use `openssl s_client` for this test because it unambiguously confirms which SSL/TLS cipher was negotiated in the connection. After some debugging information (including the cipher selected), the body of the default “Welcome to nginx!” greeting page is displayed.

### Step 5: Verify compliance with FIPS {#nginx-plus-fips-check}

FIPS 140-2 and 140-3 disallows the use of some cryptographic algorithms, including the Camellia block cipher. In addition to FIPS 140-2, FIPS 140-3 disallows the use of several ciphers and algorithms that were once allowed or still allowed under FIPS 140-2.

You can test compliance with FIPS 140-2 / 140-3 by issuing SSL/TLS requests with known ciphers on another (non-FIPS-mode) server:

#### RC4-MD5

`RC4-MD5` is considered insecure and deprecated across all modern cryptographic standards. It is disallowed and disabled by default in FIPS-compliant OpenSSL, and TLS 1.2 and 1.3. The SSL handshake always fails.

```shell
(echo "GET /" ; sleep 1) | openssl s_client -connect <NGINX-Plus-address>:443 -cipher RC4-MD5
```

For FIPS compliance, alternative cipher suites can be used such as:

- `TLS_RSA_WITH_AES_128_GCM_SHA256`
- `TLS_RSA_WITH_AES_256_GCM_SHA384`
- `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256`
- `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`

#### CAMELLIA-SHA

```shell
(echo "GET /" ; sleep 1) | openssl s_client -connect <NGINX-Plus-address>:443 -cipher CAMELLIA256-SHA
```

This cipher is considered secure but is not permitted by the FIPS standard. The SSL handshake fails if the target system is compliant with FIPS 140-2 /140-3, and succeeds otherwise.

#### AES256-SHA

The cipher is permitted under FIPS 140-2 as it combines AES encryption with SHA-1. However, under FIPS 140-3, SHA-1 is explicitly disallowed due to its vulnerabilities, such as susceptibility to collision attacks. As a result, the SSL handshake fails under FIPS 140-3 and succeeds under FIPS 140-2:

```shell
(echo "GET /" ; sleep 1) | openssl s_client -connect <NGINX-Plus-address>:443 -cipher AES256-SHA
```

For FIPS 140-3 compliance, alternative cipher suites that leverage SHA-2 or SHA-3 for hashing can be used:

- AES-GCM-Based Cipher Suites (TLS 1.2): 
  - `TLS_RSA_WITH_AES_256_GCM_SHA384`
  - `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`

- ChaCha20-Based Cipher Suites (TLS 1.2 or 1.3): 
  - `TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256`

- TLS 1.3 Cipher Suites:
  - `TLS_AES_256_GCM_SHA384`
  - `TLS_AES_128_GCM_SHA256`
  - `TLS_CHACHA20_POLY1305_SHA256`

#### 3DES

The `3DES` (Triple DES) cipher is allowed under FIPS 140-2, but disallowed under FIPS 140-3. NIST deprecated its use [starting January 1, 2024](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-131Ar2.pdf) due to its reduced security strength (112 bits) and vulnerability to brute-force attacks.

As a result, the SSL handshake always fails in FIPS-3 compliant environment:

```shell
(echo "GET /" ; sleep 1) | openssl s_client -connect <NGINX-Plus-address>:443 -cipher DES-CBC3
```
For FIPS 140-3 compliance, AES-Based or ChaCha20-Based cipher suites can be used:

- `TLS_RSA_WITH_AES_128_GCM_SHA256`
- `TLS_RSA_WITH_AES_256_GCM_SHA384`
- `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256`
- `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`
- `TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256`

#### DH and DSA

Under FIPS 140-2, Diffie-Hellman (DH) and Digital Signature Algorithm (DSA) were permitted with a minimum key size of 1024 bits. However, under FIPS 140-3, the minimum key size for both DH and DSA has been increased to 2048 bits.

For example, the `TLS_DH_RSA_WITH_AES_128_CBC_SHA` algorithm is FIPS 140-2 compliant, but not FIPS 140-3 compliant due to its use of DH with a key size of less than 2048 bits, CBC mode encryption, and SHA-1 hashing:

```shell
(echo "GET /" ; sleep 1) | openssl s_client -connect <NGINX-Plus-address>:443 -cipher TLS_DH_RSA_WITH_AES_128_CBC_SHA
```

The `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256` algorithm is FIPS 140-3 compliant as it uses Elliptic Curve Diffie-Hellman Ephemeral (ECDHE), AES-GCM for encryption, and SHA-256 for hashing:

```shell
(echo "GET /" ; sleep 1) | openssl s_client -connect <NGINX-Plus-address>:443 -cipher  TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
```

## Ciphers disabled in FIPS Mode

The FIPS 140-2 standard only permits a [subset of the typical SSL and TLS ciphers](https://csrc.nist.gov/csrc/media/publications/fips/140/2/final/documents/fips1402annexa.pdf), while FIPS 140-3 [extends this requirements](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.140-3.pdf) to enforce stricter cryptographic algorithms.

In the following test, the ciphers presented by NGINX Plus are surveyed using the `nmap` utility (installed separately). In its default configuration, with the [`ssl_ciphers HIGH:!aNULL:!MD5`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ciphers) directive, NGINX Plus presents the following ciphers to SSL/TLS clients:

```shell
nmap --script ssl-enum-ciphers -p 443 <NGINX-Plus-address>
```

The output of the command for NGINX Plus running on Red Hat Enterprise Linux 9 without FIPS enabled:

```shell
PORT    STATE SERVICE
443/tcp open  https
| ssl-enum-ciphers: 
|   TLSv1.2: 
|     ciphers: 
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384 (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_ARIA_128_GCM_SHA256 (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_ARIA_256_GCM_SHA384 (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_CAMELLIA_128_CBC_SHA256 (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_CAMELLIA_256_CBC_SHA384 (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256 (secp256r1) - A
|       TLS_RSA_WITH_AES_128_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_CBC_SHA256 (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_CCM (rsa 2048) - A
|       TLS_RSA_WITH_AES_128_GCM_SHA256 (rsa 2048) - A
|       TLS_RSA_WITH_AES_256_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_AES_256_CBC_SHA256 (rsa 2048) - A
|       TLS_RSA_WITH_AES_256_CCM (rsa 2048) - A
|       TLS_RSA_WITH_AES_256_GCM_SHA384 (rsa 2048) - A
|       TLS_RSA_WITH_ARIA_128_GCM_SHA256 (rsa 2048) - A
|       TLS_RSA_WITH_ARIA_256_GCM_SHA384 (rsa 2048) - A
|       TLS_RSA_WITH_CAMELLIA_128_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_CAMELLIA_128_CBC_SHA256 (rsa 2048) - A
|       TLS_RSA_WITH_CAMELLIA_256_CBC_SHA (rsa 2048) - A
|       TLS_RSA_WITH_CAMELLIA_256_CBC_SHA256 (rsa 2048) - A
|     compressors: 
|       NULL
|     cipher preference: client
|   TLSv1.3: 
|     ciphers: 
|       TLS_AKE_WITH_AES_128_CCM_SHA256 (ecdh_x25519) - A
|       TLS_AKE_WITH_AES_128_GCM_SHA256 (ecdh_x25519) - A
|       TLS_AKE_WITH_AES_256_GCM_SHA384 (ecdh_x25519) - A
|       TLS_AKE_WITH_CHACHA20_POLY1305_SHA256 (ecdh_x25519) - A
|     cipher preference: client
|_  least strength: A
```

When FIPS 140-3 mode is enabled, NGINX Plus presents the following ciphers to SSL/TLS clients:

```shell
PORT    STATE SERVICE
443/tcp open  https
| ssl-enum-ciphers: 
|   TLSv1.2: 
|     ciphers: 
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384 (secp256r1) - A
|       TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (secp256r1) - A
|     compressors: 
|       NULL
|     cipher preference: client
|   TLSv1.3: 
|     ciphers: 
|       TLS_AKE_WITH_AES_128_CCM_SHA256 (secp256r1) - A
|       TLS_AKE_WITH_AES_128_GCM_SHA256 (secp256r1) - A
|       TLS_AKE_WITH_AES_256_GCM_SHA384 (secp256r1) - A
|     cipher preference: client
|_  least strength: A
```

Based on the results above, the following ciphers are disallowed under FIPS 140-3 compliance:

- Camellia-Based Ciphers: FIPS compliance requires cryptographic algorithms to be validated by NIST, and Camellia is not NIST-approved despite being recognized by ISO/IEC standards.

  - `TLS_ECDHE_RSA_WITH_CAMELLIA_128_CBC_SHA256`
  - `TLS_ECDHE_RSA_WITH_CAMELLIA_256_CBC_SHA384`
  - `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA`
  - `TLS_RSA_WITH_CAMELLIA_128_CBC_SHA256`
  - `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA`
  - `TLS_RSA_WITH_CAMELLIA_256_CBC_SHA256`

- ARIA-Based Ciphers: similar to Camellia, ARIA is not a NIST-approved algorithm and is therefore excluded from FIPS compliance.

  - `TLS_ECDHE_RSA_WITH_ARIA_128_GCM_SHA256`
  - `TLS_ECDHE_RSA_WITH_ARIA_256_GCM_SHA384`
  - `TLS_RSA_WITH_ARIA_128_GCM_SHA256`
  - `TLS_RSA_WITH_ARIA_256_GCM_SHA384`

- RSA Key Exchange Ciphers: static RSA key exchange lacks Forward Secrecy, allowing decryption of past traffic if the private key is compromised, thus disallowed in FIPS mode.

  - `TLS_RSA_WITH_AES_128_CBC_SHA`
  - `TLS_RSA_WITH_AES_128_CBC_SHA256`
  - `TLS_RSA_WITH_AES_128_GCM_SHA256`
  - `TLS_RSA_WITH_AES_256_CBC_SHA`
  - `TLS_RSA_WITH_AES_256_CBC_SHA256`
  - `TLS_RSA_WITH_AES_256_GCM_SHA384`

- CBC Mode Ciphers (Non-AEAD: CBC is vulnerable to padding oracle attacks (e.g., POODLE, Lucky13), making it insecure. FIPS 140-3 prioritizes AEAD modes like AES-GCM and AES-CCM.

  - `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA`
  - `TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256`
  - `TLS_RSA_WITH_AES_128_CBC_SHA`
  - `TLS_RSA_WITH_AES_128_CBC_SHA256`
  - `TLS_RSA_WITH_AES_256_CBC_SHA`
  - `TLS_RSA_WITH_AES_256_CBC_SHA256`

- ChaCha20-Poly1305: it is not a NIST-approved algorithm and is excluded from FIPS compliance. FIPS exclusively permits algorithms such as `AES-GCM` and `AES-CCM`.

  - `TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256`

- AES-CCM Variants:

  - `TLS_RSA_WITH_AES_128_CCM`
  - `TLS_RSA_WITH_AES_256_CCM`


You can also use the [Qualys SSL server test](https://www.ssllabs.com/ssltest) to verify the ciphers presented by NGINX Plus to SSL/TLS clients.

## Conclusion

NGINX Plus can be used to decrypt and encrypt SSL/TLS‑encrypted network traffic in deployments that require FIPS 140-2 Level 1 or FIPS 140-3 Level 1 compliance.

The process described above may be used to verify that NGINX Plus is operating in conformance with the FIPS 140-2 Level 1 and FIPS 140-3 Level 1 standards.

## Definition of terms

- **Cryptographic module**: The OpenSSL software, comprised of libraries of FIPS‑validated algorithms that can be used by other applications.

- **Cryptographic boundary**: The operational functions that use FIPS‑validated algorithms. For NGINX Plus, the cryptographic boundary includes all functionality that is implemented by the [`http_auth_jwt`](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html), [`http_ssl`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html), [`http_v2`](https://nginx.org/en/docs/http/ngx_http_v2_module.html), [`http_v3`](https://nginx.org/en/docs/http/ngx_http_v3_module.html), [`mail_ssl`](https://nginx.org/en/docs/mail/ngx_mail_ssl_module.html), and [`stream_ssl`](https://nginx.org/en/docs/stream/ngx_stream_ssl_module.html) modules. These modules implement SSL and TLS operations for inbound and outbound connections which use HTTP, HTTP/2, HTTP/3, TCP, and mail protocols.

- **NGINX Plus**: The NGINX Plus software application developed by F5, Inc. and delivered in binary format from F5 servers.

- **FIPS mode**: When the operating system is configured to run in FIPS mode, the OpenSSL cryptographic module operates in a mode that has been validated to be in compliance with FIPS 140-2 Level 1 or FIPS 140-3 Level 1. Most operating systems do not run in FIPS mode by default, so explicit configuration is necessary to enable FIPS mode.

- **FIPS validated**: A component of the OpenSSL cryptographic module (the OpenSSL FIPS Object Module) is formally validated by an authorized certification laboratory. The validation holds if the module is built from source with no modifications to the source or build process. The implementation of FIPS mode that is present in operating system vendors’ distributions of OpenSSL contains this validated module.

- **FIPS compliant**: NGINX Plus is compliant with FIPS 140-2 Level 1 and FIPS 140-3 Level 1 within the cryptographic boundary when used with a FIPS‑validated OpenSSL cryptographic module on an operating system running in FIPS mode.

## See also

[FIPS 140-3 Standard in the PDF format](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.140-3.pdf)
    
[FIPS compliance with NGINX Plus and Red Hat Enterprise Linux](https://www.f5.com/pdf/technology-alliances/fips-compliance-made-simple-with-f5-and-red-hat-one-pager.pdf)

[F5 NGINX Plus running on Red Hat Enterprise Linux is now FIPS 140-3 compliant](https://www.redhat.com/en/blog/f5-nginx-plus-running-red-hat-enterprise-linux-now-fips-140-3-compliant)


## Revision history

- Version 2 (September 2025) - Added information about FIPS 140-3 Level 1 compliance, updated test procedures, updated product versions, updated URLs to operating systems, NIST certificates and other relevant resources.

- Version 1 (August 2019) - Initial version with FIPS 140-2 Level 1 compliance.
