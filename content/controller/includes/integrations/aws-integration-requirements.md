To create an Integration for AWS, you need to [configure an AWS IAM user](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#iam-user-name-and-password) with the following roles:

```json
"ec2:*Instance*",
"ec2:*Tags*"
```

In addition, you'll need to copy and save the following [AWS security credentials](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) to use when creating an AWS Integration:

- access key ID
- secret access key ID

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-748 -->