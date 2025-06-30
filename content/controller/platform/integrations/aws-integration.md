---
description: Integrate F5 NGINX Controller with Amazon Web Services.
nd-docs: DOCS-785
title: AWS Integration
toc: true
weight: 20
type:
- tutorial
---

## AWS Integration Requirements

To create an Integration for AWS, you need to [configure an AWS IAM user](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#iam-user-name-and-password) with the following roles:

```json
"ec2:*Instance*",
"ec2:*Tags*"
```

In addition, you'll need to copy and save the following [AWS security credentials](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) to use when creating an AWS Integration:

- access key ID
- secret access key ID

## Add an AWS Integration

To create an AWS Integration, take the following steps:

1. Open the F5 NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Integrations**.
1. On the **Integrations** menu, select the **Create Integration** quick action.
1. Add a name.
1. (Optional) Add a display name.
1. (Optional) Add a description.
1. (Optional) Add tags.
1. In the **Integration Type** list, select `AWS_INTEGRATION`.
1. (Optional) Add the service endpoint URI.
1. In the **Credential Type** list, select `AWS_ACCESS_KEY`.
1. Add the [access key ID](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html).
1. Add the [secret access key ID](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html).
1. Select **Submit**.

## What's Next

- [Deploy an Instance on Amazon Web Services]({{< ref "/controller/infrastructure/instances/add-aws-instance.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
