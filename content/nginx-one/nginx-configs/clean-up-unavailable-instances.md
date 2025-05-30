---
description: ''
docs: null
title: Clean up unavailable NGINX instances
toc: true
weight: 1000
type:
- how-to
---

## Overview

This guide explains how to set up automatic cleanup for NGINX instances in NGINX One. The cleanup process removes instances that have been unavailable for a specified duration. By default, this period is 24 hours from the time the NGINX instance was last updated. Administrators can change or disable the cleanup duration in **Settings > Instance Settings**. Events will be generated for NGINX instances that have been automatically cleaned up; you can see these events on the **Overview > Events** page.

## Before you start

Before you set up automatic cleanup for NGINX instances, ensure:

- You have administrator access to NGINX One.
- You understand that this action will delete instances permanently after they are unavailable for the specified duration.

## Configure instance cleanup

Follow these steps to set up automatic cleanup for NGINX instances in NGINX One:

1. On the left menu, select **Instance Settings**.
1. On the **Instance Settings** page, in the **Unavailable Instance Cleanup** section, select **Edit Duration**.
1. Choose the cleanup duration.
   - Select one of the predefined durations (None, 1 day, 7 days, 30 days) or set a custom duration. Selecting **None** disables automatic cleanup.
   - If you choose **Custom**, enter the duration in hours or days.
1. Select **Save** to apply the changes.

## Event log details

When instances are cleaned up automatically, an event log entry is created. You can find these events on the **Overview > Events** page. The event log includes the following details:

- **Impacted Object ID**: The unique identifier of the NGINX instance that was cleaned up.
- **Type**: The type of event, which will be "Automated Object Cleanup".
- **Timestamp**: The date and time when the instance was cleaned up.
- **Message**: A description indicating that the instance was unavailable for the configured duration before being cleaned up.
