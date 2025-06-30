---
nd-docs: "DOCS-1555"
---

As with JSON and XML profiles, in order for a gRPC Content Profile to become effective, it has to be associated with a URL that represents the service. However, in the sample policy above, the profile was apparently not associated with any URL and yet the profile is active. How did this happen? By setting `associateUrls` with `true`, App Protect **implicitly** creates the URL based on the package and service name as defined in the IDL file and associates the profile with that URL. In this example, the URL is `/myorg.services.photo_album/*`. Note it is a wildcard URL so that all methods in this service match it in its suffix; for example `/myorg.services.photo_album/get_photos` represents the `get_photos` RPC method.

Automatic association with URLs (`associateUrls` is `true`) is the recommended method of configuring gRPC protection, but if your gRPC services are mapped to URLs in a different manner, you can always explicitly associate a gRPC Content Profile with a different or an additional URL than the one implied by the service name, as in this example:

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

You can always override the properties of the URL with the gRPC Content Profile even if you use `associateUrls` to `true`. For example, you can turn off meta character checks by adding `"metacharsOnUrlCheck": false` within the respective URL entry.