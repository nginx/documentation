---
docs: "DOCS-1635"
---

When both `nginx.conf` file and App Protect configurations are modified, apreload enforces only the App Protect configurations but nginx reload enforces both.

For apreload, use the following command:
```shell
/opt/app_protect/bin/apreload
```

Output:

```shell
USAGE:
    /opt/app_protect/bin/apreload:

Optional arguments with default values:
  -apply
        Apply new configuration in enforcer (default true)
  -i string
        Path to the config set. Ex. /opt/app_protect/config/config_set.json (default "/opt/app_protect/config/config_set.json")
  -policy-map-location string
        Path to policy map location (default "/opt/app_protect/bd_config/policy_path.map")
  -t    Test and prepare configuration without updating enforcement
  -wait-for-enforcer
        Wait until updated config is loaded (default true)

Optionally, using --help will issue this help message.
```