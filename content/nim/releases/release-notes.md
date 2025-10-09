---
title: Release notes
weight: 100
toc: true
type: reference
product: NIM
nd-docs: DOCS-938
---

The release notes for F5 NGINX Instance Manager highlight the latest features, improvements, and bug fixes in each release. This document helps you stay up to date with the changes and enhancements introduced to improve stability, performance, and usability. For each version, you’ll find details about new features, known issues, and resolved problems, ensuring you get the most out of your NGINX instance management experience.

<details open>
<summary><i class="fa-solid fa-info-circle"></i> Support for F5 WAF for NGINX</summary>

{{< include "nim/tech-specs/nim-app-protect-support.md" >}}

</details>


---

## 2.20.0

June 16, 2025

### Upgrade Paths {#2-20-0-upgrade-paths}

NGINX Instance Manager 2.20.0 supports upgrades from these previous versions:

- 2.17.0 - 2.19.2

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-20-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Added support to report on multiple NGINX One subscriptions using a single instance of NGINX Instance Manager**<a name="2-20-0-whats-new-Added-support-to-report-on-multiple-NGINX-One-subscriptions-using-a-single-instance-of-NGINX-Instance-Manager"></a>

   Customers can have multiple NGINX One subscriptions or licenses with different attributes (prod, nonprod, etc.). Now a single NGINX Instance Manager can receive usage from these instances and send a bulk usage report to F5.

  We also simplified the licensing process for disconnected use cases. When running NGINX Instance Manager in disconnected mode, all features are enabled for 90 days when a JWT is uploaded. Customers have these 90 days to send the first usage report to activate the NGINX Instance Manager license.

- {{% icon-feature %}} **Introducing lightweight mode**<a name="2-20-0-whats-new-Introducing-lightweight-mode"></a>

   NGINX Instance Manager can now run in lightweight mode without the ClickHouse database dependency. This mode requires fewer resources and is perfect for customers who don’t need metrics-related functionality. It supports basic use cases such as:

  - Fleet management
  - WAF configuration
  - Usage tracking
  - Certificate management
  - Template automation

- {{% icon-feature %}} **Improved web analytics sent to F5**<a name="2-20-0-whats-new-Improved-web-analytics-sent-to-F5"></a>

   NGINX Instance Manager now sends improved web analytics to F5. This helps F5 understand common use cases of NGINX Instance Manager and improve functionality.


### Changes in Default Behavior{#2-20-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Breadcrumbs added for Overview, Manage, and Config templates**<a name="2-20-0-changes-in-behavior-Breadcrumbs-added-for-Overview,-Manage,-and-Config-templates"></a>

  We have added breadcrumb navigation links for the "Overview", "Manage", and "Config" templates in the NGINX Instance Manager user interface.

- {{% icon-feature %}} **Export instance groups to Excel**<a name="2-20-0-changes-in-behavior-Export-instance-groups-to-Excel"></a>

  You can now export instance groups to a Microsoft Excel spreadsheet from the Instance Group section.

- {{% icon-feature %}} **Export all instances functionality added**<a name="2-20-0-changes-in-behavior-Export-all-instances-functionality-added"></a>

  NGINX Instance Manager’s export function only included currently visible instances, not the full list. Customers had to run separate exports and merge data manually.

  An `Export All` button is now available under the Instances section. Clicking it downloads all instance details in a single Excel file.

- {{% icon-feature %}} **Automatic feature enablement in disconnected instances on license upload**<a name="2-20-0-changes-in-behavior-Automatic-feature-enablement-in-disconnected-instances-on-license-upload"></a>


  NGINX Instance Manager now enables all features by default when you upload a license to a disconnected instance. This update ensures customers can begin using the full capabilities of the system without additional configuration.

  Customers have a 90-day window to complete the full license process. If they don’t complete it within this period, the instance is automatically deactivated.



### Resolved Issues{#2-20-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} The certificate stats are not displayed correctly in the Certificates and Keys page as well as the Dashboard page. (45991)


### Known Issues{#2-20-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.19.2

May 06, 2025

### Upgrade Paths {#2-19-2-upgrade-paths}

NGINX Instance Manager 2.19.2 supports upgrades from these previous versions:

- 2.16.0 - 2.19.1

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-19-2-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="2-19-2-whats-new-Stability-and-performance-improvements"></a>

   This release includes stability and performance improvements for a more reliable experience.



### Known Issues{#2-19-2-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.19.1

March 27, 2025

### Upgrade Paths {#2-19-1-upgrade-paths}

NGINX Instance Manager 2.19.1 supports upgrades from these previous versions:

- 2.16.0 - 2.19.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-19-1-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="2-19-1-whats-new-Stability-and-performance-improvements"></a>

   This release includes stability and performance improvements for a more reliable experience.


### Resolved Issues{#2-19-1-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Publishing the NAP policy fails with the error “The attack signatures with the given version was not found” (45845)
- {{% icon-resolved %}} Automatic downloading of NAP compiler versions 5.210.0 and 5.264.0 fails on Ubuntu 24.04 (45846)


### Known Issues{#2-19-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.19.0

February 06, 2025

### Upgrade Paths {#2-19-0-upgrade-paths}

NGINX Instance Manager 2.19.0 supports upgrades from these previous versions:

- 2.16.0 - 2.18.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### Important Note about upgrades to NGINX Instance Manager 2.19 for API Connectivity Manager (ACM) users<a name="2-19-0-pre-Important-Note-about-upgrades-to-NGINX-Instance-Manager-2-19-for-API-Connectivity-Manager-(ACM)-users"></a>

