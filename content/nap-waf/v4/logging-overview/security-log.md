---
description: Learn about the F5 NGINX App Protect WAF Security Log.
docs: DOCS-915
doctypes:
- concept
title: NGINX App Protect WAF Security Log
toc: true
weight: 520
---

## Security Logs

### Security Logs Overview

**Security logs** (also known as **Request logs** or **Traffic logs**) contain information on HTTP requests and responses, how F5 NGINX App Protect WAF processes them, and the final decision made based on the configured policy parameters. The policy configuration defines the information contained in the Security log, such as whether requests are passed, blocked or alerted, due to violations, attack signatures, and other criteria.

NGINX App Protect WAF uses its own logging mechanism for request logging rather than NGINX's access logging mechanism (which is NGINX's default logging mechanism).

The Security log has the following properties:

- **Log Configuration**: `app_protect_security_log` directive referencing security_log.json file

- **Configuration contexts**: nginx.conf: `http`, `server`, `location`

- **File Destination?** Yes. You can set the destination to either `stderr`, or an absolute path to a local file, or you can use syslog, and redirect the log with Netcat and pipe:

    ```shell
    nc -vv -l “[ip]” “[port]” > “[name_of_file]” 2>&1
    ```

- **Syslog Destination?** Yes

### Directives in nginx.conf

#### app_protect_security_log_enable
This directive determines whether security logging will be enabled in the respective context.

The security log attributes are determined by the `app_protect_security_log` directive. The directive can be at the following contexts: `http`, `server` and `location`. When not present at a certain context, the directive is inherited from the context above it: `location` from `server`, then from `http`. If there is no directive at any of these context levels, then the logging is disabled for the respective context.

•	Syntax: app_protect_security_log_enable on | off

•	Levels: http, server, location

•	Example: app_protect_security_log_enable on
##### Arguments

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}

|Argument | Mandatory | Meaning | Default |
| ---| ---| ---| --- |
|ON-OFF | Yes | Whether to enable logging or not | off |

{{</bootstrap-table>}}


#### app_protect_security_log
The security log attributes are determined by the `app_protect_security_log` directive, if it was enabled in the respective context. The directive can be at the following context levels: `http`, `server` and `location`. Multiple occurrences of this directive are allowed in a single context, and all the configured logs in this context will be used. When not present in a certain context, all the directives are inherited from the context above it: `location` from `server`, then from `http`. If there is no directive at any of these context levels, but logging is enabled then the default is used for the respective context.

•	Syntax: app_protect_security_log [LOG-CONFIG-FILE] [DESTINATION]

•	Levels: http, server, location

•	Examples:

```nginx
app_protect_security_log "/etc/app_protect/conf/log_default.json" stderr;
app_protect_security_log "/etc/app_protect/conf/log_default.json" /var/log/app_protect/security.log;
app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=localhost:514;
app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=my-specific-machine-name:514;
app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=192.168.12.34:514;
app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=my.domain.com:514;
```

•	**Note:** When using `stderr`, make sure that the process `bd-socket-plugin` is not redirecting the `stderr` output to file.<br>
	- When using the Docker `entrypoint.sh` startup script from the admin guide, make sure that it doesn't redirect `stderr`.<br>
	- When using services startup, make sure that the service startup file for `nginx-app-protect.service` doesn't redirect `stderr`.

##### Arguments

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}

|Argument | Mandatory | Meaning | Default |
| ---| ---| ---| --- |
|LOG-CONFIG-FILE | No | The path to the log configuration file. See details below. | /etc/app_protect/conf/log_default.json This file is identical to "/opt/app_protect/share/defaults/log_illegal.json" after installation, but can be modified later. |
|DESTINATION | No | The destination of the log messages in NGINX format. The supported destinations options are `stderr`, or an absolute path to a local file, or syslog server as localhost, hostname, IP address or FQDN with an optional port.| syslog:server=localhost:514 |

{{</bootstrap-table>}}


### Security Log Configuration File
The file is in JSON format and consists of two parts:

1.	**filter:** which requests are to be logged.
2.	**content:** how the message is formatted.

#### Filter
The filter is mandatory, although it may be left blank.

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}

|Element | Meaning | Type/Values | Default |
| ---| ---| ---| --- |
|request_type | Log according to what App Protect detected in the request. | Enumerated values:<ul><li>**all:** all requests, both legal and illegal.</li><li>**illegal:** requests with violations (i.e., either alerted or blocked).</li><li>**blocked:** requests with violations that were blocked.</li></ul> | all |

{{</bootstrap-table>}}


#### Content
This part of the configuration file specifies what will be logged, the format of the message, and size restrictions.

Content is mandatory. If the entire content field or any of its attributes are not defined, system-defined default values are used.

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}

