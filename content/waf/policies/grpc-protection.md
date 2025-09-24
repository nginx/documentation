---
# We use sentence case and present imperative tone
title: "gRPC protection"
# Weights are assigned in increments of 100: determines sorting order
weight: 1200
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This topic describes the gRPC protection feature for F5 WAF for NGINX.

gRPC is a remote API standard and is an alternative to OpenAPI. 

F5 WAF for NGINX can protect applications exposing gRCP APIs by parsing their messages, ensuring sure they are compliant with the API specification and and enforcing security restrictions.

These security restrictions include size limits, detecting attack signatures, threat campaigns, and suspicious metacharacters in message string field values.

Only protocol buffer version 3 is supported. Any obsolete features of version 2, such as message extensions in the IDL files, will be rejected. 

IDL files that have the syntax = "proto2"; statement are also rejected.

## Unary traffic

### Content profiles

gRPC content profiles contain all the definitions for protecting a gRPC service, and are similar to [JSON and XML profiles]({{< ref "/waf/policies/xml-json-content.md##xml-and-json-content-profiles" >}}). 

They include:

- **The IDL files** of the protected gRPC service. This is essential for F5 WAF for NGINX to be able to parse the API messages and determine whether they are legal and what needs to be inspected for security.
- **Security enforcement**, which detect signatures and/or metacharacters and optionally an exception list of signatures (Such as overrides) that need to be disabled in the context of a profile.
- **Defense attributes**, special restrictions applied to the gRPC traffic. This includes a size limit for the gRPC messages in the request, and whether to tolerate fields that are not defined in the definition of the Protocol Buffer messages.


An example service might have the following IDL file:

```proto
syntax = "proto3";

package myorg.services;

import "common/messages.proto";

service photo_album {
  rpc upload_photo (Photo) returns (OperationResult) {};
  rpc get_photos (Condition) returns (PhotoResult) {};
}

message Photo {
  string name = 1;
  bytes image = 2;
}

message PhotoResult {
  repeated Photo photos = 1;
  OperationResult res = 2;
}
```

The definitions of `OperationResult` and `Condition` messages are in the imported file found in `common/messages.proto` .

Both files need to be referenced in the gRPC content profile:


```json
{
    "policy": {
        "name": "my-grpc-service-policy",
        "grpc-profiles": [
            {
                "name": "photo_service_profile",
                "associateUrls": true,
                "defenseAttributes": {
                    "maximumDataLength": 100000,
                    "allowUnknownFields": false
                },
                "attackSignaturesCheck": true,
                "signatureOverrides": [
                    {
                        "signatureId": 200001213,
                        "enabled": false
                    },
                    {
                        "signatureId": 200089779,
                        "enabled": false
                    }
                ],
                "metacharCheck": true,
                "idlFiles": [
                    {
                        "idlFile": {
                            "$ref": "file:///grpc_files/album.proto"
                        },
                        "isPrimary": true
                    },
                    {
                        "idlFile": {
                            "$ref": "file:///grpc_files/common/messages.proto"
                        },
                        "importUrl": "common"
                    }
                ]
            }
        ],
        "urls": [
            {
                "name": "*",
                "type": "wildcard",
                "method": "*",
                "$action": "delete"
            }
        ]
    }
}
```

The profile in this example enables checking of attack signatures and disallowed metacharacters in the string-typed fields within the service messages, with two signatures disabled. 

The profile also limits the size of the messages to 100KB and disallows fields that are not defined in the IDL files.

The main IDL file, `album.proto`, is marked as `primary`. The file it imports, `messages.proto`, and any others, are marked as secondary without `isPrimary`.

In order for F5 WAF for NGINX to match it to the import statement, the file location should be specified using the `importUrl` property such as in the example.

There is an alternative way to specify to all IDL files (Including their direct and indirect imports) by bundling them into a single tar file with the same directory structure expected by the import statements. 

With this method, you will have to specify which of the files in the tarball is the primary one. The supported formats are `tar` and `tgz`. 

F5 WAF for NGINX will identify the file type automatically and handle it accordingly:

```json
"idlFiles": [{
    "idlFile": {
        "$ref": "file:///grpc_files/album_service_files.tgz"
    },
    "primaryIdlFileName": "album_service.proto"
}]
```

Note the deletion of the `*` URL in the previous example. This is required to accept only requests to the gRPC services exposed by your applications. 

If you leave the wildcard URL, F5 WAF for NGINX will accept other traffic including gRPC requests, applying policy checks such as signature detection.

