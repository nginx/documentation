---
title: Identity and access management
weight: 600
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/deploy/access-management/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
---

F5 NGINXaaS for AWS uses AWS Identity and Access Management (IAM) roles to integrate with AWS services. An NGINXaaS deployment configured with an AWS IAM role has access to the following capabilities:

- Export logs to CloudWatch Logs
- Export metrics to CloudWatch Logs using EMF
- Fetch secrets from AWS Secrets Manager to use in your NGINX Configuration

NGINXaaS acts as a third party accessing your AWS account. To prevent the [confused deputy problem](https://docs.aws.amazon.com/IAM/latest/UserGuide/confused-deputy.html), NGINXaaS uses an external ID when assuming your provided IAM role. To learn more about this pattern, see [AWS documentation on third-party access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_common-scenarios_third-party.html). The external ID is always your NGINXaaS Organization ID.

## Prerequisites

- An AWS account with permissions to create IAM roles and policies
- Your NGINXaaS organization ID, available in the **Organization Info** section of the **Organization Details** page (**Settings** > **Organization Details** on the navigation menu)

## IAM role options

You have flexibility in how to structure IAM roles for your NGINXaaS deployments. Choose an architecture based on your security requirements and operational needs.

### Option 1: Single role for all deployments with shared policies

One IAM role is shared by all deployments, with access policies that apply to all deployments.

**Pros:**

- Simple to set up and maintain
- Fewer roles to manage in your AWS account
- Easier onboarding for new deployments

**Cons:**

- Cannot differentiate permissions between deployments
- All deployments have access to the same resources
- Less granular security boundaries

**Best for:** Development environments, proof-of-concept deployments, or when all deployments require identical permissions.

### Option 2: Single role for all deployments with per-deployment policies

One IAM role is shared by all deployments, but access policies are restricted to specific deployments using the deployment ID in conditions.

**Pros:**

- Fewer roles to manage in your AWS account
- Each deployment can have tailored permissions
- Policies can restrict access per deployment using [session tags]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager.md#iam-role-permissions-policy" >}}) or principal conditions

**Cons:**

- More complex policy conditions
- All deployments must use the same role ARN
- Policy updates affect all deployments

**Best for:** Multi-environment setups where you want per-deployment resource access control without managing multiple roles.

### Option 3: One role per deployment

Each deployment has its own dedicated IAM role with tailored access policies.

**Pros:**

- Maximum granularity and security isolation
- Each deployment can have tailored permissions
- Clear 1:1 mapping between role and deployment simplifies auditing and access revocation

**Cons:**

- More roles to manage in your AWS account
- More setup and maintenance overhead
- Policy duplication if deployments have similar needs

**Best for:** Production environments, strict security requirements, or when deployments require significantly different permissions.

## Key concepts

### External ID

NGINXaaS provides your organization with a unique **External ID** (your organization ID). This ID is used by the NGINXaaS dataplane to assume your IAM role. The External ID prevents unauthorized access by binding the trust relationship to your specific organization.

## How it works

NGINXaaS periodically calls the AWS [AssumeRole](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html) API to obtain temporary credentials for your IAM role. These credentials are valid for the duration of the assume role session (minimum 15 minutes) and are renewed before they expire.

Be aware of the following propagation delays when making changes:

- **Updating a role's trust policy** — Because credentials are cached for the assume role session duration, trust policy changes can take up to 15 minutes to take effect.
- **Updating a role's permissions policy** — Permissions policy changes take effect almost immediately.

## Configure IAM roles

### Step 1: Create a trust policy

Create a JSON file named `trust-policy.json` with the following content. Replace `$ORG_ID` with your organization ID, `$DEPLOYMENT_AWS_ACCOUNT_ID` with the NGINXaaS AWS Account ID from the **Deployment Data** section of the **Details** tab, and `$DEPLOYMENT_ID` with your deployment ID (Option 3 only):

{{< details summary="Trust policy for Option 1 or 2 (shared role)">}}

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowNGINXaaSDeploymentToAssumeRole",
            "Effect": "Allow",
            "Principal": {
                "AWS": ["254908360701", "207423186715", "785021966578", "775935274660", "275859940910"]
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "$ORG_ID"
                }
            }
        },
        {
            "Sid": "AllowTagging",
            "Effect": "Allow",
            "Principal": {
                "AWS": ["254908360701", "207423186715", "785021966578", "775935274660", "275859940910"]
            },
            "Action": "sts:TagSession"
        }
    ]
}
```

{{< /details >}}

{{< details summary="Trust policy for Option 3 (per-deployment role)">}}

For per-deployment roles, restrict the **Principal** to the specific IAM role ARN that NGINXaaS uses for your deployment:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowNGINXaaSDeploymentToAssumeRole",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::$DEPLOYMENT_AWS_ACCOUNT_ID:role/$DEPLOYMENT_ID"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "$ORG_ID"
                }
            }
        },
        {
            "Sid": "AllowTagging",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::$DEPLOYMENT_AWS_ACCOUNT_ID:role/$DEPLOYMENT_ID"
            },
            "Action": "sts:TagSession"
        }
    ]
}
```

{{< /details >}}

