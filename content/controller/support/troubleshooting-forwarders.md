---
description: Steps to take to investigate and fix issues with data forwarders.
nd-docs: DOCS-377
title: Troubleshoot Data Forwarders
toc: true
weight: 200
type:
- tutorial
---

## Overview

If your Data Forwarders aren't behaving how you expect them to, you can take the following steps to troubleshoot issues. If you need to [contact F5 NGINX Support]({{< ref "/controller/support/contact-support.md" >}}), make sure to [create a support package](#support/create-a-support-package) first.

## Fix NGINX Controller Issues by Upgrading

We recommend you [upgrade NGINX Controller]({{< ref "/controller/admin-guides/install/install-nginx-controller.md#update-nginx-controller" >}}) as new versions become available. Upgrades include new features, feature improvements, or fixes for known issues.

To look up your version of NGINX Controller:

1. Open the NGINX Controller browser interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the Platform menu, select **Cluster** > **Overview**.

{{< call-out "note" >}}Refer to the [NGINX Controller release notes]({{< ref "/controller/releases/" >}}) to see what's new in the latest release of NGINX Controller.{{< /call-out>}}

&nbsp;

---

## How to Find Error Messages by Using the REST API

You can find error messages emitted by the forwarder by querying the the NGINX Controller REST API

1. Send an HTTP GET request to the `/analytics/forwarders` endpoint in the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}).

    Replace the session cookie, Controller-FQDN, and forwarderName in the example curl command below with the correct values for your environment.

    ```curl
    curl -X GET --cookie "session=<session cookie>" --url "{{Controller-FQDN}}/api/v1/analytics/forwarders/{forwarderName}"
    ```

2. In the response, locate the `currentStatus.state.conditions` object.

   This object contains details about the current status of the Forwarder, including any error messages.

   <a name="integration-error-example">For example:</a>

    ```json
    {
        "currentStatus": {
            "integrationRef": {
                "ref": "/platform/integrations/splunk"
            },
            "state": {
                "conditions": [
                    {
                        "message": "error code: 440001, Integration with reference '/platform/integrations/splunk_events' cannot be found. Please check if the Integration reference is correct.",
                        "type": "error"
                    }
                ],
            ...
    }
    ```

In the example above, the Forwarder is in an `error` state because the Integration referenced by the Forwarder couldn't be found. This could be due to a spelling error in the name of the Integration, or the Integration may have been removed from the system.

&nbsp;

---

## How to Find Forwarder Events by using the User Interface

Data Forwarders generate events that can give you a historical view of actions that have occurred.

Take the following steps to view Forwarder events:

1. Open the NGINX Controller user interface and log in.
1. On the Analytics menu, select **Events**.
1. Select **Forwarder Notifications** to view all of the Events related to Data Forwarders.

&nbsp;

---

## Common Issues

### Forwarder is in an Error State but the Collector Still Receives Data

If the Data Forwarder is returning an error, but the Collector is still receiving data, the connection between NGINX Controller and the Collector may be unstable.

If this is the case, an HTTP GET request for the Forwarder will return an error message like the one shown below:

```json
"state": {
    "conditions": [
        {
            "message": "error code: 440020, Sending data failed. Connection to the specified Splunk collector at {collectorAddress} could not be established. Check Integration and Splunk collector configuration.",
            "type": "error"
        },
        {
            "message": "error code: 440050, Heartbeat failed. Connection to the collector with reference /platform/integrations/splunk could not be established. Check Integration and collector configuration.; The error has occurred 3 times in the last 30s.",
            "type": "error"
        }
    ],
}
```

The Forwarder's reported status depends on a number of conditions, each of which has an associated weight. If the sum of all weights crosses a set threshold, then the Forwarder returns an error. This doesn't necessarily mean that the connection to the Collector is broken, but it does reflect issues that are affecting the ability to consistently connect to the Collector. The Forwarder will send the data when it is able to successfully connect, which is why the Collector still displays new data.

As indicated by the error message, you should check the Forwarder's configuration and the status of the receiving platform to ensure that data will continue to be sent by the Forwarder and received by the Collector.

### Collector Receives Duplicate Data

If you have a Forwarder that is set up to use multiple data Streams, you may end up with duplicate data in the Collector. If this is the case, check your Streams to make sure that each is set up to forward a unique data set.

For example, the following Forwarder contains two Streams:

```json
"streams": [
    {
        "inputDataType": "METRICS",
        "outputFormat": "SPLUNK",
        "selector": "names=nginx.http.conn.active"
    },
    {
        "inputDataType": "METRICS",
        "outputFormat": "SPLUNK",
        "selector": "names=nginx.http*"
    }
    ]
```

In the first Stream, the selector  -- `names=nginx.http.conn.active` -- contains a single metric. The second Stream's selector -- `names=nginx.http*` -- contains a wildcard, which means that it will send data for all metrics that begin with `nginx.http`.

The wildcard in the second selector matches the metric defined in the first -- `nginx.http.conn.active`. This means that the Forwarder will send the metric `nginx.http.active` to the Collector twice (once in each Stream).

### Forwarder Reports an Error with an Integration

If you received an error message regarding an Integration, like the one in [the example above](#integration-error-example), you need to fix the Integration settings to resolve the error. However, Forwarders don't monitor the associated Integration for updates, so they will continue to return the error message even after the Integration settings are fixed.

To resolve errors with an Integration:

1. Update the Integration settings.
1. Remove the Forwarder.
1. Re-add the Forwarder.

{{< call-out "tip" >}}Before you remove the Forwarder, perform an HTTP GET request to capture the Forwarder's settings. Then, you can delete the Forwarder. Use the JSON payload returned in the GET request to re-create the Forwarder by sending an HTTP PUT request to the `/analytics/forwarders` endpoint in the [NGINX Controller REST API]]({{< ref "/controller/api/_index.md" >}}).{{< /call-out >}}

### Error code 440001 -- Integration cannot be found

The `Error 440001` message is returned when the Forwarders module can't find the referenced Integration. Try the following to resolve the issue:

- Make sure the Integration exists.

  If it doesn't, follow the steps in [Forward Analytics Data to Splunk]({{< ref "/controller/analytics/forwarders/forward-analytics-to-splunk.md" >}}) or [Forward Analytics Data to Datadog]({{< ref "/controller/analytics/forwarders/forward-analytics-to-datadog.md" >}}) to create a new one.

- Make sure the Integration reference uses the correct path format. All references should use the following relative format:

  ```json
  /platform/integrations/{integrationName}
  ```

### Splunk Data Forwarder is in an Error state after Upgrade

In NGINX Controller version 3.13, the output format `SPLUNK_HEC` was changed `SPLUNK`. If you created a Splunk Data Forwarder in an earlier version and upgraded to v3.13, you may receive the error below:

```json
"conditions": [
    {
        "message": "obtaining gateway input: creating gateway: no constructor found for gateway type SPLUNK_HEC",
        "type": "error"
    }
],
```

To resolve this error, update the Forwarder to use `SPLUNK` instead of `SPLUNK_HEC`, as described in [Forward Analytics Data to Splunk]({{< ref "/controller/analytics/forwarders/forward-analytics-to-splunk.md" >}}).

{{< call-out "tip" >}}To update the Forwarder settings, you can send an HTTP PUT request that contains the updated `outputFormat` config to the `/analytics/forwarders` endpoint in the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}).{{< /call-out >}}

{{< versions "3.6" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
