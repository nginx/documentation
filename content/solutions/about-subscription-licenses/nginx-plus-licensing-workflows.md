---
title: NGINX Plus licensing workflows
toc: true
weight: 100
nd-content-type:
- reference
nd-product: Solutions
nd-docs:
---

These workflows show how NGINX Plus validates licenses and usage reports. They cover startup, license expiration, and reporting in both connected and disconnected environments.  

Use the workflows to see what happens if a license is missing, expired, or not reporting, and the steps you can take to fix it.  

Select an image to enlarge.


[{{< img src="solutions/about-subscription-licenses/images/nginx-plus-startup-check.png" alt="Flowchart showing the NGINX Plus startup check. If no license is installed, the user must sign in to MyF5, download the license, and copy it to the NGINX instance. If a license is present, NGINX checks whether it has been expired for more than 90 days. If not, NGINX starts normally. If yes, NGINX fails to start, logs EMERGENCY messages in the error log, and requires a license update to restore service." >}}](../images/nginx-plus-startup-check.png)

[{{< img src="solutions/about-subscription-licenses/images/nginx-plus-license-expiration-check.png" alt="Flowchart showing the NGINX Plus license expiration check that runs daily after install. If the license is expired, NGINX checks whether more than 90 days have passed. If yes, NGINX logs EMERGENCY messages and cannot restart or apply changes until the license is updated. If no, NGINX logs ALERT messages and requires an update to avoid disruption. If the license is not yet expired but will expire within 30 days, NGINX logs WARN messages. If the license is valid for more than 30 days, NGINX operates normally. In R35, if the instance is internet-connected, the renewed license is updated automatically." >}}](../images/nginx-plus-license-expiration-check.png)

[{{< img src="solutions/about-subscription-licenses/images/nginx-plus-usage-check-connected.png" alt="Flowchart showing the NGINX Plus licensing reporting check, which runs by default every hour. If NGINX is connected and reporting to the F5 licensing endpoint or to NGINX Instance Manager, it operates normally. If not, NGINX checks whether fewer than 180 days have passed since the directive was set or the last successful report. If the grace period directive is set to off, NGINX continues. If the initial report has never been sent successfully, or more than 180 days have passed, NGINX stops processing traffic." >}}](../images/nginx-plus-usage-check-connected.png)

[{{< img src="solutions/about-subscription-licenses/images/nginx-plus-usage-check-disconnected.png" alt="Flowchart showing the NGINX Plus licensing reporting check for offline or air-gapped environments, which runs every hour by default. If NGINX reports to Instance Manager, it operates normally, and usage data can be exported and sent to F5. If not, NGINX checks whether the grace period directive is set to off. If the directive is off or the initial report has been sent successfully, and fewer than 180 days have passed since the last successful report, NGINX continues to operate. If the initial report has never been sent or more than 180 days have passed, NGINX stops processing traffic." >}}](../images/nginx-plus-usage-check-disconnected.png)