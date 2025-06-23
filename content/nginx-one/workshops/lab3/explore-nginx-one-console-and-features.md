---
title: "Lab 3: Explore NGINX One Console features"
weight: 300
toc: true
nd-content-type: tutorial
nd-product: nginx-one
---

## Introduction

This guide shows you how to explore and use key NGINX One Console features:

- Overview dashboard  
- TLS certificate management  
- Configuration recommendations  
- CVE scanning  
- AI Assistant for config insights  

You’ll see how each feature helps you monitor and secure your NGINX fleet without writing custom scripts.

## What you’ll learn

By the end of this tutorial, you’ll know how to:

- Navigate the Overview Dashboard panels  
- View and filter certificate status  
- Review and apply config recommendations  
- Investigate CVEs and jump to details  
- Use the AI Assistant to explain directives and variables  

## Before you begin

Make sure you have:

- An F5 Distributed Cloud (XC) account with NGINX One enabled  
- All containers from [Lab 2](nginx-one/workshops/lab2/run-workshop-components-with-docker.md) running and registered  
- {{< include "workshops/nginx-one-env-variables.md" >}}
- Basic NGINX and Linux knowledge  

---

## 1. Overview Dashboard panels

Open NGINX One Console and select **Overview**. Here are the key metrics you’ll see and what they tell you:

<span style="display: inline-block;">
{{< img src="nginx-one/images/nginx-one-dashboard.png"
    alt="Overview dashboard showing panels for instance availability, NGINX versions, operating systems, certificates status, configuration recommendations, CVE severity, CPU and memory utilization, disk space usage, unsuccessful response codes, and network usage." >}}
</span>

- **Instance availability**  
  Understand the operational state of each instance.  
  - **Online**: Agent and NGINX are connected and working.  
  - **Offline**: Agent is running but NGINX isn’t installed, isn’t running, or can’t talk to the agent.  
  - **Unavailable**: Agent lost connection or instance was removed.  
  - **Unknown**: Current state can’t be determined.  

- **NGINX versions by instance**  
  See which NGINX OSS or Plus versions your instances are running.  

- **Operating systems**  
  Find out which Linux distributions are in use.  

- **Certificates**  
  Monitor your SSL certificates—expiring soon or still valid.  

- **Config recommendations**  
  Get actionable suggestions to improve security, performance, and best practices.  

- **CVEs (Common Vulnerabilities and Exposures)**  
  Evaluate threats by severity.  
  - **Major**: High-severity; fix immediately.  
  - **Medium**: Moderate-severity; plan a fix soon.  
  - **Low/Minor**: Lower-severity; monitor.  
  - **Other**: Any non-standard categories.  

- **CPU utilization**  
  Track which instances are using the most CPU over time.  

- **Memory utilization**  
  Watch which instances consume the most RAM over time.  

- **Disk space utilization**  
  See which instances are nearing full disk capacity.  

- **Unsuccessful response codes**  
  Spot instances with high counts of HTTP 4xx/5xx errors.  

- **Top network usage**  
  Review network throughput (in/out) trends for your instances.  

---

## 2. Investigate CVEs

Use the **CVEs** panel to investigate vulnerabilities in your instances:

1. In the **CVEs** panel, select **High** to list instances with high-severity issues.  
2. Select your `$NAME-plus1` instance to view its CVE details, including ID, severity, and description.  
3. Select any CVE ID (for example, `CVE-2024-39792`) to open its official page with full details and remediation guidance.  
4. Switch to the **Security** tab to see every CVE NGINX One tracks, along with how many instances each affects.  
5. Select **View More** next to a CVE name for a direct link to the CVE database.

---

## 3. Investigate certificates

The **Certificates** panel shows the total number of certificates and their status distribution across all instances.

**Note:** NGINX One only scans certificates that are part of a running NGINX configuration.

The statuses mean:

- **Expired**: The certificate’s expiration date is past.  
- **Expiring**: The certificate will expire within 30 days.  
- **Valid**: The certificate is not near expiration.  
- **Not Ready**: NGINX One can’t determine this certificate’s status.  


1. In the **Certificates** panel, select **Expiring** to list certificates that will expire soon.  
2. Select your `$NAME-oss1` instance and switch to the **Unmanaged** tab to see each certificate’s name, status, expiration date, and subject.  
3. Select a certificate name (for example, `30-day.crt`) to open its details page.  
4. Scroll to **Placements** to see all instances that use that certificate.  

---

## 4. Configuration recommendations

The **Configuration Recommendations** pane provides actionable suggestions:

- **Orange** = Security  
- **Green** = Optimization  
- **Blue** = Best practices

1. In the Console, navigate to **Overview > Dashboard**.  
2. In the **Configuration Recommendations** pane, select **Security** to view instances with security-related suggestions.  
3. Select an instance hostname.  
4. Switch to the **Configuration** tab.  
5. Select a config file (for example, `cafe.example.com.conf`) to see recommendations highlighted by line number.  
6. Select **Edit Configuration** (pencil icon) to enter edit mode.  
7. Update the configuration to address each recommendation.  
8. Select **Next** to preview your changes, then select **Save and Publish** to apply them.

<span style="display: inline-block;">
{{< img src="nginx-one/images/config-recommendation.png"
    alt="NGINX One Console configuration recommendation panel showing a Best Practice warning: ‘log should not be set to off on line 34’, with a pencil icon to enter edit mode." >}}
</span>

---

## 5. AI Assistant

Highlight any configuration text, such as a directive, variable, or phrase, in a config preview and select **Explain with AI**. The AI Assistant panel shows:

- A concise definition of the selected element  
- Practical best-practice tips  
- Guidance on common use cases  

Try it on:

- `stub_status`  
- `proxy_buffering off`  
- `$upstream_response_time`  

<span style="display: inline-block;">
{{< img src="nginx-one/images/ai-assistant.png"
    alt="NGINX One AI Assistant panel showing a highlighted $upstream_response_time snippet alongside the assistant’s response with Purpose and Guidance headings." >}}
</span>

> **Pro tip:** You can learn about NGINX directives and variables without leaving the Console.


---

## Next steps

Go to [Lab 4: Config Sync Groups]({{< ref "nginx-one/workshops/lab4/config-sync-groups.md" >}})

---

## References

- [NGINX One Console docs]({{< ref "nginx-one/" >}})
- [CVE.org](https://www.cve.org/)