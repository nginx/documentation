---
title: Troubleshooting
description: Resolve common issues with F5 WAF for NGINX and NGINX Instance Manager by verifying installation, configuration, and connectivity.
toc: true
weight: 1000
nd-content-type: how-to
nd-product: NIMNGR
---

If you're having trouble with F5 WAF for NGINX, try the steps below.
If these steps don’t fix the issue, contact F5 Support.

---

### Check that F5 WAF for NGINX is not installed on the NGINX Instance Manager host

F5 WAF for NGINX and the WAF compiler shouldn’t run on the same host. To check:

1. Log in to the NGINX Instance Manager host from a terminal.
1. Run the command that matches your operating system:

   - For Debian-based systems:

     ```shell
     dpkg -s app-protect
     ```

   - For RPM-based systems:

     ```shell
     rpm -qa | grep app-protect
     ```

If F5 WAF for NGINX is installed, follow the [uninstall instructions]({{< ref "/waf/install/uninstall.md" >}}).

---

### Check that the WAF compiler version matches the F5 WAF for NGINX version

Each F5 WAF for NGINX release requires a matching WAF compiler version. To confirm:

1. Log in to the NGINX Instance Manager host.
1. Run the following command to see installed compiler versions:

   ```shell
   ls -l /opt/nms-nap-compiler
   ```

---

### Confirm the WAF compiler is working correctly

You can verify that the WAF compiler is installed and responsive.

```shell
sudo /opt/nms-nap-compiler/app_protect-<version>/bin/apcompile -h
```

**Example:**

```shell
sudo /opt/nms-nap-compiler/app_protect-5.575.2/bin/apcompile -h
```

**Expected output:**

```text
USAGE:
    /opt/nms-nap-compiler/app_protect-5.575.2/bin/apcompile <options>

Examples:
    /opt/nms-nap-compiler/app_protect-5.575.2/bin/apcompile -p /path/to/policy.json -o mypolicy.tgz
    /opt/nms-nap-compiler/app_protect-5.575.2/bin/apcompile -p policyA.json -g myglobal.json -o /path/to/policyA_bundle.tgz
    /opt/nms-nap-compiler/app_protect-5.575.2/bin/apcompile -g myglobalsettings.json --global-state-outfile /path/to/myglobalstate.tgz
    /opt/nms-nap-compiler/app_protect-5.575.2/bin/apcompile -b /path/to/policy_bundle.tgz --dump
    /opt/nms-nap-compiler/app_protect-5.575.2/bin/apcompile -l logprofA.json -o /path/to/logprofA_bundle.tgz
```

---

### Confirm NGINX Agent configuration on the F5 WAF for NGINX instance

Open the `/etc/nginx-agent/nginx-agent.conf` file and make sure it includes the correct settings.

```yaml
# Directories monitored for config files
config_dirs: "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms:/etc/app_protect"

# Required extensions
extensions:
  - nginx-app-protect
  - nap-monitoring

nginx_app_protect:
  # Report interval for F5 WAF details
  report_interval: 15s
  # Enable precompiled policy and log profile publication from NGINX Instance Manager
  precompiled_publication: true

nap_monitoring:
  # Buffer size for the collector — holds log lines and parsed entries
  collector_buffer_size: 50000
  # Buffer size for the processor — processes log lines from the buffer
  processor_buffer_size: 50000
  # IP address where the agent listens for syslog messages
  syslog_ip: "127.0.0.1"
  # Port number for receiving syslog messages
  syslog_port: 514
```

---

### Confirm access to the NGINX packages repository

If automatic downloads for attack signatures, bot signatures, or threat campaigns fail, make sure the repository certificate and key are configured correctly.

Run this command to test repository access:

```shell
curl \
  --key /etc/ssl/nginx/nginx-repo.key \
  --cert /etc/ssl/nginx/nginx-repo.crt \
  https://pkgs.nginx.com/app-protect-security-updates/index.xml
```

**Expected output:**

```text
...
<repositories>
<repository distro="centos" version="6" arch="x86_64" prefix="centos/6/x86_64/">
</repository>
<repository distro="centos" version="7" arch="x86_64" prefix="centos/7/x86_64/">
<package type="rpm">
  <name>app-protect-attack-signatures</name>
  <arch>x86_64</arch>
  <version epoch="0" ver="2019.07.16" rel="1.el7.ngx"/>
  <location href="RPMS/app-protect-attack-signatures-2019.07.16-1.el7.ngx.x86_64.rpm"/>
</package>
...
```
