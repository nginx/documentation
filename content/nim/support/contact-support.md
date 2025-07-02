---
nd-docs: DOCS-817
title: Where to go for support
toc: true
weight: 300
type:
- concept
---

## Support policy

F5 NGINX Instance Manager follows the support policy detailed in the knowledge base article: [K000140156](https://my.f5.com/manage/s/article/K000140156).

{{<important>}}
Support licenses for NGINX Instance Manager **do not include** support for the NGINX instances being managed.

Community support is available for NGINX Open Source instances on the [NGINX mailing list](http://mailman.nginx.org/mailman/listinfo). If you need support for NGINX Plus or [prebuilt NGINX Open Source packages](https://nginx.org/en/linux_packages.html), you must [purchase an NGINX license](https://www.nginx.com/purchase-nginx/).
{{</important>}}

---

## Contact NGINX support

For help with installing, troubleshooting, or using the NGINX Instance Manager, contact support through the [MyF5 Customer Portal](https://account.f5.com/myf5).

---

## Support script

The Support team might ask you to run one or both of the following scripts to troubleshoot issues. Attach the script outputs to your support case.

- `/usr/share/nginx-manager` – for troubleshooting issues with the NGINX Instance Manager host.
- `/usr/share/nginx-agent` – for troubleshooting issues with a data plane instance running the NGINX Agent.

### Run the support script on the NGINX Instance Manager host

1. Open an SSH connection to the NGINX Instance Manager host and log in.
2. Run the following command:

    ```bash
    /usr/share/nginx-manager/support.sh
    ```

### Run the script on a data plane instance

1. Open an SSH connection to the data plane instance and log in.
2. Run the following command:

    ```bash
    /usr/share/nginx-agent/support.sh
    ```

### Collected information

The scripts collect the following information:

- System details (`/etc/os-release`).
- Checks for installed NGINX, NGINX Instance Manager, and NGINX Agent instances.
- NGINX data:
  - `nginx -T` (current configuration).
  - `nginx -V` (version and runtime details).
  - `/var/log/nginx/*` (log files).
- NGINX Instance Manager log files:
  - `/var/log/nginx-manager/*`
- API queries from NGINX Instance Manager:
  - `GET /api/v0/instances`
  - `GET /api/v0/scan`
  - `GET /api/v0/about/system`
  - `GET /api/v0/about/license`
- NGINX Agent log files:
  - `/var/log/nginx-agent/*`

### Output file

The script creates a file in the `/tmp` directory, such as `/tmp/nginx-manager-log.tar.gz`. Review the file and **remove confidential information** before sharing it with F5.

For example, if your `/etc/nginx-manager` directory contains private keys or certificates, remove them using:

```bash
gzip -d /tmp/nginx-manager-log.tar.gz

tar -f /tmp/nginx-manager-log.tar.gz \
    --delete /etc/nginx-manager/example.key \
    --delete /etc/nginx-manager/example.crt

gzip -9 /tmp/nginx-manager-log.tar.gz
```

{{<note>}}Files shared with F5 are protected under the [F5 Support and Maintenance Privacy Statement](https://www.f5.com/company/policies/support-and-maintenance-privacy-statement).{{</note>}}

---

## Additional resources

### AskF5 knowledge base

Find solutions to common issues and corner cases on [AskF5](https://support.f5.com/csp/knowledge-center/software/NGINX?module=NGINX%20Instance%20Manager).

### NGINX training and professional services

Get expert guidance and hands-on support from [NGINX Professional Services](https://www.nginx.com/services/#package_detail_section).
