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

If you leave the wikdcard URL, F5 WAF for NGINX will accept other traffic including gRPC requests, applying policy checks such as signature detection.

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

