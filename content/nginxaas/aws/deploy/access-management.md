---
title: Identity and access management
weight: 600
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/deploy/access-management/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
---

{{< call-out class="important" title="Placeholder content" >}}
This page contains placeholder documentation for **NGINXaaS for AWS**. Workflows, screenshots, pricing, and UI text described here are illustrative only and do not represent a shipping product.
{{< /call-out >}}

F5 NGINXaaS for AWS uses IAM Role Federation (OIDC) to integrate with AWS services. For example, with IAM Role Federation configured, your NGINXaaS deployment can perform the following integrations:

 - export logs to Amazon CloudWatch Logs
 - export metrics to Amazon CloudWatch
 - fetch secrets from AWS Secrets Manager

To learn more, see [AWS's documentation on IAM roles for OpenID Connect (OIDC) federation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_oidc.html).

## Prerequisites

- In the AWS account you're configuring IAM Role Federation in, you need the following permissions to create an IAM OIDC identity provider, IAM role, and policy bindings:
    - [iam:CreateOpenIDConnectProvider](https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateOpenIDConnectProvider.html)
    - [iam:CreateRole](https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateRole.html) and [iam:PutRolePolicy](https://docs.aws.amazon.com/IAM/latest/APIReference/API_PutRolePolicy.html)
- An NGINXaaS deployment. See [our documentation on creating an NGINXaaS deployment]({{< ref "/nginxaas/aws/deploy/create-deployment/" >}}) for a step-by-step guide.

## Configure IAM Role Federation

### Create an IAM OIDC identity provider

1. Create an IAM OIDC identity provider. See [AWS's documentation on creating an OIDC identity provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html) for a step-by-step guide. Set up the provider settings as follows:
    - `Provider URL` must be `https://oidc.nginxaas.net`.
    - `Audience` must contain the full canonical identifier of your NGINXaaS deployment, for example, `nginxaas:aws:<account-id>:deployment/<deployment-id>`. If `Audience` is empty, the canonical identifier of the deployment will be included by default.
1. Create an IAM role that trusts the identity provider. See [AWS's documentation on creating a role for OIDC federation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html) for a step-by-step guide.
    - Add the following **trust policy condition**: `StringEquals` on `oidc.nginxaas.net:sub` equal to `$NGINXAAS_DEPLOYMENT_SUBJECT_ID`, where `$NGINXAAS_DEPLOYMENT_SUBJECT_ID` is the unique OIDC subject identifier of your NGINXaaS deployment. This ID can be found in the `NGINXaaS OIDC Subject Identifier` field under the **Cloud Info** section in the **Details** tab of your deployment.

### Grant access to the IAM role with your desired permissions

Depending on your use case, you will need to attach certain permission policies to the IAM role you created. See [AWS's documentation on adding IAM identity permissions](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-attach-detach.html) for more information.

{{< details summary="Grant access to export logs to a CloudWatch Logs log group">}}

To grant access to export logs to a log group, `$LOG_GROUP_ARN`, in the [AWS Management Console](https://console.aws.amazon.com/),

1. Go to the **IAM** console and select the role you created for NGINXaaS for AWS.
1. Select **Add permissions** > **Create inline policy**.
1. Add a statement granting `logs:CreateLogStream` and `logs:PutLogEvents` on `$LOG_GROUP_ARN`.
1. Name and save the policy.

Alternatively, to use the AWS CLI, you can run the following `aws` command:

```bash
aws iam put-role-policy \
    --role-name "$NGINXAAS_ROLE_NAME" \
    --policy-name nginxaas-log-writer \
    --policy-document '{
      "Version": "2012-10-17",
      "Statement": [{
        "Effect": "Allow",
        "Action": ["logs:CreateLogStream", "logs:PutLogEvents"],
        "Resource": "'"$LOG_GROUP_ARN"'"
      }]
    }'
```

{{< /details >}}

{{< details summary="Grant access to export metrics to a CloudWatch namespace">}}

To grant access to publish metrics to Amazon CloudWatch, in the [AWS Management Console](https://console.aws.amazon.com/), perform the following steps.

1. Go to the **IAM** console and select the role you created for NGINXaaS for AWS.
1. Select **Add permissions** > **Create inline policy**.
1. Add a statement granting `cloudwatch:PutMetricData`, optionally scoped with a `cloudwatch:namespace` condition to the `NGINXaaS` namespace.
1. Name and save the policy.

Alternatively, to use the AWS CLI, you can run the following `aws` command:

```bash
aws iam put-role-policy \
    --role-name "$NGINXAAS_ROLE_NAME" \
    --policy-name nginxaas-metric-writer \
    --policy-document '{
      "Version": "2012-10-17",
      "Statement": [{
        "Effect": "Allow",
        "Action": "cloudwatch:PutMetricData",
        "Resource": "*",
        "Condition": {"StringEquals": {"cloudwatch:namespace": "NGINXaaS"}}
      }]
    }'
```

{{< /details >}}

{{< details summary="Grant access to fetch a secret from AWS Secrets Manager">}}

To grant access to fetch a secret, `$SECRET_ARN`, in the [AWS Management Console](https://console.aws.amazon.com/),

1. Go to the **IAM** console and select the role you created for NGINXaaS for AWS.
1. Select **Add permissions** > **Create inline policy**.
1. Add a statement granting `secretsmanager:GetSecretValue` on `$SECRET_ARN`.
1. Name and save the policy.

Alternatively, to use the AWS CLI, you can run the following `aws` command:

```bash
aws iam put-role-policy \
    --role-name "$NGINXAAS_ROLE_NAME" \
    --policy-name nginxaas-secret-accessor \
    --policy-document '{
      "Version": "2012-10-17",
      "Statement": [{
        "Effect": "Allow",
        "Action": "secretsmanager:GetSecretValue",
        "Resource": "'"$SECRET_ARN"'"
      }]
    }'
```

If you would like to fetch more than one secret, you will need to grant access on each secret ARN, or use a wildcard resource pattern that matches your secrets.

{{< /details >}}

### Update your NGINXaaS deployment with the ARN of your IAM role

In the NGINXaaS Console,

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Enter your role ARN, for example, `arn:aws:iam::<account-id>:role/<role-name>`, under **IAM Role ARN**.
1. Select **Update**.

## What's next

- [Monitor your deployment]({{< ref "/nginxaas/aws/monitoring/enable-monitoring.md" >}})
- [Enable NGINX Logs]({{< ref "/nginxaas/aws/monitoring/enable-nginx-logs.md" >}})
