---
title: "Lab 5: Upgrade NGINX Plus to the latest version"
weight: 500
toc: true
nd-content-type: tutorial
nd-product: 
- nginx-one
- nginx-plus
---

## Introduction

In this lab, you'll upgrade NGINX Plus from R32 (or earlier) to the latest version.  

There are two scenarios:

- **Docker**: Deploy a new container running the latest NGINX Plus image, add it to your Config Sync Group, then shift traffic and retire older containers.  
- **VM**: Push your JWT license to an existing VM instance, install the new NGINX Plus package, and restart the service.

Pick the scenario that matches your setup.

---

## What you'll learn

By the end of this lab, you can:

- Deploy a Docker container running the latest NGINX Plus with NGINX Agent installed  
- Add a VM to a Config Sync Group and push your JWT license  
- Install or upgrade to the latest NGINX Plus on a VM  
- Check version and sync status in NGINX One Console  
- Clean up unavailable instances in NGINX One Console  

---

## Before you begin

Make sure you have:

- {{< include "nginx-one/workshops/xc-account.md" >}}
- Completed [Lab 4: Config Sync Groups]({{< ref "nginx-one/workshops/lab4/config-sync-groups.md" >}})  
- Docker and Docker Compose installed and running (for Docker scenario)  
- A trial or paid NGINX One JWT license (saved as `nginx-repo.jwt`) from [MyF5](https://my.f5.com/manage/s/)  
- A VM with NGINX Plus R32 (or earlier), SSH access, and NGINX Agent installed (for VM scenario)  
- {{< include "workshops/nginx-one-env-variables.md" >}}  
- Basic familiarity with Linux and NGINX  

---

## Scenario A: Upgrade NGINX Plus in Docker

### Exercise A1: Pull and run the latest NGINX Plus image

1. Log in to the private registry:

   ```shell
   echo "$JWT" | docker login private-registry.nginx.com \
     --username "$JWT" --password-stdin
   ```

2. Open `compose.yaml` in a text editor. Uncomment the **plus4** service block (lines 74–95). This block pulls the latest Debian NGINX Plus image with NGINX Agent, and sets your data plane key, JWT, and Config Sync Group.

   ```yaml
   plus4: # Debian latest NGINX Plus Web / Load Balancer
       environment:
         NGINX_AGENT_SERVER_HOST: 'agent.connect.nginx.com'
         NGINX_AGENT_SERVER_GRPCPORT: '443'
         NGINX_AGENT_TLS_ENABLE: 'true'
         NGINX_AGENT_SERVER_TOKEN: $TOKEN # Data plane key from NGINX One Console
         NGINX_LICENSE_JWT: $JWT
         NGINX_AGENT_INSTANCE_GROUP: $NAME-sync-group
       hostname: $NAME-plus4
       container_name: $NAME-plus4
       image: private-registry.nginx.com/nginx-plus/agent:debian
       volumes:
         - ./nginx-plus/etc/nginx/nginx.conf:/etc/nginx/nginx.conf
         - ./nginx-plus/etc/nginx/conf.d:/etc/nginx/conf.d
         - ./nginx-plus/etc/nginx/includes:/etc/nginx/includes
         - ./nginx-plus/usr/share/nginx/html:/usr/share/nginx/html
       ports:
         - '80'
         - '443'
         - '9000'
         - '9113'
       restart: always
   ```

   {{< call-out "note" "VS Code tip" "" >}}  
   In VS Code, highlight lines 74–95 and press `Ctrl` + `/` to uncomment.  
   {{< /call-out >}}

3. Restart your containers:

   ```shell
   docker compose down && docker compose up --force-recreate -d
   ```

4. In NGINX One Console, go to **Instances**.  
5. You should see your new instance (`$NAME-plus4`) in the list (for example, `s.jobs-plus4`).  
6. Select the instance and confirm it runs the latest versions of NGINX Plus and NGINX Agent.  
7. The `$NAME-plus4` container joins the `$NAME-sync-group` and inherits the shared config.  

   {{< call-out "note" "Tip" "" >}}  
   Because new containers in a sync group automatically pick up the shared config, you get a consistent setup across versions. This makes upgrades safer and avoids manual copy-paste steps.  
   {{< /call-out >}}

### Exercise A2: Delete unavailable containers

When you recreate containers, old entries remain in NGINX One Console. Clean them up:

1. In NGINX One Console, go to **Instances**.  
2. Select **Add filter > Availability > Unavailable**.  
3. Select the checkboxes for the unavailable hosts.  
4. Select **Delete selected**, then confirm.  
5. Remove the filter by selecting the **X** next to the filter tag.  

<span style="display: inline-block;">
{{< img src="nginx-one/images/unavailable-instances.png"
    alt="Table of three NGINX One Console instances filtered to 'Availability = Unavailable.' Shows hostnames, NGINX versions, grey Unavailable icons, and the Delete selected button." >}}
</span>

---

## Scenario B: Upgrade NGINX Plus on a VM with Config Sync Groups

{{< call-out "note" "Note" >}}  
These steps cover RHEL, Amazon Linux, CentOS, Oracle Linux, AlmaLinux, Rocky Linux, Debian, and Ubuntu only.  
{{</ call-out >}}

### Exercise B1: Create a Config Sync Group for VMs

1. In NGINX One Console, go to **Manage > Config Sync Groups**.  
2. Select **Add Config Sync Group**.  
3. In the **Name** field, enter `$NAME-sync-group-vm` (for example, `s.jobs-sync-group-vm`), then select **Create**.  

### Exercise B2: Add your VM to the Config Sync Group

1. Select **Manage > Config Sync Groups**, then pick your group's name.  
2. On the **Details** tab, in the **Instances** pane, select **Add Instance to Config Sync Group**.  
3. Select **Register a new instance with NGINX One then add to config sync group**, then select **Next**.  
4. Select **Use existing key**, paste `<your-key>` into the **Data Plane Key** box.  
5. Copy the pre-filled `curl` command and run it on your VM:

    **Example**:

    ```shell
    curl https://agent.connect.nginx.com/nginx-agent/install | \
    DATA_PLANE_KEY="<your-key>" \
    sh -s -- -y -c "<config-sync-group-name>"
    ```

6. Back in NGINX One Console, select **Refresh**. Your VM appears in the list with **Config Sync Status = In Sync**.  

### Exercise B3: Enable the NGINX Plus API and dashboard

Add a new configuration file (`/etc/nginx/conf.d/dashboard.conf`) in your group config to enable the NGINX Plus API and dashboard.  

{{< include "use-cases/monitoring/enable-nginx-plus-api-with-config-sync-group.md" >}}

### Exercise B4: Add your JWT license file

Each instance needs a JWT license before upgrading. Add it in your Config Sync Group so all members inherit it.

1. In NGINX One Console, select **Manage > Config Sync Groups**, then pick your group's name.  
2. Select the **Configuration** tab, then **Edit Configuration**.  
3. Select **Add File**, then **New Configuration File**.  
4. In **File name**, enter `/etc/nginx/license.jwt`.  
5. Select **Add**.  
6. Paste the contents of your JWT file into the editor.  
7. Select **Next**, review the diff, then select **Save and Publish**.  

See [About subscription licenses]({{< ref "solutions/about-subscription-licenses.md" >}}) for details.

### Exercise B5: Upgrade NGINX Plus on your VM

1. Upgrade the NGINX Plus package:

   - **RHEL, Amazon Linux, CentOS, Oracle Linux, AlmaLinux, Rocky Linux**  

     ```shell
     sudo yum upgrade nginx-plus
     ```

   - **Debian, Ubuntu**  

     ```shell
     sudo apt update && sudo apt install nginx-plus
     ```

2. In NGINX One Console, go to **Manage > Instances**.  
3. Select your VM instance.  
4. In the **Instance Details** pane, confirm the NGINX Plus version has been updated.  
5. If the version doesn’t update right away, refresh the page after a few seconds.  

---

## Next steps

You have upgraded your instances to the latest NGINX Plus.

Go to the [NGINX One documentation]({{< ref "nginx-one/" >}}) for more advanced guides and use cases.  

---

## References

- [NGINX One Console docs]({{< ref "/nginx-one/" >}})  
- [About subscription licenses]({{< ref "solutions/about-subscription-licenses.md" >}})
