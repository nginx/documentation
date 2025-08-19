---
title: "Lab 3: Explore NGINX One Console features"
weight: 300
toc: true
nd-content-type: tutorial
nd-product: nginx-one
---

## Introduction

In this lab, you'll explore and use key NGINX One Console features:

- Overview dashboard  
- TLS certificate management  
- Configuration recommendations  
- CVE scanning  
- AI Assistant for configuration insights  

You'll see how each feature helps you monitor and secure your NGINX fleet without writing custom scripts.

---

## What you'll learn

By the end of this tutorial, you can:

- Navigate the Overview Dashboard panels  
- View and filter certificate status  
- Review and apply configuration recommendations  
- Investigate CVEs and open details  
- Use the AI Assistant to explain directives and variables  

---

## Before you begin

Make sure you have:

- {{< include "nginx-one/workshops/xc-account.md" >}}
- All containers from [Lab 2: Run workshop components with Docker]({{< ref "nginx-one/workshops/lab2/run-workshop-components-with-docker.md" >}}) running and registered  
- {{< include "workshops/nginx-one-env-variables.md" >}}  
- Basic NGINX and Linux knowledge  

---

## 1. Overview Dashboard panels

Open NGINX One Console and select **Overview**. Here are the key metrics and what they mean:

<span style="display: inline-block;">
{{< img src="nginx-one/images/nginx-one-dashboard.png"
    alt="Overview dashboard showing panels for instance availability, NGINX versions, operating systems, certificates status, configuration recommendations, CVE severity, CPU and memory utilization, disk space usage, unsuccessful response codes, and network usage." >}}
</span>

- **Instance availability**  
  - **Online**: NGINX Agent and NGINX are connected and working  
  - **Offline**: NGINX Agent is running, but NGINX isn't installed, isn't running, or can't connect  
  - **Unavailable**: NGINX Agent lost connection or instance was removed  
  - **Unknown**: Current state can't be determined  

- **NGINX versions by instance**  
  See which NGINX Open Source or NGINX Plus versions your instances are running.  

- **Operating systems**  
  View the Linux distributions in use.  

- **Certificates**  
  Monitor SSL certificates, including expiring soon or still valid.  

- **Configuration recommendations**  
  Get suggestions to improve security, performance, and best practices.  

- **CVEs (Common Vulnerabilities and Exposures)**  
  Review threats by severity: 
  
  - **Major**: fix immediately
  - **Medium**: play to fix soon
  - **Low/Minor**: monitor
  - **Other**: any non-standard categories

- **CPU utilization**  
  Track which instances use the most CPU over time.  

- **Memory utilization**  
  Monitor which instances consume the most RAM.  

- **Disk space utilization**  
  See which instances are nearing full disk capacity.  

- **Unsuccessful response codes**  
  Spot instances with high counts of HTTP 4xx or 5xx errors.  

- **Top network usage**  
  Review inbound and outbound network traffic trends.  

---

## 2. Investigate CVEs

Use the **CVEs** panel to investigate vulnerabilities:

1. In the **CVEs** panel, select **High** to list instances with high-severity issues.  
2. Select your `$NAME-plus1` instance to view CVE details, including ID, severity, and description.  
3. Select any CVE ID (for example, `CVE-2024-39792`) to open its official page with remediation guidance.  
4. Switch to the **Security** tab to see every CVE NGINX One tracks, with the number of affected instances.  
5. Select **View More** next to a CVE name for a direct link to the CVE database.  

---

## 3. Investigate certificates

The **Certificates** panel shows the total number of certificates and their status across all instances.

**Note:** NGINX One only scans certificates that are part of a running NGINX configuration.

Statuses include:

- **Expired**: The certificate expiration date has passed  
- **Expiring**: The certificate expires within 30 days  
- **Valid**: The certificate is not near expiration  
- **Not Ready**: NGINX One can't determine the status  

Steps:

1. In the **Certificates** panel, select **Expiring** to list certificates that will expire soon.  
2. Select your `$NAME-oss1` instance and switch to the **Unmanaged** tab to see certificate name, status, expiration date, and subject.  
3. Select a certificate name (for example, `30-day.crt`) to open its details page.  
4. Scroll to **Placements** to view all instances that use that certificate.  

---

## 4. Configuration recommendations

The **Configuration Recommendations** panel provides suggestions:

- **Orange** = Security  
- **Green** = Optimization  
- **Blue** = Best practices  

1. In NGINX One Console, go to **Overview > Dashboard**.  
2. In the **Configuration Recommendations** panel, select **Security** to view security-related suggestions.  
3. Select an instance hostname.  
4. Switch to the **Configuration** tab.  
5. Select a config file (for example, `cafe.example.com.conf`) to see recommendations by line number.  
6. Select **Edit Configuration** (pencil icon) to enter edit mode.  
7. Update the configuration to address each recommendation.  
8. Select **Next** to preview your changes, then select **Save and Publish** to apply them.  

<span style="display: inline-block;">
{{< img src="nginx-one/images/config-recommendation.png"
    alt="Configuration recommendation panel showing a Best Practice warning: 'log should not be set to off on line 34', with a pencil icon to edit." >}}
</span>

---

## 5. AI Assistant

Highlight any configuration text, such as a directive, variable, or phrase, in a configuration preview and select **Explain with AI**.  

The AI Assistant shows:

- A concise definition of the selected element  
- Best-practice tips  
- Guidance on common use cases  

Try it on:

- `stub_status`  
- `proxy_buffering off`  
- `$upstream_response_time`  

<span style="display: inline-block;">
{{< img src="nginx-one/images/ai-assistant.png"
    alt="AI Assistant panel showing a highlighted $upstream_response_time snippet alongside the assistant's response with Purpose and Guidance headings." >}}
</span>

{{< call-out "note" "Pro tip:" >}}You can learn about NGINX directives and variables without leaving the Console.{{< /call-out >}}

---

## Next steps

You're ready to apply configuration changes across your fleet using sync groups.

Go to [Lab 4: Config Sync Groups]({{< ref "nginx-one/workshops/lab4/config-sync-groups.md" >}}).

---

## References

- [NGINX One Console docs]({{< ref "nginx-one/" >}})  
- [CVE.org](https://www.cve.org/)