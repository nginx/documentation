---
description: View the audit log of system and user actions.
docs: DOCS-530
title: View Events
toc: true
weight: 20
type:
- how-to
---

## Overview

The Events page shows a log of the system and user actions for F5 NGINX Controller. The logs are organized by event categories and levels, making it easy to identify and review issues.

## View Events

Take the steps below to view NGINX Controller events:

1. Open the NGINX Controller user interface and log in.
1. On the Analytics menu, select **Events**.
1. To view additional information about a particular event, select the event from the list to open the details pane.

You can filter the events by typing a keyword in the search box and/or by selecting a time period. You can filter the results further by [Event Categories](#event-categories) or [Event Levels](#event-levels).

## Event Categories

You can select from the following Event Categories:

- Agent Events;
- Agent Status Events;
- Controller Events;
- Audit Events -- a log of all actions performed by NGINX Controller users;
- Forwarder Notifications -- events emitted by [Data Forwarders]({{< ref "/controller/analytics/forwarders/_index.md" >}})
- Workload Health Events -- events emitted by the Controller Agent when the health of an upstream server changes;

To view the logs for a specific category, select the category name from the **Event Categories** list.

## Event Levels

Event levels sort events according to their information level: Debug, Info, Error, Warning, and Critical.

To view the logs for a specific level, select the level name from the **Event Levels** list.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
