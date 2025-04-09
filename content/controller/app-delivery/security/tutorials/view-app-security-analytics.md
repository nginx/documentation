---
description: How to view App Security Analytics.
docs: DOCS-487
title: View App Security Analytics
toc: true
weight: 500
type:
- concept
- reference
---

## Overview

When App Security flags or blocks a request made to an App Component as a security violation, it generates an App Security event.
You can use the F5 F5 NGINX Controller web interface or the REST API to view these events or their related statistics (measures). Metrics reflect the number of requests and bytes flagged or blocked. You can use the Security Violation Dimensions to help understand and interpret the analytics data.

For descriptions of Security Metrics and Events Dimensions, refer to [About App Security]({{< ref "/controller/app-delivery/security/concepts/what-is-waf.md" >}}) page.

## View App Security Analytics

You can use the NGINX Controller user interface or the REST API to view App Security Analytics. You can use this data to get a quick, high-level understanding of how the App Security module processes requests to an App.

1. Open the NGINX Controller user interface and log in.
2. On the Navigation Bar, select **Services**.
3. On the Services Menu, select **Apps**.
4. On the Apps Overview page, select the App name link.
5. Select **Security Analytics** under the Analytics sub-menu.

## View Security Analytics for Components

To view Security Analytics for individual Components, take the steps below.

1. Open the NGINX Controller user interface and log in.
2. On the Navigation Bar, select **Services**.
3. On the Services Menu, select **Apps**.
4. On the Apps Overview page, select the App name link.
5. Select **Components** from the menu. Select the Component name link.
6. Select **Security Analytics** under the Analytics sub-menu.

### View App Security Events

To view app security events:

1. Open the NGINX Controller user interface and log in.
2. On the Navigation Bar, select **Services**.
3. On the Services Menu, select **Apps**.
4. On the Apps Overview page, select the App name link.
5. Select **Security Events** under the Analytics sub-menu.

### View Security Events for Components

To view the security events for components, take the following steps:

1. Open the NGINX Controller user interface and log in.
2. On the Navigation Bar, select **Services**.
3. On the Services Menu, select **Apps**.
4. On the Apps Overview page, select the App name link.
5. Select **Components** from the sub-menu. Select the Component name link.
6. Select **Security Events** under the Analytics sub-menu.

## Example REST API Queries for App Security Metrics

Requests which App Security has rejected or allowed:

```curl
https://{{host}}/api/v1/analytics/metrics?
    startTime=0&
    endTime=now&
    names=sum(http.request.count)&
    groupBy=request_outcome&
    resolution=30m
```

Possible request outcomes are:

- Passed: WAF allowed the request
- Rejected: WAF blocked the request

To get request counts based on how App Security processed the traffic:

```curl
https://{{host}}/api/v1/analytics/metrics?
    startTime=0&
    endTime=now&
    resolution=5m&
    names=sum(http.request.count)&
    groupBy=request_outcome_reason&
    filter=(
        app='shopping' and
        environment='prod' and
        component='app-component')
```

| **request_outcome_reason values** | **Description** |
|--------------------------------|-----------------|
| \<empty\> | App Security did not process the traffic (in other words, App Security is not enabled). All events with this request_outcome_reason value should have a request_outcome `PASSED`.|
| SECURITY_WAF_OK | App Security processed the traffic and no violations are found.  All events with this request_outcome_reason value should have a request_outcome of `PASSED`.|
| SECURITY_WAF_FLAGGED | App Security allowed the request, but it was flagged for review. All events with this request_outcome_reason value should have a request_outcome of `PASSED`.|
| SECURITY_WAF_VIOLATION | App Security identified one or more violations and rejected the request. All events with this request_outcome_reason value should have a request_outcome of `REJECTED`.|

If you feel App Security is blocking too many requests, you can turn on monitor-only mode.

### Security Violation Events

You can use Security Violation Events to investigate violations identified by App Security for requests made to an App Component. Follow the steps below to view the Security Events:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Analytics**.
3. On the **Analytics Menu**, select **Component**.

You can use the following example Events requests to collect App Security Analytics data by using the NGINX Controller REST API:

- To view ‘security violation’ Events:

    ```curl
    GET https://{{host}}/api/v1/analytics/events?
        startTime=0&
        endTime=now&
        filter=(
            category='security violation')
    ```

