---
title: TLS with Certbot
toc: true
weight: 600
---

To set up
[SSL/TLS access in Unit]({{< relref "/unit/certificates.md#configuration-ssl" >}}),
you need certificate bundles. Although you can use self-signed certificates, it's
advisable to obtain certificates for your website from a certificate authority
(CA). For this purpose, you may employ EFF's [Certbot](https://certbot.eff.org) that issues free certificates signed by [Let's
Encrypt](https://letsencrypt.org), a non-profit CA.

{{< note >}}
The commands in this document starting with a hash (#) must be run as root or
with superuser privileges.
{{< /note >}}

## Generating certificates

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) on your website's server.

2. Install [Certbot](https://certbot.eff.org/instructions) on the same
   server, choosing `None of the above` in the `Software`
   dropdown list and the server's OS in the `System` dropdown list
   at EFF's website.

3. Run the `certbot` utility and follow its instructions to create the
   certificate bundle. You'll be prompted to enter the domain name of the
   website and [validate domain ownership](https://letsencrypt.org/docs/challenge-types/); the latter can be done
   differently. Perhaps, the easiest approach is to use the [webroot](https://eff-certbot.readthedocs.io/en/stable/using.html#webroot) method
   by having Certbot store a certain file locally and then access it by your
   domain name. First, configure Unit with a temporary route at port 80:

   ```json
   {
      "listeners": {
         "*:80": {
               "pass": "routes/acme",
               "comment_*:80": "Certbot attempts to reach the domain name at port 80"
         }
      },
      "routes": {
         "acme": [
               {
                  "match": {
                     "uri": "/.well-known/acme-challenge/*",
                     "comment_uri": "The URI that Certbot probes to download the file"
                  },
                  "action": {
                     "share": "/var/www/www.example.com$uri/",
                     "comment_share": "Arbitrary directory, preferably the one used for storing static files"
                  }
               }
         ]
      }
   }
   ```

   Make sure the **share** directory is accessible for Unit's
   [router process]({{< relref "/unit/howto/security.md#security-apps" >}})
   user account, usually **unit:unit**.

   Next, run `certbot`, supplying the **share** directory as the
   webroot path:

   ```console
   # certbot certonly --webroot -w /var/www/www.example.com/ -d www.example.com # path where the file is stored and your domain name
   ```

   If you can't employ the previous method for some reason, try using DNS
   records to validate your domain:

   ```console
   # certbot certonly --manual --preferred-challenges dns -d www.example.com # your domain name
   ```

   Certbot will provide instructions on updating the DNS entries to prove
   domain ownership.

   Any such `certbot` command stores the resulting **.pem** files
   as follows:

   ```none
   /etc/letsencrypt/       # Location can be configured, see Certbot help
   └── live/
      └── www.example.com  # Your website name
      ├── cert.pem         # Leaf website certificate
         ├── chain.pem     # Root CA certificate chain
         ├── fullchain.pem # Concatenation of the two PEMs above
         └── privkey.pem   # Your private key, must be kept secret

   ```

   {{< note >}}
   Certbot offers other validation methods ([authenticators](https://eff-certbot.readthedocs.io/en/stable/using.html#getting-certificates-and-choosing-plugins))
   as well, but they're omitted here for brevity.
   {{< /note >}}

4. Create a certificate bundle fit for Unit and upload it to the
   **certificates** section of Unit's
   [control API]({{< relref "/unit/controlapi.md#configuration-api" >}}):

   ```console
   # cat /etc/letsencrypt/live/www.example.com/fullchain.pem  \
         /etc/letsencrypt/live/www.example.com/privkey.pem > bundle1.pem # Arbitrary certificate bundle's filename
   ```

   ```console
   # curl -X PUT --data-binary @bundle1.pem \ # Certificate bundle's filename
         --unix-socket /path/to/control.unit.sock \ # Path to Unit's control socket in your installation
         http://localhost/certificates/certbot1  # Certificate bundle name in Unit's configuration

   {
      "success": "Certificate chain uploaded."
   }
   ```

5. Create or update a [listener]({{< relref "/unit/configuration.md#configuration-listeners" >}}) to use the
   uploaded bundle in Unit:

   ```console
   # curl -X PUT --data-binary \
         '{"pass": "applications/ssl_app", "tls": {"certificate": "certbot1"}}' \ # Certificate bundle name in Unit's configuration
         --unix-socket /path/to/control.unit.sock \ # Path to Unit's control socket in your installation
         'http://localhost/config/listeners/*:443'  # Listener's name in Unit's configuration

   ```

6. Try accessing your website via HTTPS:

   ```console
   $ curl https://www.example.com -v

         ...
         * TLSv1.3 (OUT), TLS handshake, Client hello (1):
         * TLSv1.3 (IN), TLS handshake, Server hello (2):
         * TLSv1.3 (IN), TLS Unknown, Certificate Status (22):
         * TLSv1.3 (IN), TLS handshake, Unknown (8):
         * TLSv1.3 (IN), TLS Unknown, Certificate Status (22):
         * TLSv1.3 (IN), TLS handshake, Certificate (11):
         * TLSv1.3 (IN), TLS Unknown, Certificate Status (22):
         * TLSv1.3 (IN), TLS handshake, CERT verify (15):
         * TLSv1.3 (IN), TLS Unknown, Certificate Status (22):
         * TLSv1.3 (IN), TLS handshake, Finished (20):
         * TLSv1.3 (OUT), TLS change cipher, Client hello (1):
         * TLSv1.3 (OUT), TLS Unknown, Certificate Status (22):
         * TLSv1.3 (OUT), TLS handshake, Finished (20):
         * SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
         * ALPN, server did not agree to a protocol
         * Server certificate:
         *  subject: CN=www.example.com
         *  start date: Sep 21 22:10:42 2020 GMT
         *  expire date: Dec 20 22:10:42 2020 GMT
         ...
   ```

## Renewing certificates

Certbot enables renewing the certificates [manually](https://eff-certbot.readthedocs.io/en/stable/using.html#renewing-certificates)
or [automatically](https://eff-certbot.readthedocs.io/en/stable/using.html#automated-renewals).
For manual renewal and rollover:

1. Repeat the preceding steps to renew the certificates and upload the new
   bundle under a different name:

   ```console
   # certbot certonly --standalone

         What would you like to do?
         - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
         1: Keep the existing certificate for now
         2: Renew & replace the cert (may be subject to CA rate limits)
   ```

   ```console
   # cat /etc/letsencrypt/live/www.example.com/fullchain.pem  \
         /etc/letsencrypt/live/www.example.com/privkey.pem > bundle2.pem # Arbitrary certificate bundle's filename
   ```

   ```console
   # curl -X PUT --data-binary @bundle2.pem \ # Certificate bundle's filename
         --unix-socket /path/to/control.unit.sock \ # Path to Unit's control socket in your installation
         http://localhost/certificates/certbot2  # Certificate bundle name in Unit's configuration

   {
      "success": "Certificate chain uploaded."
   }
   ```

   Now you have two certificate bundles uploaded; Unit knows them as
   **certbot1** and **certbot2**. Optionally, query the
   **certificates** section to review common details such as expiry dates,
   subjects, or issuers:

   ```console
   # curl --unix-socket /path/to/control.unit.sock  \ # Path to Unit's control socket in your installation
          http://localhost/certificates
   ```

2. Update the [listener]({{< relref "/unit/configuration.md#configuration-listeners" >}}), switching it to the
   renewed certificate bundle:

   ```console
   # curl -X PUT --data-binary 'certbot2' \ # New certificate bundle name in Unit's configuration
         --unix-socket /path/to/control.unit.sock \ # Path to Unit's control socket in your installation
         'http://localhost/config/listeners/*:443/tls/certificate'  # Listener's name in Unit's configuration
   ```

   {{< note >}}
   There's no need to shut Unit down; your server can stay online during the
   rollover.
   {{< /note >}}

3. Delete the expired bundle:

   ```console
   # curl -X DELETE --unix-socket /path/to/control.unit.sock \ # Path to Unit's control socket in your installation
         'http://localhost/certificates/certbot1'  # Old certificate bundle name in Unit's configuration

   {
      "success": "Certificate deleted."
   }
   ```

4. You can also make use of Unit's
   [SNI]({{< relref "/unit/configuration.md#configuration-listeners" >}})
   support by configuring several certificate bundles for a listener.

   Suppose you've successfully used Certbot to obtain Let's Encrypt
   certificates for two domains, **www.example.com** and
   **cdn.example.com**. First, upload them to Unit using the same steps as
   earlier:

   ```console
   # cat /etc/letsencrypt/live/cdn.example.com/fullchain.pem  \
         /etc/letsencrypt/live/cdn.example.com/privkey.pem > cdn.example.com.pem # Arbitrary certificate bundle's filename
   ```

   ```console
   # cat /etc/letsencrypt/live/www.example.com/fullchain.pem  \
         /etc/letsencrypt/live/www.example.com/privkey.pem > www.example.com.pem # Arbitrary certificate bundle's filename
   ```

   ```console
   # curl -X PUT --data-binary @cdn.example.com.pem \ # Certificate bundle's filename
         --unix-socket /path/to/control.unit.sock \ # Path to Unit's control socket in your installation
         http://localhost/certificates/cdn.example.com  # Certificate bundle name in Unit's configuration

   {
      "success": "Certificate chain uploaded."
   }
   ```

   ```console
   # curl -X PUT --data-binary @www.example.com.pem \ # Certificate bundle's filename
         --unix-socket /path/to/control.unit.sock \ # Path to Unit's control socket in your installation
         http://localhost/certificates/www.example.com  # Certificate bundle name in Unit's configuration

   {
      "success": "Certificate chain uploaded."
   }
   ```

   Next, configure the listener, supplying both bundles as an array value for
   the **tls/certificate** option:

   ```console
   # curl -X PUT --data-binary '{"certificate": ["cdn.example.com", "www.example.com"]}' \ # Certificate bundle names in Unit's configuration
         --unix-socket /path/to/control.unit.sock \ # Path to Unit's control socket in your installation
         'http://localhost/config/listeners/*:443/tls'  # Listener's name in Unit's configuration

   ```

   Unit does the rest of the job, automatically figuring out which bundle to
   produce for each incoming connection to both domain names.

{{< note >}}
Currently, Certbot doesn't have [installer plugins](https://eff-certbot.readthedocs.io/en/stable/using.html#getting-certificates-and-choosing-plugins)
that enable automatic certificate rollover in Unit. However, you can set up
Certbot's [hooks](https://eff-certbot.readthedocs.io/en/stable/using.html#renewing-certificates)
using the commands listed here to the same effect.
{{< /note >}}
