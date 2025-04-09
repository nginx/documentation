---
docs: DOCS-1351
---

You can track NGINX Plus instances using an [HTTP Health Check]({{< ref "nginx/admin-guide/load-balancer/http-health-check" >}}) without installing NGINX Agent. This involves updating the NGINX Plus configuration file. Follow these steps:

1. Open the NGINX Plus configuration file ([_/etc/nginx/conf.d_]({{< ref "nginx/admin-guide/basic-functionality/managing-configuration-files.md#feature-specific-configuration-files" >}})) and insert the following code within the `http {}` block:

    ```nginx
    ### F5 / NGINX Required Configuration Code ###
    ### Insert the following into the http {} block of your NGINX configuration file ###

    keyval_zone zone=uuid:32K state=/var/lib/nginx/state/instance_uuid.json;
    keyval 1 $nginx_uuid zone=uuid;

    upstream receiver {
        zone receiver 64k;

        # REQUIRED: Update NMS_FQDN with NGINX Instance Manager IP Address or hostname.
        # If configuring with hostname, please ensure to uncomment the resolver
        # directive below and define a DNS server that can resolve the hostname.
        server NMS_FQDN:443;

        # OPTIONAL: Update DNS_UP with DNS server IP address that can resolve
        # the hostname defined above.
        #resolver DNS_IP;
    }

    map CERT $repo_crt {
        # OPTIONAL: Location of client certificate
        #default /etc/ssl/nginx/nginx-client.crt;
    }

    map KEY $repo_key {
        # OPTIONAL: Location of client certificate private key
        #default /etc/ssl/nginx/nginx-client.key;
    }

    server {
        location @ngx_usage_https {
            # OPTIONAL: Configure scheme (http|https) here
            proxy_pass https://receiver;

            # REQUIRED: If using NGINX APP PROTECT (NAP) on this instance, set nap=active on the following line:
            proxy_set_header Nginx-Usage "Version=$nginx_version;Hostname=$hostname;uuid=$nginx_uuid;nap=inactive";

            health_check uri=/api/nginx-usage interval=1800s;       # DO NOT MODIFY
            proxy_ssl_certificate     $repo_crt;                    # DO NOT MODIFY
            proxy_ssl_certificate_key $repo_key;                    # DO NOT MODIFY
        }

        location @self {
            health_check uri=/_uuid interval=1d;
            proxy_pass http://self;
        }

        location = /_uuid {
            if ($nginx_uuid !~ .) {
                set $nginx_uuid $request_id;
            }
            return 204;
        }

        listen unix:/tmp/ngx_usage.sock;
    }

    upstream self {
        zone self 64k;
        server unix:/tmp/ngx_usage.sock;
    }

    ### End of F5 / NGINX Required Configuration Code ###
    ```

2. Modify the configuration to suit your specific NGINX Instance Manager installation:

   - Update the `NMS_FQDN` variable in the `upstream receiver` block with your Instance Manager hostname or IP address. If using a private DNS, uncomment and update the resolver with your [DNS IP Address](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#resolver).
   - If your Instance Manager server requires client SSL certification, specify the locations of the SSL certificate and key in the `map CERT` and `map KEY` blocks. For more details, see [Securing HTTP Traffic to Upstream Servers]({{< ref "nginx/admin-guide/security-controls/securing-http-traffic-upstream" >}}).
   - If you're using NGINX App Protect, change `nap=inactive` to `nap=active` in the `location @ngx_usage_https` block.
   - Optionally, you can limit access to the `/api/nginx-usage` location on your NGINX Instance Manager server based on client network address. For guidance on how to do this, refer to [Module ngx_http_access_module](http://nginx.org/en/docs/http/ngx_http_access_module.html).
3. Save the changes.

{{<important>}}If you install NGINX Agent later, remove this configuration to prevent double-counting instances.{{</important>}}
