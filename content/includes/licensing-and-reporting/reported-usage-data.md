---
docs:
---

By default, NGINX Plus sends usage data to F5 every hour in a `POST` request. The report includes information such as traffic volume, runtime, and instance activity.  

Here’s an example of a usage report:

```json
{
    "version": "<nginx_version>",
    "uuid": "<nginx_uuid>",
    "nap": "<active/inactive>", // NGINX App Protect status
    "http": {
        "client": {
            "received": 0, // bytes received
            "sent": 0,     // bytes sent
            "requests": 0  // HTTP requests processed
        },
        "upstream": {
            "received": 0, // bytes received
            "sent": 0      // bytes sent
        }
    },
    "stream": {
        "client": {
            "received": 0, // bytes received
            "sent": 0      // bytes sent
        },
        "upstream": {
            "received": 0, // bytes received
            "sent": 0      // bytes sent
        }
    },
    "workers": 0,       // number of worker processes running
    "uptime": 0,        // seconds the instance has been running
    "reloads": 0,       // number of reloads
    "start_time": "epoch", // start of data collection
    "end_time": "epoch"    // end of data collection
}