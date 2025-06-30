---
description: How to tune WAF for your App.
nd-docs: DOCS-486
title: Manage WAF Tuning for App Components
toc: true
weight: 300
type:
- concept
- reference
---

## Overview

WAF Tuning helps remove false positives or exceptions from Security Events.

## Disable Attack Signatures

To help determine which signatures may be causing false positives, go to the Security Analytics page of the app component. Go to the WAF Tuning tab, where F5 NGINX Controller provides this information.

To disable signatures, take the steps below.

1. Open the NGINX Controller user interface and log in.
2. On the Navigation Bar, select **Services**.
3. On the Services Menu, select **Apps**.
4. On the Apps Overview page, select the App name link.
5. Select **Components** under the All Apps sub-menu.
6. On the Components page, select the Component name link.
7. Select **Edit Component**.
8. On the Edit App Component page, select **Security** menu.
9. On the **Disable Signatures** text box, add the signatures that need to be disabled.

The top signatures list consists of the top-50 signatures that triggered security events to block requests during the selected time interval. They are investigated first to ensure false positives are not blocking requests for your app component.

This page shows the signatures from the top-1000 signature combinations. Note that order matters when counting signature combinations. For example, the combination “Signature 1, Signature 2” is distinct from “Signature 2, Signature 1”.

The top-1000 signature combinations may be a subset of all requests that result in violations. At the bottom of the WAF Tuning table, the percentage of requests represented in the WAF tuning table is shown as “Top Signatures based on X% of total requests”.

Since a single request may result in multiple signature violations, the total of all percentages in the table may be greater than 100%.

## Configure Monitor-Only Mode

To configure the Monitor-Only Mode, take the steps below.

1. Open the NGINX Controller user interface and log in.
2. On the Navigation Bar, select **Services**.
3. On the Services Menu, select **Apps**.
4. On the Apps Overview page, select the App name link.
5. Select **Components** under the All Apps sub-menu.
6. On the Components page, select the Component name link.
7. Select **Edit Component**.
8. On the Edit App Component page, select **Security** menu.
9. Toggle to Enable/Disable the **Monitor Only** button.

{{< note >}}
When **Monitor Only** mode is enabled, it will not block traffic. Event violations will be sent according to the policies associated with the referenced strategy.

When **Monitor Only** mode is disabled, traffic is blocked based on the [Violation Rating]({{< ref "/controller/app-delivery/security/concepts/app-sec-default-policy-original.md#use-of-violation-ratings-in-default-policy" >}}) score for the default policy.
{{< /note >}}

{{< versions "3.12" "latest" "ctrlvers" >}}
