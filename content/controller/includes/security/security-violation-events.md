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

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-559 -->