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

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-558 -->