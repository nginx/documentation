---
# We use sentence case and present imperative tone
title: "Build and use the converter tools"
# Weights are assigned in increments of 100: determines sorting order
weight: 400
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This document describes the tools F5 WAF for NGINX has to convert existing resources or configuration files from a BIG-IP environment for use with F5 WAF for NGINX. 

{{< call-out "important" >}}

These tools are available in the [compiler image]({{< ref "/waf/configure/compiler.md" >}}), and do not require a full deployment of F5 WAF for NGINX.

{{< /call-out >}}

## Policy converter

The F5 WAF for NGINX policy converter tool is used to convert policies from XML to JSON format. 

It is a script located on on the path `/opt/app_protect/bin/convert-policy`.

The converted policy is based on the F5 WAF for NGINX [base template]({{< ref "/waf/policies/configuration.md#base-template" >}}) and contains the minimal differences required for the JSON policy format.

You can obtain the XML policy file by exporting it from the BIG-IP system on which the policy is currently deployed.

| Option   | Description |
| ---------| ----------- |
| _-i_ | Filename of input WAF or ASM binary policy |
| _-o_ | Filename of output declarative policy |
| _--bot-profile_  | Filename of JSON Bot Profile (pre-converted to JSON from tmsh syntax) |
| _--logging-profile_ | Filename of JSON Logging Profile (pre-converted to JSON from tmsh syntax) |
| _--dos-profile_ | Filename of JSON DoS Profile (pre-converted to JSON from tmsh syntax) |
| _--full-export_ | If specified, the full policy with all entities will be exported. Otherwise, only entities that differ from the template will be included.<br> Default for the CLI is not specific (only differing entities). <br> Default for the REST endpoint above is "--full-export" (you can not override this).|

To convert a policy, first create a temporary folder and copy your XML file to it:

```shell
mkdir tmp/convert
cp <path-to-your-xml-policy-file> tmp/convert/
```

Run the compiler Docker image with the temporary folder as a mounted volume, and execute the policy converter script:

{{< call-out "note" >}}

Replace `waf-compiler-\<version-tag\>:custom` with your compiler image.

{{< /call-out >}}

```docker
docker run -it --rm \
  -v $(pwd):/tmp/convert \
  --entrypoint="/opt/app_protect/bin/convert-policy" \
  waf-compiler-<version-tag>:custom -i test.json -o test.xml
  -i /tmp/convert/policy.xml \
  -o /tmp/convert/policy.json \
  --full-export
```

```json
{
"completed_successfully": true,
"file_size": 20604,
"warnings": [
    "Default header '*-bin' cannot be deleted.",
    "Traffic Learning, Policy Building, and staging are unsupported",
    "/general/enableEventCorrelation must be '0' (was '1').",
    "Element '/websocket-urls' is unsupported.",
    "/signature-sets/learn value 1 is unsupported",
    "Element '/redirection-protection' is unsupported.",
    "/protocolIndependent must be '1' (was '0').",
    "Element '/gwt-profiles' is unsupported.",
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
    "Element '/plain-text-profiles' is unsupported."
],
"filename": "/tmp/convert/policy-ubuntu.json"
}
```

{{< call-out "note" >}}

