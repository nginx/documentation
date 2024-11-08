---
docs:
---

The following JSON example shows the NGINX Plus usage data sent to F5 in a `POST` request, every hour by default.

```json
{
    "version": "<nginx_version>",
    "uuid": "<nginx_uuid>",
    "nap": "<active/inactive>", // status of NGINX App Protect
    "http": {
        "client": {
            "received": 0, // bytes received
            "sent": 0, // bytes sent
            "requests": 0 // number of HTTP requests processed
        },
        "upstream": {
            "received": 0, // bytes received
            "sent": 0 // bytes sent
        }
    },
    "stream": {
        "client": {
            "received": 0, // bytes received
            "sent": 0 // bytes sent
        },
        "upstream": {
            "received": 0, // bytes received
            "sent": 0 // bytes sent
        }
    },
    "workers": 0, // number of worker processes running
    "uptime": 0, // number of seconds the instance has been running
    "reloads": 0, // number of times the instance has been reloaded
    "start_time": "epoch", // start time of data collection for the report
    "end_time": "epoch" // end time of data collection for the report
}
```
