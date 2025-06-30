---
nd-docs: "DOCS-1601"
---

There are different implementations based on the type of references that are being made.

#### URL Reference

URL reference is the method of referencing an external source by providing its full URL. This is a very useful method when trying to combine or consolidate parts of the policy that are present on different server machines.

{{< note >}} You need to make sure that the server where the resource files are located is always available when you are compiling your policy.
{{< /note >}}

##### Example Configuration

In this example, we are creating a skeleton policy, then enabling the file type violation. However, we do not wish to specify the file types as these file types depend on an app that defines these types. We therefore wish to have this section populated from an external reference. Note that the `filetypes` section is replaced by the `filetypeReference` section. For a list of all the available reference options, consult the documentation (declarative section). In the `filetypeReference` section, we define a **key/value** pair, where the key defines what type of reference we are making, while the value defines the actual URL to use to reach that reference item.

For the content of the file itself, it is an extension of the original JSON format for the policy, as if this section was cut from the policy and pasted into the file.

**Policy configuration:**

```json
{
    "name": "external_resources_file_types",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
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
    "filetypeReference": {
        "link": "http://domain.com:8081/file-types.txt"
    }
}
```

Content of the referenced file `file-types.txt`:

```json
[
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
        "name": "pat",
        "allowed": false
    },
    {
        "name": "mat",
        "allowed": false
    }
]
```

#### HTTPS Reference

HTTPS references are a special case of URL references. It uses the HTTPS protocol instead of the HTTP protocol. Make sure that the webserver you are downloading the resources from does also support HTTPS protocol and has certificates setup properly.

- Certificates must be valid in date (not expired) during the policy compilation.
- Certificates must be signed by a trusted CA.
- For Self-signed certificates, you need to make sure to add your certificates to the trusted CA of the machine where App Protect is installed.
- Certificates must use the exact domain name that the certificate was issued for. For example, SSL will differentiate between domain.com and www.domain.com, considering each a different domain name.

##### Example Configuration

In this configuration, we are completely satisfied with the basic default policy, and we wish to use it as is. However, we wish to define a custom response page using an external file located on an HTTPS web server. The external reference file contains our custom response page configuration.

**Policy configuration:**

```json
{
    "name": "external_references_custom_respsonse",
    "template": {
        "name": "POLICY_TEMPLATE_NGINX_BASE"
    },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "responsePageReference": {
        "link": "https://securedomain.com:8081/response-pages.txt"
    }
}
```

Content of the referenced file `response-pages.txt`:

```json
[
    {
        "responseContent": "<html><head><title>Custom Reject Page</title></head><body>This is a custom response page, it is supposed to overwrite the default page with custom text.<br><br>Your support ID is: <%TS.request.ID()%><br><br><a href='javascript:history.back();'>[Go Back]</a></body></html>",
        "responseHeader": "HTTP/1.1 200 OK\r\nCache-Control: no-cache\r\nPragma: no-cache\r\nConnection: close",
        "responseActionType": "custom",
        "responsePageType": "default"
    }
]
```

##### Example Configuration

In this example, we would like to enable all attack signatures. Yet, we want to exclude specific signatures from being enforced.

**Policy configuration:**

```json
{
    "policy": {
        "name": "external_resources_signature_modification",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                "name": "All Signatures",
                "block": true,
                "alarm": true
            }
        ]
    },
    "modificationsReference": {
        "link": "http://my-domain.com:8081/modifications.txt"
    }
}
```

Content of the referenced file `modifications.txt`:

```json
{
    "modifications": [
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200001834
            },
            "entityType": "signature",
            "action": "add-or-update"
        }
    ]
}
```

#### File Reference

File references refers to accessing local resources on the same machine, as opposed to accessing a remote resource on another server/machine. The user can specify any location that is accessible by App Protect except for the root folder ("/"). If no full path is provided, the default path `/etc/app_protect/conf` will be assumed. Note that file references can only be on the local machine: you cannot use remote hosts!

Here are some examples of the typical cases:

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Link URL Format (examples) | File Path | Comment |
| ---| ---| --- |
|<file:///foo.json> | /etc/app_protect/conf/foo.json | Default directory assumed |
|<file://foo.json> | /etc/app_protect/conf/foo.json | Formally illegal, but tolerated as long as there is no trailing slash. |
|<file:///etc/app_protect/conf/foo.json> | /etc/app_protect/conf/foo.json | Full path, but still the default one |
|<file:///bar/foo.json> | /bar/foo.json | Non-default path |
|<file://etc/app_protect/conf/foo.json> | **Not accepted** | "etc" is interpreted as remote host name |
{{</bootstrap-table>}}


##### Example Configuration

In this example, we would like to enable all attack signatures. Yet, we want to exclude specific signatures from being enforced. To do this, we reference a local file on the machine.

**Policy Configuration:**

```json
{
    "policy": {
        "name": "external_resources_signature_modification",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                "name": "All Signatures",
                "block": true,
                "alarm": true
            }
        ]
    },
    "modificationsReference": {
        "link": "file:///modifications.txt"
    }
}
```

Content of the referenced file `modifications.txt`:

```json
{
    "modifications": [
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200001834
            },
            "entityType": "signature",
            "action": "add-or-update"
        }
    ]
}
```

#### Configuration Errors

If, for any reason, the configuration was done incorrectly, the policy compilation process will fail with the following error:
```shell
APP_PROTECT { "event": "configuration_load_failure" ...
```

The error details that follow will depend on the exact situation causing the policy compilation to fail.  If the policy compilation process fails, the compiler will revert to the last working policy and all the changes for the last policy compilation attempt will be lost.