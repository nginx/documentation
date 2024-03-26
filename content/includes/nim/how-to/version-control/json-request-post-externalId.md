---
docs: DOCS-1326
---

```json
{
    "auxFiles": {
        "files": [],
        "rootDir": "/"
    },
    "configFiles": {
        "rootDir": "/etc/nginx",
        "files": [
        {
            "contents": "dXNlciB3d3ctZGF0YTsNCndvcmtlcl9wcm9jZXNzZXMgYXV0bzsNCnBpZCAvcnVuL25naW54LnBpZDsNCmluY2x1ZGUgL2V0Yy9uZ2lueC9tb2R1bGVzLWVuYWJsZWQvKi5jb25mOw0KIA0KZXZlbnRzIHsNCgl3b3JrZXJfY29ubmVjdGlvbnMgNzY4Ow0KCSMgbXVsdGlfYWNjZXB0IG9uOw0KfQ0KDQojIG5ldyBjb25maWcNCmh0dHAgew0KDQoJIyMNCgkjIEJhc2ljIFNldHRpbmdzDQoJIyMNCg0KCXNlbmRmaWxlIG9uOw0KCXRjcF9ub3",
            "name": "/etc/nginx/nginx.conf"
        }
        ]
    },
    "updateTime": "2023-02-22T17:10:02.677Z",
    "externalId": "8acf5aed9d2872b266d2f880cab23a4aa5791d1b",
    "externalIdType": "git"
}
```

This JSON defines an NGINX configuration. It specifies the root directory for auxiliary and configuration files, as well as a list of configuration files with their contents and name; the file contents are base64 encoded. Additionally, it specifies an external ID and type as version control identifiers, as well as an update time.

{{<important>}}{{<include "nim/how-to/version-control/warning-edit-config-reverts-hashed-commit.md" >}}{{</important>}}
