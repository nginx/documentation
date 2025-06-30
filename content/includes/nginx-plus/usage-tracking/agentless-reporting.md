---
nd-docs: DOCS-1408
---

Since [Release 31]({{< ref "/nginx/releases.md#nginxplusrelease-31-r31" >}}), NGINX Plus provides a built-in support for reporting of your NGINX Plus instances to NGINX Instance Manager without the need of installing NGINX Agent or tuning HTTP Health checks. If you participate in the [F5 Flex Consumption Program](https://www.f5.com/products/get-f5/flex-consumption-program), you will no longer need to manually track your NGINX Plus instances.

Usage reporting is enabled by default. At each startup, NGINX Plus attempts to discover NGINX Instance Manager via a DNS lookup of the `nginx-mgmt.local` hostname. Then NGINX Plus establishes a TLS connection to NGINX Instance Manager and every `30` minutes reports its version number, hostname, and identifier.

If NGINX instance reporting is not configured or NGINX Plus cannot provide its usage information to NGINX Instance Manager, a warning message will be logged.

Parameters customization can be done with the [`ngx_mgmt_module`](https://nginx.org/en/docs/ngx_mgmt_module.html#mgmt) module, in particular if you need to:

- use mTLS for enhanced security (recommended)

- define a custom resolver

- use an IP address or a different hostname to identify NGINX Instance Manager

- specify other custom parameters such as reporting time, path to the reporting file, etc.


## Enabling Mutual Client Certificate Auth Setup (mTLS)

It is highly recommended to secure and authorize NGINX Plus instance with NGINX Instance Manager by using client certificates unique to each endpoint.

1. Obtain a certificate, a key, and a CA certificate on both the NGINX Instance Manager and NGINX Plus instance. See the [Secure Traffic with Certificates]({{< ref "/nim/system-configuration/secure-traffic.md" >}}) for instructions on how to generate keys.

2. In the configuration file of NGINX Plus instance, on the `main` level, add the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html#mgmt) block:

   ```nginx
   mgmt {
       #...

   }
   ```

3. Set up a HTTPS server that accepts and terminates the traffic from NGINX Instance Manager. Inside the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html#mgmt) block, specify the path to the client certificate and private key file with the [`ssl_certificate`](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_certificate) and [`ssl_certificate_key`](https://nginx.org/en/docs/ngx_mgmt_module.html#sl_certificate_key) directives:

   ```nginx
   mgmt {
       ssl_protocols TLSv1.2 TLSv1.3;
       ssl_ciphers   DEFAULT;

       ssl_certificate     client_cert.pem;
       ssl_certificate_key client_cert.key;
       #...
   }
   ```

   While the server certificate is a public entity and is sent to NMS, the private key is a secure entity and should be stored in a file with restricted access.


4. Configure the verification of the NMS server certificate to validate the authenticity of NMS:

   ```nginx
   mgmt {
       #...
       ssl_trusted_certificate  trusted_ca_cert.crt;
       ssl_verify               on;
       ssl_verify_depth         2;
   }
   ```

   Full configuration:

   ```nginx
   mgmt {
       resolver 10.0.0.1;

       ssl_protocols TLSv1.2 TLSv1.3;
       ssl_ciphers   DEFAULT;

       ssl_certificate     client_cert.pem;
       ssl_certificate_key client_cert.key;

       ssl_trusted_certificate  trusted_ca_cert.crt;
       ssl_verify               on;
       ssl_verify_depth         2;
   }
   ```

5. Reload the NGINX Plus configuration:

   ```shell
   sudo nginx -s reload
   ```

6. Make the corresponding changes on the NGINX Instance Manager server side. See [Secure Client Access and Network Traffic for NMS](https://docs.nginx.com/nginx-management-suite/admin-guides/configuration/secure-traffic/)


## Specifying a custom resolver

If there is a custom DNS server in your corporate network, you can specify its address with the [`resolver`](https://nginx.org/en/docs/ngx_mgmt_module.html#resolver) directive in the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html#mgmt) block:

```nginx
mgmt {
    resolver 10.0.0.1;
    #...
}
```

By default, NGINX Plus re-resolves DNS records at the frequency specified by time‑to‑live (TTL) in the record, but you can override the TTL value with the valid parameter; in the example it is `300` seconds, or `5` minutes.

Also, the optional `ipv6=off` parameter means only IPv4 addresses are used, though resolving of both IPv4 and IPv6 addresses is supported by default:

```nginx
mgmt {
    resolver 10.0.0.1 valid=300s ipv6=off;
    #...
}
```

To make the resolver statistics appear in [Live Activity Monitoring Dashboard](https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/)), specify the [`status_zone`](https://nginx.org/en/docs/ngx_mgmt_module.html#resolver_status_zone) parameter of the [`resolver`](https://nginx.org/en/docs/ngx_mgmt_module.html#resolver) directive:

```nginx
mgmt {
    resolver 10.0.0.1 status_zone=resolver-zone1;
    #...
}
```

## Defining custom address for NGINX Instance Manager

There are several ways to configure the address of NGINX Instance Manager:

- (recommended) add an `A` record to your local DNS that will associate the default hostname with the IP address of the system running NGINX Instance Manager

- set the address with the `endpoint` parameter of the [`usage_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) directive, by default the address is `nginx-mgmt.local`:

   ```nginx
   mgmt {
       resolver     10.0.0.1;
       usage_report endpoint=nms.local interval=15m;
       #...
   }
   ```

  If the name resolves into several IP addresses, the first IP address will be used.

## Configuration Example

```nginx
#...

mgmt {
    usage_report endpoint=nginx-mgmt.local interval=30m;
    resolver     DNS_IP;

    uid_file /var/lib/nginx/nginx.id;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers   DEFAULT;

    ssl_certificate     client_cert.pem;
    ssl_certificate_key client_cert.key;

    ssl_trusted_certificate  trusted_ca_cert.crt;
    ssl_verify               on;
    ssl_verify_depth         2;
}

#...
```