|Element | Meaning | Type/Values | Mandatory | Default | Comment |
| ---| ---| ---| ---| ---| --- |
|format | Selects one of the predefined formats of log messages or a custom format that will be defined by the **format_string** field. | Enumerated values:<ul><li>**arcsight:** formatted according to ArcSight Common Event Format (CEF) with custom fields adapted for F5.</li><li>**big-iq**: formatted for BIG-IQ, the F5 centralized management platform for BIG-IP.</li><li>**default:** default format for App Protect. See the `NGINX Format Strings` section below for more details.</li><li>**grpc:** a variant of the `default` format suited for gRPC traffic. See the `NGINX Format Strings` section below for more details.</li><li>**splunk:** formatted for Splunk SIEM with F5 plugin.</li><li>**user-defined:** custom format defined by the user in the format_string field.</li></ul> | No | default |  |
|format_string | Layout template of the logged fields in the log message. | String representing the template of the message with placeholders for the message attributes. The currently available security log attributes are specified below in the `Available Security Log Attributes` section. Each attribute name is delimited by percent signs, for example: %violation_rating% | If, and only if, format=user-defined | N/A |  |
|max_message_size | Limit in KB for the total size of the message. | Range of values between 1k-64k, must not be smaller than the max_request_size | No | 2k |  |
|max_request_size | Limit in bytes for the sizes of the `request` and `request_body_base64` fields in the log. Must be smaller than max_message_size. | Integer representing bytes in the range of 1-10240, or **any**. **any** is synonymous with 10240. The type is string in terms of JSON schema, to accommodate the **any** option. The limit for “max_request_size” in log configuration is increased from 2k to 10k. | No | 2k | Relevant only if the request field is present in the log. |
| escaping_characters | Allows to replace a character in security log value with another character. There are two subfields to configure:<ul><li>**from:** defines the character to be replaced.</li><li>**to:** defines the result character after replacing</li></ul> | String both for *from* and *to* fields | No | N/A | |
| list_prefix | Defines the prefix of a list of values in the log. | String | No | N/A | |
| list_delimiter | Defines the delimiter of a list of values in the log. | String | No | `,` | |
| list_suffix | Defines the suffix of a list of values in the log. | String | No | N/A | |

{{</bootstrap-table>}}


#### Examples

##### Default Logging Content

This is the content of `/etc/app_protect/conf/log_default.json`. It is used by default when `app_protect_security_log_enabled on` is set, but `app_protect_security_log` is not:

```json
{
    "filter": {
        "request_type": "illegal"
    },
    "content": {
        "format": "default",
        "max_request_size": "2k",
        "max_message_size": "5k"
    }
}
```

##### Log Illegal Requests in Key-Value Format

```json
{
    "filter": {
        "request_type": "illegal"
    },
    "content": {
        "format": "user-defined",
        "format_string": "client_ip=%ip_client%,client_port=%src_port%,request=%request%,violations=%violations%,signature_ids=%sig_ids%",
        "max_request_size": 2000,
        "max_message_size": "5k"
    }
}
```

##### Log State Changing Requests

```json
{
    "filter": {
        "request_type": "all"
    },
    "content": {
        "format": "default",
        "max_request_size": "2k",
        "max_message_size": "5k"
    }
}
```

##### A Verbose Custom Formatted Message

```json
{
    "filter": {
        "request_type": "illegal"
    },
    "content": {
        "format": "user-defined",
        "format_string": "Request ID %support_id%: %method% %uri% received on %date_time% from IP %ip_client% had the following violations: %violations%",
        "max_request_size": "2k",
        "max_message_size": "5k"
    }
}
```

##### Log with Escaped Character and Custom List Prefix / Delimiter / Suffix

```json
{
    "filter": {
        "request_type": "all"
    },
    "content": {
        "format": "default",
        "max_request_size": "2k",
        "max_message_size": "5k",
        "escaping_characters": [
      	    {
                "from": "/",
                "to": "|"
            }
        ],
        "list_prefix": "[",
        "list_delimiter": "::",
        "list_suffix": "]"
    }
}
```

Note that in the last example:

- any `/` character in list element string in security log will be replaced with `|`. For example: `string/another_string` will become `string|another_string`.

- all lists will start with `[` and end with `]` and each element of the list will be separated with `::`. For example: `first,second,third` will become `[first::second::third]`.

#### NGINX Format Strings

