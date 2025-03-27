---
title: "Overview"
weight: 100
toc: true
docs: DOCS-000
---
{{<call-out "note" "F5 NGINX Agent v3.0 is available now">}}
<!--  (TODO: Link instructions ) -->
{{</call-out>}}

### About F5 NGINX Agent
The F5 NGINX Agent is a lightweight companion daemon designed to work with NGINX One, enabling remote management of the NGINX Instance(s). It also gathers performance metrics from NGINX and transmits them to the NGINX One Console for enhanced monitoring and control. 

### Key Features 
- Enable Access to Key NGINX One Use Cases 
    - Seamlessly integrates with essential NGINX One functionality, simplifying access to its core use cases and enhancing operational workflows.   
    - [Connect to NGINX One Console]({{< relref "/agent/install-upgrade/install/#connect-an-instance-to-nginx-one-console" >}})

- Real-Time Observability into NGINX One Data Plane Instances 
    - Provides live monitoring and actionable insights into the performance, status, and health of NGINX One Data Plane instances, improving decision-making and operational efficiency.   

    - [OpenTelemetry](https://opentelemetry.io/) support comes with F5 NGINX Agent, and the ability to [export the metrics data]({{< relref "/agent/otel/configure-otel-metrics.md" >}}) for use in other applications.

---

## How it works

### Configuration management

- The F5 NGINX Agent provides an interface that enables users to deploy configuration changes to NGINX from a centralized management plane.  
- Additionally, the F5 NGINX Agent verifies that the configuration changes are successfully applied to NGINX.
     
### Metrics Collection

- The F5 NGINX Agent comes pre-packaged with an embedded OpenTelemetry Collector .  
- This embedded collector gathers vital performance and health metrics for both NGINX and the underlying instance it operates on.  
- For example, it tracks key metrics such as active connections, requests per second, HTTP status codes, and response times. Additionally, it collects system-level data, including CPU usage, memory consumption, and disk I/O. These insights provide deep observability into NGINX's behavior, enabling teams to troubleshoot issues effectively, optimize performance, and maintain high availability.  
- Collected metrics can be seamlessly exported to the NGINX One Console or integrated with third-party data aggregators.
    



{{< img src="agent-flow.png" caption="How Agent works" alt="How NGINX Agent works" width="99%">}}

---

