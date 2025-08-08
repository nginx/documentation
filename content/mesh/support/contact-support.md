---
title: Where to Go for Support
weight: 100
description: Learn where to go for F5 NGINX Service Mesh support.
toc: true
draft: false
nd-docs: DOCS-718
type:
- task
---

Thank you for your interest in F5 NGINX Service Mesh. NGINX Service Mesh can be installed via helm charts, or by [downloading nginx-meshctl](https://github.com/nginxinc/nginx-service-mesh/releases/latest).

<!-- markdown-link-check-disable -->
### Resources

- [Product Details](https://www.nginx.com/products/nginx-service-mesh/)
- [Install NGINX Service Mesh using nginx-meshctl]( {{< ref "/mesh/get-started/install/install.md" >}} )
- [Install NGINX Service Mesh using Helm]( {{< ref "/mesh/get-started/install/install-with-helm.md" >}} )
- [NGINX Plus Kubernetes Ingress Controller](https://www.nginx.com/products/nginx-ingress-controller/)
- [NGINX Plus Product Details](https://www.nginx.com/products/nginx/)

### Commercial Support

For paid customers of NGINX Service Mesh, follow the procedures described in the following knowledge base article: [K000140156](https://my.f5.com/manage/s/article/K000140156/).

#### Generate a Support Package

To generate a support package, run the following command:

```bash
nginx-meshctl supportpkg
```

To exclude information about sidecar containers:

```bash
nginx-meshctl supportpkg --disable-sidecar-logs
```

The `supportpkg` command generates a tar file containing information about the state of your NGINX Service Mesh deployment. The package includes logs, component yaml files, events, Pod descriptions, and more. The README contained within the package describes its contents.

### GitHub Issues

{{< call-out "note" >}}
Paid customers of NGINX Service Mesh should use [Commercial Support](#commercial-support) instead of GitHub Issues.
{{< /call-out >}}

For NGINX Service Mesh support or issues not addressed by documentation, you can reach out via the Issues tab in the [NGINX Service Mesh GitHub repo](https://github.com/nginxinc/nginx-service-mesh/issues).

We use issues for bug reports and to discuss new features. Creating issues is good, creating good issues is even better. Filing meaningful bug reports with lots of information in them helps us figure out what to fix when and how it impacts our users. We like bugs because it means people are using our code, and we like fixing them even more.

All issues should follow these guidelines:

- Describe the problem. Include version of Kubernetes, `nginx-meshctl version`, and what Kubernetes platform.
- Include detailed information about how to recreate the issue.
- Include relevant configurations, error messages, and logs.
- Sanitize the data. For example, be mindful of IPs, ports, application names, and URLs.
<!-- markdown-link-check-disable -->

### NGINX Plus Kubernetes Ingress Controller Support

If you are using NGINX Service Mesh with NGINX Plus Ingress Controller for Kubernetes, you can get support through your usual channels.

Existing NGINX and F5 customers can reach out to their account team(s) for help and support with NGINX Service Mesh.
