---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller API Management Module.
docs: DOCS-366
title: Release Notes 3.18.0
toc: true
weight: 100
type:
- reference
---

{{< include "controller/apim-rn-preamble.md" >}}

&nbsp;

---

June 30, 2021

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller API Management Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}}Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

## What's New

- **Improved user experience for working with APIs**

  We've made working with APIs easier by simplifying how to navigate API definitions and related objects such as versions and published APIs.

- **Adds native Kubernetes API Gateway**

  You can run an API gateway natively in Kubernetes by using Instance Groups and DNS service discovery.

- **Create a RESTful facade for a SOAP service**

  Now you can create API versions from well-formed WSDL files that define a SOAP service. This allows incoming REST requests to be proxied to a SOAP backend with necessary JSON-to-XML transformations applied.

- **Adds Instance Groups**

  Gateway objects can now be added to Instance Groups. Instance Groups are groups of instances that share the same configuration dynamically.

## Resolved Issues

This release includes the following fixes. To locate the details for an issue when it was first reported, search the NGINX Docs for the issue ID.

- Specifying a URI to a JWK Set file is not supported on instances with multiple gateways ([17124]({{< ref "/controller/releases/release-notes.md#apim-17124" >}}))

## Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future release notes.

- **Configuration changes aren't pushed after upgrading from NGINX Controller v3.18 to NGINX Controller API Management Module v3.18. (25705)**

  If you upgrade from NGINX Controller v3.18 to NGINX Controller API Management Module v3.18, you need to upgrade your Controller Agents to successfully push configuration changes from NGINX Controller.

- **SOAP-REST proxy is incompatible with njs module version 0.6 (26088)**

  Published APIs that include SOAP-REST proxies will not pass traffic if njs-0.6 is running on the gateway instance.

  **Workaround:**

  Open an SSH connection into the NGINX Plus instance that's used as the API gateway and upgrade the njs module to the latest version, which at the time of publication is 0.6.1.

- **REST match method defaults to `PREFIX` for SOAP (26154)**

  When importing an API definition from a WSDL, the match method for each REST resource defaults to `PREFIX`. Additional options are planned for future releases.

- **Authentication policies are not yet supported for SOAP-REST proxy (26211)**

  When configuring a published API that includes SOAP services in backend workloads, authentication policies are not supported.

- **Instructions for restoring external config database may not restore published APIs (26280)**

  The commands in the [Back Up & Restore External Config Database]({{< ref "/controller/admin-guides/backup-restore/backup-restore-external-config-db.md" >}}) guide may not restore published APIs from the backup archive.

  **Workaround:**

  Follow the steps in the "Before You Begin" section in the ({{< ref "/controller/admin-guides/backup-restore/backup-restore-external-config-db.md" >}}) guide.

  In the section titled "Back Up External Config Database," replace step 2 with the following step, then proceed as per the documentation.

  2. Run the following script to back up the NGINX Controller database. The backup files are saved in a directory that looks like `pgbackup_<timestamp>`.

      ```bash
      DATE=$(date +"%Y%m%d%H%M")
      mkdir ~/pgbackup_${DATE}

      for db in common data system; do
        pg_dump -c -C -w -E utf8 -d ${db} -F c -f ~/pgbackup_${DATE}/${db}-${DATE}.backup
      done
      ```

  In the section titled "Back Up External Config Database," replace step 2 with the following step, then proceed as per the documentation.

  2. Run the following script to back up the NGINX Controller database. The backup files are saved in a directory that looks like pgbackup_<timestamp>.

      ```bash
      for backup_file in "$BACKUP_PATH"/*.backup; do
        db="$(basename "$backup_file" | cut -d '-' -f 1)"
        pg_restore -c  -d "$db" "$backup_file"
      done
      ```

## Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R24
- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19
