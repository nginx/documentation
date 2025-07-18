---
docs:
files:
  - content/nginx-one/metrics/enable-metrics.md
  - content/nginx-one/getting-started.md
---

Navigating the dashboard:

- **Drill down into specifics**: For in-depth information on a specific metric, like expiring certificates, click on the relevant link in the metric's card to go to a detailed overview page.
- **Refine metric timeframe**: Metrics show the last hour's data by default. To view data from a different period, select the time interval you want from the drop-down menu.

<span style="display: inline-block; margin-top: 20px; margin-bottom: 50px;">
{{< img src="nginx-one/images/nginx-one-dashboard.png">}}
</span>

{{<bootstrap-table "table table-striped table-bordered">}}
**NGINX One Console dashboard metrics**
| Metric | Description | Details |
|---|---|---|
| <i class="fas fa-heartbeat"></i> **Instance availability** | Understand the operational status of your NGINX instances. | - **Online**: The NGINX instance is actively connected and functioning properly. <br> - **Offline**: NGINX Agent is connected but the NGINX instance isn't running, isn't installed, or can't communicate with NGINX Agent. <br> - **Unavailable**: The connection between NGINX Agent and NGINX One Console has been lost or the instance has been decommissioned. <br> - **Unknown**: The current state can't be determined at the moment. |
| <i class="fas fa-code-branch"></i> **NGINX versions by instance** | See which NGINX versions are in use across your instances. | |
| <i class="fas fa-desktop"></i> **Operating systems** | Find out which operating systems your instances are running on. | |
| <i class="fas fa-certificate"></i> **Certificates** | Monitor the status of your SSL certificates to know which are expiring soon and which are still valid. | |
| <i class="fas fa-cogs"></i> **Config recommendations** | Get configuration recommendations to optimize your instances' settings. | |
| <i class="fas fa-shield-alt"></i> **CVEs (Common Vulnerabilities and Exposures)** | Evaluate the severity and number of potential security threats in your instances. | - **Major**: Indicates a high-severity threat that needs immediate attention. <br> - **Medium**: Implies a moderate threat level. <br> - **Minor** and **Low**: Represent less critical issues that still require monitoring. <br> - **Other**: Encompasses any threats that don't fit the standard categories. |
| <i class="fas fa-microchip"></i> **CPU utilization** | Track CPU usage trends and pinpoint instances with high CPU demand. | |
| <i class="fas fa-memory"></i> **Memory utilization** | Watch memory usage patterns to identify instances using significant memory. | |
| <i class="fas fa-hdd"></i> **Disk space utilization** | Monitor how much disk space your instances are using and identify those nearing capacity. | |
| <i class="fas fa-exclamation-triangle"></i> **Unsuccessful response codes** | Look for instances with a high number of HTTP server errors and investigate their error codes. | |
| <i class="fas fa-tachometer-alt"></i> **Top network usage** | Review the network usage and bandwidth consumption of your instances. | |

{{</bootstrap-table>}}