However, it will not apply to any gRPC-specific protection to them.

### Associate profiles with URLs

In order for a gRPC content profile to be effective, it has to be associated with a URL that represents the service. 

In the previous example, the profile was not associated with any URL and remained functional due to `associateUrls` being set to `true`.

F5 WAF for NGINX **implicitly** creates the URL based on the package and service name as defined in the IDL file and associates the profile with that URL.

Automatic association with URLs (`associateUrls` is `true`) is the recommended method of configuring gRPC protection.

If your gRPC services are mapped to URLs in a different manner, you can always explicitly associate a gRPC content profile with a different or an additional URL than the one implied by the service name.

In the following example, the URL is `/myorg.services.photo_album/*`. As a wildcard URL, all methods are matched, such as `/myorg.services.photo_album/get_photos` representing the `get_photos` RPC method.

```json
{
    "policy": {
        "name": "my-special-grpc-service-policy",
        "grpc-profiles": [
            {
                "name": "special_service_profile",
                "associateUrls": false,
                "defenseAttributes": {
                    "maximumDataLength": "any",
                    "allowUnknownFields": true
                },
                "attackSignaturesCheck": true,
                "idlFiles": [
                    {
                        "idlFile": {
                            "$ref": "file:///grpc_files/special_service.proto"
                        },
                        "isPrimary": true
                    }
                ]
            }
        ],
        "urls": [
            {
                "name": "/services/unique/special/*",
                "method": "POST",
                "type": "wildcard",
                "isAllowed": true,
                "urlContentProfiles": [
                    {
                        "contentProfile": {
                            "name": "special_service_profile"
                        },
                        "headerName": "*",
                        "headerOrder": "default",
                        "headerValue": "*",
                        "type": "grpc"
                    }
                ]
            },
            {
                "name": "*",
                "type": "wildcard",
                "method": "*",
                "$action": "delete"
            }
        ]
    }
}
```

You can override the properties of the URL with the gRPC content profile even if you use `associateUrls` to `true`. 

For example, you can turn off meta character checks by adding `"metacharsOnUrlCheck": false` within the respective URL entry.

### Response pages

A gRPC error response page is returned when a request is blocked. 

The default page returns gRPC status code `UNKNOWN` (numeric value of 2) and a short text message that includes the support ID. 

You can customize both two by adding a custom gRPC response page in your policy.

```json
{
    "policy": {
        "name": "my-special-grpc-service-policy",
        "response-pages": [
            {
                "responsePageType": "grpc",
                "grpcStatusCode": "INVALID_ARGUMENT",
                "grpcStatusMessage": "Operation does not comply with the service requirements. Please contact your administrator with the following number: <%TS.request.ID()%>"
            }
        ]
    }
}
```

