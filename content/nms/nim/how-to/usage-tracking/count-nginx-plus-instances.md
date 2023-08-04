---
title: "View Count of NGINX Plus Instances"
date: 2022-06-09T15:27:20-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in this guide to track your NGINX Plus inventory and generate usage reports. This information may be required for customers enrolled in the Flexible Consumption Program."

# Assign weights in increments of 100
weight: 100
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-934"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["Installation"]
doctypes: ["task"]
aliases:
- /nim/how-to/count-nginx-plus-instances/
---

{{< custom-styles >}}

{{< shortversions "2.3.0" "latest" "nimvers" >}}

## Overview

This guide will help you track your NGINX Plus instances and their usage. Get started by installing Instance Manager on a dedicated host and the NGINX Agent on each NGINX Plus instance you want to track. You can then use the Instance Manager web interface to view your NGINX Plus inventory and export the list of your NGINX Plus instances if needed.

---

## Prerequisites

### Install Instance Manager {#install-nim}

{{<note>}}You do not need a license for Instance Manager to view the count of your NGINX Plus instances.{{</note>}}

Instance Manager is part of the NGINX Management Suite.

To view your NGINX Plus inventory count, you’ll need to install Instance Manager on a dedicated host.

1. Begin by following the instructions to [install the NGINX Management Suite prerequisites]({{< relref "/nms/installation/vm-bare-metal/prerequisites.md" >}}).
2. Follow the instructions to [install Instance Manager]({{< relref "/nms/installation/vm-bare-metal/_index.md" >}}) on a dedicated host. 

### Install NGINX Agent on Each NGINX Plus Instance {#install-nginx-agent}

For your NGINX Plus instances to communicate with Instance Manager, you need to install the NGINX Agent on each instance.

- Follow the instructions to [install the NGINX Agent]({{< relref "/nms/nginx-agent/install-nginx-agent.md" >}}) on each NGINX Plus instance that needs to be counted.

---

## View Count of NGINX Plus Instances {#view-count}

The current count of NGINX Plus instances is shown on the **NGINX Plus Inventory** page.

1. {{< include "nim/webui-nim-login.md" >}}
1. On the left menu, select **NGINX Plus**.
1. (Optional) To export the list of NGINX Plus instances to a `.csv` file, select **Export**. The exported list of instances is bounded by the page count.

---

## Special Considerations

### Counting Instances without the NGINX Agent {#counting-without-nginx-agent}

To count your NGINX Plus instances without NGINX Agent, you can set up an [HTTP Health Check]({{< relref "nginx/admin-guide/load-balancer/http-health-check" >}}) on your NGINX Plus instances to report information to Instance Manager. This will require you to edit your NGINX configuration.

```nginx
### F5 / NGINX Required Configuration Code ###
### Insert the following into the http {} block of your NGINX configuration file ###
upstream receiver {
    zone receiver 64k;

    # REQUIRED: Update NMS_FQDN with NGINX Management Suite IP Address or hostname.
    # If configuring with hostname, please ensure to uncomment the resolver
    # directive below and define a DNS server that can resolve the hostname.
    server NMS_FQDN:443;

    # OPTIONAL: Update DNS_UP with DNS server IP address that can resolve
    # the hostname defined above.
    #resolver DNS_IP;
}

map CERT $repo_crt {
    # OPTIONAL: Location of repository certificate
    #default /etc/ssl/nginx/nginx-repo.crt;
}

map KEY $repo_key {
    # OPTIONAL: Location of repository private key
    #default /etc/ssl/nginx/nginx-repo.key;
}

server {
    location @ngx_usage_https {
        # OPTIONAL: Configure scheme (http|https) here
        proxy_pass https://receiver;
        # set nap=active if it's installed
        proxy_set_header Nginx-Usage "Version=$nginx_version;Hostname=$hostname;uuid=$nginx_uuid;nap=inactive"; 
        health_check uri=/api/nginx-usage interval=1800s;       # DO NOT MODIFY
        proxy_ssl_certificate     $repo_crt;                    # DO NOT MODIFY
        proxy_ssl_certificate_key $repo_key;                    # DO NOT MODIFY
    }

    proxy_set_header ngxuuid $nginx_uuid;

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

keyval_zone zone=uuid:32K state=/var/lib/nginx/state/instance_uuid.json;
keyval 1 $nginx_uuid zone=uuid;

### End of F5 / NGINX Required Configuration Code ###
```

The above NGINX `server` configuration can be saved as a file into the `http` context location for your NGINX plus installation, typically `/etc/nginx/conf.d`. You would need to modify the configuration base on your NGINX Instance Manager installation:

1. The `receiver` block must be updated with your `NMS_FQDN`. If you use a private DNS name, uncomment and update the `resolver` to your [DNS resolver](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#resolver). 
1. If your NGINX Instance Manager server is set up to require an SSL client certificate, the `map` block for `CERT` and `KEY` must be updated with the location of the SSL certificate and key that are known to the NGINX Instance Manager server. See [Securing HTTP Traffic to Upstream Servers]({{< relref "nginx/admin-guide/security-controls/securing-http-traffic-upstream" >}}) for more information. We recommend requiring an SSL client certificate for communication that is external to the NGINX Instance Manager server.
1. Additionally, you can set up an access limit to the `/api/nginx-usage` location of your NGINX Instance Manager server based on client network address. See [Module ngx_http_access_module](http://nginx.org/en/docs/http/ngx_http_access_module.html) for more information.

{{<warning>}}If you later install and register `nginx_agent` for your NGINX Plus instances, you should remove the added NGINX Plus instance counting configuration from the NGINX instance where the `nginx_agent` is running. Otherwise, your NGINX Plus instance may be counted multiple times.{{</warning>}}

---

## Troubleshooting

If NGINX Plus reports non-compliance errors, you may need to [add the NGINX user to the `nginx_agent` group]({{< relref "/nms/nginx-agent/configure-nginx-agent-group.md" >}}).
