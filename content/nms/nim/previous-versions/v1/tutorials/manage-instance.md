---
categories:
- examples
description: Steps on Adding an NGINX Instance to Instance Manager Management
doctypes:
- tutorial
draft: true
journeys:
- getting started
- using
personas:
- devops
- netops
- secops
- support
tags:
- docs
title: Manage an NGINX Instance
toc: true
versions: []
docs: "DOCS-643"
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document is intended to help add NGINX instances to Instance Manager management.

The current Instance Manager version requires installing and starting the agent on an NGINX instance to manage the instance in Instance Manager. This can be done manually, or you may use standard automation tools to deploy to many NGINX instances. Once you install, configure, and start the agent, it will automatically be added to the Inventory of Instance Manager.

To remove a managed instance, you must stop or <!-- vale off -->terminate<!-- vale on --> the nginx-agent process before deleting the instance in Instance Manager. Otherwise, it will add itself back to the managed inventory.

## Prerequisites {#prerequisites}

1. NGINX Instance Manager server already configured and running.
2. nginx-agent binaries, package, or repository configured on the endpoint.

## Manual Install {#install-agent}

Assuming you are on the nginx-manager server and have the repository configured, you can pull the nginx-agent there and use ssh/scp to install the nginx-agent. You can also skip the repository part and place the package in your home directory using the same steps.

1. Create an `nginx-agent.conf` file with the correct settings in your current directory.

```bash
vim nginx-agent.conf
```

Change the server name and port below and also the stub_status or plus_api sections (you can leave both in if you have a mix of plus and open source)

```yaml {hl_lines=[6,"22-23"]}
#
# /etc/nginx-agent/nginx-agent.conf
#

# Configuration file for NGINX Agent
server: nginx-manager.example.com:10443
log:
  level: info
  path: /var/log/nginx-agent/
# (optional) tags for this specific instance / machine for inventory purposes
metadata:
  location: unspecified
# instance tags
tags:
- web
- staging
- etc
# list of allowed config directories (comma-separated)
config_dirs: /etc/nginx,/usr/local/etc/nginx
nginx:
  bin_path: /usr/sbin/nginx
  stub_status: "http://127.0.0.1:80/nginx_status"
  plus_api: "http://127.0.0.1:8080/api"
  metrics_poll_interval: 1000ms
```

2. Download the package locally or place it in a directory. You can create a directory for this or just use your home directory. The examples below assume you are in the directory you are running the commands from.

{{<tabs name="get_nginx-agent">}}
{{%tab name="CentOS, RHEL using yum repo"%}}

Use the yum-downloadonly plugin with yum.