NGINX Instance Manager 2.19 is the first iteration of NGINX Instance Manager as a standalone product without modules such as API Connectivity Manager (which is [EoS](https://my.f5.com/manage/s/article/K000137989)). NGINX Instance Manager now includes Security Monitoring (previously a module) as a feature under App Protect in the web interface. The Instance Manager helm charts and docker compose options include Security Monitoring also.

Instance Manager 2.19 will not be compatible or supported with EoS API Connectivity Manager. API Connectivity Manager users get support of Instance Manager up to 2.18 and upgrades to Instance Manager 2.19 will not succeed if API Connectivity Manager is installed.

### What's New{#2-19-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **NGINX Instance Manager is now a standalone product**<a name="2-19-0-whats-new-NGINX-Instance-Manager-is-now-a-standalone-product"></a>

   Starting with this release, NGINX Instance Manager is a standalone product without any dependencies from other NGINX products (NGINX Management Suite, API Connectivity Manager).

  The Security Monitoring module is now a feature of NGINX Instance Manager found in the "App Protect" section.

  If NGINX API Connectivity Manager is currently running as a module in NGINX Instance Manager or NGINX Management Suite in your environment, you will need to remove the module before upgrading to 2.19.0.

- {{% icon-feature %}} **Forward proxy support using the HTTP CONNECT method**<a name="2-19-0-whats-new-Forward-proxy-support-using-the-HTTP-CONNECT-method"></a>

   NGINX Instance Manager can now be configured to use the CONNECT HTTP method to request that a proxy establish a HTTP(S) tunnel to an outbound server. This covers all use-cases that require outbound access such as App Protect Signature updates, licensing and usage reporting.

  - Documentation: [Configure NGINX Instance Manager to use a forward proxy]({{< ref "nim/system-configuration/configure-forward-proxy.md" >}})

- {{% icon-feature %}} **Support for OpenShift Deployments using Helm**<a name="2-19-0-whats-new-Support-for-OpenShift-Deployments-using-Helm"></a>

   Added an `OpenShift` flag to the Helm charts that creates a security context constraint resource to support NGINX Instance Manager in OpenShift.

  - Documentation: [Deploy NGINX Instance Manager using Helm]({{< ref "nim/deploy/kubernetes/deploy-using-helm.md" >}})

- {{% icon-feature %}} **VM-based active-passive HA Support with keepalived**<a name="2-19-0-whats-new-VM-based-active-passive-HA-Support-with-keepalived"></a>

   This release includes documentation for a basic HA (High availability) setup with two nodes, for bare metal and VM based environments. This feature uses keepalived and a failover script if a primary NGINX Instance Manager node fails.

  - Documentation: [Configure high availability (HA) for NGINX Instance Manager]({{< ref "nim/system-configuration/configure-high-availability.md" >}})

- {{% icon-feature %}} **Added "Export" feature  for templates**<a name="2-19-0-whats-new-Added-"Export"-feature--for-templates"></a>

   We have added a new option to export templates using the NGINX Instance Manager web interface.


### Changes in Default Behavior{#2-19-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Prompt to specify an FQDN for NIM when generating SSL certificates during installation**<a name="2-19-0-changes-in-behavior-Prompt-to-specify-an-FQDN-for-NIM-when-generating-SSL-certificates-during-installation"></a>

  When installing, users will be prompted to enter a fully qualified domain name (FQDN) to include in the Subject Alternative Name (SAN) of the NGINX Instance Manager's self-signed certificate generated during installation. This FQDN can serve as the server name for NGINX Instance Manager. Users can also specify this FQDN in the Installation Script

  {{< call-out "note" >}}Starting with NGINX Plus R33, usage data reporting requires validating the SSL certificate of NGINX Instance Manager via the `ssl_verify` directive in the `mgmt` block. Proper SAN configuration ensures seamless SSL verification.{{< /call-out >}}

- {{% icon-feature %}} **Watchdog enhancements to improve stability**<a name="2-19-0-changes-in-behavior-Watchdog-enhancements-to-improve-stability"></a>

  We have introduced new configurable element in `nms.conf` called `enable_watchdog_notifications`. When enabled, if any process takes longer than expected to respond the customer will get a notification in the web interface warning about the unresponsive process. Previously, a Watchdog process was stopping the process and led to configurations not applying.

- {{% icon-feature %}} **Expired unmanaged certificates are eventually removed from the web interface**<a name="2-19-0-changes-in-behavior-Expired-unmanaged-certificates-are-eventually-removed-from-the-web-interface"></a>

  Starting in 2.19.0, remote certificates that are expired are removed from the web interface after 30 days.


### Resolved Issues{#2-19-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Error messages persist after fix (45024)
- {{% icon-resolved %}} .tgz files are not accepted in templates (45301)
- {{% icon-resolved %}} The web interface can't display more than 100 certificates (45565)
- {{% icon-resolved %}} NGINX configuration error messages overlap outside the error window (45570)
- {{% icon-resolved %}} Syntax errors while saving template configuration (45573)


### Known Issues{#2-19-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.18.0

November 08, 2024

### Upgrade Paths {#2-18-0-upgrade-paths}

NGINX Instance Manager 2.18.0 supports upgrades from these previous versions:

- 2.15.0 - 2.17.4

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-18-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Resilient Docker Compose NGINX Instance Manager deployment**<a name="2-18-0-whats-new-Resilient-Docker-Compose-NGINX-Instance-Manager-deployment"></a>

   In 2.17, we released a [bundled container image]({{< ref "nim/deploy/docker/deploy-nginx-instance-manager-docker-compose.md" >}}) with all NGINX Instance Manager components. While this is a great option for demos and lab environments, it is not the most fault-tolerant for production.

  This [Docker Compose option]({{< ref "nim/deploy/docker/deploy-nginx-instance-manager-docker-compose.md" >}}) unlocks another easy, production-ready installation method for customers using Docker. It will also make upgrades easier when new Docker images are released by F5 NGINX. This option includes health checking, NGINX App Protect compilation support, and security monitoring.

- {{% icon-feature %}} **Entitlement and visibility for NGINX Plus R33 – Telemetry reporting for disconnected environments**<a name="2-18-0-whats-new-Entitlement-and-visibility-for-NGINX-Plus-R33-–-Telemetry-reporting-for-disconnected-environments"></a>

   If NGINX Instance Manager has internet access, customers can [automatically or manually send the usage data to F5]({{< ref "nim/admin-guide/report-usage-connected-deployment.md" >}}) as part of the new NGINX Plus R33 changes.

  For customers who have NGINX Instance Manager deployed in [disconnected environments]({{< ref "nim/disconnected" >}}), this release also includes support for manual usage reporting. Customers can now manually license NGINX Instance Manager and export usage telemetry for fully disconnected environments. For usage reporting, customers can:

  - **Export the usage report**: Manually export the usage report from NGINX Instance Manager.
  - **Send the report to F5**: Submit the report to F5 for verification from a location with internet access.
  - **Upload the acknowledgment**: After verification, upload the acknowledgment from F5 to NGINX Instance Manager.

- {{% icon-feature %}} **Ridiculously easy NGINX Instance Manager installation script (Bash)**<a name="2-18-0-whats-new-Ridiculously-easy-NGINX-Instance-Manager-installation-script-(Bash)"></a>

   Reduce the number of steps to deploy all NGINX Instance Manager components, including prerequisites, using a single [installation script]({{< ref "nim/deploy/vm-bare-metal/install.md" >}}). The script supports every OS that NGINX Instance Manager supports in the [technical specifications]({{< ref "nim/fundamentals/tech-specs.md" >}}).

  The script installs NGINX (Plus or Open Source), ClickHouse, and NGINX Instance Manager. Customers only need their NGINX Plus certificate, key, and, for NGINX Plus R33 or later, a JWT downloaded from MyF5. Support for offline installations will be added in a future update.

  Support for [offline installations]({{< ref "nim/disconnected/offline-install-guide.md" >}}) is also available for air-gapped environments.

- {{% icon-feature %}} **Adds support for F5 WAF for NGINX v5.3 and v4.11**<a name="2-18-0-whats-new-Adds-support-for-NGINX-App-Protect-WAF-v5-3-and-v4-11"></a>

     NGINX Instance Manager 2.18.0 adds support for [F5 WAF for NGINX v5.3 and v4.11]({{< relref "nap-waf/v5/admin-guide/overview.md" >}}).

    F5 WAF for NGINX v5, designed for both NGINX Open Source and NGINX Plus environments, includes a dynamic NGINX module and containerized WAF services. It provides robust security and scalability.


### Changes in Default Behavior{#2-18-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **The NGINX Usage page now only shows instances configured with the NGINX Plus R33 mgmt block.**<a name="2-18-0-changes-in-behavior-The-NGINX-Usage-page-now-only-shows-instances-configured-with-the-NGINX-Plus-R33-mgmt-block-"></a>

  The “NGINX Usage” page previously displayed instances connected to NGINX Instance Manager through multiple methods, including the NGINX Agent, health checks, and the `mgmt` block in NGINX Plus R31-R32. With the introduction of native reporting in NGINX Plus R33, only instances using this feature appear on the page, preventing duplicates. For more information on R33 usage reporting, see [About subscription licenses]({{< ref "solutions/about-subscription-licenses.md" >}}).


### Resolved Issues{#2-18-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Licensing issues when adding JWT licenses in firewalled environments (43719)
- {{% icon-resolved %}} Failure to notify user when template configuration publish fails (44975)
- {{% icon-resolved %}} Mismatch in date formats in custom date selection on NGINX usage graph (45512)


### Known Issues{#2-18-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.17.4

November 06, 2024

### Upgrade Paths {#2-17-4-upgrade-paths}

NGINX Instance Manager 2.17.4 supports upgrades from these previous versions:

- 2.14.0 - 2.17.3

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-17-4-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="2-17-4-whats-new-Stability-and-performance-improvements"></a>

   This release includes stability and performance improvements.



### Known Issues{#2-17-4-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.17.3

September 13, 2024

### Upgrade Paths {#2-17-3-upgrade-paths}

NGINX Instance Manager 2.17.3 supports upgrades from these previous versions:

- 2.14.0 - 2.17.2

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-17-3-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **GPG key update for NGINX Agent packages**<a name="2-17-3-whats-new-GPG-key-update-for-NGINX-Agent-packages"></a>

   Previous releases of NGINX Instance Manager included NGINX Agent packages signed with an expired GPG key. This release of NGINX Instance Manager includes updated keys, allowing users to successfully download the NGINX Agent from NGINX Instance Manager.



### Known Issues{#2-17-3-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.17.2

August 21, 2024

### Upgrade Paths {#2-17-2-upgrade-paths}

NGINX Instance Manager 2.17.2 supports upgrades from these previous versions:

- 2.14.0 - 2.17.1

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-17-2-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="2-17-2-whats-new-Stability-and-performance-improvements"></a>

   This release includes stability and performance improvements for a more reliable experience.



### Known Issues{#2-17-2-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.17.1

July 24, 2024

### Upgrade Paths {#2-17-1-upgrade-paths}

NGINX Instance Manager 2.17.1 supports upgrades from these previous versions:

- 2.14.0 - 2.17.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-17-1-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="2-17-1-whats-new-Stability-and-performance-improvements"></a>

   This release includes stability and performance improvements for a more reliable experience.



### Known Issues{#2-17-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.17.0

July 10, 2024

### Upgrade Paths {#2-17-0-upgrade-paths}

NGINX Instance Manager 2.17.0 supports upgrades from these previous versions:

- 2.14.0 - 2.16.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-17-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Adds support for F5 WAF for NGINX v5**<a name="2-17-0-whats-new-Adds-support-for-NGINX-App-Protect-WAF-v5"></a>

   NGINX Instance Manager 2.17.0 adds support for [F5 WAF for NGINX v5.](https://docs.nginx.com/nginx-app-protect-waf/v5/admin-guide/overview/).

  F5 WAF for NGINX v5 (designed for both NGINX Open Source and NGINX Plus environments) consists of a dynamic NGINX module and containerized WAF services, providing robust security and scalability.

- {{% icon-feature %}} **Hosted Docker images for Kubernetes Helm charts**<a name="2-17-0-whats-new-Hosted-Docker-images-for-Kubernetes-Helm-charts"></a>

   Prior to this release, users had to download NGINX Instance Manager docker images and push them to their local container registry for use in the Kubernetes Helm charts. This was not very turnkey and required multiple steps before being able to use the Helm charts. Now all Instance Manager container images are available from F5's public docker repository, simplifying the installation in Kubernetes.

  See the [Deploy Instance Manager on Kubernetes]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md" >}}) documentation for more information.

- {{% icon-feature %}} **Ansible role to deploy NGINX Instance Manager**<a name="2-17-0-whats-new-Ansible-role-to-deploy-NGINX-Instance-Manager"></a>

   This release comes with an Ansible role to help you Install NGINX Instance Manager quickly, while also encouraging the best practices for your chosen environment.

- {{% icon-feature %}} **NGINX Instance Manager IaC using Packer and Terraform**<a name="2-17-0-whats-new-NGINX-Instance-Manager-IaC-using-Packer-and-Terraform"></a>

   This release improves the [Infrastructure as Code (IaC) project]({{< ref "/nim/deploy/infrastructure-as-code/overview.md#nginx-management-suite-infrastructure-as-code" >}}) to help you quickly get started with NGINX Instance Manager using Packer and Terraform.

  The project uses Packer to create images and Terraform to deploy these images to your preferred cloud provider, including GCP, Azure, or vSphere.

- {{% icon-feature %}} **Single docker image with all the NGINX Instance Manager services and dependencies**<a name="2-17-0-whats-new-Single-docker-image-with-all-the-NGINX-Instance-Manager-services-and-dependencies"></a>

   This release includes access to a single Docker image for running NGINX Instance Manager as a container. This allows customers to deploy Instance Manager locally with a single "docker run" command. For more details, see [Deploy NGINX Instance Manager in a Single Docker Container]({{< ref "/nim/deploy/docker/deploy-nginx-instance-manager-docker-compose.md" >}}).


### Changes in Default Behavior{#2-17-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Web Analytics**<a name="2-17-0-changes-in-behavior-Web-Analytics"></a>

  NGINX Instance Manager now collects and sends anonymized telemetry and interaction information for analysis by F5 NGINX. This information is used to improve our products and services.

  Customers have the option to opt out of data collection by disabling the feature in the Instance Manager web interface, using the Account menu in the top-right corner of the screen. For more details, see [Configure Telemetry and Web Analytics]({{< ref "/nim/system-configuration/configure-telemetry.md" >}}).

- {{% icon-feature %}} **Augment Template order now matches NGINX configuration structure**<a name="2-17-0-changes-in-behavior-Augment-Template-order-now-matches-NGINX-configuration-structure"></a>

  When you generate a configuration using augment templates, the order shown in the UI now matches the structure of an NGINX configuration. This makes filling out a template more intuitive.

- {{% icon-feature %}} **End of support for CentOS 7 and Red Hat Enterprise Linux 7**<a name="2-17-0-changes-in-behavior-End-of-support-for-CentOS-7-and-Red-Hat-Enterprise-Linux-7"></a>

  CentOS 7 and Red Hat Enterprise Linux 7 reached [end of maintenance support](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux/rhel-7-end-of-maintenance) on June 30, 2024.

  Since these operating systems won't get any more updates or security patches, NGINX Instance Manager no longer supports them.

  Please upgrade your environment to one of the [supported distributions]({{< ref "/nim/fundamentals/tech-specs.md#supported-distributions" >}}) to continue using NGINX Instance Manager.


### Resolved Issues{#2-17-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Users receive login error when NGINX Management Suite is deployed in Kubernetes (44686)
- {{% icon-resolved %}} REST API does not work until you log into the web interface first (44877)
- {{% icon-resolved %}}  Editing template submissions uses the latest versions, may cause "malformed" errors (44961)
- {{% icon-resolved %}} Editing template submissions now allows for using most recent template version (44971)


### Known Issues{#2-17-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.16.0

April 18, 2024

### Upgrade Paths {#2-16-0-upgrade-paths}

NGINX Instance Manager 2.16.0 supports upgrades from these previous versions:

- 2.13.0 - 2.15.1

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-16-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Introducing configuration templates for simplifying NGINX configurations and self-service workflows**<a name="2-16-0-whats-new-Introducing-configuration-templates-for-simplifying-NGINX-configurations-and-self-service-workflows"></a>

   This release of NGINX Instance Manager introduces [Config Templates]({{< ref "nim/nginx-configs/config-templates/concepts/config-templates.md" >}}). These templates use Go templating to make it easier to set up and standardize NGINX configurations. Now, you don't need to know all the details of NGINX syntax to create a working configuration. Just provide the required inputs for a template, and the system will do the rest. This makes setting up NGINX simpler and helps you follow best practices.

  To provide more control over your configurations, [augment templates]({{< ref "nim/nginx-configs/config-templates/concepts/default-base-template.md#augmenting-global-default-base-template" >}}) let you modify only specific segments of your NGINX configuration. This, when combined with [RBAC for template submissions]({{< ref "/nim/nginx-configs/config-templates/how-to/rbac-config-templates-and-submissions.md" >}}), enables self-service workflows. Look for pre-built templates for common scenarios in our GitHub repositories soon.

- {{% icon-feature %}} **Stability and performance improvements**<a name="2-16-0-whats-new-Stability-and-performance-improvements"></a>

   This release enhances system stability and performance.


### Changes in Default Behavior{#2-16-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Change in NGINX Agent upgrade behavior**<a name="2-16-0-changes-in-behavior-Change-in-NGINX-Agent-upgrade-behavior"></a>

  Starting from version v2.31.0, the NGINX Agent will automatically restart itself during an upgrade.


### Resolved Issues{#2-16-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Upgrading to 2.12 disables telemetry (43606)


### Known Issues{#2-16-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.15.1

February 14, 2024

### Upgrade Paths {#2-15-1-upgrade-paths}

NGINX Instance Manager 2.15.1 supports upgrades from these previous versions:

- 2.12.0 - 2.15.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-15-1-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="2-15-1-whats-new-Stability-and-performance-improvements"></a>

   This release includes stability and performance improvements.


### Resolved Issues{#2-15-1-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Helm chart backup and restore is broken in NIM 2.15.0 (44758)
- {{% icon-resolved %}} Unable to use NMS Predefined Log Profiles for NAP 4.7 (44759)


### Known Issues{#2-15-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.15.0

December 12, 2023

### Upgrade Paths {#2-15-0-upgrade-paths}

NGINX Instance Manager 2.15.0 supports upgrades from these previous versions:

- 2.12.0 - 2.14.1

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-15-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Support for CA Certificates added**<a name="2-15-0-whats-new-Support-for-CA-Certificates-added"></a>

   Instance Manager now allows for managing CA Certificates to fully support NGINX directives such as _proxy_ssl_trusted_ and _proxy_ssl_verify_. The main difference after this change is that you no longer need a corresponding key to upload a certificate to Instance Manager.


### Resolved Issues{#2-15-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Querying API endpoints for Security deployments associations may return empty UIDs for Attack-Signatures and Threat-Campaigns (43034)
- {{% icon-resolved %}} Instances reporting incorrect memory utilization (44351)
- {{% icon-resolved %}} Data on the dashboard is updating unexpectedly (44504)
- {{% icon-resolved %}} Missing Data when ClickHouse services are not running (44586)
- {{% icon-resolved %}} NGINX App Protect Attack Signature, Threat Campaign and Compiler fail to download (44603)


### Known Issues{#2-15-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.14.1

October 19, 2023

### Upgrade Paths {#2-14-1-upgrade-paths}

NGINX Instance Manager 2.14.1 supports upgrades from these previous versions:

- 2.11.0 - 2.14.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-14-1-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Stability and performance improvements**<a name="2-14-1-whats-new-Stability-and-performance-improvements"></a>

   This release includes stability and performance improvements.



### Known Issues{#2-14-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.14.0

October 16, 2023

### Upgrade Paths {#2-14-0-upgrade-paths}

NGINX Instance Manager 2.14.0 supports upgrades from these previous versions:

- 2.11.0 - 2.13.1

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-14-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Instance Manager Dashboard**<a name="2-14-0-whats-new-Instance-Manager-Dashboard"></a>

   Monitor the health and performance of your NGINX instance fleet from a single page. Get insights and trends on CPU, memory, disk, and network traffic utilization. Quickly spot and mitigate common HTTP errors and TLS certificate issues. See the [Instance Manager Dashboard]({{< ref "nim/fundamentals/dashboard-overview.md" >}}) documentation to learn more.

- {{% icon-feature %}} **Work with NGINX App Protect Bundles from Instance Manager**<a name="2-14-0-whats-new-Work-with-NGINX-App-Protect-Bundles-from-Instance-Manager"></a>

   Starting with Instance Manager 2.14, you can now use the "/security/policies/bundles" endpoint to create, read, update, and delete NGINX App Protect bundles, which allow faster deployment through pre-compilation of security policies, attack signatures, and threat-campaign.  For additional information on how to use the API endpoint, refer to your product API documentation.
    To learn more about this feature, see the [Manage WAF Security Policies]({{< ref "/nim/nginx-app-protect/manage-waf-security-policies.md" >}}) documentation.

- {{% icon-feature %}} **Clickhouse LTS 23.8 support**<a name="2-14-0-whats-new-Clickhouse-LTS-23-8-support"></a>

   This release of Instance Manager has been tested and is compatible with Clickhouse LTS versions 22.3.15.33 to 23.8.


### Changes in Default Behavior{#2-14-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Inactive NGINX instances are automatically removed over time**<a name="2-14-0-changes-in-behavior-Inactive-NGINX-instances-are-automatically-removed-over-time"></a>

  If an NGINX instance has been inactive (NGINX Agent not reporting to NGINX Management Suite) for a fixed amount of time, it is now automatically removed from the instances list. Instances deployed in a virtual machine or hardware are removed after 72 hours of inactivity, and those deployed in a container are removed after 12 hours.


### Resolved Issues{#2-14-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} OIDC-authenticated users can't view the Users list using the API or web interface (43031)
- {{% icon-resolved %}} getAttackCountBySeverity endpoint broken with NGINX App Protect 4.4 and above (44051)
- {{% icon-resolved %}} Certificates may not appear in resource group  (44323)
- {{% icon-resolved %}} NGINX Agent does not report NGINX App Protect status (44531)
- {{% icon-resolved %}} Issues sorting HTTP errors in the dashboard (44536)


### Known Issues{#2-14-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.13.1

September 05, 2023

### Upgrade Paths {#2-13-1-upgrade-paths}

NGINX Instance Manager 2.13.1 supports upgrades from these previous versions:

- 2.10.0 - 2.13.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### Resolved Issues{#2-13-1-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Validation errors in Resource Groups for certificates uploaded before 2.13 upgrade (44254)
- {{% icon-resolved %}} Access levels cannot be assigned to certain RBAC features (44277)


### Known Issues{#2-13-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.13.0

August 28, 2023

### Upgrade Paths {#2-13-0-upgrade-paths}

NGINX Instance Manager 2.13.0 supports upgrades from these previous versions:

- 2.10.0 - 2.12.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-13-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Easily manage access to specific objects with Resource Groups**<a name="2-13-0-whats-new-Easily-manage-access-to-specific-objects-with-Resource-Groups"></a>

   With NGINX Instance Manager, you can now combine Instances, Instance Groups, and Certificates into a Resource Group. This grouping can be used when defining roles to grant access to those specific objects. When objects are added to or removed from the Resource Group, the changes are automatically reflected in any roles that use the Resource Group. For more details, refer to [Working with Resource Groups]({{< ref "/nim/admin-guide/rbac/manage-resource-groups.md" >}}).

- {{% icon-feature %}} **Get version controlled NGINX configurations with an external commit hash**<a name="2-13-0-whats-new-Get-version-controlled-NGINX-configurations-with-an-external-commit-hash"></a>

   The Instance Manager REST API supports setting and retrieving instances, instance groups, and staged NGINX configurations using a version control commit hash.

  To learn how to use a commit hash with NGINX configurations, refer to these topics:

  - [Add Hash Versioning to Staged Configs]({{< ref "/nim/nginx-configs/stage-configs.md#hash-versioning-staged-configs" >}})
  - [Publish Configs with Hash Versioning to Instances]({{< ref "/nim/nginx-configs/publish-configs.md#publish-configs-instances-hash-versioning" >}})
  - [Publish Configs with Hash Versioning to Instance Groups]({{< ref "/nim/nginx-configs/publish-configs.md#publish-configs-instance-groups-hash-versioning" >}})

- {{% icon-feature %}} **Configure analytics data retention with the nms.conf file**<a name="2-13-0-whats-new-Configure-analytics-data-retention-with-the-nms-conf-file"></a>

   You can set the data retention policy for analytics data, which includes metrics, events, and security events, in the `nms.conf` file. By default, metrics and security events are stored for 32 days, while events are stored for 120 days. To keep data for a longer period, update the retention durations in the `nms.conf` file.

- {{% icon-feature %}} **RBAC for security policies**<a name="2-13-0-whats-new-RBAC-for-security-policies"></a>

   You can now use [Role-Based Access Control (RBAC)]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}) to allow or restrict the level of access to security policies according to your security governance model.

- {{% icon-feature %}} **RBAC for log profiles**<a name="2-13-0-whats-new-RBAC-for-log-profiles"></a>

   You can now use [Role-Based Access Control (RBAC)]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}) to allow or restrict access to log profiles according to your security governance model.

