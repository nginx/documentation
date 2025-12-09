---
nd-files:
---

{{< call-out "warning" "Start with a clean installation" >}}
The script supports only new installations. If NGINX Instance Manager is already installed, choose one of the following options:

- **Upgrade manually** – The script can’t perform upgrades. To update an existing installation, follow the [upgrade steps](#upgrade-nim).
- **Uninstall manually** – To preserve configuration files or metrics data, follow the [uninstall steps](#uninstall-nim). This approach lets you back up files before removing packages.
- **Remove all components** – To wipe the system and start fresh, run the script with the `-r` option:

   ```bash
   sudo bash install-nim-bundle.sh -r
   ```

   This command removes NGINX Instance Manager, ClickHouse, NGINX, configuration files, services, and user accounts. **Use with caution.** This action permanently deletes data unless you’ve backed it up.
{{< /call-out >}}