The [jq](https://jqlang.github.io/jq/) command was used to format the example output.

{{< /call-out >}}

Once complete, the newly converted JSON policy file will reside in the same folder as the source XML policy file:

```shell
ls -l tmp/convert/
total 848
-rw-r--r-- 1 root root  20604 Dec 20 12:33 policy.json  # Exported JSON policy file
-rw-r--r-- 1 root root 841818 Dec 20 11:10 policy.xml   # Original XML policy file
```

## User Defined Signatures converter

The User Defined Signatures converter tool is used to convert a User Defined Signatures file from XML to JSON format.

It is a script located on on the path `/opt/app_protect/bin/convert-signatures`.

The tool accepts an optional tag argument: otherwise, the default tag value _user-defined-signatures_ is assigned with the exported JSON file.

You can obtain the User Defined Signatures XML file by exporting it from the BIG-IP system on which the policy is currently deployed.

These are the command line options available: if the script is run without the required switches and their corresponding arguments, it will display this help message.

```shell
USAGE:
    /opt/app_protect/bin/convert-signatures

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

This is an example of how to convert a single XML file (With the default tag):

{{< call-out "note" >}}

Replace `waf-compiler-\<version-tag\>:custom` with your compiler image.

{{< /call-out >}}

```shell
docker run -v `pwd`:`pwd` -w `pwd` --entrypoint /opt/app_protect/bin/convert-signatures waf-compiler-<version-tag>:custom -i /path/to/signatures.xml -o /path/to/signatures.json | jq
```

```json
{
    "filename": "/path/to/signatures.json",
    "file_size": 1602,
    "completed_successfully": true
}
```

**signatures.json**

```json
{
    "tag": "user-defined-signatures",
    "signatures": [
        {
            "accuracy": "high",
            "risk": "high",
            "systems": [],
            "rule": "content:\"header1\"; nocase;",
            "description": "",
            "signatureType": "request",
            "signatureId": "300000000",
            "revision": "1",
            "lastUpdateMicros": 1731425468000000,
            "name": "sig_1_header",
            "attackType": {
                "name": "Abuse of Functionality"
            }
        },
        {
            "signatureId": "300000002",
            "signatureType": "request",
            "attackType": {
                "name": "Cross Site Scripting (XSS)"
            },
            "name": "sig_3_uri",
            "lastUpdateMicros": 1731425631000000,
            "revision": "1",
            "risk": "high",
            "accuracy": "high",
            "description": "",
            "rule": "uricontent:\"<script>\"; nocase;",
            "systems": [
                {
                    "name": "Nginx"
                }
            ]
        },
        {
            "name": "sig_2_param",
            "attackType": {
                "name": "Abuse of Functionality"
            },
            "lastUpdateMicros": 1731425549000000,
            "revision": "1",
            "signatureId": "300000001",
            "signatureType": "request",
            "description": "",
            "rule": "valuecontent:!\"param\"; nocase; httponly; norm;",
            "systems": [],
            "accuracy": "high",
            "risk": "high"
        },
        {
            "systems": [
                {
                    "name": "Apache"
                },
                {
                    "name": "Unix/Linux"
                },
                {
                    "name": "Proxy Servers"
                },
                {
                    "name": "Django"
                }
            ],
            "description": "",
            "rule": "valuecontent:\"json123\"; nocase; jsononly; norm;",
            "risk": "high",
            "accuracy": "high",
            "lastUpdateMicros": 1731425782000000,
            "revision": "1",
            "attackType": {
                "name": "Server-Side Request Forgery (SSRF)"
            },
            "name": "sig_5_",
            "signatureType": "request",
            "signatureId": "300000004"
        },
        {
            "description": "",
            "rule": "uricontent:\"etc\"; nocase;",
            "systems": [
                {
                    "name": "Microsoft Windows"
                },
                {
                    "name": "Unix/Linux"
                }
            ],
            "accuracy": "high",
            "risk": "high",
            "name": "sig_4_",
            "attackType": {
                "name": "Path Traversal"
            },
            "lastUpdateMicros": 1731425708000000,
            "revision": "1",
            "signatureId": "300000003",
            "signatureType": "request"
        }
    ]
}
```

{{< call-out "note" >}}

The [jq](https://jqlang.github.io/jq/) command was used to format the example output.

{{< /call-out >}}

This is an example of how to convert a single XML file (With a custom tag):

```shell
docker run -v `pwd`:`pwd` -w `pwd` --entrypoint /opt/app_protect/bin/convert-signatures waf-compiler-<version-tag>:custom -i /path/to/signatures.xml -o /path/to/signatures.json --tag "MyTag"
```

## Attack Signature Report tool

The Attack Signature Report tool scans the system for attack signatures, then generates a JSON report file with information about these signatures.

This tool can be deployed and used independently from a F5 WAF for NGINX deployment using the [compiler image]({{< ref "/waf/configure/compiler.md" >}}) to generate a report about the default signatures included with F5 WAF, or the signatures included in [an update package]().

The latter case is possible on a standalone compiler deployment by comparing a report from before a signature update and a report from after the signature update.

This report can be used for reporting and troubleshooting purposes or for tracking changes to signature updates on an F5 WAF for NGINX deployment.

These are the command line options available: if the script is run without the required switches and their corresponding arguments, it will display this help message.

```shell
USAGE:
    /opt/app_protect/bin/get-signatures <arguments>

  Required arguments:
    --outfile|o='/path/to/report-file.json'
      File name to write signature report.

  Optional arguments:
    --fields|f='list,of,fields'
      Comma separated list of desired fields.
      Available fields:
      name,signatureId,signatureType,attackType,accuracy,tag,risk,systems,hasCve,references,isUserDefined,description,lastUpdateMicros

Optionally, using --help will issue this help message.
```

This command example generates a signature report with all signature details:

```shell
/opt/app_protect/bin/get-signatures -o /path/to/signature-report.json
```

```json
{
    "file_size": 1868596,
    "filename": "/path/to/signature-report.json",
    "completed_successfully": true
}
```

**signature-report.json**

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

{{< call-out "note" >}}

The [jq](https://jqlang.github.io/jq/) command was used to format the example output.

{{< /call-out >}}

This command example generates a signature report with two pre-defined fields:

```shell
/opt/app_protect/bin/get-signatures -o /path/to/signature-report.json --fields=name,signatureId
```