- {{% icon-feature %}} **Use NGINX Plus Health Checks to easily track NGINX Plus Usage with NGINX Instance Manager**<a name="2-13-0-whats-new-Use-NGINX-Plus-Health-Checks-to-easily-track-NGINX-Plus-Usage-with-NGINX-Instance-Manager"></a>

   The NGINX Plus Health Check feature now allows you to monitor the count of both NGINX Plus and NGINX App Protect instances that you've deployed. You can view this information in the "NGINX Plus" area of the "Instance Manager" web interface, or through the `/inventory` API. For guidance on how to set this up, refer to the following documentation: [View Count of NGINX Plus Instances]({{< ref "/nim/admin-guide/report-usage-connected-deployment.md" >}}).

- {{% icon-feature %}} **Improved log output for better JSON parsing**<a name="2-13-0-whats-new-Improved-log-output-for-better-JSON-parsing"></a>

   In the log output, extra whitespace has been removed, and brackets have been removed from the log `level` field. This results in clean, parsable log output, particularly when using JSON log encoding.


### Resolved Issues{#2-13-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Staged configs fail to publish after upgrading NGINX Management Suite (37479)
- {{% icon-resolved %}} Error: "Failed to create secret" when reinstalling or upgrading NGINX Management Suite in Kubernetes (42967)
- {{% icon-resolved %}} An "unregistered clickhouse-adapter" failure is logged every few seconds if logging is set to debug. (43438)


