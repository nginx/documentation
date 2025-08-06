---
description: ''
nd-docs: DOCS-817
title: Where to Go for Support
toc: true
weight: 300
type:
- concept
---

## Support Policy

F5 NGINX Management Suite adheres to the support policy detailed in the following knowledge base article: [K000140156](https://my.f5.com/manage/s/article/K000140156).

{{< call-out "important" >}}
Support licenses for Instance Manager **do not include** support for the NGINX instances that are being managed.

Community support is available for NGINX Open Source instances at the [NGINX mailing list](http://mailman.nginx.org/mailman/listinfo).
If you need support for NGINX Plus or any of the [prebuilt NGINX Open Source packages](https://nginx.org/en/linux_packages.html), you will need to [purchase an NGINX license](https://www.nginx.com/purchase-nginx/).

{{< /call-out >}}

---

## Contact NGINX Support

For questions and/or assistance with installing, troubleshooting, or using the NGINX Management Suite modules, contact Support from the [MyF5 Customer Portal](https://account.f5.com/myf5).

---

## Support Script

The Support team may ask you to run one or both of the following scripts to help with troubleshooting. The output of these scripts should be attached to any cases that you open.

- `/usr/share/nginx-manager` — for troubleshooting issues with the NGINX Management Suite host
- `/usr/share/nginx-agent` — for troubleshooting issues with a data plane instance running the NGINX Agent

To run the support script on the NGINX Management Suite host:

1. Open an SSH connection to the NGINX Management Suite host and log in.
2. Run the following command:

    ```bash
    /usr/share/nginx-manager/support.sh
    ```

To run the script on a data plane instance that has the NGINX Agent installed:

1. Open an SSH connection to the data plane instance and log in.
2. Run the following command:

    ```bash
    /usr/share/nginx-agent/support.sh
    ```

The scripts gather the following information:

- `/etc/os-release` (this is information on the OS you have)
- Checks if you are running NGINX, NGINX Management Suite, and the NGINX Agent
- Runs the following for NGINX and and saves the output:
  - `nginx -T` (this is the entire running configuration)
  - `nginx -V` (this is the version and runtime information for NGINX)
  - `/var/log/nginx/*` (these are all the log files)

- Copies the following log files for NGINX Management Suite:
  - `/var/log/nginx-manager/*`

- Queries the following API calls for NGINX Management Suite:

  - GET /api/v0/instances
  - GET /api/v0/scan
  - GET /api/v0/about/system
  - GET /api/v0/about/license

- Copies the following log files for the NGINX Agent:
  - `/var/log/nginx-agent/*`

### Output File

The script creates a file in the `/tmp` directory with a filename similar to `/tmp/nginx-manager-log.tar.gz`.

Review the contents of the output file and **remove any confidential or private information** before sending it to F5.

For example if you keep a private key and certificate in your `/etc/nginx-manager` directory (which you shouldn't do!), you can remove it by running a command similar to the following:

```bash
gzip -d /tmp/nginx-manager-log.tar.gz
tar -f /tmp/nginx-manager-log.tar.gz --delete /etc/nginx-manager/example.key --delete /etc/nginx-manager/example.crt
gzip -9 /tmp/nginx-manager-log.tar.gz
```

Information and files sent to F5 for support purposes are protected in accordance with the [F5 Support and Maintenance Privacy Statement](https://www.f5.com/company/policies/support-and-maintenance-privacy-statement).

---
## AskF5 Knowledge Base

You can find articles about commonly reported issues and corner cases on [AskF5](https://support.f5.com/csp/knowledge-center/software/NGINX?module=NGINX%20Instance%20Manager).

---

## NGINX Training and Professional Services

Get strategic guidance and hands‑on assistance from [NGINX Professional Services](https://www.nginx.com/services/#package_detail_section).
