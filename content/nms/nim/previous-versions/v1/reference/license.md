---
title: License Reference
description: "Reference for licensing NGINX Instance Manager."
draft: false
weight: 300
toc: true
categories: ["reference"]
docs: "DOCS-637"
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document is intended to help people understand the licensing for NGINX Instance Manager.

## Summary {#summary}

NGINX Instance Manager is a proprietary product that's licensed as a yearly subscription based on the number of managed instances. A managed instance is an NGINX master process or endpoint running the NGINX agent and connecting back to an NGINX Instance Manager server. The instance count does not apply to the scan feature or any validation run against a mock instance. You may also remove managed instances to add new instances.

## EULA {#eula}

NGINX Instance Manager is licensed under the [F5 standard EULA](https://www.f5.com/pdf/customer-support/end-user-license-agreement.pdf). A copy is provided here with the software and is available from the [F5 website](https://www.f5.com/pdf/customer-support/end-user-license-agreement.pdf). If the copies differ, the [F5 hosted EULA](https://www.f5.com/pdf/customer-support/end-user-license-agreement.pdf) takes precedence over the downloaded or included EULA (as the law permits). You may request a copy of the EULA from your sales team at any time.

EULA for subscription
{{<fa "download">}} {{<link "nim/previous-versions/static/previous-versions/v1/examples/EULA/EULA-SUBSCRIPTION">}}

EULA for trials
{{<fa "download">}} {{<link "nim/previous-versions/static/previous-versions/v1/examples/EULA/EULA-TRIAL">}}

EULA for F5 Products
{{<fa "download">}} {{<link "<https://www.f5.com/pdf/customer-support/end-user-license-agreement.pdf">}}>

## Support {#support}

NGINX Instance Manager is fully supported through the subscription. Support is provided for product features, including the server and agent components. Support is NOT provided for NGINX instances themselves, outside supported functions of NGINX Instance Manager. In other words, this product is not a vehicle for paid support of NGINX Open Source. NGINX Plus would be supported through the existing contract and terms.

## Bundled NGINX Plus {#bundled}

NGINX Plus is included with the NGINX Instance Manager distribution. The use of NGINX Plus is restricted to a frontend proxy and authentication mechanism for the NGINX Instance Manager Server. You may run the proxy and leverage any features available for NGINX Plus in this manner.

Advanced features of NGINX Plus are supported, but configuration and setup are not provided with the subscription. You may need to engage Professional Services or a partner for more advanced configurations, such as OpenID Connect and OAuth2. Examples are provided for advanced users, but the setup and configuration are your responsibility. NGINX Plus is supported for related NGINX Instance Manager use cases.

## Other stuff {#other}

NGINX will provide the best effort for other functions and features not explicitly listed here but related to the use and functionality of NGINX Instance Manager.

## Disclaimer {#disclaimer}

Anything mentioned here is superseded by published licenses, contracts, and agreements you have made with F5 and/or NGINX.
