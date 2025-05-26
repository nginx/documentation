---
Title: Configure high availability (HA) for NGINX Instance Manager
weight: 3
toc: true
type: how-to
product: NGINX Instance Manager
docs:
---

## Overview

High availability (HA) keeps a system running even if some components fail. In an **active-passive** HA setup, two servers work together:

- The active server handles all requests.
- The passive server stays on standby and takes over if the active server fails.

This guide shows how to configure HA for NGINX Instance Manager using `keepalived`. This setup includes:

- A virtual IP address (VIP)
- A shared Network File System (NFS)
- Automated health checks to detect failures and trigger failover

---

## Before you begin

Before setting up high availability (HA) for NGINX Instance Manager, make sure you have:

- Two physical servers with NGINX Instance Manager installed
- A reserved virtual IP address (VIP) that always points to the active instance
- An NFS share that both servers can access
- Permissions to manage IP addresses at the operating system level
- `keepalived` installed on both servers

Some cloud platforms don’t allow direct IP management with `keepalived`. If you’re using a cloud environment, check whether it supports VIP assignment.

### Limitations

<i class="fa-solid fa-triangle-exclamation"></i> This HA setup has the following restrictions:

- This setup **supports only two nodes** — one active and one passive. Configurations with three or more nodes are not supported.
- Active/active HA is not supported. This configuration works only in an active-passive setup.
- Do not modify `keepalived`. Changes beyond what is documented may cause failures.
- OpenID Connect (OIDC) authentication is not supported when NGINX Instance Manager is running in [forward-proxy mode]({{< ref "nim/system-configuration/configure-forward-proxy.md" >}}). OIDC is configured on the NGINX Plus layer and cannot pass authentication requests through a forward proxy.

---

## Reserve a virtual IP address

A **virtual IP address (VIP)** ensures that users always connect to the active server. During failover, `keepalived` automatically moves the VIP from the primary to the secondary server.

1. Choose an **unused IP address** in your network to serve as the VIP.
2. Ensure that the IP address does not conflict with existing devices.
3. Configure firewalls and security rules to allow traffic to and from the VIP.
4. Note the **VIP address**, as you will reference it in the `keepalived.conf` file.

Replace `<VIRTUAL_IP_ADDRESS>` with this IP when configuring `keepalived`.

---

## Install and configure keepalived

`keepalived` is a Linux tool that monitors system health and assigns a virtual IP (VIP) to the active server in an HA setup.

### Install keepalived

Install `keepalived` on both servers.

- For **Debian-based systems (Ubuntu, Debian):**

   ```sh
   sudo apt update
   sudo apt install keepalived -y
   ```

- For **RHEL-based systems (CentOS, RHEL):**

   ```sh
   sudo yum install keepalived -y
   ```

### Define monitored services

`keepalived` monitors specific services to determine if a node is operational. Update `/etc/nms/scripts/nms-notify-keepalived.sh` to include the services you want to monitor.

```sh
check_nms_services=(
  "clickhouse-server"
  "nginx"
  "nms-core"
  "nms-dpm"
  "nms-integrations"
  "nms-ingestion"
)
```

{{<call-out "important" "Update nms.conf on both nodes when changing mode of operation" "fa-solid fa-triangle-exclamation" >}}If you switch between connected and disconnected modes, you must update **/etc/nms/nms.conf** on both the primary and secondary nodes if `nms-integrations` is included in `check_nms_services`. NGINX Instance Manager runs in connected mode by default. For instructions on changing the mode, see the [installation guide for disconnected environments]({{< ref "nim/disconnected/offline-install-guide.md#set-mode-disconnected" >}}).{{</call-out>}}


### Configure keepalived

Edit `/etc/keepalived/keepalived.conf` on both servers and replace the placeholders with your actual network details.