### Step 2: Create the IAM role

To create the IAM role, follow [Creating a role with a custom trust policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-custom.html) in the AWS documentation, using the trust policy JSON from Step 1. Record the role **ARN** for use in your NGINXaaS deployment configuration.

Alternatively, to use the AWS CLI, replace `$ROLE_NAME` with a descriptive name (for example, `NGINXaaS-CloudWatch-Role`):

```bash
aws iam create-role --role-name $ROLE_NAME \
    --assume-role-policy-document file://trust-policy.json
```

**Example output:**

```json
{
    "Role": {
        "Path": "/",
        "RoleName": "NGINXaaS-CloudWatch-Role",
        "RoleId": "AIDA...",
        "Arn": "arn:aws:iam::123456789012:role/NGINXaaS-CloudWatch-Role",
        "CreateDate": "2024-01-15T10:30:00+00:00",
        "AssumeRolePolicyDocument": {
            ...
        }
    }
}
```

Record the role ARN for use in your NGINXaaS deployment configuration.

### Step 3: Add inline policies to your role

Add inline policies to your role to grant the permissions your deployment requires. The following sections provide example policies for common use cases.

{{< details summary="Policy for CloudWatch Logs">}}

For a full guide on monitoring and logging with NGINXaaS, see [Enable monitoring]({{< ref "/nginxaas/aws/monitoring/enable-monitoring.md" >}}) and [Enable NGINX logs]({{< ref "/nginxaas/aws/monitoring/enable-nginx-logs.md" >}}).

To add this policy in the AWS Management Console, follow [Adding inline policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-attach-detach.html#add-policies-console) in the AWS documentation. Use the JSON below and name the policy `nginxaas-cloudwatch-logs`.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:nginxaas/*"
        }
    ]
}
```

Alternatively, to use the AWS CLI:

```bash
aws iam put-role-policy --role-name $ROLE_NAME \
    --policy-name nginxaas-cloudwatch-logs \
    --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:nginxaas/*"
        }
    ]
}'
```

{{< /details >}}

{{< details summary="Policy for Secrets Manager">}}

Replace `$SECRET_ARN` with the ARN of your secret. For a full guide on using AWS Secrets Manager with NGINXaaS, see [Add certificates from AWS Secrets Manager]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager.md" >}}).

To add this policy in the AWS Management Console, follow [Adding inline policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-attach-detach.html#add-policies-console) in the AWS documentation. Use the JSON below and name the policy `nginxaas-secrets-manager`.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "$SECRET_ARN"
        }
    ]
}
```

Alternatively, to use the AWS CLI:

```bash
aws iam put-role-policy --role-name $ROLE_NAME \
    --policy-name nginxaas-secrets-manager \
    --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "$SECRET_ARN"
        }
    ]
}'
```

{{< /details >}}

### Step 4: Add the role ARN to your NGINXaaS deployment

In the NGINXaaS Console:

1. On the navigation menu, select **Deployments**.
1. Select the deployment you want to update and select **Edit**.
1. Enter your role ARN, for example, `arn:aws:iam::123456789012:role/NGINXaaS-CloudWatch-Role`, in the **Role ARN** field under the **Identity** section.
1. Select **Save Changes**.

## Monitor role assumption events

NGINXaaS for AWS generates an event when it fails to assume your IAM role. Use these events to diagnose trust policy or permission issues.

### Event types

{{< table >}}

| Event type | Description |
|---|---|
| AWS role assumption failed | NGINXaaS couldn't assume the IAM role configured for your deployment. The event message includes the error details. |

{{< /table >}}

### View events in the console

- Select **Overview** in the left menu, then select **Events**. To narrow results to a specific deployment, filter by its object ID using the controls at the top of the page.
- For a summary of recent events for a specific deployment, select **Deployments**, select the deployment, and look for the **Recent Events** card. Select **See Events Details** to go to the full Events page pre-filtered for that deployment.

### Common failure messages and remediation

{{< table >}}

| Message | Likely cause | Remediation |
|---|---|---|
| `The AWS IAM Role hasn't been set up correctly.` | The role ARN does not exist in the customer account, the trust policy's `sts:ExternalId` condition does not match the NGINXaaS organization ID, or (Option 3 only) the Principal in the trust policy does not match the deployment's IAM role ARN. AWS returns the same error for all cases. | Confirm the role ARN in your deployment's **Identity** section refers to an existing IAM role. If the role exists, verify the `sts:ExternalId` condition matches your NGINXaaS organization ID. For Option 3, also verify the trust policy Principal matches the deployment's IAM role ARN (`arn:aws:iam::$DEPLOYMENT_AWS_ACCOUNT_ID:role/$DEPLOYMENT_ID`). |

{{< /table >}}

## What's next

- [Monitor your deployment]({{< ref "/nginxaas/aws/monitoring/enable-monitoring.md" >}})
- [Enable NGINX Logs]({{< ref "/nginxaas/aws/monitoring/enable-nginx-logs.md" >}})
- [Add certificates from AWS Secrets Manager]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager.md" >}})
- [AWS IAM User Guide](https://docs.aws.amazon.com/iam/)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
