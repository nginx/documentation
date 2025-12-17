---
nd-content-type: concept
nd-docs: DOCS-000
nd-product: NONECO
title: Unmanaged certificates in Config Sync Groups
toc: true
weight: 500
---

## Overview

Config Sync Groups (CSGs) in NGINX One Console ensure configuration consistency across connected NGINX instances. While managed certificates uploaded through the Console are automatically synchronized and tracked, unmanaged certificates follow a different model that provides visibility without automated management.

Unmanaged certificates are not uploaded to the NGINX One Console. Instead, they are manually installed on individual instances and referenced directly in NGINX configuration files by their file paths. Although NGINX One does not synchronize unmanaged certificates, it tracks their metadata to help you verify consistency across instances.

## How unmanaged certificates work in Config Sync Groups

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

If certificate file paths differ between instances:

- CSG publication may fail
- The CSG configuration will be out of sync
- Instances may not receive proper configuration updates

## Requirements for unmanaged certificates

To use unmanaged certificates effectively in Config Sync Groups, you must:

- **Manual installation**: Install certificates manually on each NGINX instance in the CSG
- **Identical file paths**: Ensure that file paths referencing unmanaged certificates are identical across all instances
- **Content consistency**: Maintain identical certificate file contents across all instances to ensure proper tracking
- **User responsibility**: Take full responsibility for certificate distribution, updates, and consistency

## Important considerations

### Certificate tracking

- The NGINX One Console tracks unmanaged certificates by their content and file paths
- When certificates are consistent across all instances, their contents and metadata match, and a single consolidated entry appears in the CSG
- If certificate content differs between instances, multiple unique unmanaged certificates are displayed as separate entries

### Synchronization limitations

- **No automated sync**: Unmanaged certificates are not synchronized by the Console
- **Manual updates**: You must manually update certificates on each instance when they expire or need rotation
- **No validation**: The Console does not perform validation or rotation logic for unmanaged certificates

### Configuration options

If you don't want metadata tracking for unmanaged certificates, you can configure the NGINX Agent to ignore certificate directories using the `allowed_directories` setting.

## Best practices

### Converting to managed certificates

To maintain consistent visibility and automated management across CSGs, consider converting unmanaged certificates to managed certificates by:

1. Uploading them through the NGINX One Console
2. Leveraging the managed certificate solution for automated synchronization
3. Taking advantage of centralized certificate management features

## Troubleshooting

### Certificate inconsistencies

If you see multiple entries for what should be the same certificate:

1. Verify that file paths are identical across all instances
2. Check that certificate file contents match across all instances
3. Ensure certificates were installed correctly on all instances
4. Review NGINX Agent logs for any collection issues

If CSG publication is failing or configurations are out of sync:

1. Confirm that all certificate file paths are identical across instances
2. Verify that referenced certificate files exist on all instances
3. Check NGINX configuration syntax for certificate references

### Visibility issues

If unmanaged certificates aren't appearing in the Console:

1. Confirm that the NGINX Agent is running and connected
2. Check that certificate directories are not excluded by `allowed_directories` settings
3. Verify that NGINX configuration files correctly reference the certificate paths

## Related topics

- [Manage Config Sync Groups]({{< ref "manage-config-sync-groups.md" >}})
- [Add a file to a Config Sync Group]({{< ref "add-file-csg.md" >}})