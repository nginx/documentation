---
# We use sentence case and present imperative tone
<<<<<<< HEAD
title: View and edit an NGINX instance
# Weights are assigned in increments of 100: determines sorting order
weight: 200
=======
title: View and edit NGINX configurations
# Weights are assigned in increments of 100: determines sorting order
weight: 300
>>>>>>> c7ce27ce (Draft: new N1C doc homepage)
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
type: tutorial
# Intended for internal catalogue and search, case sensitive:
product: NGINX One
---
<!-- Possible future include, with similar files in config-sync-groups/ and staged-configs/ subdirectories -->

<<<<<<< HEAD
This guide explains how to edit the configuration of an existing **Instance** in your NGINX One Console.
=======
## Overview

This guide explains how to add a **Instances** to your NGINX One Console.

## Before you start

Before you add **Instances** to NGINX One Console, ensure:

- You have an NGINX One Console account with staged configuration permissions.```

Once you've registered your NGINX Instances with the F5 NGINX One Console, you can view and edit their NGINX configurations on the **Instances** details page.
>>>>>>> c7ce27ce (Draft: new N1C doc homepage)

To view and edit an NGINX configuration, follow these steps:

1. On the left menu, select **Instances**.
2. Select the instance you want to view the configuration for.
3. Select the **Configuration** tab to see the current configuration for the NGINX instance.
4. Select **Edit Configuration** to make changes to the current configuration.
5. Make your changes to the configuration files. The config analyzer will let you know if there are any errors.
6. When you are satisfied with the changes, select **Next**.
7. Compare and verify your changes before selecting **Save and Publish** to publish the edited configuration.

Alternatively, you can select **Save Changes As**. In the window that appears, you can set up this instance as a [**Staged Configuration**]({{< ref "/nginx-one/staged-configs/_index.md" >}}).

## See also

<<<<<<< HEAD
- [Manage Config Sync Groups]({{< ref "/nginx-one/nginx-configs/config-sync-groups/manage-config-sync-groups.md" >}})
=======
- [Manage Config Sync Groups]({{< ref "/nginx-one/config-sync-groups/manage-config-sync-groups.md" >}})
>>>>>>> c7ce27ce (Draft: new N1C doc homepage)
