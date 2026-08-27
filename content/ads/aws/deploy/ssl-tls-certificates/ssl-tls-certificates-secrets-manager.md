---
title: Add certificates from AWS Secrets Manager
description: "Fetch SSL/TLS certificates for F5 Application Delivery Service for AWS directly from AWS Secrets Manager."
weight: 75
toc: true
f5-docs: DOCS-000
url: /application-delivery-service/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager/
f5-content-type: how-to
f5-product: F5 Application Delivery Service for AWS
f5-keywords: "F5 Application Delivery Service for AWS, AWS Secrets Manager, SSL, TLS, certificates, IAM, automatic rotation, ABAC"
f5-summary: >
  Learn how to fetch SSL/TLS certificates and keys for F5 Application Delivery Service for AWS directly from AWS Secrets Manager, keeping credentials within AWS.
  This guide covers IAM permissions, adding secrets to an NGINX configuration, and automatic and manual certificate rotation.
f5-audience: operator
---

F5 Application Delivery Service for AWS can fetch secrets directly from [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html) to use as certificates and keys in your NGINX configuration, ensuring your credentials remain securely within AWS.

## Prerequisites

If you haven't already done so, [create an F5 Application Delivery Service for AWS deployment]({{< ref "/ads/aws/deploy/create-deployment/deploy-console.md" >}}) with an IAM role. See [Identity and access management]({{< ref "/ads/aws/deploy/access-management.md" >}}) for more information.

### IAM role permissions policy

To allow F5 Application Delivery Service for AWS access to your AWS Secrets Manager secrets, you must attach a permissions policy to your IAM role. The policy must allow the `secretsmanager:GetSecretValue` action. For example, the following policy allows access to the specified secret.

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": "secretsmanager:GetSecretValue",
			"Resource": "arn:aws:secretsmanager:us-east-1:123456789012:secret:secretName-AbCdEf"
		}
	]
}
```

See [AWS Secrets Manager identity-based policies](https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access_iam-policies.html#auth-and-access_examples_identity_read) for more examples.

F5 Application Delivery Service for AWS also supports attribute-based access control (ABAC) by restricting access based on tag attributes. For example, the following policy allows only the specified F5 Application Delivery Service for AWS deployment to access the secret. 

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": "secretsmanager:GetSecretValue",
			"Resource": "arn:aws:secretsmanager:us-east-1:123456789012:secret:secretName-AbCdEf",
			"Condition": {
				"StringEquals": {
					"aws:PrincipalTag/F5 Application Delivery Service for AWS:DeploymentName": "test-deployment"
				}
			}
		}
	]
}
```

