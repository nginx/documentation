---
nd-content-type: concept
nd-docs: DOCS-000
nd-product: NONECO
title: Unmanaged certificates in Config Sync Groups
toc: true
weight: 200
---

## Overview

Unmanaged certificates are SSL/TLS certificates that you install and manage manually on NGINX instances. Unlike managed certificates that are uploaded and distributed through the NGINX One Console, unmanaged certificates are installed directly on individual instances and referenced by their file paths in NGINX configuration files.

You are responsible for distributing, updating, and maintaining these certificates across your infrastructure.

### Unmanaged certificates in Config Sync Groups

Config Sync Groups (CSGs) in NGINX One Console ensure configuration consistency across connected NGINX instances. While managed certificates uploaded through the Console are automatically synchronized and tracked, unmanaged certificates follow a different model. 

When you use unmanaged certificates in a CSG, NGINX One Console provides visibility without automated management. It does not synchronize the certificate files themselves. However, it tracks their metadata to help you verify consistency across instances and understand the state of your certificates.

## How unmanaged certificates work in Config Sync Groups

If you have unmanaged certificates with CSGs, consider the following factors:

### Certificate tracking and visibility

When you use unmanaged certificates in a Config Sync Group:

- The NGINX Agent collects certificate metadata from each instance
- The Console displays unmanaged certificates based on their file paths and metadata
- Certificate consistency is determined by comparing certificate contents and file paths across instances

### Consistent certificates

When all instances in a CSG reference identical certificate files with the same file paths:

- Their contents and metadata match across all instances
- The CSG displays a single unmanaged certificate entry for that file path

### Inconsistent certificates

If certificate contents differ between instances, even when file paths are the same:

- Each unique certificate appears as a separate unmanaged entry in the Console
- Certificates are identified by their content and associated instance
- The CSG displays separate certificate entries in the configuration

If certificate contents are identical, but their file paths differ by instance:

- CSG publication may fail if file paths referenced in the NGINX configuration files do not exist on the instance
- The CSG configuration status will be out of sync
- Instances may not receive proper configuration updates

## Requirements for unmanaged certificates

To use unmanaged certificates effectively in Config Sync Groups, you must address these issues:

- **Manual installation**: Install certificates manually on each NGINX instance in the CSG
- **Identical file paths**: Ensure that file paths referencing unmanaged certificates are identical across all instances
- **Content consistency**: Maintain identical certificate file contents across all instances to ensure proper tracking
- **User responsibility**: Take full responsibility for certificate distribution, updates, and consistency

## Important considerations

NGINX One Console still helps you track unmanaged certificates:

### Certificate tracking

- The NGINX One Console tracks unmanaged certificates by their content and file paths
- When certificates are consistent across all instances, their contents and metadata match: as a result, a single consolidated entry appears in the CSG
- If certificate content differs between instances, multiple unique unmanaged certificates are displayed as separate entries

### Synchronization limitations

- **No automated sync**: Unmanaged certificates are not synchronized by the Console
- **Manual updates**: Certificates must be manually updated on each instance
- **No validation**: The Console does not perform validation logic for unmanaged certificates

### Configuration options

If you don't want metadata tracking for unmanaged certificates, you can configure the NGINX Agent to ignore certificate directories using the `allowed_directories` setting.

## Best practice: Convert to managed certificates

To maintain consistent visibility and automated management across CSGs, consider converting unmanaged certificates to managed certificates by:

- Converting them from unmanaged to managed
- Leveraging the managed certificate solution for automated synchronization
- Taking advantage of centralized certificate management features

## Troubleshooting

Seemingly minor issues can lead to problems with unmanaged certificates.

### Certificate inconsistencies

If you see multiple entries for what should be the same certificate:

- Verify that file paths are identical across all instances
- Check that certificate file contents match across all instances
- Ensure certificates were installed correctly on all instances
- Review NGINX Agent logs for any collection issues

If CSG publication is failing or configurations are out of sync:

- Confirm that all certificate file paths are identical across instances
- Verify that referenced certificate files exist on all instances
- Check NGINX configuration syntax for certificate references

### Visibility issues

If unmanaged certificates aren't appearing in the Console:

- Confirm that the NGINX Agent is running and connected
- Check that certificate directories are not excluded by `allowed_directories` settings
- Verify that NGINX configuration files correctly reference the certificate paths

## Related topics

- [Manage Config Sync Groups]({{< ref "manage-config-sync-groups.md" >}})
- [Add a file to a Config Sync Group]({{< ref "add-file-csg.md" >}})