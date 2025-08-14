---
docs:
files:
   - content/agent/about.md
   - content/nginx-one/agent/overview/about.md
---

F5 NGINX Agent is a lightweight companion daemon designed to work with NGINX One and enable remote management of NGINX instances. It also gathers performance metrics from NGINX and transmits them to the NGINX One Console for enhanced monitoring and control.

## Key features

Enable Access to key NGINX One use cases:

   - Seamlessly integrates with essential NGINX One functionality, simplifying access to its core use cases and
     enhancing operational workflows.
   - [Connects NGINX instances to NGINX One Console]({{< ref "/nginx-one/agent/install-upgrade/install-from-oss-repo.md#connect-an-instance-to-nginx-one-console" >}})

Real-time observability into NGINX One data plane instances:

   - Provides live monitoring and actionable insights into the performance, status, and health of NGINX One data plane
     instances, improving decision-making and operational efficiency.
   - NGINX Agent supports [OpenTelemetry](https://opentelemetry.io/) and the ability to
     [export the metrics data]({{< ref "/nginx-one/agent/metrics/configure-otel-metrics.md" >}}) for use in other applications.



### Configuration management

- NGINX Agent provides an interface that enables users to deploy configuration changes to NGINX instances from a
  centralized management plane.
- Additionally, NGINX Agent verifies that the configuration changes are successfully applied to NGINX instances.

### Metrics collection

NGINX Agent comes pre-packaged with an embedded OpenTelemetry Collector. This embedded collector gathers vital performance
and health metrics for both NGINX and the underlying instance it operates on.

For example, it tracks key metrics such as active connections, requests per second, HTTP status codes, and response times.
Additionally, it collects system-level data, including CPU usage, memory consumption, and disk I/O. These insights provide
deep observability into NGINX's behavior, enabling teams to troubleshoot issues effectively, optimize performance, and
maintain high availability.

By default, the OpenTelemetry Collector is configured to send metrics to NGINX One Console.