### Known Issues{#2-13-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.12.0

July 20, 2023

### Upgrade Paths {#2-12-0-upgrade-paths}

NGINX Instance Manager 2.12.0 supports upgrades from these previous versions:

- 2.9.0 - 2.11.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-12-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **New support for license tokens for automatic entitlement updates, renewals, and Flexible Consumption Reporting**<a name="2-12-0-whats-new-New-support-for-license-tokens-for-automatic-entitlement-updates,-renewals,-and-Flexible-Consumption-Reporting"></a>

   NGINX Management Suite now supports license tokens formatted as a JSON Web Token (JWT). With JWT licensing, you can automatically update entitlements during subscription renewals or amendments, and you can automate reporting for the Flexible Consumption Program (FCP). For more information, see the [Add a License]({{< ref "/nim/admin-guide/add-license.md" >}}) topic.


### Resolved Issues{#2-12-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Filtering Analytics data with values that have double backslashes (`\\`) causes failures (42105)
- {{% icon-resolved %}} Unable to publish configurations referencing the log bundle for Security Monitor (42932)
- {{% icon-resolved %}} Disk Usage in Metrics Summary shows incorrect data when multiple partitions exist on a system (42999)
- {{% icon-resolved %}} When adding a Certs RBAC permission, the "Applies to" field may display as "nginx-repo" (43012)
- {{% icon-resolved %}} Publication status of instance groups may be shown as 'not available' after restarting NGINX Management Suite (43016)
- {{% icon-resolved %}} A JWT license for an expired subscription cannot be terminated from the web interface (43580)
- {{% icon-resolved %}} On Kubernetes, uploading a JWT license for NGINX Management Suite results in the error "secret not found" (43655)


### Known Issues{#2-12-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.11.0

June 12, 2023

### Upgrade Paths {#2-11-0-upgrade-paths}

NGINX Instance Manager 2.11.0 supports upgrades from these previous versions:

- 2.8.0 - 2.10.1

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-11-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **The config editor now lets you see auxiliary files**<a name="2-11-0-whats-new-The-config-editor-now-lets-you-see-auxiliary-files"></a>

   Auxiliary files, such as certificate files and other non-config files on managed instances or instance groups, are now visible in the file tree of the config editor view. This improvement makes it easier to reference these files within a configuration.

- {{% icon-feature %}} **Introducing new predefined log profiles for F5 WAF for NGINX**<a name="2-11-0-whats-new-Introducing-new-predefined-log-profiles-for-NGINX-App-Protect-WAF"></a>

   Now, managing your F5 WAF for NGINX configuration is even easier with new predefined log profiles. In addition to the existing log_all, log_blocked, log_illegal, and log_secops log profiles, the following new predefined log profiles are now available:

  - log_f5_arcsight
  - log_f5_splunk
  - log_grpc_all
  - log_grpc_blocked
  - log_grpc_illegal

  These new log profiles make it even easier to integrate F5 WAF for NGINX with other logging systems, such as Splunk, ArcSight, and gRPC.

- {{% icon-feature %}} **You can now install Advanced Metrics automatically when you install NGINX Agent**<a name="2-11-0-whats-new-You-can-now-install-Advanced-Metrics-automatically-when-you-install-NGINX-Agent"></a>

   When installing the NGINX Agent with NGINX Management Suite, you can include the `-a` or `--advanced-metrics` flag. Including this option installs the Advanced Metrics module along with the NGINX Agent. With this module, you gain access to extra metrics and insights that enrich the monitoring and analysis capabilities of the NGINX Management Suite, empowering you to make more informed decisions.

- {{% icon-feature %}} **NGINX Management Suite can send telemetry data to F5 NGINX**<a name="2-11-0-whats-new-NGINX-Management-Suite-can-send-telemetry-data-to-F5-NGINX"></a>

   In order to enhance product development and support the success of our users with NGINX Management Suite, we offer the option to send limited telemetry data to F5 NGINX. This data provides valuable insights into software usage and adoption. By default, telemetry is enabled, but you have the flexibility to disable it through the web interface or API. For detailed information about the transmitted data, please refer to our documentation.


### Changes in Default Behavior{#2-11-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **The location of agent-dynamic.conf has changed**<a name="2-11-0-changes-in-behavior-The-location-of-agent-dynamic-conf-has-changed"></a>

  In this release, the `agent-dynamic.conf` file has been moved from `/etc/nginx-agent/` to `/var/lib/nginx-agent/`. To assign an instance group and tags to an instance, you will now need to edit the file located in `/var/lib/nginx-agent/`.

- {{% icon-feature %}} **⚠ Action required: Update OIDC configurations for management plane after upgrading to Instance Manager 2.11.0**<a name="2-11-0-changes-in-behavior-⚠-Action-required:-Update-OIDC-configurations-for-management-plane-after-upgrading-to-Instance-Manager-2-11-0"></a>

  In Instance Manager 2.11.0, we added support for telemetry to the OIDC configuration files. Existing OIDC configurations will continue to work, but certain telemetry events, such as login, may not be captured.

- {{% icon-feature %}} **Configuration file permissions have been lowered to strengthen security**<a name="2-11-0-changes-in-behavior-Configuration-file-permissions-have-been-lowered-to-strengthen-security"></a>

  To strengthen the security of configuration details, certain file permissions have been modified. Specifically, the following configuration files now have lowered permissions, granting Owner Read/Write access and Group Read access (also referred to as `0640` or `rw-r-----`):

  - /etc/nms/nginx.conf
  - /etc/nginx/conf.d/nms-http.conf
  - /etc/nms/nginx/oidc/openid_configuration.conf
  - /etc/nms/nginx/oidc/openid_connect.conf

  Additionally, the following file permissions have been lowered to Owner Read/Write and Group Read/Write access (also known as `0660` or `rw-rw-----`):

  - /logrotate.d/nms.conf
  - /var/log/nms/nms.log

  These changes aim to improve the overall security of the system by restricting access to sensitive configuration files while maintaining necessary privileges for authorized users.


### Resolved Issues{#2-11-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Count of NGINX Plus graph has a delay in being populated (37705)
- {{% icon-resolved %}} When upgrading to Instance Manager 2.10, the publish status on App Security pages shows "Invalid Date" (42108)
- {{% icon-resolved %}} Duplicate Certificate and Key published for managed certificates (42182)
- {{% icon-resolved %}} The Metrics module is interrupted during installation on Red Hat 9 (42219)
- {{% icon-resolved %}} Certificate file is not updated automatically under certain conditions (42425)
- {{% icon-resolved %}} Certificate updates allow for multiples certs to share the same serial number (42429)


### Known Issues{#2-11-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.10.1

May 22, 2023

### Upgrade Paths {#2-10-1-upgrade-paths}

NGINX Instance Manager 2.10.1 supports upgrades from these previous versions:

- 2.7.0 - 2.10.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### Resolved Issues{#2-10-1-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Valid licenses incorrectly identified as invalid (42598)


### Known Issues{#2-10-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.10.0

April 26, 2023

### Upgrade Paths {#2-10-0-upgrade-paths}

NGINX Instance Manager 2.10.0 supports upgrades from these previous versions:

- 2.7.0 - 2.9.1

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-10-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **New "Category" Filter in the Events web interface**<a name="2-10-0-whats-new-New-"Category"-Filter-in-the-Events-web-interface"></a>

   You can now filter entries in the Events web interface using a new "Category" filter. Categories for event entries include "Certs", "Instance Groups", and "Templates".

- {{% icon-feature %}} **New NGINX Agent install flag for F5 WAF for NGINX**<a name="2-10-0-whats-new-New-NGINX-Agent-install-flag-for-NGINX-App-Protect-WAF"></a>

   The NGINX Agent installation script now has a flag to enable the default configuration required for F5 WAF for NGINX. It is used to retrieve the deployment status and `precompiled_publication` mode, with an option for the F5 WAF for NGINX instance to use the mode for policies.

- {{% icon-feature %}} **NGINX Management Suite version now visible in the web interface and API**<a name="2-10-0-whats-new-NGINX-Management-Suite-version-now-visible-in-the-web-interface-and-API"></a>

   You can now look up the NGINX Management Suite and NGINX Instance Manager versions in the web interface and API. Other module versions are also visible, though older versions of API Connectivity Manager and Security Monitoring may appear as undefined.

