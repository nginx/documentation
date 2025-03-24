---
description: Learn about the F5 NGINX App Protect DoS Troubleshooting Guide.
docs: DOCS-675
title: NGINX App Protect DoS Troubleshooting Guide
toc: true
weight: 200
type:
- how-to
---

## Overview

This Troubleshooting Guide is intended to provide guidance to customers in the detection and correction of programming issues in F5 NGINX App Protect DoS. It may also be useful to IT.

## Resolving Known Problems

### Configuration

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

|Problem|Solution|
|-------|--------|
| NGINX is not running (ps -aux) <br><br> Reloading NGINX fails| Check the error log at `/var/log/nginx/error.log`. <br> Fix the problem and re-run NGINX.|
| No original source IP in logs|1. XFF is not configured (or not configured correctly) <br>2. External Load Balancer doesn't forward XFF |
| NGINX App Protect DoS functionality is not as expected| NGINX App Protect DoS has several logs which can be used for troubleshooting. <br> Usually, it is best to look for any warning or error messages within the logs. <br> Refer to [Logs Overview]({{< relref "/nap-dos/monitoring/types-of-logs.md">}})|
| `Too many open files` error message | Increase number of file descriptors. <br> For example: `worker_rlimit_nofile 65535;` in the main context of `nginx.conf` file. <br> Refer to [worker_rlimit_nofile directive](https://www.nginx.com/blog/using-nginx-plus-with-selinux/) |
| `setrlimit ... failed (Permission denied)` error message | Increase the limit using the following command as the root user:<br> `setsebool -P httpd_setrlimit 1;` <br> Refer to [Issue 4: Too many files are open Error](https://www.nginx.com/blog/using-nginx-plus-with-selinux/#Issue-4:-%3Ccode%3EToo-many-files-are-open%3C/code%3E-Error) |
| More protected objects than expected | The `app_protect_dos_enable` directive is inherited by all server and location blocks beneath it, each block will be a protected object. <br> Consider moving this directive from outer to inner block. <br> Refer to: [NGINX App Protect DoS - Directives and Policy]({{< relref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md" >}}) |
| `No DOS protection for ngx_worker at idx X` warning message | There are more nginx processes than allowed. <br> Either decrease the number of nginx processes (ngx_processes directive in `nginx.conf` file) or increase the number of supported workers for NGINX App Protect DoS using the flag `--max-workers NUM` for `/usr/bin/adminstall`. |
| `unknown directive 'app_protect_dos_xxx'` error message | App Protect DOS module is not loaded. Add this line to the main (global) context of nginx.conf: <br>  `load_module "/etc/nginx/modules/ngx_http_app_protect_dos_module.so";` |
| NGINX struggles handling a high rate of incoming connections | Linux machine should be tuned for optimal performance. <br> Refer to [Tuning NGINX for Performance](https://www.nginx.com/blog/tuning-nginx/) |
| Error in `adminstall` process, such as `Failed to allocate` | Insufficient memory to allocate all the required resources. <br> Increase the `--memory` size or decrease the number of nginx workers (`--max_workers`) if not all of them are going to be in use. <br> Use the `--help` flag for more info. |

{{</bootstrap-table>}}

### ELK issues

ELK issues are addressed directly in GitHub by posting the issue to Kibana dashboards for [NGINX App Protect DoS GitHub repo](https://github.com/f5devcentral/nap-dos-elk-dashboards).

### SELinux

Configure SELinux to allow NGINX App Protect DoS.

The configuration steps are found in the [SELinux configuration]({{< relref "/nap-dos/deployment-guide/learn-about-deployment.md#selinux-configuration" >}}) section of the deployment guide.

If SELinux still denies access to something, it means that one of more security exceptions should be enabled.

The following steps describe how to find the problematic exception and enable it.

1. Temporarily add the `httpd_t` domain to the permissive list (this will completely enable all the fields). <br> In this configuration SELinux will not deny anything related to NGINX as NGINX is labeled with the `httpd_t` context. <br>

```shell
semanage permissive -a httpd_t
```

2. Repeat the scenario which made SELinux deny and see that it now works.
3. In permissive mode, security exceptions are logged to the default Linux audit log.
Due to the previous step, the permitted exception will be logged.<br>
The log can be found in `/var/log/audit/audit.log`.
4. The following command will parse the audit log and build a SELinux command that will permit all the exceptions found in the log:

```shell
grep nginx /var/log/audit/audit.log | audit2allow -m nginx
```

5. Compare the generated output to the nginx.te file mentioned in the deployment guide.
Add all the missing commands to the nginx.te file and repeat the SELinux configuration mentioned in the deployment guide.
6. Delete the `httpd_t` domain from the permissive list:

```shell
semanage permissive -d httpd_t
```

For more information about how to use NGINX Plus with SELinux - check our [blog](https://www.nginx.com/blog/using-nginx-plus-with-selinux/)

### Send Logs to Support

If there are any problems, collect the troubleshooting information in a tarball and send it to your customer support engineer.

1. Get package version:

   a. Get NGINX App Protect DoS version:<br>

   ```shell
   /usr/bin/admd -v > package_versions.txt
   ```

   b. Get packages version:<br>For CentOS/RHEL:<br>

   ```shell
   rpm -qa nginx-plus* app-protect* >> package_versions.txt
   ```

   For Debian/Ubuntu:<br>

   ```shell
   apt list --installed | grep -E 'nginx-plus|app-protect' >> package_versions.txt
   ```

   c. Get OS version:<br>

   ```shell
   cat /etc/os-release > system_version.txt && uname -r >> system_version.txt && cat /proc/version >> system_version.txt
   ```

   d. Get NGINX App Protect DoS shared memory dump:<br>

   ```shell
   admd -c > napd_shmem.txt
   ```

   e. Get Linux shared memory dump:<br>

   ```shell
   ipcs -m > linux_shmem.txt
   ```

2. Create a list of files for tarball:<br>
   a. Create a file using your favorite editor (i.e VI editor)<br>

   ```shell
   vi logs.txt
   ```

   b. Insert the following content into the file created above:<br>

   ```shell
   package_versions.txt
   system_version.txt
   napd_shmem.txt
   linux_shmem.txt
   /var/log/adm/*
   /var/run/adm/*
   /var/log/nginx/*
   ```

   c. Add the path of your NGINX configuration files including all references, for example:<br>

   ```shell
   /etc/nginx/nginx.conf
   /etc/nginx/conf.d/*
   ```

   d. Add all policies and log file configuration, for example:<br>

   ```shell
   /etc/app_protect_dos/*
   ```

3. Create the tarball:

   ```shell
   tar cvfz logs.tgz `cat logs.txt`
   ```

4. Send `logs.tgz` to your customer support.
