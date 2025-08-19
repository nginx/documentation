---
title: "Lab 4: Config Sync Groups"
weight: 400
toc: true
nd-content-type: tutorial
nd-product: nginx-one
---

## Introduction

In this lab, you'll create and manage Config Sync Groups in NGINX One Console. Config Sync Groups keep your NGINX instances in sync with a shared configuration. You'll create a group, add instances, apply a shared config, and fix sync errors.

---

## What you'll learn

By the end of this lab, you can:

- Create a Config Sync Group  
- Add instances to a Config Sync Group  
- Update the shared configuration for a Config Sync Group  

---

## Before you begin

Make sure you have:

- {{< include "nginx-one/workshops/xc-account.md" >}}
- Completed [Lab 2: Run workshop components with Docker]({{< ref "nginx-one/workshops/lab2/run-workshop-components-with-docker.md" >}})  
- Docker and Docker Compose installed and running  
- {{< include "workshops/nginx-one-env-variables.md" >}}  
- Basic familiarity with Linux command line and NGINX concepts  

---

## Exercise 1: Create a Config Sync Group

A Config Sync Group lets you apply one configuration to multiple NGINX instances and keep them in sync.

1. In NGINX One Console, select **Manage > Config Sync Groups**.  
2. In the **Config Sync Groups** pane, select **Add Config Sync Group**.  
3. In the form, enter `$NAME-sync-group` in the **Name** field (for example, `s.jobs-sync-group`).  
4. Select **Create**. The new group appears with **Details** and **Configuration** tabs.  
   - The **Details** tab shows:
     - Object ID  
     - Last publication status and config version ID  
     - Config Sync Status (for example, Unknown)  
     - Instance status counts (In Sync, Out of Sync, Offline, Unavailable)  
5. Switch to the **Configuration** tab to view your group's configuration files. It's empty for now. You'll add one in Exercise 2.

---

## Exercise 2: Add instances to the Config Sync Group

{{< call-out "note" "Note" "" >}}  
You can mix NGINX Open Source and NGINX Plus instances in one group. Any config feature you use must work on every instance. If you need NGINX Plus-only features, create a separate group.  
{{</ call-out >}}

When you create a Config Sync Group, it has no shared config. You can add one in two ways:

- **Define config manually**: Select your group, go to the **Configuration** tab, then select **Edit Configuration**. Add or paste your NGINX config, select **Next**, review the diff, and select **Save and Publish**.  
- **Populate from first instance**: Add one NGINX instance. The console uses that instance's existing config as the group's shared config.  

### Populate group config from first instance

1. Select **Manage > Config Sync Groups**.
2. Select your `$NAME-sync-group` (for example, `s.jobs-sync-group`).  
3. On the **Details** tab, in the **Instances** pane, select **Add Instance to Config Sync Group**.  
4. Select **Register a new instance with NGINX One then add to config sync group**, then select **Next**.  
5. Select **Use existing key** and paste `$TOKEN` (or your actual data plane key) into the **Data Plane Key** box.  
6. Select the **Docker Container** tab. The tab shows sample commands. Copy them and modify as follows.  

7. **Log in to the private registry:**

   ```shell
   echo "$JWT" \
     | docker login private-registry.nginx.com \
       --username "$JWT" --password-stdin
   ```

8. **Pull a Docker image** (replace version as needed). You can select a specific NGINX Plus version, OS type, and OS version. Here, use the R31 Alpine image:

   ```shell
   docker pull private-registry.nginx.com/nginx-plus/agent:nginx-plus-r31-alpine-3.19-20240522
   ```

   See [Pulling the image]({{< ref "nginx/admin-guide/installing-nginx/installing-nginx-docker.md#pull-the-image" >}}) for details.

