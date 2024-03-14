---
aliases:
- analytics/alerts/configure-notifications/
authors: []
categories:
- analytics
date: "2020-10-26T15:32:41-06:00"
description: Set up Alerts Integration with ServiceNow. Deprecated in v3.13.
docs: DOCS-523
doctypes:
- task
draft: false
journeys:
- researching
- getting started
- using
personas:
- devops
- netops
- secops
- support
roles:
- admin
- user
- read-only
tags:
- docs
- deprecated
title: ServiceNow Alerts Integration
toc: true
weight: 600
---


## ServiceNow Alert Integration

{{< deprecated >}}
**The ServiceNow Alert Integration is deprecated in NGINX Controller v3.13.**
{{< /deprecated >}}

The ServiceNow integration sends all notifications from NGINX Controller to the Incidents table in your ServiceNow account. Follow the steps below to set up the integration.

1. Install Python3 on your machine.
2. In your ServiceNow instance, go to **System OAuth > Application Registry** and create a new OAuth API endpoint for external clients.

    Fill out the form and specify a long refresh token lifespan. Consider aligning the token lifespan with the expiry date of your NGINX Controller license.

    {{< important >}} The ServiceNow integration will fail once the refresh token expires.{{< /important >}}

3. Select the **Configure ServiceNow** button. In the prompt, provide the requested information for the ServiceNow client and select **Save**.

   - **ServiceNow Instance** - The instance ID for your ServiceNow account.
   - **Client ID** - Client ID from ServiceNow (from Step 2).
   - **Client Secret** - Client Secret from ServiceNow (from Step 2).
   - **Username** - Your ServiceNow username; this is used to generate the access token and will not be stored.
   - **Password** - Your ServiceNow password; this is used to generate the access token and will not be stored.
   - **Controller host** - The URL of your NGINX Controller instance.
   - **Controller email** - The email that you use to log in to Controller.
   - **Controller password** - The password that you use to log in to Controller.
   - **Controller port** - The port on which NGINX Controller is running; the default is 80.
   - **Company name** - The name of your company; this is used to create the ServiceNow transport.  
<br>
4. Watch Controller alerts come through as incidents in ServiceNow. 

    Mapping of Controller Alerts to ServiceNow Priority:

   - ('alerts', 'created')  → 1
   - ('alerts', 'cleared') → 3
   - ('agent', 'nginx_not_found') → 1
   - ('agent', 'nginx_config_parsing_error') → 1
   - ('ssl_expiration', 'ssl_cert_has_expired') → 1
   - ('ssl_expiration', 'ssl_cert_will_expire') → 2
   - ('agent', 'agent_version_old') → 2
   - ('agent', 'agent_version_obsoleted') → 1
   - ('group_actions', 'group_action_completed') → 3

{{< versions "3.0" "3.13" "ctrlvers" >}}

