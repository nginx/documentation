---
description: Learn about the F5 NGINX App Protect WAF Troubleshooting Guide.
title: NGINX App Protect WAF Troubleshooting Guide
toc: true
weight: 400
nd-docs: DOCS-1645
type:
- concept
---

## Overview

This Troubleshooting Guide is intended to provide guidance to customers in the detection and correction of programming issues in F5 NGINX App Protect WAF. It may also be useful to IT in resolving any installation or configuration problems. <br>

Refer to the below table for any NGINX App Protect WAF installation or configuration known problems.

## Resolving Known Problems

### Configuration

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Problem|Solution|
|-------|--------|
| NGINX is not running (ps -aux)<br><br> Reloading NGINX fails| Check the error log at `/var/log/nginx/error.log`<br>Fix the problem and re-run NGINX. |
| NGINX App Protect WAF functionality is not as expected| NGINX App Protect WAF has several logs which can be used for troubleshooting. <br> Usually, it is best to look for any warning or error messages within the logs. <br> Refer to [Logs Overview]({{< ref "/nap-waf/v5/logging-overview/logs-overview.md">}}) |
| `Too many open files` error message | Increase number of file descriptors. <br> For example: `worker_rlimit_nofile 65535;` in the main context of `nginx.conf` file. <br> Refer to [worker_rlimit_nofile directive](https://www.nginx.com/blog/using-nginx-plus-with-selinux/#Issue-4:-%3Ccode%3EToo-many-files-are-open%3C/code%3E-Error)|
| `setrlimit ... failed (Permission denied)` error message | Increase the limit using the following command as the root user:<br> `setsebool -P httpd_setrlimit 1;` <br> Refer to [Issue 4: Too many files are open Error](https://www.nginx.com/blog/using-nginx-plus-with-selinux/#Issue-4:-%3Ccode%3EToo-many-files-are-open%3C/code%3E-Error) |
| unknown directive `app_protect_xxx` error message  | App Protect module is not loaded. Add this line to the main (global) context of nginx.conf:<br>`load_module "/etc/nginx/modules/ngx_http_app_protect_module.so";`  |
| Compiler error message:<br>*Expected declarative policy* | Make sure your policy conforms to proper WAF policy standards. The proper structure is:<pre><code>`{`<br>&nbsp;&nbsp;&nbsp;&nbsp;`"policy": {`<br>&nbsp;&nbsp;&nbsp;&nbsp;`...`<br>&nbsp;&nbsp;&nbsp;&nbsp;`}`<br>`}`</code></pre> |
| Error messages:<br>*Policy Bundles version is older than the local version*<br>and<br>*Policy Bundles version is newer than the local version* | Recompile all of your bundles from scratch. Bundles must always be recompiled whenever you install security updates. |
| Error messages:<br>*Found mixed content of compiled and raw configuration*<br>and<br> *Compiler is required, but not installed: Missing /opt/app_protect/bin/config_set_compiler* | Only pre-compiled bundles can be used in the nginx.conf -- don't use JSON policies. Make sure the JSON policies are compiled to bundles first. |
| Error messages:<br>*Policy Bundles have differing global states*<br>and<br>*Policy Bundles have differing cookie seeds* | Recompile all of your bundles from scratch with your custom compiler. Bundles must always be compiled using the same compiler image/version. Default and custom policy bundles can't be mixed. |
| Error message:<br>*Duplicate policy name found* | Don't compile multiple policies with the same name, and don't compile one policy to multiple bundles. Each policy can only be compiled once but the bundle can be reused many times. |
| Error message:<br>*Duplicate logging profile name found* | Don't compile the same logging profile to multiple bundles. Each logging profile can only be compiled once but the bundle can be reused many times. |
| Error message:<br>*Timeout waiting for enforcer* | Likely an internal issue. Please contact support and provide the policies used in the bundles. |
{{</bootstrap-table>}}

## SELinux

In some operating systems, security mechanisms like **SELinux** or **AppArmor** are enabled by default, potentially blocking necessary file access for the `nginx` process and `waf-config-mgr` and `waf-enforcer` containers. To ensure NGINX App Protect WAF operates smoothly without compromising security, consider setting up a custom SELinux policy or AppArmor profile. For short-term troubleshooting, you may use `permissive` (SELinux) or `complain` (AppArmor) mode to avoid these restrictions, but keep in mind that this lowers security and isn't advised for prolonged use.

For more information about how to use NGINX Plus with SELinux - check our [blog](https://www.nginx.com/blog/using-nginx-plus-with-selinux/).

## Opening a Support Ticket

In order to open a support ticket, collect the troubleshooting information in one directory, create a tarball and send it to your customer support engineer:

1. For Docker compose deployment, run the following command to collect logs:

    ```shell
    sudo docker compose logs > docker_compose_logs.txt
    ```

    Alternatively, if a centralized logging system like the ELK stack is utilized, retrieve the logs in CSV format, `docker_compose_logs.csv`.

2. For Kubernetes deployment:

    Replace `default` in code snippets below with the name of your namespace.

    Locate the deployment and list all pods:

    ```shell
    kubectl get pods -n default
    ```

    Use the following script to collect logs from all pods:

    ```shell
    #!/bin/bash

    set -x

    # Define the namespace variable
    NAMESPACE="default"

    # Define a directory to store log files
    log_dir="k8s_logs_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$log_dir"

    # Loop through all pods and containers, saving logs to the defined directory
    for pod in $(kubectl get pods -n $NAMESPACE -o=name | sed 's|pod/||g'); do
        for container in $(kubectl get pod/$pod -n $NAMESPACE -o=jsonpath='{.spec.containers[*].name}'); do
            kubectl logs $pod -c $container -n $NAMESPACE > "${log_dir}/${pod}_${container}_logs.txt"
        done
    done

    echo "Logs collected and archived in ${log_dir}.tar.gz"
    ```

    This script iterates over each pod in your namespace, identifies each container within those pods, and then saves the logs of each container into separate files. These files are named after the respective pod and container and are stored in a directory named `k8s_logs_<timestamp>`.

3. If NGINX is directly installed on the host machine:

    - For CentOS / RHEL / Rocky Linux / Amazon Linux / Oracle Linux:

    ```shell
    rpm -qa nginx* app-protect* > package_versions.txt
    ```

    - For Debian / Ubuntu:

    ```shell
    apt list --installed | grep -E 'nginx|app-protect' > package_versions.txt
    ```

    - For Alpine Linux:

    ```shell
    apk info -vv | grep -E 'nginx|app-protect' > package_versions.txt
    ```

    - Get OS information via:

    ```shell
    cat /etc/os-release > system_version.txt && uname -r >> system_version.txt && cat /proc/version >> system_version.txt
    ```

    - Add nginx logs from `/var/log/nginx/`

4. Add all policies and log file configuration (JSON and bundle files).

5. Add all nginx configuration including all references such as `/etc/nginx/nginx.conf`

6. At the same direcotory, run the following command to create the tarball file:

     ```shell
     tar cvfz logs.tgz .
     ```

7. Attach `logs.tgz` to support ticket.
