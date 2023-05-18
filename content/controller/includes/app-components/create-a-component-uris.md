A Component definition must contain one or more URIs.

**Web Component URIs** can be either of the following:

- a complete URI that follows the format `<schema://host>[:port][/path]`, or
- a relative path that follows the format `</path>[/...]`.

Relative paths inherit the host URI configured for the Gateway associated with the Component.
The host and relative path(s) defined for a Component take precedence over the host defined in the associated Gateway.

Example Web URI definitions:

- `http://www.f5.com:8080/sales`
- `http://*.f5.com:5050/test`
- `/images`
- `/*.jpg`
- `/locations/us/wa*`

**TCP/UDP URIs** must be a complete URI that follows the format `<tcp|udp|tcp+tls://*|IP:port|portRange>`.
TCP+TLS URIs can include TLS information.

Example TCP/UDP URI definitions:

- `tcp://192.168.1.1:12345`
- `tcp+tls://192.168.1.1:12346`
- `tcp://192.168.1.1:12345-12350`
- `tcp://*:12345`
- `udp://192.168.1.1:12345`
- `udp://*:12345`

On the **Create App Component** *URIs* page:

1. Define the **URIs**:
  
    - Select **Add URI**.
    - In the **URI** box, type the URI for the Component.
    - (Optional) Select a **Match Method** (applicable only to Web Components).
    - (Optional) Select **Customize for this URI** to add custom **TLS Settings**.

        {{< note >}}
TLS Settings can be inherited from the Gateway, or customized at the Component level. Enable this option if you want the Component to use a different cert than that used by the Gateway.
        {{< /note >}}

1. (Optional) Define the **Shared TLS Settings**.

    - To use a cert that is already associated with the Gateway, select it from the list.
    - To add a new shared cert, select **Create New**.

1. Select **Next**.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-497 -->