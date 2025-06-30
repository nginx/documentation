---
nd-docs: "DOCS-1552"
---

#### XFF Headers and Trust

XFF trust is disabled by default but can be enabled.

In this example, we use the default configuration but enable the trust of XFF header.

```json
{
    "policy": {
        "name": "xff_enabled",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "general": {
            "customXffHeaders": [],
            "trustXff": true
        }
    }
}
```


In this example, we configure a policy with a custom-defined XFF header.

```json
{
    "policy": {
        "name": "xff_custom_headers",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "general": {
            "customXffHeaders": [
                "xff"
            ],
            "trustXff": true
        }
    }
}
```

#### Blocking Page Customization

You can customize the blocking page text and formatting to suit your particular design requirements.

In this example, we use the default configuration but modify the response page that is displayed to the customer.

```json
 {
    "policy": {
        "name": "blocking_page",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "response-pages": [
            {
                "responseContent": "<html><head><title>Custom Reject Page</title></head><body>This is a custom response page; it is supposed to overwrite the default page with custom text.<br><br>Your support ID is: <%TS.request.ID()%><br><br><a href='javascript:history.back();'>[Go Back]</a></body></html>",
                "responseHeader": "HTTP/1.1 200 OK\r\nCache-Control: no-cache\r\nPragma: no-cache\r\nConnection: close",
                "responseActionType": "custom",
                "responsePageType": "default"
            }
        ]
    }
}
```


#### AJAX Response Page for Single Page Applications (SPAs)

There is a special scenario where default or regular custom response pages cannot be used. SPAs (Single Page Applications) are applications that provide application functionality within the boundaries of a single HTML page. Once a SPA application has been loaded in the browser, it typically makes REST API calls to remote resources expecting JSON response bodies rather than HTML markup. If this SPA application were to receive a default HTML-formatted block page, it would not be able to interpret this, likely causing an application error.

A way to handle such a situation is via configuring an AJAX response page. The AJAX response page will cause a pop-up to appear on the client browser, informing them that the request has been blocked.

In this example, we set up an AJAX response page.

```json
{
    "policy": {
        "name": "NGINX-SPA",
        "description": "Policy with AJAX response page enabled for blocking AJAX requests",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "enforcementMode": "blocking",
        "response-pages": [
            {
                "responsePageType": "ajax",
                "ajaxEnabled": true,
                "ajaxPopupMessage": "My customized popup message! Your support ID is: <%TS.request.ID()%>"
            }
        ]
    }
}
```