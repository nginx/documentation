---
title: Status API
weight: 900
toc: true
---

<a name="configuration-stats"></a>

Unit collects information about the loaded language models, as well as
instance- and app-wide metrics, and makes them available via the **GET**-only
**/status** section of the [control API]({{< relref "/unit/controlapi.md" >}}):

{{<bootstrap-table "table table-striped table-bordered">}}

| Option        | Description                                         |
|--------------|-----------------------------------------------------|
| **modules**  | Object; lists currently loaded language modules. |
| **connections** | Object; lists per-instance connection statistics. |
| **requests** | Object; lists per-instance request statistics.  |
| **applications** | Object; each option item lists per-app process and request statistics. |

{{</bootstrap-table>}}

Example:

```json
{
    "modules": {
        "python": [
            {
                "version": "3.12.3",
                "lib": "/opt/unit/modules/python.unit.so"
            },
            {
                "version": "3.8",
                "lib": "/opt/unit/modules/python-3.8.unit.so"
            }
        ],

        "php": {
           "version": "8.3.4",
           "lib": "/opt/unit/modules/php.unit.so"
        }
    },

    "connections": {
        "accepted": 1067,
        "active": 13,
        "idle": 4,
        "closed": 1050
    },

    "requests": {
        "total": 1307
    },

    "applications": {
        "wp": {
            "processes": {
                "running": 14,
                "starting": 0,
                "idle": 4
            },

            "requests": {
                "active": 10
            }
        }
    }
}
```

---

## Modules

Each item in the **modules** object lists one of the currently loaded language
modules, the installed version (or versions) of the module, and the path to the
module file:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option     | Description |
|-----------|-------------|
| **name**   | String; language module name. |
| **version** | String; language module version. If multiple versions are loaded, the list contains multiple items. |
| **lib**    | String; path to the language module file. |

{{</bootstrap-table>}}

---

## Connections

The **connections** object offers the following Unit instance metrics:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option   | Description |
|----------|-------------|
| **accepted** | Integer; total accepted connections during the instance's lifetime. |
| **active** | Integer; current active connections for the instance. |
| **idle** | Integer; current idle connections for the instance. |
| **closed** | Integer; total closed connections during the instance's lifetime. |

{{</bootstrap-table>}}

Example:

```json
"connections": {
    "accepted": 1067,
    "active": 13,
    "idle": 4,
    "closed": 1050
}
```

{{< note >}}
For details of instance connection management,
refer to
[Configuration Settings]({{< relref "/unit/configuration.md#configuration-stngs" >}}).
{{< /note >}}

---

## Requests

The **requests** object currently exposes a single instance-wide metric:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option   | Description |
|----------|-------------|
| **total** | Integer; total non-API requests during the instance's lifetime. |

{{</bootstrap-table>}}

Example:

```json
"requests": {
    "total": 1307
}
```

---

## Applications

Each item in **applications** describes an app currently listed in the
**/config/applications**
[section]({{< relref "/unit/configuration.md#configuration-applications" >}}).

{{<bootstrap-table "table table-striped table-bordered">}}

| Option      | Description |
|------------|-------------|
| **processes** | Object; lists per-app process statistics. |
| **requests**  | Object; similar to **/status/requests**, but includes only the data for a specific app. |

{{</bootstrap-table>}}

Example:

```json
"applications": {
    "wp": {
        "processes": {
            "running": 14,
            "starting": 0,
            "idle": 4
        },

        "requests": {
            "active": 10
        }
    }
}
```

---

## Processes

The **processes** object exposes the following per-app metrics:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option      | Description |
|------------|-------------|
| **running**  | Integer; current running app processes. |
| **starting** | Integer; current starting app processes. |
| **idle**     | Integer; current idle app processes. |

{{</bootstrap-table>}}


Example:

```json
"processes": {
    "running": 14,
    "starting": 0,
    "idle": 4
}
```

{{< note >}}
For details of per-app process management,
refer to
[Process management]({{< relref "/unit/configuration.md#configuration-proc-mgmt" >}}).
{{< /note >}}
