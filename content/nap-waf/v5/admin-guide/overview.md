---
title: F5 WAF for NGINX Administration Guide
weight: 100
toc: true
type: how-to
product: NAP-WAF
nd-docs: DOCS-1362
---

## Introduction

F5 F5 WAF for NGINX v5, designed for NGINX Open Source and NGINX Plus environments, offers advanced Web Application Firewall (WAF) capabilities, supporting all features of [F5 WAF for NGINX v4]({{< ref "/nap-waf/v4/admin-guide/install.md" >}}). This solution, available at an additional cost, consists of a dynamic NGINX module and containerized WAF services, providing robust security and scalability.

### Key Advantages

- Ability to work with NGINX Open Source as well as NGINX Plus.
- Scalable architecture, ideal for both small and large-scale deployments.
- Seamless integration with existing DevOps and SecOps workflows.

### Use Case Scenarios

- E-Commerce Platform: Securing transactional data and user information in a high-traffic environment.
- API Protection: Offering robust security for API gateways against common vulnerabilities.
- DevOps Environments: Integrating WAF into continuous integration and delivery pipelines to ensure security is a part of the development lifecycle.

### Technical Requirements

- Basic understanding of NGINX and containerization concepts.
- Software prerequisites include Docker or Kubernetes, depending on the chosen deployment method.

## Technical Specifications

F5 WAF for NGINX v5 supports the following operating systems:

| Distribution | Version             |
| ------------ | ------------------- |
| Alpine       | 3.19                |
| Debian       | 11, 12              |
| Ubuntu       | 22.04, 24.04        |
| Amazon Linux | 2023                |
| RHEL         | 8, 9                |
| Rocky Linux  | 8, 9                |
| Oracle Linux | 8.1                 |

## Deployment Types

F5 WAF for NGINX v5 supports a range of use cases to meet various operational needs:

1. [Docker Compose Deployment]({{< ref "/nap-waf/v5/admin-guide/deploy-on-docker.md" >}})
   - Deploys both NGINX and WAF components within containers.
   - Suitable for environments across development, testing, and production stages.

2. [Kubernetes Deployment]({{< ref "/nap-waf/v5/admin-guide/deploy-with-helm.md" >}})
   - Integrates both NGINX and WAF components in a single pod.
   - Ideal for scalable, cloud-native environments.

3. [NGINX on Host/VM with Containerized WAF]({{< ref "/nap-waf/v5/admin-guide/install.md" >}})
   - NGINX operates on the host system or a virtual machine. WAF components are deployed in containers.
   - Perfect for situations where NGINX is already in use on host systems. Addition of WAF components will not disrupt the existing NGINX setup.

## F5 WAF for NGINX Compiler

F5 WAF for NGINX v5 enhances deployment speed through the pre-compilation of security policies and logging profiles into bundle files.

Use the [F5 WAF for NGINX Compiler]({{< ref "/nap-waf/v5/admin-guide/compiler.md" >}}) to transform security policies and logging profiles from JSON format into a consumable bundle files.

For signature updates, read the [Update App Protect Signatures]({{< ref "/nap-waf/v5/admin-guide/compiler.md#update-app-protect-signatures" >}}) section of the compiler documentation.

---

## Transitioning from F5 WAF for NGINX v4 to v5

Upgrading from v4 to v5 is not supported due to architectural changes in F5 WAF for NGINX v5.

{{< call-out "note" >}}
We recommend that you deploy the F5 WAF for NGINX v5 in a staging environment.  Compile policies with WAF compiler and test the enforcement before you transfer the traffic from the v4 to v5. This keeps the v4 deployment for backup.
{{< /call-out >}}

1. Back up your F5 WAF for NGINX configuration files. These include NGINX configurations, JSON policies, logging profiles, user-defined signatures, and global settings.

2. Install F5 WAF for NGINX 5. Use either nginx OSS or nginx-plus based on the need of customer's application.
   - [Installing F5 WAF for NGINX]({{<ref "/nap-waf/v5/admin-guide/install.md">}})
   - [Deploying F5 WAF for NGINX on Docker]({{<ref "/nap-waf/v5/admin-guide/deploy-on-docker.md">}})
   - [Deploying F5 WAF for NGINX on Kubernetes]({{<ref "/nap-waf/v5/admin-guide/deploy-with-helm.md">}})

3. Compile your `.json` policies and logging profiles to `.tgz` bundles using [compiler-image]({{<ref "/nap-waf/v5/admin-guide/compiler.md">}}). F5 WAF for NGINX v5 supports policies and logging profiles in a compiled bundle format only.

   {{< call-out "note" >}}
   If you were previously using a default [logging profile]({{<ref "/nap-waf/v5/admin-guide/deploy-on-docker.md#using-policy-and-logging-profile-bundles">}}) JSON like `/opt/app_protect/share/defaults/log_all.json`, you can replace it with the default constant such as `log_all`, and then you will not need to compile the logging profile into a bundle.

   ```nginx
   app_protect_security_log log_all /log_volume/security.log;
   ```

   {{< /call-out >}}

4. Replace the `.json` references in nginx.conf with the above created `.tgz` [bundles]({{<ref "/nap-waf/v5/admin-guide/install.md#using-policy-and-logging-profile-bundles">}}).

5. Make sure that `.tgz` bundles references are accessible to the `waf-config-mgr` container.

6. Restart the deployment if it has already initiated. Additionally, restart NGINX if utilizing the VM + containers deployment type.  After the migrations, check that the NGINX process is running in the NGINX error log and there are no issues.


---

## Troubleshooting and FAQs

Review the [Troubleshooting Guide]({{< ref "/nap-waf/v5/troubleshooting-guide/troubleshooting.md#nginx-app-protect-5" >}}) for common deployment challenges and solutions to ensure a smooth setup process.

Docker images for F5 WAF for NGINX v5 are built using Ubuntu 22.04 (Jammy) binaries.