The `grpcStatusCode` expects one of the [standard gRPC status code values](https://grpc.github.io/grpc/core/md_doc_statuscodes.html).

### Detect Base64 in string values

F5 WAF for NGINX to can detect if values in string fields in gRPC payload are Base64 encoded. 

When a value is detected as Base64 encoded F5 WAF for NGINX will enforce the configured signatures on the decoded value **and** the original value.

This feature is disabled by default and can be enabled by setting `decodeStringValuesAsBase64` to `enabled`.

gRPC protocol buffers are intended to carry binary fields of "bytes" type and trying to decode strings as Base64 may lead to false positives. 

Using Base64-encoded strings for binary data is not considered good practice, but Base64 detection can be enabled for applications that do so.

```json
{
    "policy": {
        "applicationLanguage": "utf-8",
        "name": "valid_string_encoding_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "idl-files": [
            {
                "fileName": "valid_string.proto",
                "link": "file:///tmp/grpc/valid_string.proto"
            }
        ],
        "grpc-profiles": [
            {
                "name": "base64_decode_strings",
                "description": "My first profile",
                "idlFiles": [
                    {
                        "idlFile": {
                            "fileName": "valid_string.proto"
                        }
                    }],
                "decodeStringValuesAsBase64": "enabled"
            }
        ]
    }
}
```

### Server reflection

[gRPC server reflection](https://grpc.github.io/grpc/core/md_doc_server_reflection_tutorial.html) provides information about publicly-accessible gRPC services on a server, and assists clients at runtime to construct RPC requests and responses without precompiled service information. 

gRPC server reflection is not currently supported by F5 WAF for NGINX. 

If server reflection support is required, F5 WAF for NGINX must be disabled on the reflection URIs by adding a location block:

```nginx
server {
    location /grpc.reflection {
        app_protect_enable off;
        grpc_pass grpc://grpc_backend;
    }
}
```

## Bidirectional streaming

gRPC can have a stream of messages on each side: client, server, or both. 

Bidirectional streaming leverages HTTP/2 streaming capability, namely the ability to send multiple gRPC messages from either side ended by the message having the `END_STREAM` flag set to 1.

Bidirectional streaming will:

1. Accept streaming services on either or both sides (client or server) and send a sequence of messages using a read-write stream.
1. Inspect the client messages in the stream and log them one by one.
1. In case of blocking action:
    - Send the blocking response.
    - Close the stream on both directions.
1. Pass the server messages through without inspection.

### Configure streaming

The only configuration related to streaming is the IDL file using the `rpc` declaration. The keyword `stream` indicates that the message on the respective side is streaming.

#### Client stream

A client writes a sequence of messages and sends them to the server. Once the client has finished writing the messages, it waits for the server to read them and return its response.

gRPC guarantees message ordering within an individual RPC call.

```shell
rpc LotsOfGreetings(stream HelloRequest) returns (HelloResponse);
```
#### Server stream

The client sends a request to the server and gets a stream to read a sequence of messages back. 

The client reads from the returned stream until there are no more messages. gRPC guarantees message ordering within an individual RPC call.

```shell
rpc LotsOfReplies(HelloRequest) returns (stream HelloResponse);
```
#### Bidirectional streams

Both sides send a sequence of messages using a read-write stream. 

The two streams operate independently, so clients and servers can read and write in whatever order they like: for example, the server could wait to receive all the client messages before writing its responses, or it could alternately read a message and then write a message, or some other combination of reads and writes. 

The order of messages in each stream is preserved.

```shell
rpc BidiHello(stream HelloRequest) returns (stream HelloResponse);
```

```proto
syntax = "proto3";
package streaming;
service Greeter {
  rpc BothUnary (HelloRequest) returns (HelloReply) {}
  rpc ClientStreaming (stream HelloRequest) returns (HelloReply) {}
  rpc ServerStreaming (HelloRequest) returns (stream HelloReply) {}
  rpc BidirectionalStreaming (stream HelloRequest) returns (stream HelloReply) {}
}
message HelloRequest {
  string message = 1;
}
message HelloReply {
  string message = 1;
}
```

### Enable gRPC protection for bidirectional streaming

To enable gRPC protection, an HTTP/2 server definition needs to be applied with the `grpc_pass` location in the `nginx.conf` file. In addition, the `app_protect_policy_file` directive points to a policy specific to gRPC. 

All gRPC messages will be in the security logs under the `log_grpc_all.json` file: for more details, refer to the [gRPC logging](#grpc-logging) section.

```nginx
user nginx;
worker_processes auto;

load_module modules/ngx_http_app_protect_module.so;

error_log /var/log/nginx/error.log debug;
working_directory /tmp/cores;
worker_rlimit_core 1000M;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    keepalive_timeout  30m;
    client_body_timeout 30m;
    client_max_body_size 0;
    send_timeout 30m;

    proxy_connect_timeout  30m;
    proxy_send_timeout  30m;
    proxy_read_timeout  30m;
    proxy_socket_keepalive on;

    server {
        listen       80 default_server http2;
        server_name  localhost;
        app_protect_enable on;
        app_protect_policy_file "/etc/app_protect/conf/grpc_policy.json";
        app_protect_security_log_enable on;
        app_protect_security_log "/opt/app_protect/share/defaults/log_grpc_all.json" /tmp/grpc.log;

        grpc_socket_keepalive on;
        grpc_read_timeout 30m;
        grpc_send_timeout 30m;

        location / {
            default_type text/html;
            grpc_pass grpc://<GRPC_BACKEND_SERVER_IP>:<PORT>;
        }
    }
}
```

### Bidirectional streaming enforcement

Bidirectional enforcement applies per message: each message is buffered and processed (For all inspection actions according to the policy: signatures, metacharacters, and other violations) on its own.

When receiving a client event:

- The request header and each of the messages in the client stream is enforced **separately**.
- The Enforcer issues a separate security log message per each message containing the violations found on it (if any). Refer to the [gRPC violations](#grpc-violations) section for more details on gRPC violations. There is a separate log message per request headers opening the stream.
- Then the Enforcer decides on the action that results from the violations just as it does for a regular HTTP request, but in gRPC it is done **per message** rather than the per whole stream. If a message needs to be blocked, a blocking response is sent to the client and the stream is closed, but all the messages that preceded the blocked message have already been sent to the server.
- If the request headers message has blocking violations, the blocking response is sent right away, ignoring any subsequent client messages. The security log will just reflect the headers in this scenario.

#### Server response flow

gRPC server messages are not processed. All gRPC messages (unary or streaming) including the headers and trailer messages, are sent directly to the client (without sending them to the Enforcer).

With bidirectional streaming, the blocking response comes as the trailers message is sent to the client on behalf of the server. 

At the same time, the server gets the END_STREAM frame to ensure streams on both sides are closed.

#### Size limits

The maximum total request size is applied to each message on its own, rather than to the total stream messages. 

By default, the maximum gRPC message size is 4MB. You can configure different sizes in the declarative policy, like the 100KB in the [content profiles example](#content-profiles).

If a message is sent with a size larger than that value, a _GRPC_FORMAT_ violation is raised. If a message is sent with a size larger than 10MB, a _GRPC_MALFORMED_ and _REQUEST_MAX_LENGTH_ violation is raised.

There is no limit to the number of messages in a stream.

#### Message compression

Message compression is not currently supported. 

It will trigger the violation _VIOL_GRPC_MALFORMED_  and the connection will be blocked if a compressed message is sent.

#### Slow POST attacks

A Slow POST attack or Slow HTTP POST attack is a type of denial of service attack. 

The attacker sends a legitimate HTTP POST request with the header Content-Length specified. The attacker then proceeds to send this content slowly. The server establishes a connection to the client and keeps it open to receive the request that it thinks is legitimate.

The attacker sends several such requests and effectively occupies the server’s entire connection pool. As a result, it blocks the service for other legitimate users and results in a denial of service.

To mitigate this, a client sending messages very slowly for a long time may be cut off by resetting the connection.

In gRPC, a connection is considered “slow” if a message takes more than 10 seconds to process. The slow connection timer will be reset when a message ends and not when the whole request ends. 

This way, a limit is applied on the number of concurrent messages rather than the number of concurrent gRPC connections (streams), as many of them may be idle.

The number of slow connections is limited to 25. Once another connection becomes slow it is reset.

## gRPC violations

There are three violations specific to gRPC, which are all enabled in the default policy

- `VIOL_GRPC_MALFORMED`: This violation is issued when a gRPC message cannot be parsed according to its expected definition. This violation **blocks** in the default policy.
- `VIOL_GRPC_FORMAT`: This violation is issued when any of the definitions in the `defenseAttributes` of the profile are violated; for example, the maximum total size is exceeded.
- `VIOL_GRPC_METHOD`: This violation is issued when the gRPC method is unrecognized in the configured IDL.

The violation `VIOL_METHOD` (not to be confused with the above `VIOL_GRPC_METHOD`) is not unique to gRPC, but in the context of a gRPC content profile, it is issued in special circumstances.

Since gRPC mandates the `POST` method on any gRPC request over HTTP, any other HTTP method on a request to URL with gRPC content profile will trigger this violation, even if the respective HTTP method is allowed in the policy. 

In an earlier example, the request `GET /myorg.services.photo_album/get_photos` will trigger `VIOL_METHOD` even though `GET` is among the allowed HTTP methods in the policy (by the base template).

## gRPC logging

Security logs for gRPC requests have three unique fields: `uri`, `grpc_method`, and `grpc_service`.

Since the content of gRPC requests is binary (protocol buffers), they are transferred with Base64 encoding. As a result, it is recommended to use the `headers` and `request_body_base64` fields instead of the `request` field. 

A new predefined log format called `grpc` should be used in all gRPC locations that also use policies with gRPC content profiles.

View the [available security log attributes]({{< ref "/waf/logging/security-logs.md#available-security-log-attributes" >}}) topic for more information.

F5 WAF for NGINX provides three security log bundles for gRPC using the new format: `log_grpc_all`, `log_grpc_illegal` and `log_grpc_blocked` for all requests, illegal requests, and blocked requests respectively. 

Unless you have special requirements, the best practice is to use one of these bundles in all gRPC locations with the `app_protect_security_log` directive.

```nginx
server {
    server_name my_grpc_service.com;
    location / {
        app_protect_enable on;
        app_protect_policy_file "/etc/app_protect/conf/policy_with_grpc_profile.tgz";
        app_protect_security_log_enable on;
        app_protect_security_log "/etc/app_protect/conf/log_grpc_all.tgz" stderr;
        grpc_pass grpcs://grpc_backend;
    }
}
```