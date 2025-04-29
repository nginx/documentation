---
title: "Configuration overview"
toc: true
weight: 300
docs: DOCS-1229
---

This page describes how to configure F5 NGINX Agent using configuration files, CLI (Command line interface) flags, and environment variables.

{{<note>}}

- NGINX Agent interprets configuration values set by configuration files, CLI flags, and environment variables in the following priorities:

  1. CLI flags overwrite configuration files and environment variable values.
  2. Environment variables overwrite configuration file values.
  3. Config files are the lowest priority and config settings are superseded if either of the other options is used.

- You must open any required firewall ports or add SELinux/AppArmor rules for the ports and IPs you want to use.

{{</note>}}

## Configuration via Configuration Files 

The NGINX Agent configuration file is created using a YAML structure and can be found in `/etc/nginx-agent/nginx-agent.conf`

1. Edit the configuration file `sudo vim /etc/nginx-agent/nginx-agent.conf`
2. Add the log property 
```bash
log:
  level: debug 
```
3. Save and exit 
4. `sudo systemctl restart nginx-agent`

## Configuration via CLI Parameters

From a command line terminal: 
```bash
sudo nginx-agent \
      --log-level=debug
```

## Configuration via Environment Variables
Environment variables are another way to set configuration values, especially in containerized deployments or CI/CD pipelines. 

```bash
sudo docker run \
  --env=NGINX_AGENT_LOG_LEVEL=debug \
  -d agent
```
