### How is a Workload Defined for Licensing Purposes?

Workloads are back-end objects (whether the workload is a stand-alone application or containerized) behind the NGINX Controller that receive traffic. For licensing purposes, workloads are calculated by counting the unique IP addresses used by workloads within each distinct location.

Workloads can be reused across instances within the same location without increasing the number of workloads counted. However, if a workload is referenced by instances across multiple locations, that workload will be counted once for each different location. For example, if workload 1.1.1.1 is referenced by instance1 and instance2, if both instance1 and instance2 are grouped under location1, then 1.1.1.1 will only be counted as one workload. However, if instance1 is grouped under location1 while instance2 is grouped under location2, then 1.1.1.1 will be counted twice.

### How is Aggregate Data Defined for Licensing Purposes?

Aggregate data is represented by the total volume of bytes in/out per hour for all of the data planes managed by NGINX Controller.

### How Do I Ensure My License for NGINX Controller Is Compliant?

To verify your license is compliant, check for the following:

- Make sure your usage is within the capacity that your license allows. Refer to the [View License Details]({{< relref "/platform/licensing-controller.md#view-license-details" >}}) section for instructions.

- Ensure your license has not expired.

- If you are using an Association Token, make sure to allow incoming and outgoing connections on port 443 TCP. If you're running NGINX Controller v3.15 or earlier, also enable incoming and outgoing connections on port 8883 TCP. These ports are used for validating the entitlements for your license. Refer to the [NGINX Controller Technical Specifications Guide]({{< relref "/admin-guides/install/nginx-controller-tech-specs.md#firewallip-settings" >}}) for these and other firewall requirements.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-755 -->
