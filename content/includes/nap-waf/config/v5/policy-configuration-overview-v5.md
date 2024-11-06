---
docs: "DOCS-1628"
---

The NGINX App Protect WAF security policy configuration uses the declarative format based on a pre-defined base template. The policy is represented in a JSON file which you can edit to add, modify and remove security capabilities with respect to the base template. The JSON file then should be compiled to a bundle file (`.tgz`) using the [NGINX App Protect WAF Compiler]({{< relref "/nap-waf/v5/admin-guide/compiler.md" >}}). The way the policy is integrated into the NGINX configuration is via referencing the bundle file (using the full path) in the `nginx.conf` file.

Refer to the [admin guide]({{< relref "/nap-waf/v5/admin-guide/install.md#using-policy-and-logging-profile-bundles" >}}) for instructions on how to mount bundle files to your deployment.

NGINX App Protect WAF provides a [JSON Schema](https://json-schema.org/) which can be used to validate a JSON policy file to ensure file format compliance. The schema file can be generated using a script inside the NGINX App Protect WAF Compiler image:

```shell
sudo docker run --rm \
 -v $(pwd):$(pwd) \
 -w $(pwd) \
 --entrypoint=/opt/app_protect/bin/generate_json_schema.pl \
 private-registry.nginx.com/nap/waf-compiler:1.0.0
```

Replace the `1.0.0` with the version you use.

This script will output the schema to a file named `policy.json` into the current working directory. Once the schema file is generated, you can use validation tools such as [AJV](https://ajv.js.org/standalone.html) to validate a JSON policy file.

In the following example, the NGINX configuration file with App Protect enabled in the HTTP context and the policy `/policies/policy1.tgz` is used:

```nginx
user nginx;
worker_processes  4;

load_module modules/ngx_http_app_protect_module.so;

error_log /var/log/nginx/error.log debug;

events {
    worker_connections  65536;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    app_protect_enable on; # This is how you enable NGINX App Protect WAF in the relevant context/block
    app_protect_policy_file "/etc/app_protect/conf/policy1.tgz"; # This is a reference to the policy bundle file to use. If not defined, the default policy is used
    app_protect_security_log_enable on; # This section enables the logging capability
    app_protect_security_log "/etc/app_protect/conf/log_all.tgz" syslog:server=127.0.0.1:514; # This is where the remote logger is defined in terms of: logging options (defined in the referenced file), log server IP, log server port

    server {
        listen       80;
        server_name  localhost;
        proxy_http_version 1.1;

        location / {
            client_max_body_size 0;
            default_type text/html;
            proxy_pass http://172.29.38.211/;
        }
    }
}
```
