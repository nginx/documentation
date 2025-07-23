---
description: Install F5 NGINX Plus on Amazon Web Services (AWS), to provide sophisticated
  Layer 7 load balancing for your apps running on Amazon Linux, RHEL, and Ubuntu.
nd-docs: DOCS-411
title: Installing NGINX Plus AMIs on Amazon EC2
toc: true
weight: 300
type:
- how-to
---

NGINX, Inc. participates in the Amazon Web Services (AWS) Partner Network as a Standard Technology Partner. We offer Amazon Machine Images (AMIs) for use in the Amazon Elastic Compute Cloud (EC2), available at the AWS Marketplace for several operating systems, including Amazon Linux, Red Hat Enterprise Linux, and Ubuntu.

The AMIs contain the following components:

- Latest version of [NGINX Plus](https://www.f5.com/products/nginx/nginx-plus), optimized for use on Amazon EC2
- Pre-packaged software for building highly available (HA) NGINX Plus configurations

## Install the F5 NGINX Plus AMI

To quickly set up an NGINX Plus environment on AWS:

1. Follow the instructions in [Getting Started with Amazon EC2 Linux Instances](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html) to sign up on AWS and get more information about EC2 itself.
2. Proceed to the product page for the appropriate AMI at the AWS Marketplace, and launch the AMI.

    - [NGINX Plus – Amazon Linux AMI HVM](https://aws.amazon.com/marketplace/seller-profile?id=741df81b-dfdc-4d36-b8da-945ea66b522c)
    - [NGINX Plus – Red Hat Enterprise Linux 7 AMI HVM](https://aws.amazon.com/marketplace/seller-profile?id=741df81b-dfdc-4d36-b8da-945ea66b522c)
    - [NGINX Plus – Red Hat Enterprise Linux 6 AMI HVM](https://aws.amazon.com/marketplace/seller-profile?id=741df81b-dfdc-4d36-b8da-945ea66b522c)
    - [NGINX Plus – Ubuntu AMI HVM](https://aws.amazon.com/marketplace/seller-profile?id=741df81b-dfdc-4d36-b8da-945ea66b522c)

    Click the **Continue to Subscribe** button to proceed to the **Launch on EC2** page.

3. Select the type of launch by clicking the appropriate tab ({{<nb>}}**1-Click Launch**{{</nb>}}, {{<nb>}}**Manual Launch**{{</nb>}}, or {{<nb>}}**Service Catalog**{{</nb>}}). Choose the desired options for billing, instance size, and so on, and click the {{<nb>}}**Accept Software Terms…**{{</nb>}} button.
4. When configuring the firewall rules, add a rule to accept web traffic on TCP ports 80 and 443 (this happens automatically if you launch from the {{<nb>}}**1-Click Launch**{{</nb>}} tab).
5. As soon as the new EC2 instance launches, NGINX Plus starts automatically and serves a default **index.html** page. To view the page, use a web browser to access the public DNS name of the new instance. You can also check the status of the NGINX Plus server by logging into the EC2 instance and running this command:

	```nginx
	/etc/init.d/nginx status
	```

See [NGINX Plus on the AWS Cloud Quick Start](https://aws.amazon.com/blogs/apn/introducing-a-new-aws-quick-start-nginx-plus-on-the-aws-cloud-in-15-minutes/) deployment guide for details.

## What If I Need Help?

If you encounter any problems with NGINX Plus configuration, documentation is available at [nginx.org](https://nginx.org/en/docs/) and in the [NGINX Plus Admin Guide]({{< ref "/nginx/admin-guide/installing-nginx/" >}}).

Customers who purchase an NGINX Plus AMI at the AWS Marketplace are eligible for the AWS support provided by the NGINX, Inc. engineering team. To activate support, submit the [AMI Support Activation](https://www.nginx.com/ami-support-activation/) form (you need your AWS account number). When you request support, we’ll ask you to provide the AWS account number that you registered, along with the IDs of your EC2 instances in some cases.
