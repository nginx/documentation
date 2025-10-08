---
# We use sentence case and present imperative tone
title: "F5 WAF for NGINX integration overview"
# Weights are assigned in increments of 100: determines sorting order
weight: 100
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: concept
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NGINX One
---

You can now integrate the features of F5 WAF for NGINX v4 and v5 in F5 NGINX One Console. F5 WAF for NGINX offers advanced Web Application Firewall (WAF) capabilities.
Through the NGINX One Console UI, you can now set up the [F5 WAF for NGINX]({{< ref "/waf/" >}}) firewall. This solution provides robust security and scalability.

## Features

Once you've connected to the NGINX One Console, select **App Protect > Policies**. You can add new policies or edit existing policies, as defined in the [F5 WAF for NGINX Administration Guide]({{< ref "/nap-waf/v5/admin-guide/overview.md" >}})

Through the NGINX One Console UI, you can:

- [Add and configure a policy]({{< ref "/nginx-one/nap-integration/configure-policy.md/" >}})
- [Review existing policies]({{< ref "/nginx-one/nap-integration/review-policy.md/" >}})
- [Deploy policies]({{< ref "/nginx-one/nap-integration/deploy-policy.md/" >}}) on instances and Config Sync Groups

You can also set up policies through the [NGINX One Console API]({{< ref "/nginx-one/nap-integration/security-policy-api.md/" >}}).

## Set up F5 WAF for NGINX

You can [install and upgrade F5 WAF for NGINX]({{< ref "/waf/install/" >}})

### Container-related configuration requirements

F5 WAF for NGINX has specific requirements for the configuration with Docker containers:

- Directory associated with the volume, which you may configure in a `docker-compose.yaml` file.
  - You may set it up with the `volumes` directive with a directory like `/etc/nginx/app_protect_policies`.
  - You need to set up the container volume. So when the policy bundle is referenced in the `nginx` directive, the file path is what the container sees.
  - You need to also include an `app_protect_policy_file`, as described in [App Protect Specific Directives]({{< ref "/nap-waf/v5/configuration-guide/configuration.md#app-protect-specific-directives" >}})

  - You'll need to set a policy bundle (in compressed tar format) in a configured `volume`.
  - Make sure the directory for [NGINX Agent]({{< ref "/agent/configuration/" >}}) includes `/etc/nginx/app_protect_policies`.

When you deploy NAP policy through NGINX One Console, do not also use plain JSON policy in the same NGINX instance.
