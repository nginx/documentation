---
description: Learn how to customize a Developer Portal and publish documentation using
  F5 NGINX Management Suite API Connectivity Manager.
nd-docs: DOCS-900
title: Customize a Developer Portal
toc: true
weight: 300
---

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

You can use API Connectivity Manager to create and manage Developer Portals (or, "Dev Portals") to host your APIs and documentation. API Connectivity Manager Dev Portals provide a framework for customization that lets you match your Dev Portal to your brand's or business' requirements.
You can customize the Dev Portal website's landing page, All APIs page, and Docs page(s), as well as the site's header and footer.

### Before You Begin

Complete the following prerequisites before proceeding with this guide:

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with a [Developer Portal]({{< ref "/nms/acm/getting-started/add-devportal" >}}) cluster.
- You have verified that you can access the Developer Portal using the configured hostname.

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

## Customize a Developer Portal {#create-dev-portal}

API Connectivity Manager uses a Dev Portal framework to define the look and feel of Developer Portals. These settings are applied at the Cluster level and apply to all Developer Portals hosted by the Cluster.

Take the steps below to customize your Dev Portal by defining a custom Dev Portal framework.

1. In the API Connectivity Manager user interface, go to **Environments > \<your environment\>**, where "your environment" is the Environment that contains a Developer Portal.
1. Select **Edit Portal Theme** from the **Actions** menu for the desired Developer Portal. You can then edit any of the options provided.

    - [Brand](#brand-options)
    - [Style](#style-options)
    - [Website](#website-options)

1. You can save your changes at any time by selecting the **Save and Publish** option.

{{< call-out "note" >}}
<br/>

- The Preview section to the right of the settings in each section will update automatically as you make changes.
- The changes will be applied immediately when you select **Save and Publish**; as such we recommend testing any changes in a "non-production" Environment first.
{{< /call-out >}}

## Brand Options

### Add Custom Logo

1. Select **Upload Image**.
1. Browse your local filesystem and select the file you'd like to upload.
1. Select **Save and Publish** or select **Next** to continue making changes.

### Add a Favicon

1. Select **Upload Favicon**.
1. Browse your local filesystem and select the file you'd like to upload.
1. Select **Save and Publish** or select **Next** to continue making changes.

## Style Options

### Colors

You can customize the colors of the following items:

- page background,
- page text,
- theme (buttons, etc.), and
- callouts (information, success, error, and warning).

To customize any of the above fields:

1. Select the field that you want to customize.
1. Enter the hex code for the desired color, or drag the sliders to create and refine a custom color.
1. Select **Save and Publish** or select **Next** to continue making changes.

### Fonts

You can customize the font used in any of the following:

- hero text,
- header and body text,
- code.

To customize the font used in your Dev Portal(s):

1. Select the field that you want to customize.
1. Choose a font from the list provided.
1. Select **Save and Publish** or select **Next** to continue making changes.

## Website Options

You can customize the following sections of your Dev Portal website:

- [Header](#header-options)
- [Footer](#footer-options)
- [Homepage](#homepage-options)
- [Documentation](#add-documentation)

### Header {#header-options}

You can customize the header's background color, text color, and provide text to appear next to your logo image.

To customize the background or text color:

1. Select the field that you want to customize.
1. Enter the hex code for the desired color, or drag the sliders to create and refine a custom color.

To customize the header text, enter the text you want to use in the **Complementary logo text** field.

Then, select **Save and Publish** or select **Next** to continue making changes.

### Footer {#footer-options}

You can customize the footer's background color, text color, and provide links to appear in the footer.

To customize the background or text color:

1. Select the field that you want to customize.
1. Enter the hex code for the desired color, or drag the sliders to create and refine a custom color.

To add links:

1. Select **Add Links**.
1. Provide the display text and the target URL.

To delete links:

1. Select the "Delete" icon for any link that you want to remove.

Then, select **Save and Publish** or select **Next** to continue making changes.

### Homepage {#homepage-options}

You can customize the following options for your Dev Portal homepage:

- Hero image/banner text and color
- "About Us" cards: The homepage features three cards, which appear below the banner.
- Steps for getting started with your API.

To edit the hero image/banner:

1. Select the **Edit** icon.
1. Enter your desired text for the **Title** and **Secondary Title**.
1. Select the **Background** field and/or **Ink** field, then enter the hex code for the desired color or drag the sliders to create and refine a custom color.
1. Select **Save Changes**.

To edit the "About Us" cards:

1. Select the **Edit** icon.
1. Enter your desired **Title** (required), **Description** (required), icon, and **Alt Text** for each card.
1. Select **Save Changes**.

To edit the **Get Started** steps:

1. Select the **Edit** icon.
1. Enter your desired **Title** (required), **Description** (required), icon, and **Alt Text** for each of the four steps.
1. Select **Save Changes**.

> {{< icon "fa-solid fa-lightbulb" >}} At this point, we recommend selecting **Save and Publish** to save any customizations you've made.
> Verify that the changes have been applied, then move on to adding your [**Documentation**](#add-documentation).

### Documentation {#add-documentation}

#### Configure Documentation Page

You can edit the **Documentation Page** section of your Dev Portal website to add custom documentation for your APIs.
You can add or edit up to five Markdown documents. The following placeholder pages are included by default:

- Get Started
- Authentication
- Responses
- Errors

To customize the **Documentation** page of your Developer Portal, take the steps below:

1. Select the **Documentation** option in the **Edit Developer Portal** sidebar.
1. To add a new Markdown document, select **Add Page**. This adds a new blank item to the Pages table, which you can then edit and preview as described below.

    1. Select the **Edit** icon in the Pages table.
    1. Edit the sample text, or paste your text into the editor.
    1. Select **Preview** to view the Markdown rendered as HTML.
    1. Provide a new **Page Name**, if desired.
    1. Select **Save** to save your changes.

1. To reorder your documents, select the up or down arrow next to the Page name.

When ready, select **Save and Publish** to save all of your changes and publish your documentation.

#### Configure All APIs Page

The **All APIs** page is where all of your APIs will appear on your Dev Portal site.
To customize the **Configure All APIs** page of your Developer Portal, take the steps below:

1. Select the **Documentation** option in the **Edit Developer Portal** sidebar.
1. Select the **Edit** icon for the **Configure All APIs** section.
1. Add your **Page Description** (required).
1. Select **Upload illustration** to add a new full-width image to the page. Then, browse your local filesystem and select the file you'd like to upload.
1. To change the image background color, select the **Illustration Background** field. Then, then enter the hex code for the desired color or drag the sliders to create and refine a custom color.
1. Add the desired **Alt Text** for the image to the field provided.
1. Select **Save Changes**.

When ready, select **Save and Publish** to save and publish your **All APIs** page changes.
