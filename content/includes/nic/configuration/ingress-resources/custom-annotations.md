---
nd-docs: DOCS-595
doctypes:
- ''
title: Custom annotations
toc: true
weight: 300
---

This topic explains how you can use custom annotations with F5 NGINX Ingress Controller.

Custom annotations enable you to quickly extend the Ingress resource to support many advanced features of NGINX, such as rate limiting, caching, etc.

## Overview

NGINX Ingress Controller supports a number of annotations for the Ingress resource that fine tune NGINX configuration (for example, connection timeouts) or enable additional features (for example, JWT validation). The complete list of annotations is available [here](/nginx-ingress-controller/configuration/ingress-resources/advanced-configuration-with-annotations).

The annotations are provided only for the most common features and use cases, meaning that not every NGINX feature or a customization option is available through the annotations. Additionally, even if an annotation is available, it might not give you the satisfactory level of control of a particular NGINX feature.

Custom annotations allow you to add an annotation for an NGINX feature that is not available as a regular annotation. In contrast with regular annotations, to add a custom annotation, you don't need to modify the Ingress Controller source code -- just modify the template. Additionally, with a custom annotation, you get full control of how the feature is implemented in NGINX configuration.

## Usage

The Ingress Controller generates NGINX configuration for Ingress resources by executing a configuration template. See [NGINX template](https://github.com/nginx/kubernetes-ingress/blob/v{{< nic-version >}}/internal/configs/version1/nginx.ingress.tmpl) or [NGINX Plus template](https://github.com/nginx/kubernetes-ingress/blob/v{{< nic-version >}}/internal/configs/version1/nginx-plus.ingress.tmpl).

To support custom annotations, the template has access to the information about the Ingress resource - its *name*, *namespace* and *annotations*. It is possible to check if a particular annotation present in the Ingress resource and conditionally insert NGINX configuration directives at multiple NGINX contexts - `http`, `server`, `location` or `upstream`. Additionally, you can get the value that is set to the annotation.

Consider the following excerpt from the template, which was extended to support two custom annotations:

```jinja2
# This is the configuration for {{$.Ingress.Name}}/{{$.Ingress.Namespace}}

{{if index $.Ingress.Annotations "custom.nginx.org/feature-a"}}
# Insert config for feature A if the annotation is set
{{end}}

{{with $value := index $.Ingress.Annotations "custom.nginx.org/feature-b"}}
# Insert config for feature B if the annotation is set
# Print the value assigned to the annotation: {{$value}}
{{end}}
```

Consider the following Ingress resource and note how we set two annotations:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  namespace: production
  annotations:
    custom.nginx.org/feature-a: "on"
    custom.nginx.org/feature-b: "512"
spec:
  rules:
  - host: example.com
    . . .
```

Assuming that the Ingress Controller is using that customized template, it will generate a config for the Ingress resource that will include the following part, generated by our template excerpt:

```yaml
# This is the configuration for cafe-ingress/default

# Insert config for feature A if the annotation is set



# Insert config for feature B if the annotation is set
# Print the value assigned to the annotation: 512
```

**Notes**:

- You can customize the template to insert you custom annotations via [custom templates](/nginx-ingress-controller/configuration/global-configuration/custom-templates).
- The Ingress Controller uses go templates to generate NGINX config. You can read more information about go templates [here](https://golang.org/pkg/text/template/).

See the examples in the next section that use custom annotations to configure NGINX features.

### Custom Annotations with Mergeable Ingress Resources

A Mergeable Ingress resource consists of multiple Ingress resources - one master and one or several minions. Read more about Mergeable Ingress resources [here](/nginx-ingress-controller/configuration/ingress-resources/cross-namespace-configuration).

If you'd like to use custom annotations with Mergeable Ingress resources, please keep the following in mind:

- Custom annotations can be used in the Master and in Minions. For Minions, you can access them in the template only when processing locations.

    If you access `$.Ingress` anywhere in the Ingress template, you will get the master Ingress resource. To access a Minion Ingress resource, use `$location.MinionIngress`. However, it is only available when processing locations:

    ```jinja2
      {{range $location := $server.Locations}}
      location {{$location.Path}} {
        {{with $location.MinionIngress}}
          # location for minion {{$location.MinionIngress.Namespace}}/{{$location.MinionIngress.Name}}
        {{end}}
      } {{end}}
    ```

    **Note**: `$location.MinionIngress` is a pointer. When a regular Ingress resource is processed in the template, the value of the pointer is `nil`. Thus, it is important that you check that `$location.MinionIngress` is not `nil` as in the example above using the `with` action.

- Minions do not inherent custom annotations of the master.

### Helper Functions

Helper functions can be used in the Ingress template to parse the values of custom annotations.

{{% table %}}
| Function | Input Arguments | Return Arguments | Description |
| ---| ---| ---| --- |
| ``split`` | ``s, sep string`` | ``[]string`` | Splits the string ``s`` into a slice of strings separated by the ``sep``. |
| ``trim`` | ``s string`` | ``string`` | Trims the trailing and leading whitespace from the string ``s``. |
| ``contains`` | ``s, substr string`` | ``bool`` | Tests whether the string ``substr`` is a substring of the string ``s``. |
| ``hasPrefix`` | ``s, prefix string`` | ``bool`` | Tests whether the string ``prefix`` is a prefix of the string ``s``. |
| ``hasSuffix`` | ``s, suffix string`` | ``bool`` | Tests whether the string ``suffix`` is a suffix of the string ``s``. |
| ``toLower`` | ``s string`` | ``bool`` | Converts all letters in the string ``s`` to their lower case. |
| ``toUpper`` | ``s string`` | ``bool`` | Converts all letters in the string ``s`` to their upper case. |
| ``replaceAll`` | ``s, old, new string`` | ``string`` | Replaces all occurrences of ``old`` with ``new`` in the string ``s``. |
{{% /table %}}

Consider the following custom annotation `custom.nginx.org/allowed-ips`, which expects a comma-separated list of IP addresses:

```yaml
annotations:
  custom.nginx.org/allowed-ips: "192.168.1.3, 10.0.0.13"
```

 The helper functions can parse the value of the `custom.nginx.org/allowed-ips` annotation, so that in the template you can use each IP address separately. Consider the following template excerpt:

```jinja2
{{range $ip := split (index $.Ingress.Annotations "custom.nginx.org/allowed-ips") ","}}
    allow {{trim $ip}};
{{end}}
deny all;
```

The template excerpt will generate the following configuration:

```
allow 192.168.1.3;
allow 10.0.0.13;
deny all;
```

## Example

See the [custom annotations example](https://github.com/nginx/kubernetes-ingress/blob/v{{< nic-version >}}/examples/ingress-resources/custom-annotations).