The session tags passed in the request to fetch the secret will appear in `AssumeRole` [events in CloudTrail](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_session-tags.html#id_session-tags_ctlogs). The following tags are supported:

- `F5 Application Delivery Service for AWS:OrganizationID`
- `F5 Application Delivery Service for AWS:DeploymentID`
- `F5 Application Delivery Service for AWS:DeploymentName`

## Add an SSL/TLS certificate to AWS Secrets Manager

To add an SSL/TLS certificate and key as a secret to AWS Secrets Manager,

1. Make sure your certificate and key file(s) are in one of the [accepted formats]({{< ref "/ads/aws/deploy/ssl-tls-certificates/overview.md#supported-certificate-types-and-formats" >}}).
1. Follow AWS's [instructions to create a secret in AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/create_secret.html) and set your certificate and private key file contents as the `plaintext` secret value.

{{< call-out class="note" title="Note" >}}

There are many ways to manage your SSL/TLS certificates and keys. For example, you can include the PEM certificate data in the same secret as your private key. The `ssl_certificate` directive supports a single file containing multiple certificates and a key. See NGINX's [Configuring HTTPS servers](https://nginx.org/en/docs/http/configuring_https_servers.html) guide for more details.

{{< /call-out >}}

## Use an AWS Secrets Manager certificate in an NGINX configuration

To add your AWS Secrets Manager certificate and key to an NGINX configuration in the F5 Application Delivery Service for AWS console,

1. Select **Configurations** in the left menu.
2. Select the ellipsis (three dots) next to the configuration you want to edit, and select **Edit**.
3. Select {{< icon "plus">}} **Add File**.
4. Select **Cloud Provider Secret** as the type of file you want to add.
5. Select  **AWS Secrets Manager** as the **Cloud Secret Manager**.
6. Provide the required information:
    {{< table >}}

   | Field                       | Description                  | Note |
   |---------------------------- | ---------------------------- | ---- |
   | Secret ARN              | The Amazon Resource Name (ARN) of the secret in AWS Secrets Manager | The ARN must match the format `arn:<PARTITION>:secretsmanager:<REGION>:<ACCOUNT_ID>:secret:<SECRET_NAME>-<6_RANDOM_CHARACTERS>`. |
   | Version Stage           | The staging label of the secret version. | Version stage is optional and cannot be specified at the same time as Version ID. If you don't specify a version stage or a version ID, F5 Application Delivery Service for AWS fetches the version labeled `AWSCURRENT`. See AWS's [documentation on secret versions](https://docs.aws.amazon.com/secretsmanager/latest/userguide/whats-in-a-secret.html#term_version) for more information. |
   | Version ID              | The unique identifier of the secret version. | Version ID is optional and cannot be specified at the same time as version stage. If you don't specify a version stage or a version ID, F5 Application Delivery Service for AWS fetches the version labeled `AWSCURRENT`. |
   | File Path               | F5 Application Delivery Service for AWS writes the secret to this file path, so it can be used with NGINX directives such as `ssl_certificate` or `ssl_certificate_key` in your NGINX configuration. | The path must be unique within the configuration. See the [NGINX Filesystem Restrictions table]({{< ref "/ads/aws/deploy/nginx-configuration/configuration-rules.md#nginx-filesystem-restrictions" >}}) for the allowed directories the file can be written to. |

    {{< /table >}}

{{< call-out "tip" "Enable automatic rotation with AWSCURRENT" >}}
If you set the **Version Stage** to `AWSCURRENT` or leave **Version Stage** and **Version ID** unspecified, F5 Application Delivery Service for AWS automatically picks up any new secret version AWS Secrets Manager promotes to `AWSCURRENT` without a configuration change. F5 Application Delivery Service for AWS applies new versions within four hours. See [Rotate an AWS Secrets Manager certificate (automatic)](#rotate-an-aws-secrets-manager-certificate-automatic) for details.
{{< /call-out >}}

7. Update the NGINX configuration to reference the certificate you just added by the path value.
8. Select **Add**, **Next**, and then **Save** to save your changes.

## Update your F5 Application Delivery Service for AWS deployment's NGINX configuration

Before updating your F5 Application Delivery Service for AWS deployment to use your new NGINX configuration, make sure your deployment already has an [IAM role set up]({{< ref "/ads/aws/deploy/access-management.md" >}}) with the `secretsmanager:GetSecretValue` permission granted, so it can fetch certificates. Then, in the F5 Application Delivery Service for AWS console:

1. Select **Deployments**.
1. Select the deployment you want to edit.
1. In the **Configuration Info** panel, select **Edit**.
1. Select the configuration and configuration version created in the last section.
1. Select **Update Configuration**.

{{< call-out class="note" title="Note" >}}

Configurations with AWS Secrets Manager secrets can only be added to AWS deployments.

{{< /call-out >}}

## Rotate an AWS Secrets Manager certificate (automatic)

If you set the **Version Stage** to `AWSCURRENT` or leave **Version Stage** and **Version ID** unspecified, F5 Application Delivery Service for AWS fetches the latest secret version. When you [update the value of a secret](https://docs.aws.amazon.com/secretsmanager/latest/userguide/manage_update-secret-value.html) or [configure an AWS Lambda function to rotate the secret](https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotate-secrets_lambda.html), AWS Secrets Manager moves the `AWSCURRENT` label to the new secret version. F5 Application Delivery Service for AWS automatically picks up that new version within four hours.

If you set the **Version Stage** to a staging label other than `AWSCURRENT`, F5 Application Delivery Service for AWS fetches the secret version the staging label points to. When you [move a staging label to point to a different secret in AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_UpdateSecretVersionStage.html), F5 Application Delivery Service for AWS automatically picks up that secret within four hours.

No configuration changes are required in either case. To confirm your deployment is using an updated certificate, check the **Certificates** list for the new serial number or inspect the certificate at your deployment's endpoint.

## Rotate an AWS Secrets Manager certificate (manual)

To immediately refetch secrets without editing your NGINX configuration, use **Reapply Configuration**. This is useful in the following scenarios:

- **New secret version**: You've uploaded a new certificate and want F5 Application Delivery Service for AWS to use it right away.
- **Updated IAM role or permissions**: You've updated your IAM role trust policy or permissions policy and want F5 Application Delivery Service for AWS to retry immediately.

To reapply your configuration:

1. In the F5 Application Delivery Service for AWS console, go to your deployment.
2. Select **Reapply Configuration** in the **Configuration Info** panel.

F5 Application Delivery Service for AWS reapplies your current configuration version and immediately refetches all referenced secrets.

## Monitor secret fetch events

F5 Application Delivery Service for AWS generates an event each time it fetches or fails to fetch a secret from AWS Secrets Manager. Use these events to track successful rotations and diagnose access failures.

### Event types

{{< table >}}
| Event type | Description |
|---|---|
| Successful Secret Fetch from AWS | The secret was fetched from AWS Secrets Manager and applied to NGINX. |
| Failed Secret Fetch from AWS | F5 Application Delivery Service for AWS couldn't fetch the secret. The event message includes the error details. |
{{< /table >}}

### View events in the console

- Select **Overview** in the left menu, then select **Events**. To narrow results to a specific deployment, filter by its object ID using the controls at the top of the page.
- For a summary of recent events for a specific deployment, select **Deployments**, select the deployment, and look for the **Recent Events** card. Select **See Events Details** to go to the full Events page pre-filtered for that deployment.

### Common failure messages and remediation

{{< table >}}
| Message | Likely cause | Remediation |
|---|---|---|
| `operation error Secrets Manager: GetSecretValue, get identity: get credentials: failed to refresh cached credentials, operation error STS: AssumeRole...` | The IAM role's trust policy is not configured correctly. | Verify the IAM role trust policy allows `sts:AssumeRole` and `sts:TagSession` on the F5 Application Delivery Service for AWS principal. |
| `AccessDeniedException... no identity-based policy allows the secretsmanager:GetSecretValue action` | The IAM role's permissions policy is not configured correctly. | Verify the IAM role has a permissions policy allowing `secretsmanager:GetSecretValue` on the secret ARN and any tag attribute conditions are met. |
| `ResourceNotFoundException: Secrets Manager can't find the specified secret...` | The secret ARN doesn't exist, or the referenced version stage or version ID doesn't point to an existing version. | Confirm the secret ARN is correct and that the specified version stage or version ID is assigned to an existing version. |
{{< /table >}}

## What's next

[Upload an NGINX Configuration]({{< ref "/ads/aws/deploy/nginx-configuration/nginx-configuration-console.md" >}})
