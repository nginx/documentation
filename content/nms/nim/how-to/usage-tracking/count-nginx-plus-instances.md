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

This guide will help you track your NGINX Plus instances and their usage. Get started by installing NGINX Instance Manager on a dedicated host and NGINX Agent on each NGINX Plus instance you want to track. You can then use the NGINX Instance Manager web interface to view your NGINX Plus inventory and export the list of your NGINX Plus instances if needed.

---

## Prerequisites

### Install Instance Manager {#install-nim}

{{<note>}}You do not need a license for NGINX Instance Manager to view the count of your NGINX Plus instances.{{</note>}}

Instance Manager is part of the NGINX Management Suite.

To view your NGINX Plus inventory count, you’ll need to install NGINX Instance Manager on a dedicated host.

1. Begin by following the instructions to [install NGINX Management Suite prerequisites]({{< relref "/nms/installation/vm-bare-metal/prerequisites.md" >}}).
2. Next, follow the instructions to [install NGINX Instance Manager]({{< relref "/nms/installation/vm-bare-metal/_index.md" >}}) on a dedicated host. 

### Install NGINX Agent on Each NGINX Plus Instance {#install-nginx-agent}

For your NGINX Plus instances to communicate with NGINX Instance Manager, you must install NGINX Agent on each instance.

- Follow these instructions to [install NGINX Agent]({{< relref "/nms/nginx-agent/install-nginx-agent.md" >}}) on each NGINX Plus instance that needs to be counted.

{{<note>}}To optimize NGINX Agent performance for reporting, the following line may be added to the NGINX Agent configuration file (`/etc/nginx-agent/nginx-agent.conf`).
```
features: registration,dataplane-status
```
{{</note>}}

---

## View Count of NGINX Plus Instances {#view-count}

The current count of NGINX Plus instances is shown on the **NGINX Plus Inventory** page.

1. {{< include "nim/webui-nim-login.md" >}}
1. On the left menu, select **NGINX Plus**.
1. (Optional) To export the list of NGINX Plus instances to a `.csv` file, select **Export**. The exported list of instances is bounded by the page count.

---

## Special Considerations

### Counting Instances without the NGINX Agent {#counting-without-nginx-agent}

To track your NGINX Plus instances without NGINX Agent, you can set up an [HTTP Health Check]({{< relref "nginx/admin-guide/load-balancer/http-health-check" >}}) on your NGINX Plus instances to report tracking information to NGINX Instance Manager. This will require you to add the following to your NGINX Plus configuration:

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

keyval_zone zone=uuid:32K state=/var/lib/nginx/state/instance_uuid.json;
keyval 1 $nginx_uuid zone=uuid;

### End of F5 / NGINX Required Configuration Code ###
```

The above NGINX `server` configuration can be saved as a file into the `http` context location of your NGINX Plus installation, typically `/etc/nginx/conf.d`. You must modify the configuration to suit your NGINX Instance Manager installation:

1. The `NMS_FQDN` variable in the `upstream receiver` block must be updated to reflect your NGINX Instance Manager hostname or IP address. If using a private DNS, uncomment and update the `resolver` to reflect your [DNS IP Address](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#resolver). 
1. If your NGINX Instance Manager server is configured to require a client SSL certificate, the `map CERT` and `map KEY` blocks must be updated with the location of the SSL certificate and key that are known to the NGINX Instance Manager server. See [Securing HTTP Traffic to Upstream Servers]({{< relref "nginx/admin-guide/security-controls/securing-http-traffic-upstream" >}}) for more information. We recommend using client SSL certificates for all communications external to the NGINX Instance Manager server.
1. If you are using NGINX App Protect on this instance, you must update `nap=inactive` to `nap=active` in the `location @ngx_usage_https` block.
1. Additionally, you can set up an access limit to the `/api/nginx-usage` location of your NGINX Instance Manager server based on client network address. See [Module ngx_http_access_module](http://nginx.org/en/docs/http/ngx_http_access_module.html) for more information.

{{<warning>}}If you later install and register NGINX Agent for your NGINX Plus instances, you should remove the above NGINX Plus configuration from the NGINX instance where NGINX Agent is running. Otherwise, your NGINX Plus instance may be counted multiple times.{{</warning>}}

---

## Troubleshooting

If NGINX Plus reports non-compliance errors, you may need to [add the NGINX user to the `nginx_agent` group]({{< relref "/nms/nginx-agent/configure-nginx-agent-group.md" >}}).
