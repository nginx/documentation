---
nd-docs: "DOCS-1611"
---

Clickjacking refers to a technique used by malicious actors to embed remote website content into their malicious websites, tricking the end users to click on the embedded frames triggering actions the users were not aware of, such as liking a certain Facebook page or giving a restaurant a 5 star rating. To protect against such attacks, NGINX App Protect WAF uses the `X-Frame-Options` header capabilities. The `X-Frame-Options` header is injected by NGINX App Protect WAF to indicate to the browser whether it should embed  the content or not. Please note that this additional layer of security is available only in browsers that support the `X-Frame-Options` headers.

##### Configuration

`X-Frame-Options` can be configured as follows:
- X-Frame-Options: `deny` - This option will prevent the browser from displaying the content in a frame, regardless of the website trying to do so.
- X-Frame-Options: `only-same` - This option allows the browser to display the content in a frame only if it comes from the same website.

Please note that a third configuration option was available but it was deprecated by RFC and is not supported by NGINX App Protect WAF.

To enable this protection in NGINX App Protect WAF, we enable the feature for a URL (or for all URLs, via the wildcard URL), and then set the value to be assigned to the `X-Frame-Options` header. Following is an example of a policy enabling the feature for the URL `/clickme`, and using `only-same` as the value for the `X-Frame-Options` header:

```json
{
    "name": "x_frame_options",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "urls": [
        {
            "name": "/clickme",
            "type": "explicit",
            "method": "*",
            "isAllowed": true,
            "clickjackingProtection": true,
            "allowRenderingInFrames": "only-same"
        }
    ]
}
```

In the following example, a policy is created with Clickjacking enabled for the URL `/clickme`, and using `DENY` as the value for the `X-Frame-Options` header:

```json
{
    "name": "x_frame_options",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "urls": [
        {
            "name": "/clickme",
            "type": "explicit",
            "method": "*",
            "isAllowed": true,
            "clickjackingProtection": true,
            "allowRenderingInFrames": "never"
        }
    ]
}
```