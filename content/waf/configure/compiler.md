---
# We use sentence case and present imperative tone
title: "Build and use the compiler tool"
# Weights are assigned in increments of 100: determines sorting order
weight: 300
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This document describes how to use the F5 WAF for NGINX compiler, a tool for converting security policies and logging profiles from JSON to a bundle file that F5 WAF can process and apply.

You can use it to get the latest security updates for [Attack signatures]({{< ref "/waf/policies/attack-signatures.md" >}}), Threat campaigns and Bot signatures. 

The compiler is packaged as a Docker image and can executed using the Docker CLI or as part of a continuous integration/continuous delivery (CI/CD) pipeline.

{{< call-out "note" "Alternatives to the compiler tool">}}

If you are using a virtual machine/bare-metal installation, read the [Update F5 WAF for NGINX signatures]({{< ref "/waf/install/update-signatures.md" >}}) topic.

If you are using a Helm-based Kubernetes deployment, read the [Kubernetes operations improvements (Early access)]({{< ref "/waf/install/kubernetes-plm.md" >}}) topic.

{{< /call-out >}}

One or more bundle files can be referenced in the NGINX configuration file, and you can configure global settings such as the cookie seed and user-defined signatures.

For more information about policies, read the [Configure policies]({{< ref "/waf/policies/configuration.md" >}}) topic.

## Before you begin

To complete this guide, you will need the following prerequisites:

