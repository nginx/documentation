---
description: Create custom dashboards to view custom graphs.
nd-docs: DOCS-527
title: Create Custom Dashboards
toc: true
weight: 20
type:
- how-to
---

## Overview

You can use the F5 NGINX Controller user interface to create your own Dashboards populated with customizable graphs of NGINX and system-level metrics.

{{< note >}}

- You can add up to 30 Elements to Dashboard.
- Dashboards are accessible by all Users.

{{< /note >}}

## Before You Begin

- [Install the NGINX Controller Agent on instances that you want to monitor]({{< ref "/controller/admin-guides/install/install-nginx-controller-agent.md" >}})
- [Configure Metrics collection on your NGINX instances]({{< ref "/controller/admin-guides/config-agent/configure-metrics-collection.md" >}})

## Dashboards

In NGINX Controller, you can create dashboards to display custom graphs. Some use cases for custom graphs include the following:

- Checking NGINX performance for a particular application or microservice, for example, based on the URI path
- Displaying metrics per virtual server
- Visualizing the performance of a group of NGINX servers, for example, front-end load-balancers or an NGINX edge caching layer
- Analyzing a detailed breakdown of HTTP status codes per application

When building a custom graph, metrics can be summed or averaged across NGINX servers. By using metric filters, it is possible to create additional "metric dimensions", for example, reporting the number of POST requests for a specific URI.

   {{< note >}}

The functionality of user-defined dashboards recently changed in NGINX Controller. Some of the functionalities that were present in the
previous version might not be currently present or work differently. Your old dashboards were not migrated to the new version.

   {{< /note >}}

## Create a Custom Dashboard

To create a custom dashboard:

1. Open the NGINX Controller user interface and log in.
2. The first page you will see is the **Analytics Overview** page.
3. Select the Dashboards tab to see the **My Dashboards** list page.
4. To create a new dashboard - use **Create** button and provide required information.

### Add a Dashboard Element

To add an Element to a Dashboard:

1. Create a new Dashboard or select the edit icon to edit an existing Dashboard.
2. Select **Add element** button.
3. Provide a title.
4. (Optional) Enter a description of the Element.
5. Select the type of Element to add:

   - **Line chart** displays data for a specific time period
   - **Stat** displays the metric's most recent value

6. Select a metric from the drop-down menu.
7. Select the aggregation method for the selected metric.
   {{< see-also >}}
For more information about metrics and supported aggregation methods, see the [Metrics Catalog Reference]({{< ref "/controller/analytics/catalogs/metrics.md" >}}).
   {{< /see-also >}}
8. (Optional) Add a filter to refine the data. For example, you can limit the data to a specific App or Environment.
9. (Optional) Select **Add metrics** to add more metrics.
   {{< note >}}
Additional metrics can only be added to a **Line chart** Element.
   {{< /note >}}
10. (Optional) Select the **Override Default Time Settings** option to select a time range for the Element.

    - The default time range is the last seven days.
    - You can select a new pre-defined time range or select **Custom time range** to define a new time range.

11. Select **Create** or **Edit** to save your Element settings.

## Filter Metrics

You can use the filtering functionality for NGINX metrics. If you select **Add filter**, you can add multiple criteria to define specific "metric dimensions".

The filter consists of one or more expressions in a form of:

`dimensionName operator value`

where:

- `dimensionName` is a name of the dimension from the dimensions catalog
- `operator` is a comparison rule (equality, likeliness, etc.)
- `value` is a value to which we want compare the dimensions value

Filters can be used in conjunction using `AND` or `OR` logical operators. There is no possibility of nesting these expressions.

Filters are used to narrow down the data set presented on the chart/stat. For example, you may not want to display the data for all of your applications, but only for the particular one.

## Limitations

- You are not able to add more than 30 elements to the single dashboard.
- All dashboards are accessible for all users.
- Dashboards defined in the old custom dashboards view are not migrated to the new dashboards view.

## Clone a Custom Dashboard

To clone an existing dashboard from the Dashboards page, select the **Clone** icon on a dashboard's row, or select **Clone** from the toolbar above the table (you need to select a dashboard first).

You can also clone a dashboard from the elements view using the **Clone Dashboard** button. This button is not available in "edit" mode, so make sure you finish editing a dashboard before cloning it.

When you clone a dashboard, the new one will have the same display name as the original dashboard + the current date. For example, if you clone the "My system graphs" dashboard, the cloned dashboard's display name will be something like "My system graphs Aug 24, 2021, 14:37:32". You can change the display name later on the Edit Config page.

## Predefined Dashboards

You can find predefined dashboards on the Dashboards page. Predefined dashboards have a special "Read Only" tag, include elements to show the most common metrics, and cover some common cases. The predefined dashboards might be helpful in learning how custom dashboards work. You can clone any of the predefined dashboards and then modify them as needed.

Predefined dashboards cannot be deleted or modified.

{{< note >}}

- Predefined dashboards were introduced in NGINX Controller 3.21.
- If you already have custom dashboards, the predefined ones should appear at the end of the list when default sorting is applied.

{{< /note >}}

## What's Next

- [Overview Dashboard]({{< ref "/controller/analytics/dashboards/overview-dashboard.md" >}})
- [Overview of Metrics and Metadata]({{< ref "/controller/analytics/metrics/overview-metrics-metadata.md" >}})
- [Set up Metrics Collection]({{< ref "/controller/admin-guides/config-agent/configure-metrics-collection.md" >}})
- [Metrics Catalog Reference]({{< ref "/controller/analytics/catalogs/metrics.md" >}})
- [Dimensions Catalog Reference]({{< ref "/controller/analytics/catalogs/dimensions.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
