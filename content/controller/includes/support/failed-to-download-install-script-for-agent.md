When deploying an NGINX Plus instance, the deployment may fail because the Controller Agent install script doesn't download. When this happens, an error similar to the following is logged to `/var/log/agent_install.log`: "Failed to download the install script for the agent."

Take the following steps to troubleshoot the issue:

- Ensure that ports 443 and 8443 are open between NGINX Controller and the network where the NGINX Plus instance is being deployed.
- Verify that you can communicate with NGINX Controller from the NGINX Plus instance using the NGINX Controller FQDN that you provided when you installed NGINX Controller.
- If you're [deploying an NGINX Plus instance on Amazon Web Services]({{< relref "/infrastructure/instances/add-aws-instance.md" >}}) using a template, ensure that the Amazon Machine Image (AMI) referenced in the `instance_template` has a cURL version of 7.32 or newer.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-358 -->