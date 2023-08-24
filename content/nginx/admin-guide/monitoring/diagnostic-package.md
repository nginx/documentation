---
description: Automate collection of data required to troubleshoot issues in a NGINX or NGINX Plus deployment.

docs: 
doctypes:
- task
title: NGINX Diagnostic Package
toc: true
weight: 300
---

## Introduction

The NGINX diagnostic package automates the collection of the data required to troubleshoot issues in your NGINX environment. The package contains a [light weight script](https://nginx.org/download/nginx-supportpkg.sh) to collect the diagnostic data required to troubleshoot your NGINX open source and/or NGINX Plus instance.  

The diagnostic package collects following information from the NGINX installation:

- host commands (`ps,lsof,vmstat...etc`)
- NGINX config files
- NGINX log files
- NGINX service information
- NGINX process information
- NGINX versions, dynamically linked libraries, and NGINX Plus api endpoints (if its a NGINX Plus instance)
- NGINX agent logs and configs if NGINX Agent is present
- NGINX app protect logs and configs if NGINX App Protect is present

It will not collect:

- NJS scripts
- LUA scripts
- inspect for coredumps

How to run: 

The script requires superuser privileges. It needs to be run as root or with `sudo` and should have execute permissions.
```shell
$ chmod +x nginx-supportpkg.sh
$ sudo ./nginx-supportpkg.sh
```
The output is a compressed `.tar.gz` file containing the diagnostic data and is created in the current working directory. The compressed archive contains textual output of all the commands run by the script to make it easier to review the collected data. 
The archive has <b>```support-pkg-<timestamp>.tar.gz```</b> naming format.


Use the tar command to extract the contents of the archive.
```shell
tar -xvf support-pkg-1682457903.tar.gz

The script provides a number of flags to customize what data needs to be collected based on your NGINX deployment. 

Available Options:
```shell
Usage: ./nginx-supportpkg.sh [-option value...]
-h | --help Print this help message+
-d | --debug Sets bash debug flag
-o | --output_dir Directory where support-pkg archive will be generated
-n | --nginx_log_path NGINX log directory path
-xc | --exclude_nginx_configs Exclude all nginx configs from the support package
-xl | --exclude_nginx_logs Exclude all nginx logs from the support package
-ac | --exclude_agent_configs Exclude all agent configs from the support package
-al | --exclude_agent_logs Exclude all agent logs from the support package
-nc | --exclude_nap_configs Exclude all app protect configs from the support package
-nl | --exclude_nap_logs Exclude all app protect logs from the support package
-ea | --exclude_api_stats Exclude nginx plus api stats from the support package
-pi | --profile_interval Profiling interval in seconds. Default: '15'
```

Supported Operating Systems:

The script should run on most operating systems supported by NGINX [https://docs.nginx.com/nginx/technical-specs/]. It has been currently tested on the following operating systems.

- CentOS 7
- Ubuntu 20.04
- Debian 11
- RHEL 9.1
- Rocky Linux 9.1
- SUSE Linux Enterprise Server 15
- AlmaLinux 9.1
- Amazon Linux 2



Note: The goal of diagnostic package is to ease the process of collecting and sharing the data required to troubleshoot NGINX issues. It does not collect any sensitive information about your environment. However, it is advised to review the script prior to running it. It is also advised to review the archive output to make sure it conforms with your organizations data-sharing guidelines prior to sharing with us.   