- {{% icon-feature %}} **NGINX Management Suite can now use NGINX Ingress Controller to manage routing**<a name="2-10-0-whats-new-NGINX-Management-Suite-can-now-use-NGINX-Ingress-Controller-to-manage-routing"></a>

   The NGINX Management Suite Helm Chart can now generate an NGINX Ingress Controller VirtualServer definition, which can be used to expose NGINX Management Suite when running in your Kubernetes cluster.
  More about the VirtualServer custom resource can be found in the [VirtualServer and VirtualServerRoute](https://docs.nginx.com/nginx-ingress-controller/configuration/virtualserver-and-virtualserverroute-resources/) documentation.

- {{% icon-feature %}} **Configuration Publication Status now visible in App Security pages.**<a name="2-10-0-whats-new-Configuration-Publication-Status-now-visible-in-App-Security-pages-"></a>

   The most recent publication date and status for an instance's configuration is now visible on App Security Pages. This reflects configuration for NGINX, NGINX App Protect policies, Attack Signatures and Threat Campaigns.

- {{% icon-feature %}} **Instance Manager can now automatically retrieve WAF compilers associated with NGINX App Protect instances**<a name="2-10-0-whats-new-Instance-Manager-can-now-automatically-retrieve-WAF-compilers-associated-with-NGINX-App-Protect-instances"></a>

   Using a user-provided NGINX repository certificate & key after the first set-up of the WAF compiler, Instance Manager can automatically retrieve WAF compilers associated with NGINX App Protect instances. These can be used to publish F5 WAF for NGINX configurations in `precompiled_publication` mode.

- {{% icon-feature %}} **Add option to toggle ICMP scanning in the web interface**<a name="2-10-0-whats-new-Add-option-to-toggle-ICMP-scanning-in-the-web-interface"></a>

   You can now explicitly enable or disable ICMP scanning at the top of the "Scan" interface.

- {{% icon-feature %}} **New NGINX Agent install flag for Security Monitoring**<a name="2-10-0-whats-new-New-NGINX-Agent-install-flag-for-Security-Monitoring"></a>

   The NGINX Agent installation script now has a flag to enable the default configuration required for the Security Monitoring module.


### Changes in Default Behavior{#2-10-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Improvements to Role Based Access Control for SSL Certificate and Key management**<a name="2-10-0-changes-in-behavior-Improvements-to-Role-Based-Access-Control-for-SSL-Certificate-and-Key-management"></a>

  Role Based Access Control for SSL Certificate and Key management can now use three different objects for precise controls: certificates, systems, and instance groups. Using certificates as an object controls the viewing and assigning of specific certificate and key pairs. Using systems or instance groups allows a user to see all certificates but restricts access for publishing.

- {{% icon-feature %}} **By default, NGINX Management Suite is not exposed to the internet when installed with a Helm Chart**<a name="2-10-0-changes-in-behavior-By-default,-NGINX-Management-Suite-is-not-exposed-to-the-internet-when-installed-with-a-Helm-Chart"></a>

  When NGINX Management Suite is installed using a Helm Chart, it now defaults to a ClusterIP without an external IP address.


### Resolved Issues{#2-10-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Installing NGINX Agent on FreeBSD fails with "error 2051: not implemented" (41157)
- {{% icon-resolved %}} Configuration changes for NGINX Agent take longer than expected. (41257)
- {{% icon-resolved %}} SELinux errors encountered when starting NGINX Management Suite on RHEL9 with the SELinux policy installed (41327)


### Known Issues{#2-10-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.9.1

April 06, 2023

### Upgrade Paths {#2-9-1-upgrade-paths}

NGINX Instance Manager 2.9.1 supports upgrades from these previous versions:

- 2.6.0 - 2.9.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### Resolved Issues{#2-9-1-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} NGINX configurations with special characters may not be editable from the web interface after upgrading Instance Manager (41557)


### Known Issues{#2-9-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.9.0

March 21, 2023

### Upgrade Paths {#2-9-0-upgrade-paths}

NGINX Instance Manager 2.9.0 supports upgrades from these previous versions:

- 2.6.0 - 2.8.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-9-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **New webpages for viewing Attack Signature and Threat Campaigns**<a name="2-9-0-whats-new-New-webpages-for-viewing-Attack-Signature-and-Threat-Campaigns"></a>

   The Instance Manager web interface now allows you to view Attack Signatures and Threat Campaign packages published to instances and instance groups. You can also publish these packages using the precompiled publication mode.

- {{% icon-feature %}} **NGINX Agent supports Rocky Linux 8 and 9**<a name="2-9-0-whats-new-NGINX-Agent-supports-Rocky-Linux-8-and-9"></a>

   The NGINX Agent now supports Rocky Linux 8 (x86_64, aarch64) and 9 (x86_64, aarch64).  The NGINX Agent supports the same distributions as NGINX Plus. For a list of the supported distributions, refer to the [NGINX Plus Technical Specs](https://docs.nginx.com/nginx/technical-specs/#supported-distributions) guide.

- {{% icon-feature %}} **New Events for CUD actions**<a name="2-9-0-whats-new-New-Events-for-CUD-actions"></a>

   Events will be triggered for `CREATE`, `UPDATE`, and `DELETE` actions on Templates, Instances, Certificates, Instance Groups, and Licenses.

- {{% icon-feature %}} **The _Certificate and Keys_ webpage has a new look!**<a name="2-9-0-whats-new-The-_Certificate-and-Keys_-webpage-has-a-new-look!"></a>

   Our new and improved _Certificates and Keys_ webpage makes it easier than ever to efficiently manage your TLS certificates.

- {{% icon-feature %}} **Add commit hash details to NGINX configurations for version control**<a name="2-9-0-whats-new-Add-commit-hash-details-to-NGINX-configurations-for-version-control"></a>

   Use the Instance Manager REST API to add a commit hash to NGINX configurations if you use version control, such as Git.

  For more information, see the following topics:

  - [Add Hash Versioning to Staged Configs]({{< ref "/nim/nginx-configs/stage-configs.md#hash-versioning-staged-configs" >}})
  - [Publish Configs with Hash Versioning to Instances]({{< ref "/nim/nginx-configs/publish-configs.md#publish-configs-instances-hash-versioning" >}})
  - [Publish Configs with Hash Versioning to Instance Groups]({{< ref "/nim/nginx-configs/publish-configs.md#publish-configs-instance-groups-hash-versioning" >}})


### Security Updates{#2-9-0-security-updates}

{{< call-out "important" >}}
For the protection of our customers, NGINX doesn’t disclose security issues until an investigation has occurred and a fix is available.
{{< /call-out >}}

This release includes the following security updates:

- {{% icon-resolved %}} **Instance Manager vulnerability CVE-2023-1550**<a name="2-9-0-security-updates-Instance-Manager-vulnerability-CVE-2023-1550"></a>

  NGINX Agent inserts sensitive information into a log file ([CVE-2023-1550](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-1550)). An authenticated attacker with local access to read NGINX Agent log files may gain access to private keys. This issue is exposed only when the non-default trace-level logging is enabled.

  NGINX Agent is included with NGINX Instance Manager, and used in conjunction with API Connectivity Manager and the Security Monitoring module.

  This issue has been classified as [CWE-532: Insertion of Sensitive Information into Log File](https://cwe.mitre.org/data/definitions/532.html).

  #### Mitigation

  - Avoid configuring trace-level logging in the NGINX Agent configuration file. For more information, refer to the [Configuring the NGINX Agent]({{< ref "/nginx-one/agent/configure-instances/configuration-overview/">}}) section of the documentation. If trace-level logging is required, ensure only trusted users have access to the log files.

  #### Fixed in

  - NGINX Agent 2.23.3
  - Instance Manager 2.9.0

  For more information, refer to the MyF5 article [K000133135](https://my.f5.com/manage/s/article/K000133135).


### Changes in Default Behavior{#2-9-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **SSL Certificates can be associated with Instance Groups**<a name="2-9-0-changes-in-behavior-SSL-Certificates-can-be-associated-with-Instance-Groups"></a>

  When assigning SSL certificates for the NGINX data plane, you have the option of associating them with a single instance or with an instance group. When associated with an instance group, the certificates will be shared across all instances in the group.

- {{% icon-feature %}} **⚠ Action required: OIDC configurations for the management plane must be updated after upgrading to Instance Manager 2.9.0**<a name="2-9-0-changes-in-behavior-⚠-Action-required:-OIDC-configurations-for-the-management-plane-must-be-updated-after-upgrading-to-Instance-Manager-2-9-0"></a>

  OIDC configuration files were modified to improve support for automation and integration in CI/CD pipelines. To continue using OIDC after upgrading to Instance Manager 2.9.0, you'll need to update these configuration files.

  To take advantage of the expanded functionality for OIDC authentication with NGINX Management Suite, we recommend following these two options:

  #### Option 1

  1. During the upgrade, type `Y` when prompted to respond `Y or I: install the package mainatiner's version` for each of the following files:

      - `/etc/nms/nginx/oidc/openid_configuration.conf`
      - `/etc/nms/nginx/oidc/openid_connect.conf`
      - `/etc/nms/nginx/oidc/openid_connect.js`

  1. After the upgrade finishes, make the following changes to the `/etc/nms/nginx/oidc/openid_configuration.conf` file using the `/etc/nms/oidc/openid_connect.conf.dpkg-old` that was created as a backup:

      - Uncomment the appropriate "Enable when using OIDC with" for your IDP (for example, keycloak, azure).
      - Update `$oidc_authz_endpoint` value with the corresponding values from `openid_connect.conf.dpkg-old`.
      - Update `$oidc_token_endpoint` value with the corresponding values from `openid_connect.conf.dpkg-old`.
      - Update `$oidc_jwt_keyfile` value with the corresponding values from `openid_connect.conf.dpkg-old`.
      - Update `$oidc_client` and `oidc_client_secret` with corresponding values from `openid_connect.conf.dpkg-old`.
      - Review and restore any other customizations from `openid_connect.conf.dpkg-old` beyond those mentioned above.

  1. Save the file.
  1. Restart NGINX Management Suite:

      ```bash
      sudo systemctl restart nms
      ```

  1. Restart the NGINX web server:

      ```bash
      sudo systemctl restart nginx
      ```

  <br>

  #### Option 2

  1. Before upgrading Instance Manager, edit the following files with your desired OIDC configuration settings:

      - `/etc/nginx/conf.d/nms-http.conf`
      - `/etc/nms/nginx/oidc/openid_configuration.conf`
      - `/etc/nms/nginx/oidc/openid_connect.conf`
      - `/etc/nms/nginx/oidc/openid_connect.js`

  1. During the upgrade, type `N` when prompted to respond `N or O  : keep your currently-installed version`.
  1. After the upgrade finishes replace `etc/nms/nginx/oidc/openid_connect.js` with `openid_connect.js.dpkg-dist`.
  1. Restart NGINX Management Suite:

      ```bash
      sudo systemctl restart nms
      ```

  1. Restart the NGINX web server:

      ```bash
      sudo systemctl restart nginx
      ```


### Resolved Issues{#2-9-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} After upgrading to NGINX Instance Manager 2.1.0, the web interface reports timeouts when NGINX Agent configs are published (32349)
- {{% icon-resolved %}} Scan misidentifies some NGINX OSS instances as NGINX Plus (35172)
- {{% icon-resolved %}} Scan does not update an unmanaged instance to managed (37544)
- {{% icon-resolved %}} "Public Key Not Available" error when upgrading Instance Manager on a Debian-based system (39431)
- {{% icon-resolved %}} The Type text on the Instances overview page may be partially covered by the Hostname text (39760)
- {{% icon-resolved %}} System reports "Attack Signature does not exist" when publishing default Attack Signature (40020)
- {{% icon-resolved %}} App Protect: "Assign Policy and Signature Versions" webpage may not initially display newly added policies (40085)
- {{% icon-resolved %}} Precompiled Publication setting is reverted to false after error publishing NGINX App Protect policy  (40484)
- {{% icon-resolved %}} Upgrading NGINX Management Suite may remove the OIDC configuration for the platform (41328)


### Known Issues{#2-9-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.8.0

January 30, 2023

### Upgrade Paths {#2-8-0-upgrade-paths}

NGINX Instance Manager 2.8.0 supports upgrades from these previous versions:

- 2.5.0 - 2.7.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-8-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Enhanced details page for SSL Certificates**<a name="2-8-0-whats-new-Enhanced-details-page-for-SSL-Certificates"></a>

   The Instance Manager web interface now features an improved details page for SSL Certificates. This page provides important information about the certificate and any associated instances.

- {{% icon-feature %}} **Automatic retrieval of Attack Signatures and Threat Campaign updates to Instance Manager**<a name="2-8-0-whats-new-Automatic-retrieval-of-Attack-Signatures-and-Threat-Campaign-updates-to-Instance-Manager"></a>

   Instance Manager now allows you to [set up automatic downloads of the most recent Attack Signature and Threat Campaign packages]({{< ref "/nim/nginx-app-protect/setup-waf-config-management.md##automatically-download-latest-packages" >}}). By publishing these updates to your App Protect instances from Instance Manager, you can ensure your applications are shielded from all recognized attack types.

- {{% icon-feature %}} **Improved WAF Compiler error messages**<a name="2-8-0-whats-new-Improved-WAF-Compiler-error-messages"></a>

   The messaging around [security policy compilation errors]({{< ref "/nim/nginx-app-protect/manage-waf-security-policies.md#check-for-compilation-errors" >}}) has been improved by providing more detailed information and alerting users if the required compiler version is missing.


### Changes in Default Behavior{#2-8-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Switching between storing secrets on disk and using Vault migrates secrets**<a name="2-8-0-changes-in-behavior-Switching-between-storing-secrets-on-disk-and-using-Vault-migrates-secrets"></a>

  When transitioning between storing secrets on disk or using HashiCorp Vault, any existing secrets can be easily migrated to the new storage method. For instructions, refer to the guide [Configure Vault for Storing Secrets]({{< ref "/nim/system-configuration/configure-vault.md" >}}).

- {{% icon-feature %}} **Create roles using either an object name or UID**<a name="2-8-0-changes-in-behavior-Create-roles-using-either-an-object-name-or-UID"></a>

  You can now use either an object name or a unique identifier (UID) when assigning object-level permissions while creating or editing a role via the Instance Manager REST API.

- {{% icon-feature %}} **Upgrading from 2.7 or earlier, you must re-enable `precompiled_publication` to continue publishing security policies with Instance Manager**<a name="2-8-0-changes-in-behavior-Upgrading-from-2-7-or-earlier,-you-must-re-enable-`precompiled_publication`-to-continue-publishing-security-policies-with-Instance-Manager"></a>

  To continue publishing security policies with Instance Manager if you are upgrading from Instance Manager 2.7 and earlier, you must set the  `precompiled_publication` parameter to `true` in the `nginx-agent.conf` file.

  In Instance Manager 2.7 and earlier, the `pre-compiled_publication` setting was set to `true` by default. However, starting with Instance Manager 2.8, this setting is set to `false` by default. This means you will need to change this setting to `true` again when upgrading from earlier versions.

  To publish App Protect policies from Instance Manager, add the following to your `nginx-agent.conf` file:

  ```yaml
      nginx_app_protect:
         precompiled_publication: true
  ```


### Resolved Issues{#2-8-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Web interface reports no license found when a license is present (30647)
- {{% icon-resolved %}} Associating instances with expired certificates causes internal error (34182)
- {{% icon-resolved %}} Publishing to an Instance/instance-group will fail when the configuration references a JSON policy or a JSON log profile  (38357)
- {{% icon-resolved %}} Missing dimension data for Advanced Metrics with modules (38634)
- {{% icon-resolved %}} Large payloads can result in disk I/O error for database operations (38827)
- {{% icon-resolved %}} The Policy API endpoint only allows NGINX App Protect policy upsert with content length upto 3.14MB. (38839)
- {{% icon-resolved %}} Deploy NGINX App Protect policy is listed as "Not Deployed" on the Policy Version detail page (38876)
- {{% icon-resolved %}} NGINX Management Suite services may lose connection to ClickHouse in a Kubernetes deployment (39285)
- {{% icon-resolved %}} NGINX App Protect status may not be displayed after publishing a configuration with a security policy and certificate reference (39382)
- {{% icon-resolved %}} Security Policy Snippet selector adds incorrect path reference for policy directive (39492)
- {{% icon-resolved %}} "Unpack: parse error" when compiling security update packages on CentOS 7, RHEL 7, and Amazon Linux 2 (39563)
- {{% icon-resolved %}} The API Connectivity Manager module won't load if the Security Monitoring module is enabled (39943)
- {{% icon-resolved %}} Automatic downloads of attack signatures and threat campaigns are not supported on CentOS 7, RHEL 7, or Amazon Linux 2 (40396)
- {{% icon-resolved %}} The API Connectivity Manager module won't load if the Security Monitoring module is enabled (44433)


### Known Issues{#2-8-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.7.0

December 20, 2022

### Upgrade Paths {#2-7-0-upgrade-paths}

NGINX Instance Manager 2.7.0 supports upgrades from these previous versions:

- 2.4.0 - 2.6.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### Changes in Default Behavior{#2-7-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **NGINX App Protect upgrades are supported**<a name="2-7-0-changes-in-behavior-NGINX-App-Protect-upgrades-are-supported"></a>

  You can upgrade F5 WAF for NGINX on managed instances where Instance Manager publishes NGINX App Protect policies and configurations. For example, upgrade from App Protect release 3.12.2 to release 4.0.

- {{% icon-feature %}} **NGINX Management Suite Config file is now in YAML format**<a name="2-7-0-changes-in-behavior-NGINX-Management-Suite-Config-file-is-now-in-YAML-format"></a>

  With the release of NGINX Instance Manager 2.7, the NGINX Management Suite configuration file is now in YAML format. Through the upgrade process, your existing configuration will automatically be updated. Any settings you have customized will be maintained in the new format. If you have existing automation tooling for the deployment of the NGINX Management Suite that makes changes to the configuration file, you will need to update it to account for the change.

- {{% icon-feature %}} **Existing NGINX Agent configuration kept during upgrade to the latest version**<a name="2-7-0-changes-in-behavior-Existing-NGINX-Agent-configuration-kept-during-upgrade-to-the-latest-version"></a>

  When upgrading NGINX Agent, the existing NGINX Agent configuration is maintained during the upgrade. If the Agent configuration is not present in `/etc/nginx-agent/nginx-agent.conf`, a default configuration is provided after NGINX Agent installation.


### Resolved Issues{#2-7-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Instance Manager reports old NGINX version after upgrade (31225)
- {{% icon-resolved %}} Instance Manager returns a "Download failed" error when editing an NGINX config for instances compiled and installed from source (35851)
- {{% icon-resolved %}} Null data count is not correctly represented in the NGINX Plus usage graph. (38206)
- {{% icon-resolved %}} When upgrading a multi-node NMS deployment with helm charts the core, dpm, or integrations pods may fail to start (38589)
- {{% icon-resolved %}} When upgrading Instance Manager from v2.4 to later versions of Instance Manager, certificate associations are no longer visible. (38641)
- {{% icon-resolved %}} NGINX App Protect policy deployment status not reflecting removal of associated instance. (38700)
- {{% icon-resolved %}} When upgrading a multi-node NMS deployment with helm charts the ingestion pod may report a "Mismatched migration version" error (38880)
- {{% icon-resolved %}} After a version upgrade of NGINX Instance Manager, NMS Data Plane Manager crashes if you publish NGINX configuration with App Protect enablement directive (app_protect_enable) set to ON (38904)


### Known Issues{#2-7-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.6.0

November 17, 2022

### Upgrade Paths {#2-6-0-upgrade-paths}

NGINX Instance Manager 2.6.0 supports upgrades from these previous versions:

- 2.3.0 - 2.5.1

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-6-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Manage and deploy configurations to F5 WAF for NGINX Instances**<a name="2-6-0-whats-new-Manage-and-deploy-configurations-to-NGINX-App-Protect-WAF-Instances"></a>

   This release introduces the following features to [manage and deploy configurations to NGINX App Protect instances]({{< ref "/nim/nginx-app-protect/overview-nap-waf-config-management.md" >}}):

  - Create, upsert, and delete F5 WAF for NGINX security policies
  - Manage F5 WAF for NGINX security configurations by using the NGINX Management Suite user interface or REST API
  - Update Signatures and Threat Campaign packages
  - Compile security configurations into a binary bundle that can be consumed by F5 WAF for NGINX instances

- {{% icon-feature %}} **Adds support for RHEL 9**<a name="2-6-0-whats-new-Adds-support-for-RHEL-9"></a>

   Instance Manager 2.6 supports RHEL 9. See the [Technical Specifications Guide]({{< ref "/nim/fundamentals/tech-specs#distributions" >}}) for details.

- {{% icon-feature %}} **Support for using HashiCorp Vault for storing secrets**<a name="2-6-0-whats-new-Support-for-using-HashiCorp-Vault-for-storing-secrets"></a>

   NGINX Management Suite now supports the use of Hashicorp Vault to store secrets such as SSL Certificates and Keys. Use of a new or existing Vault deployment is supported.

- {{% icon-feature %}} **Graph and additional data are included in NGINX Plus usage tracking interface**<a name="2-6-0-whats-new-Graph-and-additional-data-are-included-in-NGINX-Plus-usage-tracking-interface"></a>

   On the NGINX Plus usage tracking page, the number of NGINX Plus instances used over time is available in a graph. You can also view the minimum, maximum, and average count of concurrent unique instances in a given time period.

- {{% icon-feature %}} **Adds support for Oracle 8**<a name="2-6-0-whats-new-Adds-support-for-Oracle-8"></a>

   Oracle 8 is now [a supported distribution]({{< ref "/nim/fundamentals/tech-specs#distributions" >}}) starting with Instance Manager 2.6. You can use the RedHat/CentOS distro to install the Oracle 8 package.


### Changes in Default Behavior{#2-6-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **GET Roles API responses now include user and group associations**<a name="2-6-0-changes-in-behavior-GET-Roles-API-responses-now-include-user-and-group-associations"></a>

  `GET /roles` and `GET/roles/{roleName}` API responses include any user(s) or group(s) associated with a role now.


### Resolved Issues{#2-6-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Password error "option unknown" occurs when installing NGINX Instance Manager on Ubuntu with OpenSSL v1.1.0 (33055)
- {{% icon-resolved %}} Instance Manager reports the F5 WAF for NGINX build number as the version (37510)


### Known Issues{#2-6-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.5.1

October 11, 2022

### Upgrade Paths {#2-5-1-upgrade-paths}

NGINX Instance Manager 2.5.1 supports upgrades from these previous versions:

- 2.2.0 - 2.5.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### Resolved Issues{#2-5-1-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Extended NGINX metrics aren't reported for NGINX Plus R26 and earlier (37738)


### Known Issues{#2-5-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.5.0

October 04, 2022

### Upgrade Paths {#2-5-0-upgrade-paths}

NGINX Instance Manager 2.5.0 supports upgrades from these previous versions:

- 2.2.0 - 2.4.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-5-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Track NGINX Plus usage over time**<a name="2-5-0-whats-new-Track-NGINX-Plus-usage-over-time"></a>

   When viewing your NGINX Plus instances in the Instance Manager web interface, you can set a date and time filter to review the [NGINX Plus instance count]({{< ref "/nim/admin-guide/report-usage-connected-deployment.md" >}}) for a specific period. Also, you can use the Instance Manager REST API to view the lowest, highest, and average number of NGINX Plus instances over time.

- {{% icon-feature %}} **New helm charts for each release of Instance Manager**<a name="2-5-0-whats-new-New-helm-charts-for-each-release-of-Instance-Manager"></a>

   Each release of Instance Manager now includes a helm chart, which you can use to easily [install Instance Manager on Kubernetes]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md" >}}). You can download the helm charts from [MyF5](https://my.f5.com/manage/s/downloads).


### Resolved Issues{#2-5-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} OIDC is not supported for helm chart deployments (33248)
- {{% icon-resolved %}} Managed certificates may be overwritten if they have the same name on different datapath certificates (36240)
- {{% icon-resolved %}} Scan overview page doesn't scroll to show the full list of instances (36514)


### Known Issues{#2-5-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.4.0

August 16, 2022

### Upgrade Paths {#2-4-0-upgrade-paths}

NGINX Instance Manager 2.4.0 supports upgrades from these previous versions:

- 2.1.0 - 2.3.1

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-4-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Get notified about critical events**<a name="2-4-0-whats-new-Get-notified-about-critical-events"></a>

   Instance Manager 2.4 adds a notifications panel to the web interface. After logging in to NGINX Management Suite, select the notification bell at the top of the page to view critical system events (`WARNING` or `ERROR` level events). Future releases will support additional notification options.

- {{% icon-feature %}} **See which of your NGINX Plus instances have NGINX App Protect installed**<a name="2-4-0-whats-new-See-which-of-your-NGINX-Plus-instances-have-NGINX-App-Protect-installed"></a>

   Now, when you [view your NGINX Plus inventory]({{< ref "/nim/admin-guide/report-usage-connected-deployment.md" >}}), you can see which instances have [NGINX App Protect](https://www.nginx.com/products/nginx-app-protect/) installed. NGINX App Protect is a modern app‑security solution that works seamlessly in DevOps environments as a robust WAF or app‑level DoS defense, helping you deliver secure apps from code to customer.


### Changes in Default Behavior{#2-4-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **You no longer need to associate a certificate with an instance using the web interface**<a name="2-4-0-changes-in-behavior-You-no-longer-need-to-associate-a-certificate-with-an-instance-using-the-web-interface"></a>

  NGINX Management Suite will automatically deploy a certificate to an NGINX instance if the instance's config references the certificate on the NMS platform.

- {{% icon-feature %}} **Adds nms-integrations service**<a name="2-4-0-changes-in-behavior-Adds-nms-integrations-service"></a>

  This release adds a new service called `nms-integerations`. This service is for future integrations; no user management or configuration is needed at this time.


### Resolved Issues{#2-4-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Unable to publish config changes to a custom nginx.conf location (35276)


### Known Issues{#2-4-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.3.1

July 21, 2022

### Upgrade Paths {#2-3-1-upgrade-paths}

NGINX Instance Manager 2.3.1 supports upgrades from these previous versions:

- 2.0.0 - 2.3.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### Security Updates{#2-3-1-security-updates}

{{< call-out "important" >}}
For the protection of our customers, NGINX doesn’t disclose security issues until an investigation has occurred and a fix is available.
{{< /call-out >}}

This release includes the following security updates:

- {{% icon-resolved %}} **Instance Manager vulnerability CVE-2022-35241**<a name="2-3-1-security-updates-Instance-Manager-vulnerability-CVE-2022-35241"></a>

  In versions of 2.x before 2.3.1 and all versions of 1.x, when Instance Manager is in use, undisclosed requests can cause an increase in disk resource utilization.

  This issue has been classified as [CWE-400: Uncontrolled Resource Consumption](https://cwe.mitre.org/data/definitions/400.html).

  For more information, refer to the AskF5 article [K37080719](https://support.f5.com/csp/article/K37080719).



### Known Issues{#2-3-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.3.0

June 30, 2022

### Upgrade Paths {#2-3-0-upgrade-paths}

NGINX Instance Manager 2.3.0 supports upgrades from these previous versions:

- 2.0.0 - 2.2.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-3-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Instance Manager provides information about your F5 WAF for NGINX installations**<a name="2-3-0-whats-new-Instance-Manager-provides-information-about-your-NGINX-App-Protect-WAF-installations"></a>

   You can configure NGINX Agent to report the following F5 WAF for NGINX installation information to NGINX Management Suite:

  - The current version of F5 WAF for NGINX
  - The current status of F5 WAF for NGINX (active or inactive)
  - The Attack Signatures package version
  - The Threat Campaigns package version

- {{% icon-feature %}} **View a summary of your instances' most important metrics for the last 24 hours**<a name="2-3-0-whats-new-View-a-summary-of-your-instances'-most-important-metrics-for-the-last-24-hours"></a>

   This release adds a **Metrics Summary** page, from which you can view key system, network, HTTP request, and connection metrics at a glance for the last 24 hours. After logging in to Instance Manager, select an instance on the **Instances Overview** page, then select the **Metrics Summary** tab.

- {{% icon-feature %}} **Track the details for your NGINX Plus instances**<a name="2-3-0-whats-new-Track-the-details-for-your-NGINX-Plus-instances"></a>

   Easily track your NGINX Plus instances from the new NGINX Plus inventory list page. [View the current count for all your NGINX Plus instances]({{< ref "/nim/admin-guide/report-usage-connected-deployment.md" >}}), as well as each instance's hostname, UID, version, and the last time each instance was reported to Instance Manager. Select the `Export` button to export the list of NGINX Plus instances to a `.csv` file.

- {{% icon-feature %}} **Explore events in NGINX Instance Manager with the Events Catalogs API**<a name="2-3-0-whats-new-Explore-events-in-NGINX-Instance-Manager-with-the-Events-Catalogs-API"></a>

   This release introduces a Catalogs API endpoint specifically for viewing NGINX Instance Manager events and corresponding information. You can access the endpoint at `/analytics/catalogs/events`.

- {{% icon-feature %}} **Support for provisioning users and user groups with SCIM**<a name="2-3-0-whats-new-Support-for-provisioning-users-and-user-groups-with-SCIM"></a>

   Now, you can [use SCIM to provision, update, or deprovision users and user groups]({{< ref "/nim/admin-guide/authentication/oidc/scim-provisioning.md" >}}) for your Identity Provider to NGINX Instance Manager. SCIM, short for "[System for Cross-domain Identity Management](http://www.simplecloud.info)," is an open API for managing identities.

- {{% icon-feature %}} **Adds support for Ubuntu 22.04**<a name="2-3-0-whats-new-Adds-support-for-Ubuntu-22-04"></a>

   The NGINX Management Suite, which includes NGINX Instance Manager, now supports Ubuntu 22.04 (Jammy).

  Refer to the [Technical Specifications Guide]({{< ref "/nim/fundamentals/tech-specs" >}}) for details.


### Changes in Default Behavior{#2-3-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **New login screen**<a name="2-3-0-changes-in-behavior-New-login-screen"></a>

  Sometimes it's the small things that count. Now, when logging in to NGINX Instance Manager, you're treated to an attractive-looking login screen instead of a bland system prompt. 🤩


### Resolved Issues{#2-3-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Post-install steps to load SELinux policy are in the wrong order (34276)


### Known Issues{#2-3-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.2.0

May 25, 2022

### Upgrade Paths {#2-2-0-upgrade-paths}

NGINX Instance Manager 2.2.0 supports upgrades from these previous versions:

- 2.0.0 - 2.1.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-2-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **New events for NGINX processes and configuration rollbacks**<a name="2-2-0-whats-new-New-events-for-NGINX-processes-and-configuration-rollbacks"></a>

   Now, you can use the [NGINX Instance Manager Events API]({{< ref "/nim/monitoring/view-events-metrics.md" >}}) or [web interface]({{< ref "/nim/monitoring/view-events-metrics.md" >}}) to view events when NGINX instances start and reload or when a configuration is rolled back.

- {{% icon-feature %}} **Filter events and metrics with custom date and time ranges**<a name="2-2-0-whats-new-Filter-events-and-metrics-with-custom-date-and-time-ranges"></a>

   Now you can filter [events]({{< ref "/nim/monitoring/view-events-metrics" >}}) and [metrics]({{< ref "/nim/monitoring/view-events-metrics" >}}) using a custom date and time range. Select **Custom time range** in the filter list, then specify the date and time range you want to use.

- {{% icon-feature %}} **Role-based access control added to Events and Metrics pages**<a name="2-2-0-whats-new-Role-based-access-control-added-to-Events-and-Metrics-pages"></a>

   A warning message is shown when users try to view the Events and Metrics pages in the web interface if they don't have permission to access the Analytics feature. For instructions on assigning access to features using role-based access control (RBAC), see [Set Up RBAC]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}).

- {{% icon-feature %}} **Modules field added to Metrics and Dimensions catalogs**<a name="2-2-0-whats-new-Modules-field-added-to-Metrics-and-Dimensions-catalogs"></a>

   A `modules` field was added to the [Metics]({{< ref "/nim/monitoring/catalogs/metrics.md" >}}) and [Dimensions]({{< ref "/nim/monitoring/catalogs/dimensions.md" >}}) catalogs. This field indicates which module or modules the metric or dimension belongs to.

- {{% icon-feature %}} **Adds reporting for NGINX worker metrics (API only)**<a name="2-2-0-whats-new-Adds-reporting-for-NGINX-worker-metrics-(API-only)"></a>

   The NGINX Agent now gathers metrics for NGINX workers. You can access these metrics using the NGINX Instance Manager Metrics API.

  The following worker metrics are reported:

  - The count of NGINX workers
  - CPU, IO, and memory usage


### Resolved Issues{#2-2-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Running Agent install script with sh returns “not found” error  (33385)


### Known Issues{#2-2-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.1.0

April 05, 2022

### Upgrade Paths {#2-1-0-upgrade-paths}

NGINX Instance Manager 2.1.0 supports upgrades from these previous versions:

- 2.0.0 - 2.0.1

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### What's New{#2-1-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **Adds Docker support for NGINX Agent**<a name="2-1-0-whats-new-Adds-Docker-support-for-NGINX-Agent"></a>

   Now you can collect metrics about the Docker containers that the NGINX Agent is running in. The NGINX Agent uses the available cgroup files to calculate metrics like CPU and memory usage.

  If you have multiple Docker containers on your data plane host, each container registers with Instance Manager as unique.

  Refer to the [NGINX Agent Docker Support](https://docs.nginx.com/nginx-agent/installation-upgrade/container-environments/docker-support/) guide for details.

  {{< call-out "note" >}}Containerizing the NGINX Agent is supported only with Docker at the moment. Look for additional container support in future releases of Instance Manager.{{< /call-out >}}

- {{% icon-feature %}} **Redesigned metrics views in the web interface**<a name="2-1-0-whats-new-Redesigned-metrics-views-in-the-web-interface"></a>

   The metrics pages in the web interface have been revised and improved.

  See the [View Metrics]({{< ref "/nim/monitoring/view-events-metrics" >}}) topic to get started.

- {{% icon-feature %}} **New RBAC lets you limit access to NGINX Instance Manager features**<a name="2-1-0-whats-new-New-RBAC-lets-you-limit-access-to-NGINX-Instance-Manager-features"></a>

   RBAC has been updated and improved. Add users to roles -- or add users to user groups if you're using an external identity provider -- to limit access to Instance Manager features.

  For more information, see the tutorial [Set Up RBAC]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}).

- {{% icon-feature %}} **Improved certificate handling**<a name="2-1-0-whats-new-Improved-certificate-handling"></a>

   Stability and performance improvements for managing certificates using the web interface.

- {{% icon-feature %}} **View events for your NGINX instances**<a name="2-1-0-whats-new-View-events-for-your-NGINX-instances"></a>

   Now you can use the Instance Manager API or web interface to view events for your NGINX instances.

  See the [View Events]({{< ref "/nim/monitoring/view-events-metrics" >}}) and [View Events (API)]({{< ref "/nim/monitoring/view-events-metrics" >}}) topics for instructions.

- {{% icon-feature %}} **Deploy NGINX Instance Manager on Kubernetes using a helm chart**<a name="2-1-0-whats-new-Deploy-NGINX-Instance-Manager-on-Kubernetes-using-a-helm-chart"></a>

   We recommend using the Instance Manager helm chart to install Instance Manager on Kubernetes.

  Among the benefits of deploying from a helm chart, the chart includes the required services, which you can scale independently as needed; upgrades can be done with a single helm command; and there's no requirement for root privileges.

  For instructions, see [Install from a Helm Chart]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md" >}}).


### Changes in Default Behavior{#2-1-0-changes-in-behavior}
This release has the following changes in default behavior:

- {{% icon-feature %}} **Tags are no longer enforced for RBAC or set when creating or updating a role**<a name="2-1-0-changes-in-behavior-Tags-are-no-longer-enforced-for-RBAC-or-set-when-creating-or-updating-a-role"></a>

  If you're using tags for RBAC on an earlier version of Instance Manager, you'll need to re-create your roles after upgrading. Tags assigned to instances for the purpose of RBAC won't be honored after you upgrade.

- {{% icon-feature %}} **The DeploymentDetails API now requires values for `failure` and `success`**<a name="2-1-0-changes-in-behavior-The-DeploymentDetails-API-now-requires-values-for-`failure`-and-`success`"></a>

  The DeploymentDetails API spec has changed. Now, the `failure` and `success` fields are required. The values can be an empty array or an array of UUIDs of NGINX instances.

  Endpoint: `/systems/instances/deployments/{deploymentUid}`

  Example JSON Response

  ```json
          {
            "createTime": "2022-04-18T23:09:16Z",
            "details": {
              "failure": [ ],
              "success": [
                {
                  "name": "27de7cb8-f7d6-3639-b2a5-b7f48883aee1"
                }
              ]
            },
            "id": "07c6101e-27c9-4dbb-b934-b5ed75e389e0",
            "status": "finalized",
            "updateTime": "2022-04-18T23:09:16Z"
          }
  ```


### Resolved Issues{#2-1-0-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Unable to register multiple NGINX Agents in containers on the same host (30780)
- {{% icon-resolved %}} Include cycles in the configuration cause analyzer to spin. (31025)
- {{% icon-resolved %}} System reports "error granting scope: forbidden" if user granting permissions belongs to more than one role (31215)
- {{% icon-resolved %}} When using Instance Groups, tag-based access controls are not enforced (31267)
- {{% icon-resolved %}} Bad Gateway (502) errors with Red Hat 7 (31277)


### Known Issues{#2-1-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.0.1

January 27, 2022

### Upgrade Paths {#2-0-1-upgrade-paths}

NGINX Instance Manager 2.0.1 supports upgrades from these previous versions:

- 2.0.0

If your NGINX Instance Manager version is older, you may need to upgrade to an intermediate version before upgrading to the target version.

### Resolved Issues{#2-0-1-resolved-issues}

This release fixes the following issues. Check the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic for more information on the latest resolved issues. Use your browser's search function to find the issue ID in the page.

- {{% icon-resolved %}} Unable to access the NGINX Instance Manager web interface after loading SELinux policy (31583)
- {{% icon-resolved %}} The `nms-dpm` service restarts when registering multiple NGINX Agents with the same identity (31612)


### Known Issues{#2-0-1-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.

---

## 2.0.0

December 21, 2021


### What's New{#2-0-0-whats-new}
This release includes the following updates:

- {{% icon-feature %}} **(Experimental) Share a configuration across multiple instances**<a name="2-0-0-whats-new-(Experimental)-Share-a-configuration-across-multiple-instances"></a>

   With a feature called **Instance Groups**, you can share the same configuration across multiple instances. So, if your website requires a number of instances to support the load, you can publish the same configuration to each instance with ease.

- {{% icon-feature %}} **More metrics and instance dashboards**<a name="2-0-0-whats-new-More-metrics-and-instance-dashboards"></a>

   Instance Manager now collects additional metrics from the NGINX instances. We also added pre-configured dashboards to the web interface for each NGINX instance managed by Instance Manager. See the [Catalog Reference]({{< ref "/nim/monitoring/catalogs/" >}}) documentation for a complete list of metrics.

- {{% icon-feature %}} **New architecture!**<a name="2-0-0-whats-new-New-architecture!"></a>

   We redesigned and improved the architecture of Instance Manager!

- {{% icon-feature %}} **Improved user access control**<a name="2-0-0-whats-new-Improved-user-access-control"></a>

   Instance Manager 2.x. allows you to create user access controls with tags. Administrators can grant users read or write access to perform instance management tasks. And admins can grant or restrict access to the Settings options, such as managing licenses and creating users and roles. See the [Set up Authentication]({{< ref "/nim/admin-guide/authentication/basic-auth/set-up-basic-authentication.md#rbac" >}}) guide for more details.



### Known Issues{#2-0-0-known-issues}

You can find information about known issues in the [Known Issues]({{< ref "/nim/releases/known-issues.md" >}}) topic.