9. **Run the container**. Copy the `docker run` command from the user interface and modify it:

   - Replace `YOUR_JWT_HERE` in `--env NGINX_LICENSE_JWT` with `$JWT`  
   - Replace `YOUR_DATA_PLANE_KEY` in `--env NGINX_AGENT_SERVER_TOKEN` with `$TOKEN`  
   - Add `--hostname "$NAME-one-manual"` and `--name "$NAME-one-manual"`  
   - Ensure `--env NGINX_AGENT_INSTANCE_GROUP="$NAME-sync-group"` is set  

   ```shell
   docker run \
   --hostname "$NAME-one-manual" \
   --name "$NAME-one-manual" \
   --env NGINX_LICENSE_JWT="$JWT" \
   --env NGINX_AGENT_SERVER_GRPCPORT=443 \
   --env NGINX_AGENT_SERVER_HOST=agent.connect.nginx.com \
   --env NGINX_AGENT_SERVER_TOKEN="$TOKEN" \
   --env NGINX_AGENT_INSTANCE_GROUP="$NAME-sync-group" \
   --env NGINX_AGENT_TLS_ENABLE=true \
   --restart always \
   --runtime runc \
   -d private-registry.nginx.com/nginx-plus/agent:nginx-plus-r31-alpine-3.19-20240522
   ```

10. In the **Config Sync Groups** pane, select **Refresh**. The new instance appears and the shared config populates. The first instance added becomes the default config source.  
11. Select the **Configuration** tab to view the shared config.  

### Add instances using Docker Compose

Instead of registering containers manually, you can set the sync group in your Compose file and restart all containers.

1. Stop the running containers:

   ```shell
   docker compose down
   ```

2. Open `compose.yaml` in a text editor.  
3. Uncomment the lines beginning with:

   ```yaml
   NGINX_AGENT_INSTANCE_GROUP: $NAME-sync-group
   ```

4. Restart all containers:

   ```shell
   docker compose up --force-recreate -d
   ```

5. In NGINX One Console, select **Refresh**. Instances with `NGINX_AGENT_INSTANCE_GROUP` set appear in the Config Sync Group.  
6. Instances automatically sync the existing NGINX config. When sync finishes, the **Config Sync Status** shows `In Sync`.  

<span style="display: inline-block;">
{{< img src="nginx-one/images/config-sync-status.png"
    alt="Table showing hostnames, NGINX versions, operating systems, availability status, and green In Sync indicators for each instance in the config sync group." >}}
</span>

---

## Exercise 3: Edit the group config and sync changes

Modify the shared configuration and apply the changes to all group members.

1. Select **Manage > Config Sync Groups**, then choose `$NAME-sync-group` (for example, `s.jobs-sync-group`).  
2. Select the **Configuration** tab.  
3. Select **Edit Configuration** (pencil icon).  
4. In the file list, select `default.conf`.  
5. In the editor pane, add these lines at 21–24:  

   ```yaml
   location /test_header {
       add_header X-Test-App true;
       return 200 'HTTP/1.1 200 OK\nContent-Type: text/html\n\n<html><body>Welcome to Lab 4 of the NGINX One Console Workshop!</body></html>';
   }
   ```

   <span style="display: inline-block;">
   {{< img src="nginx-one/images/config-sync-edits.png" alt="Editor showing modifications to default.conf with validator status 'NGINX Config OK'." >}}
   </span>

   The file is marked **modified** and the validator shows **NGINX Config OK**.  

6. Select **Next**, review the diff, then select **Save and Publish**.  
7. Select the **Details** tab and confirm **Last Publication Status** shows **Succeeded**.  
8. In the **Instances** table, confirm each host shows **Config Sync Status = In Sync**.  
9. Test your change by curling any instance's HTTP endpoint. Replace `<HOST>` and `<PORT>` with the values from the Instances table (for example, `localhost:80`):  

   ```shell
   curl http://localhost:80/test_header
   ```

   You should see:

   ```text
   HTTP/1.1 200 OK
   Content-Type: text/html

   <html><body>Welcome to Lab 4 of the NGINX One Console Workshop!</body></html>
   ```

---

## Next steps

You're ready to install your NGINX Plus license (JWT) on each instance. This will let you upgrade them to NGINX R34.  

Go to [Lab 5: Upgrade NGINX Plus to the latest version]({{< ref "/nginx-one/workshops/lab5/upgrade-nginx-plus-to-latest-version.md" >}}).

---

## References

- [NGINX One Console docs]({{< ref "/nginx-one/" >}})
