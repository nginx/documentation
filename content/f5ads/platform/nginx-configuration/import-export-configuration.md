---
title: Import and export configurations
description: "Import an NGINX configuration from a tar.gz archive, or export a configuration version as a tar.gz archive, in the F5 ADS Console."
weight: 120
toc: true
f5-content-type: how-to
f5-product: F5 Application Delivery Service
f5-keywords: "NGINX configuration, import, export, tar.gz, tarball, archive, F5 ADS Console"
f5-summary: >
  Import an existing NGINX configuration into F5 Application Delivery Service from a tar.gz archive, or export a configuration version as a tar.gz archive.
  Use import to move a working configuration to F5 Application Delivery Service without creating each file by hand.
  The archive must contain /etc/nginx/nginx.conf, and the paths in the archive must match the paths on the deployment.
f5-audience: operator
---

## Overview

Import an existing NGINX configuration from a `tar.gz` archive, also called a [tarball](https://en.wikipedia.org/wiki/Tar_(computing)), instead of creating each file in the console. You can also export any configuration version as a `tar.gz` archive.

## Before you begin

Before you begin, make sure that:

- **You can log in to the F5 ADS Console**: See [Access the F5 ADS Console]({{< ref "/f5ads/platform/nginx-configuration/nginx-configuration-console.md#access-the-f5-ads-console" >}}).
- **Your configuration follows the F5 ADS rules**: Imported configurations follow the same rules as other configurations. See [NGINX configuration rules and limits]({{< ref "/f5ads/platform/nginx-configuration/configuration-rules.md" >}}).

## Archive requirements

An archive that you import must meet these requirements:

- Must be a gzip-compressed tar file with the `.tar.gz` or `.tgz` extension, in ustar, pax, or GNU tar format.
- Must contain `/etc/nginx/nginx.conf`, the main NGINX configuration file.
- Each path must be the path of the file on the deployment. F5 ADS adds a leading `/` if a path doesn't have one, so `etc/nginx/nginx.conf` and `./etc/nginx/nginx.conf` both become `/etc/nginx/nginx.conf`.
- Its files must be in directories that you can upload to, such as `/etc/nginx`, `/opt`, `/srv`, or `/var/www`. For the full list, see [NGINX filesystem restrictions]({{< ref "/f5ads/platform/nginx-configuration/configuration-rules.md#nginx-filesystem-restrictions" >}}).

F5 ADS reads relative paths in NGINX directives from `/etc/nginx`. For example, `include conf.d/*.conf;` reads the files in `/etc/nginx/conf.d`.

The archive also has these size limits:

{{< table >}}

| Limit | Value |
|-------|-------|
| Archive size | 5 MB |
| Size of one file, uncompressed | 10 MB |
| Size of all files, uncompressed | 10 MB |
| Number of entries, including directories | 1,000 |

{{< /table >}}

When you import an archive, F5 ADS:

- Skips directories, symbolic links, and other entries that aren't regular files.
- Skips macOS metadata files: `.DS_Store` and files with names that start with `._`. It imports other hidden files, such as `.htpasswd`.
- Ignores the file permissions and owners in the archive.

{{< call-out class="important" >}}

An archive can contain certificates, private keys, and other secrets in plain text. Store and share the archive securely. To keep keys out of your configuration files, use [managed SSL/TLS certificates]({{< ref "/f5ads/platform/ssl-tls-certificates/ssl-tls-certificates-console.md" >}}).

{{< /call-out >}}

## Create an archive

Create the archive from the root directory (`/`) so that its paths start with `etc/nginx/`. If you create it from inside `/etc/nginx`, the archive doesn't contain `/etc/nginx/nginx.conf`, and the import fails.

1. Create an archive named `nginx-config.tar.gz` from the files in `/etc/nginx`:

   - **GNU tar (Linux):**

     ```shell
     tar --format=pax -czvf nginx-config.tar.gz -C / etc/nginx
     ```

   - **BSD tar (macOS):**

     ```shell
     COPYFILE_DISABLE=1 tar --format pax -czvf nginx-config.tar.gz -C / etc/nginx
     ```

   These commands use the pax format. To use ustar, replace `pax` with `ustar`. The ustar format can't store paths longer than 255 characters. On macOS, `COPYFILE_DISABLE=1` keeps macOS metadata files out of the archive.

1. List the files in the archive:

   ```shell
   tar -tvzf nginx-config.tar.gz
   ```

   The output must include `etc/nginx/nginx.conf`:

   ```text
   drwxr-xr-x root/root         0 2026-11-23 10:00 etc/nginx/
   drwxr-xr-x root/root         0 2026-11-23 10:00 etc/nginx/conf.d/
   -rw-r--r-- root/root       412 2026-11-23 10:00 etc/nginx/conf.d/default.conf
   -rw-r--r-- root/root      1290 2026-11-23 10:00 etc/nginx/nginx.conf
   ```

   An archive that you export from F5 ADS shows `/etc/nginx/nginx.conf`, with a leading `/`. You can import it without changes.

### Create an archive from a different directory

If your files aren't in `/etc/nginx`, change the paths when you create the archive:

- **GNU tar (Linux):**

  ```shell
  tar --format=pax -czvf nginx-config.tar.gz --transform 's,^<SOURCE_DIRECTORY>,etc/nginx,' -C <PARENT_DIRECTORY> <SOURCE_DIRECTORY>
  ```

- **BSD tar (macOS):**

  ```shell
  COPYFILE_DISABLE=1 tar --format pax -czvf nginx-config.tar.gz -s ',^<SOURCE_DIRECTORY>,etc/nginx,' -C <PARENT_DIRECTORY> <SOURCE_DIRECTORY>
  ```

Replace:

- `<SOURCE_DIRECTORY>` with the directory that contains `nginx.conf`, for example `my-nginx`.
- `<PARENT_DIRECTORY>` with the directory that contains `<SOURCE_DIRECTORY>`, for example `~`.

## Import a configuration

1. On the left menu, select **Configurations**.
1. Select **Add Configuration**.
1. Select **Import Configuration**.
1. Enter a name for the configuration and an optional description.
1. Select **Import from File**.
1. Select **Upload File**, and then choose your archive.
1. Select **Import**.

   If the archive is valid, you'll see the message "File(s) were imported successfully."

1. Select **Next**.
1. Review the files in the editor, and fix any errors or warnings.

   You can edit, add, rename, and delete files before you save the configuration.

1. Select **Add Configuration**.

F5 ADS creates the configuration and its first version. To apply it, update a deployment to use the configuration.

## Export a configuration

To export a version from the configuration list:

1. On the left menu, select **Configurations**.
1. Select the ellipsis (three dots) icon next to the configuration.
1. Select **Export**.
1. From the **Version** list, select the version to export.
1. Select **Export**.

To export a version from the configuration details:

1. On the left menu, select **Configurations**, and then select the configuration.
1. Export a version:

   - To export the version that's open in the editor, select the **Configuration** tab, and then select **Export**.
   - To export another version, select the **Versions** tab. Select the ellipsis (three dots) icon next to the version, and then select **Export**.

Your browser downloads a file named `<VERSION_ID>.tar.gz`, where `<VERSION_ID>` is the ID of the configuration version.

The archive:

- Contains the files of one configuration version as they were submitted, at their full paths, such as `/etc/nginx/nginx.conf`.
- Sets the permissions of all files to `0644`.
- Doesn't contain managed certificates and keys, or references to secrets in a cloud secret manager. If you import the archive, add these again.

To extract the archive, use the `-C` option with a new directory. `tar` removes the leading `/` from the paths, so the files go into `exported-config/etc/nginx/`:

```shell
mkdir exported-config
tar -xzvf <VERSION_ID>.tar.gz -C exported-config
```

{{< call-out class="caution" >}}

Don't extract the archive in the root directory (`/`) of a system that runs NGINX, and don't use the `-P` (`--absolute-names`) option. Both replace the files in `/etc/nginx`.

{{< /call-out >}}

## Troubleshooting

### The archive must contain /etc/nginx/nginx.conf

**Symptom**: The import fails with the message "the archive must contain /etc/nginx/nginx.conf, which must be the main NGINX configuration file."

**Cause**: The archive doesn't have a file at `/etc/nginx/nginx.conf`. This happens when you create the archive from inside `/etc/nginx`, so the paths start with `./` or `nginx.conf`.

**Fix**: Create the archive from the root directory. See [Create an archive](#create-an-archive).

### The archive is too large or has too many entries

**Symptom**: The import fails with the message "the configuration archive must be 5MB or less," or with a message that starts with a file name and `too large`, `total uncompressed size too large`, or `too many entries`.

**Cause**: The archive or one of its files is over a limit in [Archive requirements](#archive-requirements).

**Fix**: Remove files that NGINX doesn't need, such as logs or backups, and create the archive again.

## References

For more information, see:

- [Manage configurations using the Console]({{< ref "/f5ads/platform/nginx-configuration/nginx-configuration-console.md" >}})
- [NGINX configuration rules and limits]({{< ref "/f5ads/platform/nginx-configuration/configuration-rules.md" >}})
- [Add certificates using the Console]({{< ref "/f5ads/platform/ssl-tls-certificates/ssl-tls-certificates-console.md" >}})