- An active F5 WAF for NGINX subscription (Purchased or trial)
- Credentials to the [MyF5 Customer Portal](https://account.f5.com/myf5), provided by email from F5, Inc.
- [Docker](https://docs.docker.com/get-started/get-docker/)

## Download your subscription credentials 

{{< include "licensing-and-reporting/download-certificates-from-myf5.md" >}}

## Configure Docker for the F5 Container Registry 

Create a directory and copy your certificate and key to this directory:

```shell
mkdir -p /etc/docker/certs.d/private-registry.nginx.com
cp <path-to-your-nginx-repo.crt> /etc/docker/certs.d/private-registry.nginx.com/client.cert
cp <path-to-your-nginx-repo.key> /etc/docker/certs.d/private-registry.nginx.com/client.key
```

Log in to the Docker registry:

```shell
docker login private-registry.nginx.com
```

## Create the Dockerfile

This example Dockerfile is based on a Debian image.

```dockerfile
# syntax=docker/dockerfile:1
ARG BASE_IMAGE=private-registry.nginx.com/nap/waf-compiler:<version-tag>
FROM ${BASE_IMAGE}

# Installing packages as root
USER root

ENV DEBIAN_FRONTEND="noninteractive"

RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update \
    && apt-get install -y \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        wget \
        gnupg2 \
        ubuntu-keyring \
    && wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | gpg --dearmor | \
    tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null \
    && printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] \
    https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | \
    tee /etc/apt/sources.list.d/nginx-app-protect.list \
    && wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx \
    && apt-get update \
    && apt-get install -y \
        app-protect-attack-signatures \
        app-protect-bot-signatures \
        app-protect-threat-campaigns \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# non-root default user (UID 101)
USER nginx
```

{{< call-out "note" >}}

You can can upgrade or downgrade one of the Signatures by specifying a specific version, such as _app-protect-attack-signatures-2020.04.30_.

{{< /call-out >}}

You can use the Docker registry API to list the available image tags.

Replace `<path-to-your-nginx-repo.key>` with the location of your client key and `<path-to-your-nginx-repo.crt>` with the location of your client certificate. 

```shell
curl -s https://private-registry.nginx.com/v2/nap/waf-compiler/tags/list --key <path-to-your-nginx-repo.key> --cert <path-to-your-nginx-repo.crt>
```
```json
{
  "name": "nap/waf-compiler",
  "tags": [
    "1.0.0",
    "5.1.0",
    "5.2.0"
  ]
}
```

{{< call-out "note" >}}

The [jq](https://jqlang.github.io/jq/) command was used to format the example output.

{{< /call-out >}}

## Build the container image

Run the following command to build your image, where `waf-compiler-<version-tag>:custom` is an example of the image tag:

```shell
sudo docker build --no-cache --platform linux/amd64 \
--secret id=nginx-crt,src=nginx-repo.crt \
--secret id=nginx-key,src=nginx-repo.key \
-t waf-compiler-<version-tag>:custom .
```

{{< call-out "warning" >}}

Never upload your F5 WAF for NGINX images to a public container registry such as Docker Hub. Doing so violates your license agreement.

{{< /call-out >}}

## Using the compiler

This section uses `version-tag` as a placeholder in its examples, following the previous section. Ensure that all input files are accessible to UID 101.

### Compile a security policy

To compile a security policy from a JSON file and create a policy bundle, run the following command:

```shell
docker run --rm \
 -v $(pwd):$(pwd) \
 waf-compiler-<version-tag>:custom \
 -p $(pwd)/policy.json -o $(pwd)/compiled_policy.tgz
```

{{< call-out "warning" >}}

Ensure that the output directory is writable, otherwise you may encounter a permission denied error.

{{< /call-out >}}

To use multiple policy bundles within a single NGINX configuration, you must supply a [global settings](#global-settings) JSON file. 

This ensures that all bundles have a common foundation such as cookie seed and user-defined signatures.

An example `global_settings.json` might look as follows:

```json
{
    "waf-settings": {
        "cookie-protection": {
            "seed": "<seed value>"
        }
    }
}
```

To compile a policy with global settings, add the `-g` parameter:

```shell
docker run --rm \
 -v $(pwd):$(pwd) \
 waf-compiler-1.0.0:custom \
 -g $(pwd)/global_settings.json -p $(pwd)/policy.json -o $(pwd)/compiled_policy.tgz
```

You can incorporate the source of the policy (as `policy.json`) or logging profile (as `logging_profile.json`) into the final bundle using the `-include-source` parameter.

```shell
docker run --rm \
 -v $(pwd):$(pwd) \
 waf-compiler-1.0.0:custom \
 -include-source -full-export -g $(pwd)/global_settings.json -p $(pwd)/policy.json -o $(pwd)/compiled_policy.tgz
```

This will transform any configuration that relies on external references into an inline configuration within the bundled source. 

Additionally, when `-include-source` is combined with `-full-export`, the policy.json within the bundle will contain the entire source policy, including any default settings from the base template.

### Compile a logging profile

To compile a logging profile, execute the command below:

```shell
docker run \
 -v $(pwd):$(pwd) \
 waf-compiler-<version-tag>:custom \
 -l $(pwd)/log_01.json -o $(pwd)/log01.tgz
```

### View bundle information

To view information about a bundle file, such as attack signatures versions, use the following command:

```shell
docker run \
 -v $(pwd):$(pwd) \
 waf-compiler-<version-tag>:custom \
 -dump -bundle $(pwd)/compiled_policy.tgz
```

## Debugging bundle errors

When [configuring policies]({{< ref "/waf/policies/configuration.md">}}), you may run into problems.

There are ways to remediate them based on the context:

{{< table >}}
| Description             | Solution  |
| ----------------------- | --------  |
| _Expected declarative policy_ | Ensure the JSON of the policy is well-formed | 
| _Policy Bundles version is older than the local version_ | You must recompile all your bundles from scratch when installing security updates. |
| _Policy Bundles version is newer than the local version_ | You must recompile all your bundles from scratch when installing security updates. |
| _Found mixed content of compiled and raw configuration_ | Only pre-compiled bundles can be used in NGINX configuration: compile JSON to bundles first. |
| _Compiler is required, but not installed: Missing /opt/app_protect/bin/config_set_compiler_ | Only pre-compiled bundles can be used in NGINX configuration: compile JSON to bundles first. |
| _Policy Bundles have differing global states_ | Recompile all of your bundles from scratch with your custom compiler. Bundles must be compiled with the same compiler: you cannot mix default and custom bundles. |
| _Policy Bundles have differing cookie seeds_ | Recompile all of your bundles from scratch with your custom compiler. Bundles must be compiled with the same compiler: you cannot mix default and custom bundles. |
| _Duplicate policy name found_ | Don't compile multiple policies with the same name, or one policy to multiple bundles. Each policy can be compiled once but a bundle can be re-used. |
| _Duplicate logging profile name found | Don't compile the same logging profile to multiple bundles. Each profile can be compiled once but a bundle can be re-used. |
| _Timeout waiting for enforcer_ | Likely an internal issue: [contact Support]({{< ref "/waf/support.md" >}}) |
{{< /table >}}

## Global settings

The global settings allows configuration of the following items:

### cookie-protection

| Name       | Type   | Description |
| ---------- | ------ | ----------- |
| seed       | string | The seed value is used by F5 WAF for NGINX to generate the encryption key for the cookies it creates. These cookies are used for various purposes such as validating the integrity of the cookies generated by the application. Use a random alphanumeric string of at least 20 characters length (but not more than 1000 characters). |

### user-defined-signatures

| Name  | Reference | Type   | Description |
| ----- | --------- | ------ | ----------- |
| $ref  | Yes       | string | Path to the file that contains the user defined signatures. |

#### Example

```json
{
    "waf-settings": {
        "cookie-protection": {
            "seed": "80miIOiSeXfvNBiDJV4t"
        },
        "user-defined-signatures": [
            {
                "$ref": "file:///policies/uds.json"
            }
        ]
    }
}
```

{{< call-out "warning" >}}

When deploying multiple scalability instances (Such as Kubernetes deployment replicas), ensure that all policy bundles are compiled with the same global settings and security updates.

{{< /call-out >}}


## Using the compiler in a CI/CD process

When executing commands inside the compiler container, ensure that you use `/opt/app_protect/bin/apcompile` as the compiler binary.

This is particularly important if you're overriding the default entry point as part of a CI/CD process.

```shell
/opt/app_protect/bin/apcompile -g /path/to/global_settings.json -p /path/to/policy.json -o /path/to/compiled_policy.tgz
```