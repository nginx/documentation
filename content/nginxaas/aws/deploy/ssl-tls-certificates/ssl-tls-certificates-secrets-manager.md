---
title: Add certificates from AWS Secrets Manager
weight: 75
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
---

{{< call-out class="important" title="Placeholder content" >}}
This page contains placeholder documentation for **NGINXaaS for AWS**. Workflows, screenshots, pricing, and UI text described here are illustrative only and do not represent a shipping product.
{{< /call-out >}}

F5 NGINXaaS for AWS can fetch secrets directly from [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html) to use as certificates and keys in your NGINX configuration, ensuring your credentials remain securely within AWS.

## Prerequisites

If you haven't already done so, complete the following prerequisites:

- [Create an NGINXaaS deployment]({{< ref "/nginxaas/aws/deploy/create-deployment/deploy-console.md" >}}).
- Configure IAM Role Federation (OIDC). See [our documentation on setting up IAM Role Federation]({{< ref "/nginxaas/aws/deploy/access-management.md#configure-iam-role-federation" >}}) for exact steps.
  - [Grant access to fetch a secret from AWS Secrets Manager]({{< ref "/nginxaas/aws/deploy/access-management.md#grant-access-to-fetch-a-secret-from-aws-secrets-manager" >}}) by attaching a policy granting `secretsmanager:GetSecretValue` on the secret to the IAM role.

## Add an SSL/TLS certificate to AWS Secrets Manager

To add an SSL/TLS certificate and key as a secret to AWS Secrets Manager,

- Ensure your certificate and key file(s) are in one of our [accepted formats]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/overview.md#supported-certificate-types-and-formats" >}}).
- Follow AWS's [instructions to create a secret in AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/create_secret.html) and store your certificate and key file(s) as the secret value.

{{< call-out class="note" >}}

