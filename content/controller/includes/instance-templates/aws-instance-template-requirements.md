You'll need to gather the following AWS information to create an Instance Template for AWS NGINX instances. You may need to look up this information in your AWS account.

- [Amazon Machine Image ID](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)

  The AMI that you select should be secure and hardened. We recommend closing ports that are not needed and updating the AMI to include the latest security patches. NGINX Controller will not secure or update this Instance for you.  

  The AMI must be an operating system that is supported by the NGINX Controller Agent. For the list of supported OSes, see the [NGINX Controller Technical Specifications Guide]({{< relref "/admin-guides/install/nginx-controller-tech-specs.md" >}}).

  The AMI image must have the following software packages installed:

  - NGINX Plus (R19, R20, R21, R22, or R23)
  - Python 2.7 (for NGINX Controller 3.6 and earlier)
  - Golang (for NGINX Controller 3.7 and newer)
  - OpenSSL
  - cURL 7.32 or newer
  - libxerces-c3.2
  - Cloud-init

- [EC2 Instance Type](https://aws.amazon.com/ec2/instance-types/)

  After you've configured the AMI, you need to define the EC2 Instance size. You can find the EC2 Instance sizes that your region supports here: [https://aws.amazon.com/ec2/instance-types/](https://aws.amazon.com/ec2/instance-types/).

- [Subnet ID](https://docs.aws.amazon.com/vpc/latest/userguide/working-with-vpcs.html)
  
  The SubnetId identifies the specific subnet contained within your VPC that you want to deploy your Instance into.

- [Security Group IDs](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)

  The security group controls traffic flowing to and from your NGINX Instances. You need to use the GroupId from the security group to configure your Instance Template.

  The GroupId you select must have ports 22, 443, and 8443 opened to allow communication from NGINX Plus to NGINX Controller. We recommend opening only ports 22 and 8443 to the IP address that NGINX Controller is using. The ports that your applications use will require other ports to be open. If your HTTP application is running on this NGINX Plus Instance, you need to open port 80.

  The security group you select should use the same VPC ID that was configured with your Location.

- [AWS Public Key](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

  The [AWS public key](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) is the key that allows NGINX Controller to communicate with your NGINX Plus orchestrated Instance. You need this key so you can install updates. If you do not want to provide your public key, you need to manually install the NGINX Controller agent. You will copy/paste your ssh key name into this field.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-740 -->