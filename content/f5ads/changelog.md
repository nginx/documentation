---
title: "Changelog"
weight: 1000
toc: true
f5-docs: DOCS-000
url: /f5ads/changelog/
f5-content-type: reference
f5-product: F5 Application Delivery Service for AWS
nollms: true
---

Learn about the latest updates, new features, and resolved bugs in F5 Application Delivery Service for AWS.

To see a list of currently active issues, visit the [Known issues]({{< ref "/f5ads/aws/known-issues.md" >}}) page.

## September 4, 2026

- {{% icon-feature %}} **F5 ADS for AWS is now generally available in more regions**

  F5 ADS for AWS is now available in the following additional regions per geography:

  {{< table "table" >}}

  | F5 ADS Geography | AWS Regions             |
  | --------------- | ----------------------- |
  | CA              | ca-central-1, ca-west-1 |

  {{< /table >}}

See the [Supported regions]({{< ref "/f5ads/aws/overview.md#supported-regions" >}}) documentation for the full list of regions where F5 ADS for AWS is available.

## September 1, 2026

- {{% icon-feature %}} **F5 ADS for AWS now supports F5 WAF for NGINX (Preview)**

You can now deploy F5 ADS with [F5 WAF for NGINX]({{< ref "/waf" >}}); an advanced high-performance web application firewall (WAF) to provide protection from OWASP Top 10 web application security risks.

**Note:** This feature is currently in Preview and free to use during the preview period. Custom security policies and custom logging profiles are not yet supported.

## July 31, 2026

- {{% icon-feature %}} **F5 ADS for AWS is now available (Early Access)**

You can now use F5 Application Delivery Service to integrate with your applications in AWS. This is a major new release allowing you to work in multi-cloud setups or simplify your current AWS presence with a fully-managed, secure NGINX offering.

See the documentation for [F5 ADS for AWS]({{< ref "/f5ads/aws/overview.md" >}}) for more info.

**Note:** This feature is currently in Early Access. Please contact us if you are interested in participating in our Early Access offering by sending an email to <a href="mailto:nginxaas-early-access@f5.com?subject=F5%20ADS%20for%20AWS%20EA%20interest">nginxaas-early-access@f5.com</a>.
