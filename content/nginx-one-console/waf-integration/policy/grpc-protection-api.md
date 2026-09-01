---
title: "Add gRPC protection to a policy"
weight: 450
toc: true
f5-content-type: how-to
f5-product: NGINX One Console
---

F5 WAF for NGINX can protect gRPC APIs by validating messages against their Interface Definition Language (IDL) files (`.proto`). This is configured through the `grpc-profiles` property of a WAF policy.

{{< call-out class="important" >}}
This page covers only how to upload the `.proto` files a `grpc-profiles` entry references through the NGINX One Console API. For a full description of the gRPC protection feature itself — content profiles, defense attributes, URL association, streaming, violations, and logging — see [gRPC protection]({{< ref "/waf/policies/grpc-protection.md" >}}) and the `grpc-profiles` section of the [Policy parameter reference]({{< ref "/waf/policies/parameter-reference.md" >}}).

**gRPC protection is currently supported through the API only.** There is no NGINX One Console UI for configuring `grpc-profiles` or uploading IDL files yet.
{{< /call-out >}}

{{< call-out class="warning" >}}
**⚠️ Experimental API** — The file reference fields and request bodies described on this page (`file_references`, `file_references_archive`, and related schemas) are under active development and may change in a future release.
{{< /call-out >}}

## Why file references are needed

A `grpc-profiles` entry's `idlFiles` point at the service's `.proto` file(s) using a `file://` URI, for example:

```json
"idlFiles": [
  {
    "idlFile": { "$ref": "file:///grpc_files/album.proto" },
    "isPrimary": true
  }
]
```

The policy JSON only contains a *reference* to the file — it doesn't contain the file itself. To make the reference resolvable, you must separately upload the actual `.proto` file content in the same API request that creates or updates the policy.

{{< call-out class="note" >}}
**You must explicitly provide the file contents yourself.** NGINX One Console does not fetch, generate, or infer IDL files on your behalf — you own the `.proto` file(s) for your gRPC service, and you are responsible for uploading their exact content every time you create or update a policy version that references them. If a policy version's `file://` reference has no matching uploaded file, the policy will fail to compile.
{{< /call-out >}}

You can upload file references in either of two ways:

- **Inline as base64 JSON** — good for a small number of files, or when you're already sending the policy as JSON.
- **As a `.tar.gz` archive** — good for bundling many files (for example, a primary `.proto` plus its imports) without base64 overhead. Available only when *creating* a policy.

## Upload files as inline JSON (`file_references`)

Send the policy as `application/json` to `POST /app-protect/policies` (create) or `PUT /app-protect/policies/{nap_policy_object_id}` (update a policy, creating a new version), with a `file_references` array alongside the base64-encoded `policy`:

```json
{
  "policy": "<base64-encoded policy.json>",
  "file_references": [
    {
      "type": "proto",
      "file_path": "/grpc_files/album.proto",
      "content": "<base64-encoded contents of album.proto>"
    }
  ]
}
```

Each entry in `file_references` requires:

| Field | Description |
|-------|--------------|
| `type` | Currently only `proto` is supported. |
| `file_path` | The absolute path matching the `file://` URI referenced in the policy JSON. Must start with `/`. |
| `content` | The base64-encoded file content. |

{{< call-out class="important" >}}
On update (`PUT`), `file_references` **replaces the full set of files** for the new policy version. If you omit `file_references` on an update, the new version is created with **no** file references at all — even if a previous version had files uploaded. Always re-include every file reference the policy still needs when updating.
{{< /call-out >}}

## Upload files as a `.tar.gz` archive (`file_references_archive`)

When creating a policy (`POST /app-protect/policies` only — not supported on update), you can instead send `multipart/form-data` with a `policy` field and a `file_references_archive` field containing a gzip-compressed tarball of the referenced files:

```bash
curl -X POST https://api.nginx-one.console.nginx.com/app-protect/policies \
  -H "Authorization: Bearer <token>" \
  -F "policy=<base64-encoded policy.json>" \
  -F "file_references_archive=@refs.tar.gz;type=application/gzip"
```

The archive's internal directory structure determines the absolute path each file resolves to. Build the archive from the **parent** of the referenced directory so the paths line up with your policy's `file://` URIs:

```
grpc_files/
├── album.proto
└── common/
    └── messages.proto
```

```bash
# Correct — paths resolve to /grpc_files/album.proto, /grpc_files/common/messages.proto
tar czf refs.tar.gz grpc_files/

# Incorrect — paths resolve to /album.proto (missing parent directory)
cd grpc_files && tar czf refs.tar.gz *.proto
```

If your policy references `"$ref": "file:///grpc_files/album.proto"`, the archive must contain `grpc_files/album.proto` at that relative path. Only regular files are extracted — symlinks, hardlinks, and directory-only entries are ignored.

## Path rules and limits

`file_path` (JSON method) and archive entry paths (multipart method) must:

- Be absolute (start with `/`) and contain no `..` traversal segments.
- Target a directory outside the standard system paths (`/etc`, `/tmp`, `/usr`, `/var`, `/opt`, `/root`, and similar). Use a novel top-level directory such as `/grpc_files` for your referenced files.

| Limit | Inline JSON (`file_references`) | Archive (`file_references_archive`) |
|-------|----------------------------------|--------------------------------------|
| Max size per file | 2 MB | 2 MB (uncompressed) |
| Max total size | 5 MB | 10 MB (uncompressed) / 5 MB (compressed archive) |
| Max number of files | 50 | 100 |

## Retrieving file reference information

`GET` requests for a policy version return **metadata only** for each file reference — `type`, `file_path`, `size`, and a base64-encoded SHA-256 `hash` — not the file's content:

```json
"file_references": [
  {
    "type": "proto",
    "file_path": "/grpc_files/album.proto",
    "size": 4096,
    "hash": "oxiWKPqR/soi4MQCgVnW8KHt8Jk68AqCeQcQ1sed4Dk="
  }
]
```

There is currently no endpoint to download the original file content back from NGINX One Console — keep a copy of your `.proto` files on your side.

## Full example

The following creates a WAF policy with a `grpc-profiles` entry that references `album.proto`, uploading the file inline as base64 JSON. (This mirrors the [example]({{< ref "/waf/policies/grpc-protection.md#content-profiles" >}}) from the gRPC protection feature documentation.)

```bash
curl -X POST https://api.nginx-one.console.nginx.com/app-protect/policies \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "policy": "<base64 of the JSON below>",
    "file_references": [
      {
        "type": "proto",
        "file_path": "/grpc_files/album.proto",
        "content": "<base64-encoded contents of album.proto>"
      }
    ]
  }'
```

Decoded `policy` contents:

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
        "idlFiles": [
          {
            "idlFile": { "$ref": "file:///grpc_files/album.proto" },
            "isPrimary": true
          }
        ]
      }
    ],
    "urls": [
      { "name": "*", "type": "wildcard", "method": "*", "$action": "delete" }
    ]
  }
}
```

## See also

- [Set security policies through the API]({{< ref "/nginx-one-console/waf-integration/policy/security-policy-api.md" >}})
- [API reference guide]({{< ref "/nginx-one-console/api/api-reference-guide.md" >}})
- [gRPC protection]({{< ref "/waf/policies/grpc-protection.md" >}}) — full feature description
- [Policy parameter reference]({{< ref "/waf/policies/parameter-reference.md" >}}) — `grpc-profiles` field reference
