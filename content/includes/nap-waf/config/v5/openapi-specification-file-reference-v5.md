---
docs: "DOCS-1632"
---

The OpenAPI Specification defines the spec file format needed to describe RESTful APIs. The spec file can be written either in JSON or YAML. Using a spec file simplifies the work of implementing API protection. Refer to the OpenAPI Specification (formerly called Swagger) for details.

The simplest way to create an API protection policy is using an OpenAPI Specification file to import the details of the APIs. If you use an OpenAPI Specification file, NGINX App Protect WAF will automatically create a policy for the following properties (depending on what's included in the spec file):
* Methods
* URLs
* Parameters
* JSON profiles

To obtain an OpenAPI-ready policy template, execute the following command:

```shell
sudo docker run --rm --entrypoint='' private-registry.nginx.com/nap/waf-compiler:1.0.0 cat /etc/app_protect/conf/NginxApiSecurityPolicy.json
```

Ensure to substitute 1.0.0 with the specific version that you are using.

It contains violations related to OpenAPI set to blocking (enforced).

{{< note >}} NGINX App Protect WAF supports only one OpenAPI Specification file reference per policy.{{< /note >}}