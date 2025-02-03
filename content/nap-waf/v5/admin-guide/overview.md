---
title: NGINX App Protect WAF Administration Guide
weight: 100
toc: true
type: how-to
product: NAP-WAF
docs: DOCS-1362
---

## Introduction

F5 NGINX App Protect WAF v5, designed for NGINX Open Source and NGINX Plus environments, offers advanced Web Application Firewall (WAF) capabilities, supporting all features of [NGINX App Protect WAF v4]({{< relref "/nap-waf/v4/admin-guide/install.md" >}}). This solution, available at an additional cost, consists of a dynamic NGINX module and containerized WAF services, providing robust security and scalability.

### Key Advantages

- Ability to work with NGINX Open Source in addition to NGINX Plus.
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

NGINX App Protect WAF v5 supports the following operating systems:

| Distribution | Version             |
| ------------ | ------------------- |
| Alpine       | 3.17, 3.19          |
| Debian       | 11, 12              |
| Ubuntu       | 20.04, 22.04, 24.04 |
| Amazon Linux | 2023                |
| RHEL         | 8, 9                |
| Rocky Linux  | 8                   |
| Oracle Linux | 8.1                 |

## Deployment Types

NGINX App Protect WAF v5 supports a range of deployment scenarios to meet various operational needs:

1. [Docker Compose Deployment]({{< relref "/nap-waf/v5/admin-guide/deploy-on-docker.md" >}})
   - Deploys both NGINX and WAF components within containers.
   - Suitable for environments across development, testing, and production stages.

2. [Kubernetes Deployment]({{< relref "/nap-waf/v5/admin-guide/deploy-on-kubernetes.md" >}})
   - Integrates both NGINX and WAF components in a single pod.
   - Ideal for scalable, cloud-native environments.

3. [NGINX on Host/VM with Containerized WAF]({{< relref "/nap-waf/v5/admin-guide/install.md" >}})
   - NGINX is operated directly on the host system or a virtual machine, with WAF components deployed in containers.
   - Perfect for situations where NGINX is already in use on host systems, allowing for the addition of WAF components without disrupting the existing NGINX setup.

## NGINX App Protect WAF Compiler

NGINX App Protect WAF v5 enhances deployment speed through the pre-compilation of security policies and logging profiles into bundle files.

Use the [NGINX App Protect WAF Compiler]({{< ref "/nap-waf/v5/admin-guide/compiler.md" >}}) to transform security policies and logging profiles from JSON format into a consumable bundle files.

For signature updates, read the [Update App Protect Signatures]({{< ref "/nap-waf/v5/admin-guide/compiler.md#update-app-protect-signatures" >}}) section of the compiler documentation.

---

## Transitioning from NGINX App Protect WAF v4 to v5

Upgrading directly from v4 to v5 is not supported due to architectural changes in NGINX App Protect WAF v5.

{{< note >}}
We recommend that you deploy the NGINX App Protect WAF v5 in a staging environment.  Only after you compile policies with WAF compiler and test the enforcement should you transfer the traffic from the v4 to v5. This keeps the v4 deployment for backup.
{{< /note >}}

1. Back up your NGINX App Protect WAF configuration files, such as NGINX configurations, JSON policies, logging profiles, user-defined signatures, and global settings.

1. Install NGINX App Protect WAF 5 (using either nginx OSS or nginx-plus based on the need of customer's application).
   - [Installing NGINX App Protect WAF]({{<relref "/nap-waf/v5/admin-guide/install.md">}})
   - [Deploying NGINX App Protect WAF on Docker]({{<relref "/nap-waf/v5/admin-guide/deploy-on-docker.md">}})
   - [Deploying NGINX App Protect WAF on Kubernetes]({{<relref "/nap-waf/v5/admin-guide/deploy-on-kubernetes.md">}})

1. Compile your `.json` policies and logging profiles to `.tgz` bundles using [compiler-image]({{<relref "/nap-waf/v5/admin-guide/compiler.md">}}) because NGINX App Protect WAF v5 supports policies and logging profiles in a compiled bundle format only.

   {{< note >}}
   If you were previously using a default [logging profile]({{<relref "/nap-waf/v5/admin-guide/deploy-on-docker.md#using-policy-and-logging-profile-bundles">}}) JSON like `/opt/app_protect/share/defaults/log_all.json`, you can replace it with the default constant such as `log_all`, and then you will not need to explicitly compile the logging profile into a bundle.

   ```nginx
   app_protect_security_log log_all /log_volume/security.log;
   ```

   {{< /note >}}

1. Replace the `.json` references in nginx.conf with the above created `.tgz` [bundles]({{<relref "/nap-waf/v5/admin-guide/install.md#using-policy-and-logging-profile-bundles">}}).

1. Make sure that `.tgz` bundles references are accessible to the `waf-config-mgr` container.

1. Restart the deployment if it has already been initiated. Additionally, restart NGINX if utilizing the VM + containers deployment type.  After the migrations, check that the NGINX process is running in the NGINX error log and there are no issues.


---

## Troubleshooting and FAQs

See common deployment challenges and solutions to ensure a smooth setup process in the [Troubleshooting Guide]({{< relref "/nap-waf/v5/troubleshooting-guide/troubleshooting.md#nginx-app-protect-5" >}}).

Docker images for NGINX App Protect WAF v5 are built using Ubuntu 22.04 (Jammy) binaries.
