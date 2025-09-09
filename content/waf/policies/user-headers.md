---
# We use sentence case and present imperative tone
title: "User-defined HTTP headers"
# Weights are assigned in increments of 100: determines sorting order
weight: 600
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

HTTP header enforcement refers to the handling of the headers section as a special part of the request. These header elements are parsed and enforced based on header specific criteria. However, it is important to distinguish between 2 distinct types of enforcement for HTTP headers:

* The first type of header enforcement is global enforcement for all header content, regardless of the header field name or value. This type of enforcement enables/disables violations that are effective for all contents of the header section of the request. Examples of this are `VIOL_HEADER_LENGTH` and `VIOL_HEADER_METACHAR`. These violations can be configured in the `blocking-settings` section under the `violations` list in the declarative policy.
* The second type of header enforcement is the ability to configure certain violations that are relevant only to specific header fields. Examples of this are allowing repeated instances of the same header field and enabling/disabling Attack Signature checks for an HTTP header field. These violations are configured in the `headers` section where we configure each HTTP header element separately as an object in the list. Additionally, the corresponding violations need to be enabled in the `blocking-settings` section under the `violations` list for them to be enforced.

As far as the header field enforcement is concerned, the following violations are enabled by default:
* `VIOL_HEADER_REPEATED` (in Block mode)
* `VIOL_MANDATORY_HEADER` (in Alarm mode)

There are 3 additional violations that are part of the header enforcement but are specific to the Cookie header alone:
* `VIOL_COOKIE_LENGTH` (in Alarm mode)
* `VIOL_COOKIE_MALFORMED` (in Block mode)
* `VIOL_COOKIE_MODIFIED` (in Alarm mode)

In the base template, there are 4 header objects configured by default:
* `* (wildcard)` - This entity represents the default action taken for all the header fields that have not been explicitly defined in the headers section.
* `Cookie` - This entity handles the `Cookie` header field; this object is just a placeholder and does not affect configuration (See the cookie note below).
* `Referer` - This entity handles the `Referer` header field.
* `Authorization` - This entity handles the `Authorization` header field.
* `Transfer-Encoding` - This entity handles the `Transfer-Encoding` header field.

It is important to emphasize that the Cookie header field is a special case because its behavior is determined by and configured in the `cookie` policy entity rather than the `header` entity. The `Cookie` HTTP header entity is only a placeholder in that it is read-only and does not affect the way cookies are enforced. To modify the configuration of the cookie header field behavior, modify the respective `cookie` entity in the declarative policy.

It is possible to customize the policy configuration using different enforcement modes of the above two violations, as well as configuring custom header elements. For example, we can add a new header `Myheader` and exclude this header from attack signature checks. Alternatively, we can specify a mandatory header that should be present in all requests being sent to our application.

Following is an example configuration where we enable Header violations in blocking mode, create a custom header `MyHeader`, and configure this custom header to allow multiple occurrences of the same header, disable checking attack signatures for the header, and mark it as optional (not mandatory):

```json
{
    "policy": {
        "name": "user_headers_blocking_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_MANDATORY_HEADER",
                    "block": true
                }
            ]
        },
        "headers": [
            {
                "name": "MyHeader",
                "type": "explicit",
                "decodeValueAsBase64": "disabled",
                "htmlNormalization": false,
                "mandatory": false,
                "allowRepeatedOccurrences": true,
                "checkSignatures": false
            }
        ]
    }
}
```