There are many ways to manage your SSL/TLS certificates and keys. For example, one option is to include the PEM certificate data in the same secret as your private key because NGINX's `ssl_certificate` directive supports a single file containing multiple certificates and a key. See NGINX's [Configuring HTTPS servers](https://nginx.org/en/docs/http/configuring_https_servers.html) guide for more details.

{{< /call-out >}}

## Use an AWS Secrets Manager certificate in an NGINX configuration

To add your AWS Secrets Manager certificate and key to an NGINX configuration in the NGINXaaS console,

- Select **Configurations** in the left menu.
- Select the ellipsis (three dots) next to the configuration you want to edit, and select **Edit**.
- Select {{< icon "plus">}} **Add File**.
- Select **AWS Secrets Manager** as the type of file you want to add.
- Provide the required information:
    {{< table >}}

   | Field                       | Description                  | Note |
   |---------------------------- | ---------------------------- | ---- |
   | Secret ARN       | The Amazon Resource Name (ARN) of the secret in AWS Secrets Manager | The ARN must match the format `arn:aws:secretsmanager:$REGION:$ACCOUNT_ID:secret:$SECRET_NAME`, optionally followed by a version stage such as `AWSCURRENT` or `AWSPENDING`. If you don't specify a version stage, NGINXaaS for AWS fetches the version labeled `AWSCURRENT`. |
   | File Path               | The secret will be written to this file path so it can be used with NGINX directives such as ssl_certificate or ssl_certificate_key in your NGINX configuration. | The path must be unique within the configuration. |

    {{< /table >}}

{{< call-out "tip" "Enable automatic rotation with AWSCURRENT" >}}
If you reference the `AWSCURRENT` version stage (the default when no stage is specified), NGINXaaS for AWS automatically picks up any new secret version AWS Secrets Manager promotes to `AWSCURRENT` without a configuration change. NGINXaaS for AWS applies new versions within four hours. See [Rotate an AWS Secrets Manager certificate (automatic)](#rotate-an-aws-secrets-manager-certificate-automatic) for details.
{{< /call-out >}}

- Update the NGINX configuration to reference the certificate you just added by the path value.
- Select **Add**, **Next**, and then **Save** to save your changes.

## Update your NGINXaaS deployment's NGINX configuration

Before updating your NGINXaaS deployment to use your new NGINX configuration, ensure your deployment already has an [IAM OIDC identity provider and IAM role set up]({{< ref "/nginxaas/aws/deploy/access-management.md#configure-iam-role-federation" >}}) with the `secretsmanager:GetSecretValue` permission granted, so it can fetch certificates. Then, in the NGINXaaS console:

- Select **Deployments**.
- Select the deployment you want to edit.
- In the **Configuration Info** panel, select **Edit**.
- Select the configuration and configuration version created in the last section.
- Select **Update Configuration**.

## Rotate an AWS Secrets Manager certificate (automatic)

If you reference the `AWSCURRENT` version stage for your secret, NGINXaaS for AWS fetches whichever version currently carries that staging label. When you [rotate the secret in AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotate-secrets_how.html) — whether through a configured rotation function or by manually promoting a new version — and AWS Secrets Manager moves the `AWSCURRENT` label to the new version, NGINXaaS for AWS automatically picks up that version within four hours.

If you reference a specific version stage other than `AWSCURRENT` (for example, a custom staging label), NGINXaaS for AWS fetches the secret version that stage points to. When you [move that staging label to a different version in AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/getting-started.html#term_version), NGINXaaS for AWS automatically picks up that version within four hours.

No configuration changes are required in either case. To confirm your deployment is using an updated certificate, check the **Certificates** list for the new serial number or inspect the certificate at your deployment's endpoint.

## Rotate an AWS Secrets Manager certificate (manual)

To immediately refetch secrets without editing your NGINX configuration, use **Reapply Configuration**. This is useful in the following scenarios:

- **New secret version**: You've uploaded a new certificate and want NGINXaaS for AWS to use it right away.
- **IAM Role Federation or permissions fix**: You've updated an IAM OIDC identity provider or granted AWS Secrets Manager permissions and want NGINXaaS for AWS to retry immediately.

To reapply your configuration:

1. In the NGINXaaS console, go to your deployment.
2. Select **Reapply Configuration** in the **Configuration Info** panel.

NGINXaaS for AWS reapplies your current configuration version and immediately refetches all referenced secrets.

## Monitor secret fetch events

NGINXaaS for AWS generates an event each time it fetches or fails to fetch a secret from AWS Secrets Manager. Use these events to track successful rotations and diagnose access failures.

### Event types

{{< table >}}
| Event type | Description |
|---|---|
| Successful Secret Fetch from AWS | The secret was fetched from AWS Secrets Manager and applied to NGINX. |
| Failed Secret Fetch from AWS | NGINXaaS for AWS couldn't fetch the secret. The event message includes the error details. |
{{< /table >}}

### View events in the console

- Select **Overview** in the left menu, then select **Events**. To narrow results to a specific deployment, filter by its object ID using the controls at the top of the page.
- For a summary of recent events for a specific deployment, select **Deployments**, select the deployment, and look for the **Recent Events** card. Select **See Events Details** to go to the full Events page pre-filtered for that deployment.

### Common failure messages and remediation

{{< table >}}
| Message | Likely cause | Remediation |
|---|---|---|
| `Failed to fetch secret ... AccessDeniedException: User: arn:aws:sts::$ACCOUNT_ID:assumed-role/$ROLE_NAME/... is not authorized to perform: secretsmanager:GetSecretValue on resource: $SECRET_ARN` | The IAM role assumed through IAM Role Federation doesn't have the required permission on the secret. | Verify the IAM role has a policy granting `secretsmanager:GetSecretValue` on the secret ARN. |
| `Failed to fetch secret ... ResourceNotFoundException: Secrets Manager can't find the specified secret` or `...can't find the specified secret version` | The secret ARN doesn't exist, or the referenced version stage doesn't point to an existing version. | Confirm the secret ARN is correct and that the specified version stage (for example, `AWSCURRENT`) is assigned to an existing version. |
{{< /table >}}

## What's next

[Upload an NGINX Configuration]({{< ref "/nginxaas/aws/deploy/nginx-configuration/nginx-configuration-console.md" >}})