If you are on a RHEL5 or RHEL6 distribution [install the downloadonly plugin](https://access.redhat.com/solutions/10154).
You can skip this step for RHEL7.

```bash
# RHEL5
$ sudo yum install -y yum-downloadonly
# RHEL6
$ sudo yum install -y yum-plugin-downloadonly
```

Download the rpm using yum to the local directory. This assumes you have the nginx-manager repository already set.

```bash
sudo yum install --downloadonly --downloaddir=. nginx-agent
agentrpm=$(ls $PWD/nginx-agent*.rpm | tail -n 1)
echo $agentrpm
```

{{%/tab%}}
{{%tab name="CentOS8, RHEL8, Fedora using dnf repo"%}}

Download the rpm using dnf to the local directory. This assumes you have the nginx-manager repository already set.

```bash
sudo dnf download nginx-agent
agentrpm=$(ls $PWD/nginx-agent*.rpm | tail -n 1)
echo $agentrpm
```

{{%/tab%}}
{{%tab name="Debian and Ubuntu using apt-get repo"%}}

Download the deb using apt-get to the local directory. This assumes you have the nginx-manager repository already set.

```bash
sudo apt download nginx-agent
#sudo apt-get download nginx-agent # use older apt-get if necessary
agentdeb=$(ls $PWD/nginx-agent*.deb | tail -n 1)
echo $agentdeb
```

{{%/tab%}}
{{%tab name="Drop package on server"%}}

Download the agent zip file from the myf5 portal and unzip the archive. The files should be in the pkg_deb_build or pkg_rpm_build directory.

For rpm

```bash
agentrpm=$(ls $PWD/pkg_rpm_build/nginx-agent*.rpm | tail -n 1)
echo $agentrpm
agentdeb=$(ls $PWD/pkg_deb_build/nginx-agent*.deb | tail -n 1)
echo $agentdeb
```

{{%/tab%}}
{{</tabs>}}

3. Copy, Install, and Start the NGINX Agent

{{<tabs name="get_nginx-agent">}}
{{%tab name="CentOS, RHEL, and rpm-based"%}}

Use ssh keys to speed this up. This assumes the user has sudo privileges.

```bash
agentsystem="remoteserver.com" # remove system hostname/FQDN
agentuser="user" # username with sudo privileges
scp $agentrpm $agentuser@$agentsystem:./
scp nginx-config.conf $agentuser@$agentsystem:./
ssh $agentuser@$agentsystem sudo yum install -y ./nginx-agent*.rpm # RHEL7/CentOS7 and yum-based
#ssh $agentuser@$agentsystem sudo dnf install -y ./nginx-agent*.rpm # RHEL8/CentOS8/Fedora and dnf-based
#ssh $agentuser@$agentsystem sudo rpm -Uvh ./nginx-agent*.rpm # use rpm instead of package management
ssh $agentuser@$agentsystem sudo cp nginx-agent.conf /etc/nginx-agent/nginx-agent.conf
ssh $agentuser@$agentsystem sudo systemctl enable nginx-agent --now # For systemd-based systems
ssh $agentuser@$agentsystem systemctl status nginx-agent # Confirm it ran successfully
```

{{%/tab%}}
{{%tab name="Ubuntu, Debian, and deb-based"%}}

Use ssh keys to speed this up. This assumes the user has sudo privileges.

```bash
agentsystem="remoteserver.com" # remove system hostname/FQDN
agentuser="user" # username with sudo privileges
scp $agentdeb $agentuser@$agentsystem:./
scp nginx-config.conf $agentuser@$agentsystem:./
ssh $agentuser@$agentsystem sudo apt install ./nginx-agent*.deb
#ssh $agentuser@$agentsystem sudo dpkg -i ./nginx-agent*.deb && sudo apt-get install -f # Use older apt-get if necessary - not a clean process
ssh $agentuser@$agentsystem sudo cp nginx-agent.conf /etc/nginx-agent/nginx-agent.conf
ssh $agentuser@$agentsystem sudo systemctl enable nginx-agent --now # For systemd-based systems
ssh $agentuser@$agentsystem systemctl status nginx-agent # Confirm it ran successfully
```

{{%/tab%}}
{{</tabs>}}

4. Check the instance is now appearing on the Instance Manager server inventory list. Once you start the nginx-agent and point to the nginx-manager, registration is automatic.

## Automation Options {#automate-agent}

You can use standard automation solutions to help install the nginx-agent on multiple instances. These options assume you are already familiar with the automation solutions mentioned and can minimally configure them on your own.

This section will be expanded as solutions are added.

### Bash scripting {#automate-agent-bash}

You can simply use a bash script to accomplish multiple installs of the nginx-agent.

Follow the steps above for downloading the agent package, but for step 3, you can loop through instances using a bash script. See below for some examples to get started.

1. Create a list of hostnames to use and ensure ssh keys are installed.

```bash
$ serverlist=server_list.txt # use a file for a list of the systems
$ cat $serverlist
10.1.1.5
nginx5
nginx7.example.com
```

Use a bash script to copy the ssh keys to the other servers. If you have a different username, then insert it before the "$ip" (for example, "centos@$ip").

```bash
#!/bin/bash
for ip in `cat $serverlist`; do
  ssh-copy-id -i ~/.ssh/id_rsa.pub $ip
done
```

2. Download the rpm or deb package locally

{{<tabs name="get_nginx-agent2">}}
{{%tab name="CentOS, RHEL using yum repo"%}}

Use the yum-downloadonly plugin with yum.

If you are on a RHEL5 or RHEL6 distribution [install the downloadonly plugin](https://access.redhat.com/solutions/10154).

```bash
# RHEL5
$ sudo yum install -y yum-downloadonly
# RHEL6
$ sudo yum install -y yum-plugin-downloadonly
```

Download the rpm using yum to the local directory. This assumes you have the nginx-manager repository already set.

```bash
sudo yum install --downloadonly --downloaddir=. nginx-agent
agentpackage=$(ls $PWD/nginx-agent*.rpm | tail -n 1)
echo $agentpackage
```

{{%/tab%}}
{{%tab name="CentOS8, RHEL8, Fedora using dnf repo"%}}

Download the rpm using dnf to the local directory. This assumes you have the nginx-manager repository already set.

```bash
sudo dnf download nginx-agent
agentpackage=$(ls $PWD/nginx-agent*.rpm | tail -n 1)
echo $agentpackage
```

{{%/tab%}}
{{%tab name="Debian and Ubuntu using apt-get repo"%}}

Download the deb using apt-get to the local directory. This assumes you have the nginx-manager repository already set.

```bash
sudo apt download nginx-agent
#sudo apt-get download nginx-agent # use older apt-get if necessary
agentpackage=$(ls $PWD/nginx-agent*.deb | tail -n 1)
echo $agentpackage
```

{{%/tab%}}
{{%tab name="Drop package on server"%}}

Download the agent zip file from the myf5 portal and unzip the archive. The files should be in the pkg_deb_build or pkg_rpm_build directory.

For rpm

```bash
agentrpm=$(ls $PWD/pkg_rpm_build/nginx-agent*.rpm | tail -n 1)
echo $agentrpm
agentpackage=$agentrpm
agentdeb=$(ls $PWD/pkg_deb_build/nginx-agent*.deb | tail -n 1)
echo $agentdeb
#agentpackage=$agentdeb
```

{{%/tab%}}
{{</tabs>}}

3. Create an `nginx-agent.conf` file for use with the script

```bash
vim nginx-agent.conf
```

Change the servername and port below and also the stub_status or plus_api sections (you can leave both in if you have a mix of plus and open source)

```yaml {hl_lines=[6,"22-23"]}
#
# /etc/nginx-agent/nginx-agent.conf
#

# Configuration file for NGINX Agent
server: nginx-manager.example.com:10443
log:
  level: info
  path: /var/log/nginx-agent/
# (optional) tags for this specific instance / machine for inventory purposes
metadata:
  location: unspecified
# instance tags
tags:
- web
- staging
- etc
# list of allowed config directories (comma-separated)
config_dirs: /etc/nginx,/usr/local/etc/nginx
nginx:
  bin_path: /usr/sbin/nginx
  stub_status: "http://127.0.0.1:80/nginx_status"
  plus_api: "http://127.0.0.1:8080/api"
  metrics_poll_interval: 1000ms
```

4. Use a bash script and the hostname file to handle your instance installs

```bash
#!/bin/bash

serverlist=./server_list.txt
agentuser=$USER #replace with the username you are using for ssh
package=rpm #replace with deb for debian/ubuntu
#agentpackage=$(ls $PWD/nginx-agent*.rpm | tail -n 1) # for rpm package if not defined
#agentpackage=$(ls $PWD/nginx-agent*.deb | tail -n 1) # for deb package if not defined
agentconf=./nginx-agent.conf

if package=rpm; then
  packagerinstall="yum install -y"
elif package=deb; then
  packagerinstall="apt install"
fi

for agenthostname in `cat $serverlist`; do
  scp $agentpackage $agentuser@$agenthostname:./
  ssh $agentuser@$agenthostname sudo "$packagerinstall ./nginx-agent*.$package"
  scp $agentconf $agentuser@$agenthostname:./
  ssh $agentuser@$agenthostname sudo systemctl enable nginx-agent --now
  echo "Installed nginx-agent on $agenthostname..."
done
```

## What's Next

Check the web interface or API on the Instance Manager server; you should now see your instance on the inventory list. There is no additional action needed to have the instance information come up. If you wish to remove the instance, you will need to ensure the service is stopped and won't run, and then you can remove the instance in the inventory.
