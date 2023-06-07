---
authors: []
categories:
- installation
date: "2020-10-26T15:32:41-06:00"
description: How to start, stop, and verify the state of the NGINX Controller Agent
  service
docs: DOCS-251
doctypes:
- task
draft: false
journeys:
- getting started
- using
menu:
  docs:
    parent: Installation
    weight: 50
personas:
- devops
- support
roles:
- admin
tags:
- docs
title: Manage the NGINX Controller Agent Service
toc: true
weight: 210
---

## Starting and Stopping the Agent

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

## Verify that the Agent Has Started

To verify that the NGINX Controller Agent has started, run the following command on the NGINX Plus system where you installed the Agent:

```bash
ps ax | grep -i 'controller\-'
2552 ?        S      0:00 controller-agent
```

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}