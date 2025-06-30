---
nd-docs: "DOCS-1617"
---

A user can enable/disable specific file types in the policy.

In this example, we enable the file type violation in blocking mode. In the detailed configuration, we allow the \* wildcard entity which would allow all file types by default. In the last section, we explicitly disable the `bat` file type. This is an example of allowing all, but specifically blocking (via deny list) certain items.  You may add as many file types as you wish, each declared in its own curly brackets, along with the `"allowed": false` directive.

```json
{
    "policy": {
        "name": "policy1",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_FILETYPE",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "filetypes": [
            {
                "name": "*",
                "type": "wildcard",
                "allowed": true,
                "checkPostDataLength": false,
                "postDataLength": 4096,
                "checkRequestLength": false,
                "requestLength": 8192,
                "checkUrlLength": true,
                "urlLength": 2048,
                "checkQueryStringLength": true,
                "queryStringLength": 2048,
                "responseCheck": false
            },
            {
                "name": "bat",
                "allowed": false
            }
        ]
    }
}
```


#### Response Signatures
All Response Signatures are attack signatures detected on the response side, in contrast to the request side.


#### Restrict Response Signatures

Restrict Response Signatures enhancement assists the users in saving time by limiting the search for response signatures to a specified amount. You can enable the signature verification in the response by setting the `responseCheck` parameter to true. However, the restriction of certain signatures is set in the policy and then enforced by the App Protect.

In the policy base template under the "filetypes" section, make sure you enable the `responseCheck` attribute for `responseCheckLength` to work properly. The default value of `responseCheck` parameter is set to false.

The `responseCheckLength` parameter refers to the number of uncompressed bytes in the response body prefix that are examined for signatures. The `responseCheckLength` field will be added with the default value of **20000** bytes which means that the first 20,000 bytes of the response body will undergo signature verification.

Restrict Response Signature example:

In the below policy example, in the "filetypes" section, the `responseCheck` parameter is set to true, indicating that response check will be enabled.
When enforcing signatures on the response, we have the flexibility to restrict the portion of the response body that requires validation. In this case, the policy is configured with `responseCheckLength` set to 1000, signifying that only the initial 1000 bytes of the response body will undergo signature verification.

```json
{
    "policy": {
        "name": "response_signatures_block",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "filetypes": [
           {
            "name": "*",
            "type": "wildcard",
            "responseCheck": true,
		    "responseCheckLength": 1000
           }
        ],
            "signature-sets": [
          {
                "name": "All Response Signatures",
                "block": true,
                "alarm": true
           }
        ]
    }
}
```

#### How Does Restrict Response Signature Check Work?

The response signature check is always done on the configured `responseCheckLength` as described above. Usually NGINX App Protect WAF will buffer only that part of the response saving memory and CPU, but in some conditions the whole response may have to be buffered, such as when the response body is compressed.

#### Allowed Methods

In the policy, you can specify what methods to allow or disallow.

In this example, we enable the illegal method violation in blocking mode. In the methods configuration, we define which of the methods are allowed. If a method is allowed by default, it can be disallowed via `"$action": "delete"`. In the following example we disallow the default allowed method `PUT` by removing it from the default enforcement. For illustrative purposes this example also has all the other methods that are allowed by default defined in the configuration, but in practicality they do not actually need to be included explicitly to be allowed:


```json
{
    "policy": {
        "name": "blocking_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_METHOD",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "methods": [
            {
                "name": "GET"
            },
            {
                "name": "POST"
            },
            {
                "name": "HEAD"
            },
            {
                "name": "PUT",
                "$action": "delete"
            },
            {
                "name": "PATCH"
            },
            {
                "name": "DELETE"
            },
            {
                "name": "OPTIONS"
            }
        ]
    }
}
```

#### Custom Method Enforcement

To enable any custom method other than the above mentioned HTTP standard methods, the user must configure the specific modules that allow those methods. NGINX will reject any custom method other than the standard allowed HTTP methods GET, POST, PUT, DELETE, HEAD, and OPTIONS.

For example, see currently supported [WebDAV Methods](https://nginx.org/en/docs/http/ngx_http_dav_module.html).

#### Response Codes

Response codes are a general setting that defines which response codes are acceptable, while all others will be blocked.

In this example, we enable the response status codes violation in blocking mode. In the general configuration, we define which of the response codes are allowed. This would mean that all others will be considered as illegal response codes and will be blocked. In this configuration, you specify a list of comma-separated response codes that are allowed.


```json
{
    "policy": {
        "name": "allowed_response",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_HTTP_RESPONSE_STATUS",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "general": {
            "allowedResponseCodes": [
                400,
                401,
                403,
                404,
                502,
                499
            ]
        }
    }
}
```