---
nd-docs: "DOCS-1562"
---

There are three violations that are specific to gRPC. They are all enabled in the default policy. See also the [Violations](#violations) section.

- `VIOL_GRPC_MALFORMED`: This violation is issued when a gRPC message cannot be parsed according to its expected definition. This violation **blocks** in the default policy.
- `VIOL_GRPC_FORMAT`: This violation is issued when any of the definitions in the `defenseAttributes` of the profile are violated; for example, the maximum total size is exceeded.
- `VIOL_GRPC_METHOD`: This violation is issued when the gRPC method is unrecognized in the configured IDL.

The violation `VIOL_METHOD` (not to be confused with the above `VIOL_GRPC_METHOD`) is not unique to gRPC, but in the context of a gRPC Content Profile, it is issued in special circumstances. Since gRPC mandates using the `POST` method on any gRPC request over HTTP, any other HTTP method on a request to URL with gRPC Content Profile will trigger this violation, even if the respective HTTP method is allowed in the policy. So, in our first example above, the request `GET /myorg.services.photo_album/get_photos` will trigger `VIOL_METHOD` even though `GET` is among the allowed HTTP methods in the policy (by the base template).