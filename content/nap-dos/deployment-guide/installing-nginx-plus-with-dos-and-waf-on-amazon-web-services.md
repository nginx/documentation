---
description: Install F5 NGINX Plus, NGINX App Protect WAF + DoS on Amazon Web Services
  (AWS), to provide sophisticated Layer 7 load balancing, Modern app security solution,
  behavioral DoS detection and mitigation that works seamlessly in DevOps environments
  for your apps running on CentOS, RHEL, Debian and Ubuntu Linux OS.
docs: DOCS-1204
title: NGINX App Protect WAF + DoS AMIs on Amazon EC2
toc: true
weight: 110
type:
- how-to
---

NGINX, Inc. participates in the Amazon Web Services (AWS) Partner Network as a Standard Technology Partner. We offer Amazon Machine Images (AMIs) for use in the Amazon Elastic Compute Cloud (EC2), available at the AWS Marketplace for several operating systems, including Amazon Linux, Red Hat Enterprise Linux, and Ubuntu.

The AMIs contain combination of the following components:

- Latest version of [F5 NGINX Plus](https://www.f5.com/products/nginx/nginx-plus), optimized for use on Amazon EC2

- Latest version of [NGINX App Protect DoS](https://docs.nginx.com/nginx-app-protect-dos/), optimized for use on Amazon EC2
- Latest version of [NGINX App Protect WAF](https://docs.nginx.com/nginx-app-protect-waf/), optimized for use on Amazon EC2
- Pre-packaged software for building highly available (HA) NGINX Plus configurations

## Installing the NGINX Plus NGINX App Protect WAF + DoS

To quickly set up an environment with NGINX Plus, NGINX App Protect WAF and NGINX App Protect DoS on AWS:

1. Follow the instructions in [Getting Started with Amazon EC2 Linux Instances](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html) to sign up on AWS and get more information about EC2 itself.
2. Proceed to the product page for the appropriate AMI at the AWS Marketplace, and launch the AMI.

    - [NGINX Plus with NGINX App Protect DoS – RHEL 7 Linux AMI HVM](https://aws.amazon.com/marketplace/pp/prodview-bjdboufufnb7g?sr=0-4&ref_=beagle&applicationId=AWSMPContessa)

    - [NGINX Plus with NGINX App Protect DoS – RHEL8 Linux AMI HVM](https://aws.amazon.com/marketplace/pp/prodview-e6bifer7o6uzm?sr=0-13&ref_=beagle&applicationId=AWSMPContessa)

    - [NGINX Plus with NGINX App Protect DoS – CentOS 7 Linux AMI HVM](https://aws.amazon.com/marketplace/pp/prodview-deeny2oe7izti?sr=0-12&ref_=beagle&applicationId=AWSMPContessa)

    - [NGINX Plus with NGINX App Protect DoS – Debian 11 Linux AMI HVM](https://aws.amazon.com/marketplace/pp/prodview-56oveh2rsxsbq?sr=0-2&ref_=beagle&applicationId=AWSMPContessa)

    - [NGINX Plus with NGINX App Protect DoS – Ubuntu 20.04 Linux AMI HVM](https://aws.amazon.com/marketplace/pp/prodview-gsoln2vnsgpr4?sr=0-5&ref_=beagle&applicationId=AWSMPContessa)

    - [NGINX Plus with NGINX App Protect DoS – Ubuntu 22.04 Linux AMI HVM](https://aws.amazon.com/marketplace/pp/prodview-l6f2q2ykrjufy?sr=0-13&ref_=beagle&applicationId=AWSMPContessa)

    - [NGINX Plus with NGINX App Protect WAF + DoS – RHEL 7 Linux AMI HVM](https://aws.amazon.com/marketplace/pp/prodview-jedbygo6xbvto?sr=0-1&ref_=beagle&applicationId=AWSMPContessa)

    - [NGINX Plus with NGINX App Protect WAF + DoS – RHEL 8 Linux AMI HVM](https://aws.amazon.com/marketplace/pp/prodview-6pvnoyr2mp2co?sr=0-18&ref_=beagle&applicationId=AWSMPContessa)

    - [NGINX Plus with NGINX App Protect WAF + DoS – CentOS 7 Linux AMI HVM](https://aws.amazon.com/marketplace/pp/prodview-jedbygo6xbvto?sr=0-1&ref_=beagle&applicationId=AWSMPContessa)

    - [NGINX Plus with NGINX App Protect WAF + DoS – Debian 11 Linux AMI HVM](https://aws.amazon.com/marketplace/pp/prodview-wbyobl7a55vcu?sr=0-3&ref_=beagle&applicationId=AWSMPContessa)

    - [NGINX Plus with NGINX App Protect WAF + DoS – Ubuntu 20.04 Linux AMI HVM](https://aws.amazon.com/marketplace/pp/prodview-zhxmqlcoylkca?sr=0-2&ref_=beagle&applicationId=AWSMPContessa)

    Click the **Continue to Subscribe** button to proceed to the **Launch on EC2** page.

3. Select the type of launch by clicking the appropriate tab (<span style="white-space: nowrap; font-weight:bold;">1‑Click Launch</span>, **Manual Launch**, or **Service Catalog**). Choose the desired options for billing, instance size, and so on, and click the <span style="white-space: nowrap; font-weight:bold;">Accept Software Terms…</span> button.
4. When configuring the firewall rules, add a rule to accept web traffic on TCP ports 80 and 443 (this happens automatically if you launch from the <span style="white-space: nowrap; font-weight:bold;">1-Click Launch</span> tab).
5. As soon as the new EC2 instance launches, NGINX Plus starts automatically and serves a default **index.html** page. To view the page, use a web browser to access the public DNS name of the new instance. You can also check the status of the NGINX Plus server by logging into the EC2 instance and running this command:

	```nginx
	/etc/init.d/nginx status
	```

  See [NGINX Plus on the AWS Cloud](https://www.nginx.com/resources/datasheets/nginx-quick-start-guide-for-aws/) deployment guide for details.

6. Verify latest NGINX PLUS / NGINX App Protect DoS / NGINX App Protect WAF packages are installed on EC2 after its first start:


     Verify NGINX App Protect WAF latest release from <https://docs.nginx.com/nginx-app-protect-waf/releases/> is

     installed by comparing with installed version from following command on the EC2 machine

      ```shell
      cat /opt/app_protect/VERSION /opt/app_protect/RELEASE
      ```

     Verify NGINX DoS latest release from <https://docs.nginx.com/nginx-app-protect-dos/releases/> is

     installed by comparing with installed version from following command on the EC2 machine

      ```shell
      admd -v
      ```

     Verify NGINX Plus latest release from <https://docs.nginx.com/nginx/releases/> is
     installed by comparing with installed version from following command on the EC2 machine

      ```shell
      nginx -v
      ```

    In case NGINX PLUS / NGINX App Protect DoS / NGINX App Protect WAF packages are not latest release then upgrade the following  with these commands:


    For App Protect DoS solution based on RedHat / CentOS

      ```shell
      sudo service nginx stop
      sudo yum install app-protect-dos
      sudo systemctl start nginx
      ```

    For App Protect DoS solution based on Debian / Ubuntu

      ```shell
      sudo service nginx stop
      sudo apt-get update
      sudo apt-get install app-protect-dos
      sudo service nginx start
      ```

     For App Protect WAF solution based on RedHat / CentOS

      ```shell
      sudo service nginx stop
      sudo yum install app-protect
      sudo systemctl start nginx
      ```

    For App Protect WAF solution based on Debian / Ubuntu

      ```shell
      sudo service nginx stop
      sudo apt-get update
      sudo apt-get install app-protect
      sudo service nginx start
      ```

7. If AMI includes [NGINX App Protect WAF](https://docs.nginx.com/nginx-app-protect-waf/)

    To enable NGINX App Protect WAF use the following steps:

    a. Load the NGINX App Protect WAF module on the main context in the `nginx.conf` file:

    ```shell
    load_module modules/ngx_http_app_protect_module.so;
    ```

    b. Enable NGINX App Protect WAF on an `http/server/location` context in the `nginx.conf` file:

    ```shell
    app_protect_enable on;
    ```

    c. Restart the NGINX service:

    ```shell
    sudo systemctl restart nginx
    ```

   For more configuration information follow [NGINX App Protect WAF Configuration Guide](https://docs.nginx.com/nginx-app-protect-waf/configuration-guide/configuration/).



8. If AMI includes [NGINX App Protect DoS](https://docs.nginx.com/nginx-app-protect-dos/)

    To enable NGINX App Protect DoS use the following steps:

    a. Load the NGINX App Protect DoS module on the main context in the `nginx.conf` file:

    ```shell
    load_module modules/ngx_http_app_protect_dos_module.so;
    ```

    b. Enable NGINX App Protect DoS on an `http/server/location` context in the `nginx.conf` file:

    ```shell
    app_protect_dos_enable on;
    app_protect_dos_name "App1";
    app_protect_dos_policy_file "/etc/app_protect_dos/BADOSDefaultPolicy.json";
    app_protect_dos_monitor uri=serv:80/; # Assuming server_name "serv" on port 80, with the root path "/"
    ```

    c. Enable the L4 accelerated mitigation feature (for Debian11/Ubuntu20.04/RHEL8) in the `http` context of the `nginx.conf` file:

    ```shell
    app_protect_dos_accelerated_mitigation on;
    ```

    d. Restart the NGINX service:

    ```shell
    sudo systemctl restart nginx
    ```

  For more configuration information follow [NGINX App Protect DoS Directives and Policy](https://docs.nginx.com/nginx-app-protect-dos/directives-and-policy/learn-about-directives-and-policy/).



## What If I Need Help?

If you encounter any problems with NGINX Plus configuration, documentation is available at [nginx.org](https://nginx.org/en/docs/) and in the [NGINX Plus Admin Guide](https://docs.nginx.com/nginx/admin-guide/installing-nginx/).

If you encounter any problems with NGINX App Protect DoS configuration, documentation is available at the [NGINX App Protect DoS Troubleshooting Guide](https://docs.nginx.com/nginx-app-protect-dos/troubleshooting-guide/how-to-troubleshoot/).

If you encounter any problems with NGINX App Protect WAF configuration, documentation is available at the [NGINX App Protect WAF Troubleshooting Guide](https://docs.nginx.com/nginx-app-protect-waf/v4/troubleshooting-guide/troubleshooting/).


Customers who purchase an NGINX Plus AMI at the AWS Marketplace are eligible for the AWS support provided by the NGINX, Inc. engineering team. To activate support, submit the [AMI Support Activation](https://www.nginx.com/ami-support-activation/) form (you need your AWS account number). When you request support, we’ll ask you to provide the AWS account number that you registered, along with the IDs of your EC2 instances in some cases.