When format = `default` or `grpc`, messages are shown in comma separated key-value pairs consisting of the attributes appearing in [Available Security Log Attributes](#available-security-log-attributes) with some differences: `grpc` format contains the gRPC-specific fields and the request body encoded in Base64 and separated from the headers, while the `default` format contains the whole request in one field in its original encoding. See details there.

Both `default` and `grpc` strings start like this:

"attack_type=\\"%attack_type%\\",blocking_exception_reason=\\"%blocking_exception_reason%\\",..."

### Syslog Transport
The syslog transport is over TCP. It is currently unsecured, which means that SSL/TLS is not supported. We highly recommend that you do not send the logs directly to their remote destinations, but rather proxy them through a local syslog server residing on the same pod or same VM as NGINX App Protect WAF. The local syslog server will forward them over a secure channel to the remote destination. We recommend you use mutual authentication TLS (mTLS) to avoid any man-in-the-middle attacks attempting to hijack or alter the logs on their way.

It is *not* guaranteed that all requests that match the filters will indeed reach their destination especially if the system is overwhelmed by the incoming traffic. In this case some log records may be dropped.

### Factory Configuration Files
NGINX will provide example configuration files under /opt/app_protect/share/defaults/ with the following settings:

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}

|Name | Filter | Content |
| ---| ---| --- |
|log_all | all | format=default |
|log_blocked | blocked requests | format=default |
|log_f5_arcsight | illegal requests | format=arcsight, sizes are system-defined and cannot be changed. |
|log_f5_splunk | illegal requests | format=splunk, sizes are system-defined and cannot be changed. |
|log_grpc_all | all | format=grpc |
|log_grpc_blocked | blocked requests | format=grpc |
|log_grpc_illegal | illegal requests | format=grpc |
|log_illegal | illegal requests | format=default |

{{</bootstrap-table>}}


### Available Security Log Attributes
The table below lists attributes that are generated in the security logs. When using customized logs (i.e., format=user-defined), you can add or remove entries from the list below. Per each attribute we show whether it is included in each of the predefined formats: `default` and `grpc`.



{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}