- To get security violation details based on the Support ID seen on the request blocking page:

    ```curl
    GET https://{{host}}/api/v1/analytics/events?
        startTime=0&
        endTime=now&
        filter=(
            category='security violation' and
            waf.support_id='1880765231147185611')
    ```

- To get all events where WAF rejected to investigate:

    ```curl
    GET https://{{host}}/api/v1/analytics/events?
        startTime=0&
        endTime=now&
        filter=(
            category='security violation' and
            request_outcome='REJECTED')
    ```

- To get all events where WAF flagged to investigate:

    ```curl
    GET https://{{host}}/api/v1/analytics/events?
        startTime=0&
        endTime=now&
        filter=(
            category='security violation' and
            request_outcome_reason='SECURITY_WAF_FLAGGED')
    ```

- To get all events where WAF has rejected or flagged to review:

    ```curl
    GET https://{{host}}/api/v1/analytics/events?
        startTime=0&
        endTime=now&
        filter=(
            category='security violation' and
            request_outcome_reason in ('SECURITY_WAF_VIOLATION','SECURITY_WAF_FLAGGED'))
    ```

- To get all events where WAF has rejected or flagged for a specific App Component:

    ```curl
    GET https://{{host}}/api/v1/analytics/events?
        startTime=0&
        endTime=now&
        filter=(
                category='security violation' and
                request_outcome_reason in ('SECURITY_WAF_VIOLATION','SECURITY_WAF_FLAGGED') and
                app='shopping' and
                environment='prod' and
                component='app-component')
    ```

   {{< tip >}}
To get all Events, remove the Environment, App, and Component filters from the request call.
   {{< /tip >}}

- To find requests flagged by App Security’s violation rating algorithm as a possible or likely threat:

    ```curl
    GET https://{{host}}/api/v1/analytics/events?
        startTime=0&
        endTime=now&
        filter=(
            category='security violation' and
            request_outcome_reason = 'SECURITY_WAF_FLAGGED' and
            waf.violation_rating in ('POSSIBLE_ATTACK','MOST_LIKELY_ATTACK') and
            app='shopping' and
            environment='prod' and
            component='app-component')
    ```

    {{< important >}}
This is important if you are using App Security WAF monitoring only mode. You can use it to understand the type of threats WAF believes should be blocked.
    {{< /important >}}

- To get Events that have triggered a specific signature-based violation by signature id:

    ```curl
    GET https://{{host}}/api/v1/analytics/events?
        startTime=0&
        endTime=now&
        filter=(
            category='security violation' and
            waf.signature_ids ='*200000098*' and
            app='shopping' and
            environment='prod' and
            component='app-component')
    ```

    The substring search using wildcards or ‘IN’ operand should be used because each signature might be part of various combinations of signatures triggered by App Security per request.

- To get Events that have triggered a specific a signature-based violation by signature id:

    ```curl
    GET https://{{host}}/api/v1/analytics/events?
        startTime=0&
        endTime=now&
        filter=(
            category='security violation' and
            waf.signature_names IN ('DIRECTORY_TRAVERSAL') and
            app='shopping' and
            environment='prod' and
            component='app-component')
    ```

    The substring search using wildcards or ‘IN’ operand should be used because each signature might be part of various combinations of signatures triggered by App Security per request.

- To get Events that triggered a particular attack type:

    ```curl
    GET https://{{host}}/api/v1/analytics/events?
        startTime=0&
        endTime=now&
        filter=(
            category='security violation' and
            waf.attack_types='*Non-browser Client, Abuse of Functionality*' and
            app='shopping' and
            environment='prod' and
            component='app-component')
    ```

    The substring search using wildcards or ‘IN’ operand should be used because each signature might be part of various combinations of attack types triggered by App Security per request.

- To get Events from a remote address (client IP)

    ```curl
    GET https://{{host}}/api/v1/analytics/events?
        startTime=0&
        endTime=now&
        filter=(
            category='security violation' and
            http.remote_addr='172.18.71.147' and
            app='shopping' and
            environment='prod' and
            component='app-component')
    ```

## Related Pages

- [About App Security]({{< ref "/controller/app-delivery/security/concepts/what-is-waf.md" >}})

{{< versions "3.12" "latest" "ctrlvers" >}}
