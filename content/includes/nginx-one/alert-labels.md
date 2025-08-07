---
files:
  - content/nginx-one/secure-your-fleet/set-up-security-alerts.md
  - content/nginx-one/glossary.md
---


You can configure a variety of NGINX alerts in the F5 Distributed Cloud. If you have access to the [F5 Distributed Cloud]({{< ref "/nginx-one/getting-started.md#confirm-access-to-the-f5-distributed-cloud" >}}), log in and select the **Audit Logs & Alerts** tile. 

Go to **Notifications > Alerts**. Select the gear icon and select **Alert Name > Active Alerts**. You may see one or more of the following alerts in the **Audit Logs & Alerts** Console. 

{{<bootstrap-table "table table-striped table-bordered">}}

### Alert Labels

| **Alertname**                  | **Description**                                                    | **Alert Level** | **Action**                                                                                                      |
|--------------------------------|----------------------------------------------------------------------|-----------------|------------------------------------------------------------------------------------------------------------------|
| HighCVENGINX                  | A high-severity CVE is impacting an NGINX instance                  | Critical        | Review the CVE details in the NGINX One Console. Apply updates or change configurations to resolve the vulnerability. |
| MediumCVENGINX                | A medium-severity CVE is impacting an NGINX instance                | Major           | Review the CVE details in the NGINX One Console. Apply updates or configuration changes as needed.               |
| LowCVENGINX                   | A low-severity CVE is impacting an NGINX instance                   | Minor           | Review the CVE details in the NGINX One Console. Consider updates or configuration changes to maintain security.  |
| SecurityRecommendationNGINX   | A security recommendation has been found for an NGINX configuration | Critical        | Review the configuration issue in the NGINX One Console. Follow the recommendations to secure the instance or Config Sync Group.      |
| OptimizationRecommendationNGINX| An optimization recommendation has been found for an NGINX configuration| Major          | Review the optimization details in the NGINX One Console. Update the configuration to for the instance or Config Sync Group to enhance performance.       |
| BestPracticeRecommendationNGINX| A best practice recommendation has been found for an NGINX configuration | Minor          | Review the best practice recommendation in the NGINX One Console. Update the configuration for the instance or Config Sync Group to align with industry standards. |
| NGINXOffline                  | An NGINX instance is now offline                                   | Major           | Verify the host is online. Check the NGINX Agent's status on the instance and ensure it is connected to the NGINX One Console. |
| NGINXUnavailable              | An NGINX instance is now unavailable                               | Major           | Ensure the NGINX Agent and host are active. Verify the NGINX Agent can connect to the NGINX One Console and resolve any network issues. |
| NewNGINX                      | A new NGINX instance has connected to NGINX One                   | Minor           | Review the instance details in the NGINX One Console. Confirm availability, CVEs, and recommendations to ensure the instance is operational. |
{{</bootstrap-table>}}