|Attribute Name | Description | Included in formats |
| ---| ---| --- |
| attack_type | A list of comma separated names of suspected attacks identified in a transaction. | default, grpc |
| blocking_exception_reason | The blocking exception reason when a configured violation was not blocked. | default, grpc |
| bot_anomalies | Comma-separated list of anomalies that were detected. | default, grpc |
| bot_category | The category of the detected bot. | default, grpc |
| bot_signature_name | The name of the detected bot. | default, grpc |
| client_class | The classification of the client. It can have one of the following values: `N/A`, `Suspicious Browser`, `Malicous Bot`, `Trusted Bot`, `Untrusted Bot`. If the client is classified as standard browser, then the value is `N/A`. | default, grpc |
| date_time | The date and time the request was received by App Protect. | default, grpc |
| dest_port | The port assigned to listen to incoming requests. | default, grpc |
| enforced_bot_anomalies | Comma-separated list of anomalies that caused the request to be blocked. | default, grpc |
| grpc_method | The method name of the gRPC request (derived from the URI). Not to be confused with `http_method`. Applicable only to requests that are processed by a gRPC Content Profile. The value is `N/A` in other cases. | grpc |
| grpc_service | The service name of the gRPC request (derived from the URI). Applicable only to requests that are processed by a gRPC Content Profile. The value is `N/A` in other cases. | grpc |
| compression_method | The compression algorithm used for the present message. Currently one of: <ul><li>gzip</li><li>deflate</li><li>none</li><li>n/a</li></ul> | grpc |
|headers | The headers part of the request including the query string but not the body. | grpc |
|ip_client | The source IP of the client initiating the request<br>       Note: if a proxy is being used, this may differ from the IP in the `X-Forwarded-For` header. | default, grpc |
|is_truncated_bool | A flag that returns `true` if a request is truncated in the security logs, or `false` if it is not. | default, grpc <br><br> **Note:** The log field name used for this attribute is `is_truncated`.|
|json_log | Contains the violations and applicable signature names and IDs associated with a transaction. See [Blocking Observability](#blocking-observability) for more information. <br> **Note:** Starting with release 4.3, the `json_log` field will include the Violation details formatted in JSON format. | default, grpc |
| json_log.stream.id | The id of the gRPC stream (request) to which the current message belongs. This is used to correlate all the messages in the stream. Currently this number is identical to the support id of the headers message. | grpc |
| json_log.stream.index | The ordinal sequence number of the message in the stream. The numbering starts from 0 which is always the request headers event. In Unary rpcs there will only be indexes 0 and 1. | grpc |
| json_log.stream.controlState | The current state of the client stream as reflected by the message:<ul><li>**start:** headers </li><li>**ongoing:** gRPC messages before the last </li><li>**end:** empty log entry that indicates stream closing</li></ul>   | grpc |
|method | The method of request. For example, GET, POST, HEAD. | default, grpc |
|outcome | One of the following:<ul><li>**PASSED:** the request was sent to the backend server.</li><li>**REJECTED:** the request was blocked.</li></ul> | default, grpc |
|outcome_reason | One of the following:<ul><li>**SECURITY_WAF_OK:** allowed with no violations (legal request).</li><li>**SECURITY_WAF_VIOLATION:** blocked due to security violations.</li><li>**SECURITY_WAF_FLAGGED:** allowed, although it has violations (illegal).</li><li>**SECURITY_WAF_VIOLATION_TRANSPARENT:** allowed, when the policy is in transparent mode, but would be blocked if the policy is set to blocking mode. </li></ul> | default|
|policy_name | The name of the App Protect policy for which the violation was triggered. | default, grpc |
|protocol | The protocol used, either HTTP or HTTPS if terminating SSL on App Protect. | default, grpc |
|request | The entire request including headers, query string, and data in its original encoding. If the request contains binary content or uses text encoding that the log destination does not support, then this field may not be rendered correctly. In such cases we recommend using the `request_body_base64` and `headers` fields instead. | default |
|request_body_base64 | The body of the request (if exists) encoded in Base64. Suitable for binary content. | grpc |
|request_status | The status of client request made to Web Application as assigned by the App Protect policy. The possible values are:<ul><li>**blocked:** The request was blocked due to a violation encountered. A blocking response page was returned to the client.</li><li>**alerted:** The request contains violation(s) but is not blocked (typical in cases where the enforcement mode is set to transparent).</li><li>**passed:** A successful request with no violations.</li></ul> | default, grpc |
|response_code | The response code returned by the server. | default, grpc |
|severity | The maximum severity calculated from all violations found in the request. It is a static value coming from the Violations. | default, grpc |
|sig_cves | Signature CVEs value of the matched signatures. | default, grpc |
|sig_ids | Signature ID value of the matching signature that resulted in the violation. | default, grpc |
|sig_names | Signature name of the matching signature that resulted in the violation. | default, grpc |
|sig_set_names | The signature set names of the matched signatures. | default, grpc |
|src_port | The source port of the client. | default, grpc |
|sub_violations | Refers to the sub-violations detected under the ‘HTTP protocol compliance failed’ and the ‘Evasion technique detected’ violations. | default, grpc |
|support_id | A unique identifier for a transaction. | default, grpc |
|threat_campaign_names | Names of the Threat Campaigns detected in the request, separated by commas. | default, grpc |
|unit_hostname | host name of the app-protect instance | default, grpc |
|uri | The URI or Uniform Resource Identifier of the request. | default, grpc |
|violation_details | XML including details about each violation. | default, grpc |
|violation_rating | Estimation of the likelihood that the request is indeed a threat on a scale of 0 to 5: 0 - not a threat (no violations), 5 - most likely a threat | default, grpc |
|violations | Comma-separated list of logical violation names (e.g., `VIOL_ATTACK_SIGNATURES`, `VIOL_HTTP_PROTOCOL`). | default, grpc |
|vs_name | A unique identifier of the location in the nginx.conf file that this request is associated with. It contains the line number of the containing server block in nginx.conf, the server name, a numeric discriminator that distinguishes between multiple entries within the same server, and the location name.  For example: ’34-mydomain.com:0-~/.*php(2). | default, grpc |
|x_forwarded_for_header_value | `X-Forwarded-For` header information. This option is commonly used when proxies are involved to track the originator of the request. | default, grpc |

{{</bootstrap-table>}}

### Blocking Observability

When the NGINX App Protect policy is enforced in Transparent Mode, it is easier to know which transactions would be blocked if the Blocking Mode is set to **True** and also would be able to know which violations and signatures intended for the transaction to be blocked.

To facilitate this, NGINX App Protect introduces a new security log field named `json_log`, which contains JSON formatted data. This field contains the violations and applicable signature names and IDs associated with a transaction. This field will indicate if a particular violation or signature will create a blocking condition (indicated in the `isBlocked` property) according to the signature/violation configuration.

Each detected signature is reported within a JSON block with the `VIOL_ATTACK_SIGNATURE` violation and the `isBlocked` boolean property.

Here is an example of `json_log` field for a request with several violations and signatures:

```JSON
{
  "violations": [
    {
      "enforcementState": {
        "isBlocked": false
      },
      "violation": {
        "name": "VIOL_URL_METACHAR"
      }
    },
    {
      "enforcementState": {
        "isBlocked": true
      },
      "violation": {
        "name": "VIOL_RATING_THREAT"
      }
    },
    {
      "enforcementState": {
        "isBlocked": true
      },
      "signature": {
        "name": "XSS script tag (URI)",
        "signatureId": 200000099
      },
      "violation": {
        "name": "VIOL_ATTACK_SIGNATURE"
      }
    },
    {
      "enforcementState": {
        "isBlocked": true
      },
      "signature": {
        "name": "XSS script tag end (URI)",
        "signatureId": 200000093
      },
      "violation": {
        "name": "VIOL_ATTACK_SIGNATURE"
      }
    }
  ]
}
```
