---
description: How to start, stop, and verify the state of the F5 NGINX Controller Agent
  service.
docs: DOCS-251
title: Manage the NGINX Controller Agent Service
toc: true
weight: 210
type:
- how-to
---

## Starting and Stopping the Agent

To start, stop, and restart the F5 NGINX Controller Agent, run the following commands on the NGINX Plus system where you installed the Agent.

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
