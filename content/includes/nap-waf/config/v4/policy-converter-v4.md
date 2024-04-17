---
docs: "DOCS-1539"
---

The Policy Converter tool `/opt/app_protect/bin/convert-policy` is used for converting XML formatted ASM and Advanced WAF policies to JSON. The converted JSON policy is based on the NGINX App Protect WAF policy base template and contains the minimal diff to it in JSON declarative policy format.

Elements in the XML policy that are not supported in the NGINX App Protect WAF environment will generate warnings. Note that any configuration that is invalid or irrelevant to the NGINX App Protect WAF environment is removed from the exported declarative policy.

{{< note >}} All NGINX App Protect WAF versions support converting XML policies exported from BIG-IP regardless of any version. If the source XML policy has not changed from when it was in use on BIG-IP, then it's always a good idea to convert it with the Policy Converter tool included with the version of NGINX App Protect WAF you are using. This way, as more configuration items from BIG-IP become supported in NGINX App Protect WAF, they will be included in the converted policy. A policy that was converted will work on the same or greater NGINX App Protect WAF version it originally came from.{{< /note >}}

The Policy Converter tool has options to include the following elements in a full export:
- Elements that are the same as the default template policy. (Invalid elements are removed, but no warnings reported.)
- Elements that are not supported in the NGINX App Protect WAF environment. (No elements removed and no warnings reported.)

The XML policy file can be obtained by exporting the policy from the BIG-IP device on which the policy is currently deployed.

Using the tool:
```shell
/opt/app_protect/bin/convert-policy
```

Output:
```shell
USAGE:
    /opt/app_protect/bin/convert-policy

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
/opt/app_protect/bin/convert-policy -i /path/to/policy.xml -o /path/to/policy.json | jq
```

Output:
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
    "filename": "/path/to/policy.json"
}
```

In the above example we piped the output to `jq` utility (which needs to be installed separately) to get the output with proper indentation.

Example of generating an unmodified JSON policy (may cause warnings/errors when used in NGINX App Protect WAF):
```shell
/opt/app_protect/bin/convert-policy -i /path/to/policy.xml -o /path/to/policy.json --keep-full-configuration
```

Example of translating a valid NGINX App Protect WAF JSON policy into a full JSON policy including elements from the defaults:
```shell
/opt/app_protect/bin/convert-policy -i /path/to/policy.json -o /path/to/full_policy.json --full-export
```

Note that if the script is run without the required switches and their corresponding arguments, it will display the help message.