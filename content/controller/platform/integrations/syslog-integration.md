---
nd-docs: DOCS-567
title: Syslog Integration
weight: 30
---

## Syslog Integration Requirements


Confirm that your Syslog server meets the following requirements:

### Network protocol

The syslog server should be able to receive data via one of the following protocols:

- TCP  - for unencrypted connections.
- TLS  - for encrypted connections. Validation of the Certificate Authority (CA) and mutual TLS are currently **not** supported.

### Syslog Format

- The forwarder produces [RFC-5424](https://tools.ietf.org/html/rfc5424)-compliant messages.

- For delimiting, the octet count is added to every syslog message. See [RFC-5425](https://tools.ietf.org/html/rfc5425#section-4.3.1) for details.

Example of a message sent by the forwarder in syslog format:

```bash
<6>1 2019-09-10T06:40:15+02:00 controller.fqdn.svc nginx_controller 1 ngxctrl [dimensions alias="my_system" category="agent event" counter="1" instance="" instance.tags="tag1,tag2" level="INFO" local_id="d23c85484ee760ee5f4619c0434e1968b5290964487541da0889964eb783613c" location="" message="nginx stub_status detected, https://127.0.0.1:443/basic_status" parent_hostname="d0784771a503" root_uuid="49946669ca315d45bae1d6c05de9bd7e"] nginx stub_status detected, https://127.0.0.1:443/basic_status
```

### Example configuration for Syslog-NG

The example of `syslog-ng.conf` that receives messages over TLS:

```bash
@version: 3.29
@include "scl.conf"

source s_network {
    default-network-drivers(
    tls(key-file("/key.pem") cert-file("/cert.pem") peer-verify(optional-trusted))

    # the optional flag that enables the access to $RAWSMSG
    flags(store-raw-message)
    );
};

destination d_remote  {
    file("/var/log/controller.events.log");

    # if you want to see the raw message with all dimensions:
    file("/var/log/controller.events.raw.log" template("${RAWMSG}\n"));
};

log {
    source(s_network);
    destination(d_remote);
};
```


## Add a Syslog Integration

Take the following steps to create an Integration for syslog:

1. Open the F5 NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Integrations**.
4. On the **Integrations** menu, select the **Create Integration** quick action.
5. Add a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. (Optional) Add tags.
9. In the **Integration Type** list, select `GENERIC_INTEGRATION`.
10. In the **Endpoint URI** box, add the TCP endpoint for your syslog.
    Syslog's URL can be provided in two formats:
     - `tcp://hostname[:port]` for unencrypted TCP connections (example: `tcp://192.168.0.1:601`).
     - `tcp+tls://hostname[:port]` for encrypted TCP connections with TLS (example: `tcp+tls://192.168.0.1:6514`)
11. In the **Credential Type** list, select `UNAUTHENTICATED`.
12. Select **Submit**.
