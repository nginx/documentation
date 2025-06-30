---
title: NGINX App Protect WAF Compiler
weight: 500
toc: true
type: how-to
product: NAP-WAF
nd-docs: DOCS-1367
---

## Overview

The F5 NGINX App Protect WAF v5 Compiler is a tool that compiles security policies and logging profiles from JSON format to a bundle file that the Enforcer can consume and apply. The bundle file is then referenced in the nginx configuration file. The compiler is packaged as a Docker image and can be run using the Docker CLI or involved during a CI/CD process.

## Use Cases

- Get latest security updates - [Attack Signatures]({{< ref "/nap-waf/v5/configuration-guide/configuration.md#attack-signatures-overview" >}}), [Threat Campaigns]({{< ref "/nap-waf/v5/configuration-guide/configuration.md#threat-campaigns" >}}), [Bot Signatures]({{< ref "/nap-waf/v5/configuration-guide/configuration.md#bot-signatures" >}}).
- Apply multiple policy bundle files within the same `nginx.conf`.
- Configure global settings such as the cookie seed and user-defined signatures.

## Building Compiler Image

{{< important >}}
To ensure you are using the latest security updates, it is recommended to regularly rebuild your compiler image with the latest signature packages and recompile security policies.
{{< /important >}}

1. Download Certificates

    Log in to [My F5](https://my.f5.com) and download the following two files from your active NGINX App Protect WAF subscription:

    ```shell
    nginx-repo.key
    nginx-repo.crt
    ```

2. {{< include "nap-waf/setup-docker-registry.md" >}}

3. Create the `Dockerfile`:

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
{{< note >}}The user can upgrade or downgrade one of the Signatures by specifying a specific version, for example: app-protect-attack-signatures-2020.04.30.{{< /note >}}

You can use the Docker registry API to list the available image tags.
Replace `<path-to-your-nginx-repo.key>` with the location of your client key and `<path-to-your-nginx-repo.crt>` with the location of your client certificate. The optional `jq` command is used to format the JSON output for easier reading and requires the [jq](https://jqlang.github.io/jq/) JSON processor to be installed.

```shell
curl -s https://private-registry.nginx.com/v2/nap/waf-compiler/tags/list --key <path-to-your-nginx-repo.key> --cert <path-to-your-nginx-repo.crt> |jq
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

4. Build the image


    Run the command below to build your image, where `waf-compiler-<version-tag>:custom` is an example of the image tag:

    ```shell
    sudo docker build --no-cache --platform linux/amd64 \
    --secret id=nginx-crt,src=nginx-repo.crt \
    --secret id=nginx-key,src=nginx-repo.key \
    -t waf-compiler-<version-tag>:custom .
    ```

{{< note >}}
Never upload your NGINX App Protect WAF images to a public container registry such as Docker Hub. Doing so violates your license agreement.
{{< /note >}}

## Usage

This section assumes that you built a customized compiler image - `waf-compiler-<version-tag>:custom`.

Make sure that input files are accessible to UID 101.

### Policy Compilation

To compile a security policy from a JSON file and create a policy bundle, execute the following command:

{{< warning >}}

Ensure that the output directory is writable, otherwise you may encounter a permission denied error.

{{< /warning >}}

```shell
docker run --rm \
 -v $(pwd):$(pwd) \
 waf-compiler-<version-tag>:custom \
 -p $(pwd)/policy.json -o $(pwd)/compiled_policy.tgz
```

However, to utilize multiple policy bundles within a single NGINX configuration, it's necessary to supply a [global settings](#global-settings) JSON file. This ensures that all bundles have a common foundation, including cookie seed, user-defined signatures, and more.

For instance:

`global_settings.json`:

```json
{
    "waf-settings": {
        "cookie-protection": {
            "seed": "<seed value>"
        }
    }
}
```

Compilation with global settings:

```shell
docker run --rm \
 -v $(pwd):$(pwd) \
 waf-compiler-1.0.0:custom \
 -g $(pwd)/global_settings.json -p $(pwd)/policy.json -o $(pwd)/compiled_policy.tgz
```

Using `-include-source`, you can incorporate the source of the policy (as `policy.json`) or logging profile (as `logging_profile.json`) into the final bundle. This process transforms any configuration that relies on external references into an inline configuration within the bundled source. Furthermore, when `-include-source` is combined with `-full-export`, the policy.json within the bundle will contain the entire source policy, including any default settings from the base template.

```shell
docker run --rm \
 -v $(pwd):$(pwd) \
 waf-compiler-1.0.0:custom \
 -include-source -full-export -g $(pwd)/global_settings.json -p $(pwd)/policy.json -o $(pwd)/compiled_policy.tgz
```

### Logging Profile Compilation

To compile a logging profile, execute the command below:

```shell
docker run \
 -v $(pwd):$(pwd) \
 waf-compiler-<version-tag>:custom \
 -l $(pwd)/log_01.json -o $(pwd)/log01.tgz
```

### Bundle Information

To view information about a bundle file, such as attack signatures versions, use the following command:

```shell
docker run \
 -v $(pwd):$(pwd) \
 waf-compiler-<version-tag>:custom \
 -dump -bundle $(pwd)/compiled_policy.tgz
```

---

## Global Settings

The global settings allows configuration of the following items:

### waf-settings

{{<bootstrap-table "table table-striped table-bordered">}}
| Field Name | Type | Description |
|-|-|-|
| [cookie-protection](#cookie-protection) | object | Defines the cookie protection settings. |
| [user-defined-signatures](#user-defined-signatures) | array of objects | Defines user defined signatures. |
{{</bootstrap-table>}}

### cookie-protection

{{<bootstrap-table "table table-striped table-bordered">}}
| Field Name | Type | Description |
|-|-|-|
| seed | string | The seed value is used by F5 NGINX App Protect WAF to generate the encryption key for the cookies it creates. These cookies are used for various purposes such as validating the integrity of the cookies generated by the application. Use a random alphanumeric string of at least 20 characters length (but not more than 1000 characters). |
{{</bootstrap-table>}}

### user-defined-signatures

{{<bootstrap-table "table table-striped table-bordered">}}
| Field Name | Reference | Type | Description |
|-|-|-|-|
| $ref | Yes | string | Path to the file that contains the user defined signatures. |
{{</bootstrap-table>}}

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

## Horizontal Scaling

When deploying multiple scalability instances, such as Kubernetes deployment replicas, it is essential to ensure that all policy bundles are compiled with the same global settings and security updates.

## WAF Compiler in CI/CD

When executing commands inside the compiler container, especially if it's part of a CI/CD process and you're overriding the default entrypoint, ensure that you use `/opt/app_protect/bin/apcompile` as the compiler binary.

For example:

```shell
/opt/app_protect/bin/apcompile -g /path/to/global_settings.json -p /path/to/policy.json -o /path/to/compiled_policy.tgz
```

<!-- ## Converter Tools

WAF Compiler image includes a number of tools that can be used to facilitate the process of porting existing resources or configuration files from the BIG-IP for use in the NGINX App Protect WAF environment.

### Policy Converter

The Policy Converter tool is used for converting XML formatted ASM and Advanced WAF policies to JSON. The converted JSON policy is based on the NGINX App Protect WAF policy base template and contains the minimal diff to it in JSON declarative policy format. It is located at `/opt/app_protect/bin/convert-policy` inside the WAF Compiler image.

Elements in the XML policy that are not supported in the NGINX App Protect WAF environment will generate warnings. Note that any configuration that is invalid or irrelevant to the NGINX App Protect WAF environment is removed from the exported declarative policy.

{{< note >}}
All NGINX App Protect WAF versions support converting XML policies exported from BIG-IP regardless of any version. If the source XML policy has not changed from when it was in use on BIG-IP, then it's always a good idea to convert it with the Policy Converter tool included with the version of NGINX App Protect WAF you are using. This way, as more configuration items from BIG-IP become supported in NGINX App Protect WAF, they will be included in the converted policy. A policy that was converted will work on the same or greater NGINX App Protect WAF version it originally came from.
{{< /note >}}

The Policy Converter tool has options to include the following elements in a full export:

- Elements that are the same as the default template policy. (Invalid elements are removed, but no warnings reported.)
- Elements that are not supported in the NGINX App Protect WAF environment. (No elements removed and no warnings reported.)

The XML policy file can be obtained by exporting the policy from the BIG-IP device on which the policy is currently deployed.

Usage:
```shell
Required arguments:
    --outfile|o='/path/to/policy.json'
        File name for where to write exported policy.
        Can also be set via an environment variable: EXPORT_FILE
    --infile|i='/path/to/policy.xml'
        Advanced WAF/ASM Security Policy file to convert
        Can also be set via an environment variable: IMPORT_FILE

Optional arguments:
    --format|f='json'
        Desired output format for signature file. Default 'json'
        Supported formats: 'json'
    --keep-full-configuration
        By default the exported policy will only contain elements that are valid for the environment in which this tool is run.
        If keep-full-configuration is enabled then the full configuration is retained, including elements that are not supported in NGINX App Protect WAF.
    --full-export
        By default the exported policy will only contain elements that are different from the default policy template.
        If full-export is enabled then all policy elements are included in the export file.
        When this option is selected, no warnings are generated when removing unsupported elements from the exported policy.

Optionally, using --help will issue this help message.
```

Example of generating a JSON policy suitable for NGINX App Protect WAF usage:

```shell
sudo docker run --rm \
 -v $(pwd):$(pwd) \
 --entrypoint=/opt/app_protect/bin/convert-policy \
 waf-compiler-<version-tag>:custom \
 -i $(pwd)/policy1.xml -o $(pwd)/policy1.json
```

Output (displayed and piped into `jq`):
```json
{
    "warnings": [
        "Traffic Learning, Policy Building, and staging are unsupported",
        "Element '/plain-text-profiles' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_ASM_COOKIE_HIJACKING' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_BLOCKING_CONDITION' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_BRUTE_FORCE' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_CONVICTION' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_CROSS_ORIGIN_REQUEST' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_CSRF' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_CSRF_EXPIRED' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_DYNAMIC_SESSION' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_FLOW' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_FLOW_DISALLOWED_INPUT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_FLOW_ENTRY_POINT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_FLOW_MANDATORY_PARAMS' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_GEOLOCATION' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_GRPC_FORMAT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_GRPC_METHOD' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_GWT_FORMAT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_GWT_MALFORMED' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_HOSTNAME_MISMATCH' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_LOGIN_URL_BYPASSED' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_LOGIN_URL_EXPIRED' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_MALICIOUS_DEVICE' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_MALICIOUS_IP' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_PARAMETER_DYNAMIC_VALUE' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_PLAINTEXT_FORMAT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_REDIRECT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_SESSION_AWARENESS' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_VIRUS' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_BAD_REQUEST' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_BINARY_MESSAGE_LENGTH' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_BINARY_MESSAGE_NOT_ALLOWED' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_EXTENSION' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_FRAMES_PER_MESSAGE_COUNT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_FRAME_LENGTH' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_FRAME_MASKING' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_FRAMING_PROTOCOL' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_TEXT_MESSAGE_NOT_ALLOWED' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_WEBSOCKET_TEXT_NULL_VALUE' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_XML_SCHEMA' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_XML_SOAP_ATTACHMENT' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_XML_SOAP_METHOD' is unsupported.",
        "/blocking-settings/violations/name value 'VIOL_XML_WEB_SERVICES_SECURITY' is unsupported.",
        "/blocking-settings/http-protocols/description value 'Unparsable request content' is unsupported.",
        "/general/enableEventCorrelation must be 'false' (was 'true').",
        "Element '/websocket-urls' is unsupported.",
        "/protocolIndependent must be 'true' (was 'false').",
        "Element '/redirection-protection' is unsupported.",
        "Element '/gwt-profiles' is unsupported.",
        "/signature-sets/learn value true is unsupported"
    ],
    "file_size": 24227,
    "completed_successfully": true,
    "filename": "/path/to/policy1.json"
}
```

Example of generating an unmodified JSON policy (may cause warnings/errors when used in NGINX App Protect WAF):

```shell
sudo docker run --rm \
 -v $(pwd):$(pwd) \
 --entrypoint=/opt/app_protect/bin/convert-policy \
 waf-compiler-<version-tag>:custom \
 -i $(pwd)/policy1.xml -o $(pwd)/policy1.json --keep-full-configuration
```

Example of translating a valid NGINX App Protect WAF JSON policy into a full JSON policy including elements from the defaults:

```shell
sudo docker run --rm \
 -v $(pwd):$(pwd) \
 --entrypoint=/opt/app_protect/bin/convert-policy \
 waf-compiler-<version-tag>:custom \
 -i $(pwd)/policy1.json -o $(pwd)/policy1.json --full-export
```

Note that if the script is run without the required switches and their corresponding arguments, it will display the help message.

Optionally, you can build an image for the policy converter by using the WAF Compiler image as a base and overriding the default entrypoint in your Dockerfile:

```Dockerfile
ENTRYPOINT /opt/app_protect/bin/convert-policy
```

Assuming you have tagged this image as `waf-policy-converter-<version-tag>:custom`, you can run it using the following command:

```shell
sudo docker run --rm \
 -v $(pwd):$(pwd) \
 waf-compiler-<version-tag>:custom \
 -i $(pwd)/policy1.xml -o $(pwd)/policy1.json
 ```

### User Defined Signatures Converter

The User Defined Signatures Converter tool takes a User Defined Signatures XML file as input and exports the content as a JSON file suitable for use in an NGINX App Protect WAF environment. It is located at `/opt/app_protect/bin/convert-signatures` inside the WAF Compiler image.

The tool can optionally accept a tag argument as an input. Otherwise, the default tag value `user-defined-signatures` is assigned to the exported JSON file.

Note that the User Defined signatures XML file can be obtained by exporting the signatures from a BIG-IP device.

Usage:

```shell
Required arguments:
    --outfile|o='/path/to/signatures.json'
        File name to write JSON format export
        Can also be set via an environment variable: EXPORT_FILE
    --infile|i='/path/to/signatures.xml'
        Advanced WAF/ASM User Defined Signatures file to Convert
        Can also be set via an environment variable: IMPORT_FILE

Optional arguments:
    --tag|t='mytag'
        Signature Tag to associate with User Defined Signatures.
        If no tag is specified in the XML file, a default tag of 'user-defined-signatures' will be assigned.
        Can also be set via an environment variable: TAG
    --format|f='json'
        Desired output format for signature file. Default 'json'
        Supported formats: 'json'

Optionally, using --help will issue this help message.
```

Example of generating a user defined signature JSON file (with default tag):

```shell
sudo docker run --rm \
 -v $(pwd):$(pwd) \
 --entrypoint=/opt/app_protect/bin/convert-signatures \
 waf-compiler-<version-tag>:custom \
 -i $(pwd)/signatures.xml -o $(pwd)/signatures.json
```

Output:

```json
{
    "file_size": 1003,
    "filename": "/path/to/signatures.json",
    "completed_successfully": true
}
```

Example of the contents of the output file (displayed and piped into `jq`):

```json
{
    "signatures": [
        {
            "attackType": {
                "name": "Buffer Overflow"
            },
            "name": "my_first_sig",
            "lastUpdateMicros": 1606014750000000,
            "rule": "content:\"first_sig\"; nocase;",
            "description": "This is the first user defined signature",
            "revision": "1",
            "systems": [
                {
                    "name": "Microsoft Windows"
                }
            ],
            "accuracy": "low",
            "signatureId": "300000002",
            "signatureType": "request",
            "risk": "low"
        },
        {
            "attackType": {
                "name": "Command Execution"
            },
            "name": "my_second_sig",
            "lastUpdateMicros": 1606014818000000,
            "rule": "uricontent:\"second_sig\"; nocase; objonly;",
            "description": "Short description of the signature",
            "revision": "1",
            "systems": [
                {
                    "name": "Unix/Linux"
                }
            ],
            "accuracy": "medium",
            "signatureId": "300000003",
            "signatureType": "request",
            "risk": "medium"
        }
    ],
    "tag": "user-defined-signatures"
}
```

Example of generating a user defined signature JSON file (with custom tag):

```shell
sudo docker run --rm \
 -v $(pwd):$(pwd) \
 --entrypoint=/opt/app_protect/bin/convert-signatures \
 waf-compiler-<version-tag>:custom \
 -i $(pwd)/signatures.xml -o $(pwd)/signatures.json --tag "MyTag
```

Note that if the script is run without the required switches and their corresponding arguments, it will display the help message.

## Attack Signature Report Tool

The Attack Signature Report tool scans the system for attack signatures and generates a JSON report file that includes information about these signatures. It is located at `/opt/app_protect/bin/get-signatures` inside the WAF Compiler image.

This report can be used for reporting or troubleshooting purposes or for auditing/tracking changes for signature updates on the NGINX App Protect WAF deployment itself.

Usage:

```shell
  Required arguments:
    --outfile|o='/path/to/report-file.json'
      File name to write signature report.

  Optional arguments:
    --fields|f='list,of,fields'
      Comma separated list of desired fields.
      Available fields:
      name,signatureId,signatureType,attackType,accuracy,tag,risk,systems,hasCve,references,isUserDefined,description,lastUpdateMicros
```

Example of generating a signature report (with all signature details):

```shell
sudo docker run --rm \
 -v $(pwd):$(pwd) \
 --entrypoint=/opt/app_protect/bin/get-signatures \
 waf-compiler-<version-tag>:custom \
 -o $(pwd)/signature-report.json
```

Output (displayed and piped into `jq`):

```json
{
    "file_size": 1868596,
    "filename": "/path/to/signature-report.json",
    "completed_successfully": true
}
```

Example of the contents of the output file (displayed and piped into `jq`):
```json
{
    "signatures": [
        {
            "isUserDefined": false,
            "attackType": {
                "name": "Detection Evasion"
            },
            "name": "Unicode Fullwidth ASCII variant",
            "hasCve": false,
            "systems": [
                {
                    "name": "IIS"
                }
            ],
            "references": [
                {
                    "value": "infosecauditor.wordpress.com/2013/05/27/bypassing-asp-net-validaterequest-for-script-injection-attacks/",
                    "type": "url"
                }
            ],
            "signatureId": 299999999,
            "signatureType": "request",
            "risk": "low",
            "accuracy": "low"
        },
        {
            "isUserDefined": false,
            "attackType": {
                "name": "Predictable Resource Location"
            },
            "name": "IIS Web Server log dir access (/W3SVC..)",
            "hasCve": false,
            "systems": [
                {
                    "name": "IIS"
                }
            ],
            "references": [
                {
                    "value": "www.webappsec.org/projects/threat/classes/predictable_resource_location.shtml",
                    "type": "url"
                }
            ],
            "signatureId": 200000001,
            "signatureType": "request",
            "risk": "low",
            "accuracy": "high"
        },
        {
            "isUserDefined": false,
            "name": "WEB-INF dir access (/WEB-INF/)",
            "attackType": {
                "name": "Predictable Resource Location"
            },
            "hasCve": true,
            "systems": [
                {
                    "name": "Java Servlets/JSP"
                },
                {
                    "name": "Macromedia JRun"
                },
                {
                    "name": "Jetty"
                }
            ],
            "references": [
                {
                    "value": "www.webappsec.org/projects/threat/classes/predictable_resource_location.shtml",
                    "type": "url"
                },
                {
                    "value": "CVE-2016-4800",
                    "type": "cve"
                },
                {
                    "value": "CVE-2007-6672",
                    "type": "cve"
                }
            ],
            "signatureType": "request",
            "risk": "low",
            "signatureId": 200000018
        }
    ],
    "revisionDatetime": "2019-07-16T12:21:31Z"
}
```

Example of generating signature report (with a preset set of fields):

```shell
sudo docker run --rm \
 -v $(pwd):$(pwd) \
 --entrypoint=/opt/app_protect/bin/get-signatures \
 waf-compiler-<version-tag>:custom \
 -o $(pwd)/signature-report.json --fields=name,signatureId
```

Note that if the script is run without the required switches and their corresponding arguments, it will display the help message.

Optionally, you can build an image for the signature report tool by using the WAF Compiler image as a base and overriding the default entrypoint in your Dockerfile:

```Dockerfile
ENTRYPOINT /opt/app_protect/bin/get-signatures
```

Assuming you have tagged this image as `waf-sig-reporter-<version-tag>:custom`, you can run it using the following command:

```shell
sudo docker run --rm \
 -v $(pwd):$(pwd) \
 waf-sig-reporter-<version-tag>:custom \
 -o $(pwd)/signature-report.json --fields=name,signatureId
 ```
-->