```sh
vrrp_script nms_check_keepalived {
    script "/etc/nms/scripts/nms-check-keepalived.sh"
    interval 10
    weight 10
}

vrrp_instance VI_28 {
    state MASTER   # Set to BACKUP on the secondary server
    interface <NETWORK_INTERFACE>   # Replace with the correct network interface
    priority 100
    virtual_router_id 251
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass <AUTH_PASSWORD>   # Replace with a secure password
    }
    virtual_ipaddress {
        <VIRTUAL_IP_ADDRESS>   # Replace with your reserved VIP
    }
    track_script {
        nms_check_keepalived
    }
    notify /etc/nms/scripts/nms-notify-keepalived.sh
}
```

Replace:
- `<NETWORK_INTERFACE>` with your actual network interface (for example, `ens32`).
- `<AUTH_PASSWORD>` with a secure authentication password.
- `<VIRTUAL_IP_ADDRESS>` with your reserved VIP.

Ensure the configuration is identical on both servers, except for the `state` value:
- Set `MASTER` on the primary server.
- Set `BACKUP` on the secondary server.

Restart `keepalived` to apply the configuration:

```sh
sudo systemctl restart keepalived
```

---

## Configure Network File System (NFS) for shared storage

NGINX Instance Manager requires shared storage for configuration files and logs.

### Mount NFS on both servers

Replace `<NFS_SERVER_IP>` with the actual IP address of your NFS server in the following commands.

```sh
sudo mount -t nfs4 \
  -o rw,relatime,vers=4.2, \
     rsize=524288,wsize=524288,namlen=255, \
     hard,proto=tcp,timeo=600,retrans=2,sec=sys \
  <NFS_SERVER_IP>:/mnt/nfs_share/clickhouse \
  /var/lib/clickhouse

sudo mount -t nfs4 \
  -o rw,relatime,vers=4.2, \
     rsize=524288,wsize=524288,namlen=255, \
     hard,proto=tcp,timeo=600,retrans=2,sec=sys \
  <NFS_SERVER_IP>:/mnt/nfs_share/nms \
  /var/lib/nms
```

### Persist NFS mounts

Add the following lines to `/etc/fstab` on both servers, replacing `<NFS_SERVER_IP>` with your actual NFS server's IP.

```sh
<NFS_SERVER_IP>:/mnt/nfs_share/clickhouse /var/lib/clickhouse nfs defaults 0 0
<NFS_SERVER_IP>:/mnt/nfs_share/nms /var/lib/nms nfs defaults 0 0
```

### Verify NFS mounts

Run these commands to confirm that the NFS mounts are working:

```sh
sudo mount -a
df -h
ls -lart /mnt/nfs_share/clickhouse
ls -lart /var/lib/nms
sudo ls -lart /var/lib/clickhouse
telnet <NFS_SERVER_IP> 2049
rpcinfo -p <NFS_SERVER_IP>
sudo showmount -e <NFS_SERVER_IP>
dmesg | grep nfs
```

---

## Test failover

Failover can be tested by simulating a failure on the active server.

### Methods to trigger failover

- Restart `keepalived`:

   ```sh
   sudo systemctl restart keepalived
   ```

- Stop a monitored service:

   ```sh
   sudo systemctl stop clickhouse-server
   ```

- Reboot the active server:

   ```sh
   sudo reboot
   ```

- Simulate a network failure by disconnecting the active server.

### Verify failover

To check if the passive server has taken over, run the following command on the backup server:

```sh
ip a | grep <VIRTUAL_IP_ADDRESS>
```

The VIP should now be assigned to the secondary server.

---

## Troubleshooting

If failover does not work as expected, check the following:

- Ensure `keepalived` is running:
  ```sh
  systemctl status keepalived
  ```
- Check logs for errors:
  ```sh
  journalctl -u keepalived --no-pager | tail -50
  ```
- Verify that NFS mount points are accessible:
  ```sh
  df -h
  ```
- Check the `keepalived` configuration for syntax errors:
  ```sh
  cat /etc/keepalived/keepalived.conf
  ```

---

## Need help?

For additional support, visit the [F5 Support Portal](https://support.f5.com).