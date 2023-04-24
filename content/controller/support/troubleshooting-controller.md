---
authors: []
categories:
- installation
- infrastructure
- platform management
date: "2020-10-26T15:32:41-06:00"
description: Steps to take to investigate and fix issues with NGINX Controller and
  the Controller Agent
docs: DOCS-376
doctypes:
- tutorial
- troubleshooting
draft: false
journeys:
- using
- self service
personas:
- devops
- netops
- secops
- support
roles:
- admin
- user
tags:
- docs
title: Troubleshoot NGINX Controller and the Controller Agent
toc: true
weight: 100
---

## Overview

If NGINX isn't behaving how you expect, you can take the following steps to troubleshoot issues. If you need to [contact NGINX Support]({{< relref "/support/contact-support.md" >}}), make sure to [create a support package](#create-a-support-package) first.

## Fix NGINX Controller Issues by Upgrading



{{< include "support/upgrade-to-fix-issues.md" >}}



&nbsp;

---

## Create a Support Package



{{< include "installer/helper-script/create-support-package.md" >}}

### Support Package Details

{{< include "installer/helper-script/support-package-details.md" >}}



&nbsp;

---

## Security Events Not Available



If NGINX Controller isn't logging WAF Violation Security Events for an App Component that has WAF enabled, take the following steps:

1. Check the `agent.conf` security setting for every Instance referenced by the Gateway(s) associated with the App Component. You'll need to verify that the Extensions group contains the setting `security = True`.
2. Restart the NGINX Controller Agent.

To start, stop, and restart the NGINX Controller Agent, run the following commands on the NGINX Plus system where you installed the Agent.

Start the NGINX Controller Agent:

```bash
service controller-agent start
```

Stop the NGINX Controller Agent:

```bash
service controller-agent stop
```

Restart the NGINX Controller Agent:

```bash
service controller-agent restart
```



&nbsp;

---

## Signature Name missing in Security Violation Events



If you don't see **Signature Names** in **Security Violation Events**, restart the Controller Agent on the dataplane instance.

```bash
sudo systemctl restart controller-agent
```



&nbsp;

---

## Controller Agent Install Script Failed to Download



{{< include "support/failed-to-download-install-script-for-agent.md" >}}



&nbsp;

---

## Controller Agent Asks for Password



{{< include "support/controller-agent-prompt-for-password.md" >}}



&nbsp;

---

## Controller Agent Isn't Reporting Metrics

<a name="troubleshooting-metrics"></a>



{{< include "support/controller-agent-no-metrics.md" >}}



&nbsp;

---

## Licensing



{{< include "licensing/troubleshoot-license.md" >}}



&nbsp;

---

## Events Don't Display in the Analytics User Interface



Certain content-filtering and ad-blocking web browser extensions may incorrectly block the elements on the NGINX Controller Analytics events page. As a result, when you access the **Analytics > Events** page using the NGINX Controller user interface, you may observe messages indicating missing events. Refer to the AskF5 KB article [K48603454](https://support.f5.com/csp/article/K48903454) to learn more about this issue and how to resolve it.



{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
