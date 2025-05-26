---
docs: "DOCS-1616"
---

The gRPC Content Profile contains all the definitions for protecting a gRPC service. It is similar in nature to the **JSON and XML profiles** handling JSON and XML traffic respectively. Roughly it includes:
- **The IDL files** of the protected gRPC service. This is essential for App Protect to be able to parse the API messages and determine whether they are legal and what needs to be inspected for security. [For more info regarding including an external file]({{< ref "#including-an-external-json-schema-file" >}}).
- **Security enforcement**: whether to detect signatures and/or metacharacters and optionally an exception (a.k.a override) list of signatures that need to be disabled in the context of this profile.
- **Defense attributes**: special restrictions applied to the gRPC traffic. This includes a size limit for the gRPC messages in the request, and whether to tolerate fields that are not defined in the definition of the Protocol Buffer messages.

Let's look at an example:

Assume you have a service with this IDL:

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

The definitions of `OperationResult` and `Condition` messages are in the imported file found in `common/messages.proto` which we will not list here. The two files need to be referenced in the gRPC Content Profile. Here is the policy with the profile example:

#### Policy with the profile example:

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

The profile in this example enables checking of attack signatures and disallowed metacharacters in the string-typed fields within the service messages. Two signatures are disabled. The profile also limits the size of the messages to 100KB and disallows fields that are not defined in the IDL files.

The main IDL file, `album.proto` is marked as `primary`. The file it imports, `messages.proto`, is marked as secondary, that is, `isPrimary` is `false` and so should be any imported file. In order for App Protect to be able to match it to the import statement, the file location should be specified as done in the example above using the `importUrl` property.

An alternative and probably more convenient way to specify all the IDL files, the primary and all its imports, direct and indirect, is to bundle them into a single tar file in the same directory structure as they are expected by the import statements. In this case, you will have to specify which of the files in the tarball is the primary one. The supported formats are `tar` and `tgz`. App Protect will identify the file type automatically (tar, gzipped tar, or JSON) and handle it accordingly. Following the above example:

```json
"idlFiles": [{
    "idlFile": {
        "$ref": "file:///grpc_files/album_service_files.tgz"
    },
    "primaryIdlFileName": "album_service.proto"
}]
```

Note the deletion of the `*` URL in the above policy. This is required if you want to accept only requests pertaining to the gRPC services exposed by your apps. If you decide to leave this catch-all URL, App Protect will accept other traffic including gRPC requests, applying policy checks such as signature detection. However, it will not apply to any gRPC-specific protection on them.
