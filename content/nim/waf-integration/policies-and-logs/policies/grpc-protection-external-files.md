---
title: Create a gRPC security policy with external files
description: Upload .proto files with an F5 WAF for NGINX policy in F5 NGINX Instance Manager so the policy can protect your gRPC services.
toc: true
weight: 800
f5-content-type: how-to
f5-product: F5 NGINX Instance Manager
f5-keywords: "gRPC, proto, IDL, file references, WAF policy, REST API"
f5-summary: >
  Reference external .proto files from an F5 WAF for NGINX policy by using the F5 NGINX Instance Manager REST API.
  Instance Manager validates the files, compiles them with the policy, and removes temporary files after compilation.
f5-audience: admin
---

This guide explains how to protect gRPC services by referencing external `.proto` files from an F5 WAF for NGINX policy in F5 NGINX Instance Manager.

Using the F5 NGINX Instance Manager REST API, you can attach external files directly to a WAF policy request — no need to place files on the Instance Manager host before compilation. You can upload `.proto` IDL files for gRPC protection, OpenAPI specification files (`.yaml`, `.yml`, `.json`) for API protection, and `.tgz` bundles that package `.proto`, `.yaml`, `.yml`, `.json` files with their directory structure. When you create or update a policy through the API, Instance Manager does three things:

- **Accepts the files** with the policy, in the same API request.
- **Validates the references in both directions.** Every `file://` reference in the policy must have a matching uploaded file, and every uploaded file must be referenced by the policy.
- **Cleans up automatically.** Instance Manager writes the files to a temporary directory for compilation, then removes the directory when compilation finishes.

After compilation, the `.proto` files are bundled with the compiled policy and delivered to your NGINX instances.

{{< call-out class="note" title="API only" >}}This feature is available in F5 NGINX Instance Manager 2.24.0 and later, and only through the REST API. The web interface doesn't support it in this release.{{< /call-out >}}

## Before you begin

Make sure you have:

- NGINX Instance Manager 2.24.0 with F5 WAF for NGINX policy management set up. See [How WAF policy management works]({{< ref "/nim/waf-integration/overview.md" >}}).
- An access token or basic authentication credentials for the REST API. The examples in this topic use an access token. To use basic authentication instead, replace the `Authorization` header with `-u <USERNAME>:<PASSWORD>`.
- The `.proto` file for your gRPC service, plus every file it imports, directly or indirectly.

## How file references work

In a policy, a gRPC profile lists its `.proto` files in `idlFiles`. Each entry
points to an uploaded file using a `file://` URI:


## Prepare your files

1. Identify the *primary* `.proto` file. This is the file that defines the gRPC service.
2. Collect every file that the primary file imports, and every file those files import. NGINX Instance Manager doesn't discover imports for you, so list each file explicitly, and upload each file.

For more about how F5 WAF for NGINX uses `.proto` files in gRPC content profiles,
including supported proto3 syntax requirements and import resolution, see
[gRPC protection]({{< ref "/waf/policies/grpc-protection.md" >}}).

3. Check that your files meet these limits:

   | Limit | JSON request | Multipart request |
   |-------|--------------|-------------------|
   | Maximum number of files | 50 | 100 |
   | Maximum size per file | 2 MB | 2 MB |
   | Maximum total size | 5 MB (decoded) | 5 MB compressed, 10 MB uncompressed |

   The base64-encoded policy `content` field can be up to 3 MB.

4. Check the file types. NGINX Instance Manager accepts the following types, and you set the type of each file in the `type` field of its `file_references` entry:

   | `type` value | File extensions | Use for |
   |--------------|-----------------|---------|
   | `proto` | `.proto` | gRPC service definition files |
   | `openapi` | `.yaml`, `.yml`, `.json` | OpenAPI specification files for API protection |
   | `tgz` | `.tgz`, `.tar` | IDL bundle: `.proto` files packaged with their directory structure (experimental). Note: `.tar.gz` is not a supported extension — use `.tgz` or `.tar`. |

   If an archive contains any other file type, NGINX Instance Manager rejects the whole archive.

5. Check that your `.proto` files meet the WAF compiler requirements:

   - They use Protocol Buffers version 3 syntax (`syntax = "proto3";`).
   - The primary file defines at least one `service` block with at least one `rpc` method.
   - Every imported file is also uploaded, either as a separate `file_references` entry or in the same bundle, with `importUrl` set on each secondary file to match the import prefix.

   The WAF compiler validates syntax at compile time. If a file has errors, compilation returns a message that describes the failure.

### Create a .tgz bundle

To upload many `.proto` files in one entry, package them with their directory structure in a `.tgz` bundle. The following steps use these sample files. Save each file to the path shown:

{{< details summary="Sample files" >}}

`payment_service.proto` is the primary gRPC service definition:

```protobuf
syntax = "proto3";

package payments;

service PaymentService {
  rpc ProcessPayment(PaymentRequest) returns (PaymentResponse);
}

message PaymentRequest {
  string customer_id = 1;
  string description = 2;
}

message PaymentResponse {
  string transaction_id = 1;
  string status         = 2;
}
```

`common/money.proto` is a supporting type that the service imports:

```protobuf
syntax = "proto3";

package common;

message Money {
  string currency_code = 1;
  int64  amount_micros = 2;
}
```

`payment_api.yaml` is an OpenAPI specification for API protection policies:

```yaml
openapi: "3.0.0"
info:
  title: Payment API
  version: "1.0"
paths:
  /payments/{id}:
    get:
      summary: Get payment by ID
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
      responses:
        "200":
          description: Payment details
```

{{< /details >}}

1. Create a directory structure that matches the import paths:

   ```shell
   mkdir -p grpc_bundle/grpc_files/common
   cp payment_service.proto grpc_bundle/grpc_files/
   cp common/money.proto grpc_bundle/grpc_files/common/
   ```

2. Create the bundle:

   ```shell
   cd grpc_bundle
   tar -czf payment_bundle.tgz grpc_files/
   ```

## Define the gRPC profile in the policy

Add a `grpc-profiles` section to your policy JSON. For each `.proto` file, add an entry to `idlFiles`.

| Field | Required | Description |
|-------|----------|-------------|
| `hasIdlFiles` | Yes | Set to `true` when the profile has `idlFiles`. |
| `associateUrls` | No | Set to `true` to associate URLs with the profile from `google.api.http` annotations in your `.proto` files. If you set this field, every `.proto` file must have those annotations. Otherwise, `apcompile` fails. The example in this topic omits this field. |
| `idlFiles[].idlFile.$ref` | Yes | The `file:///` URI of the file. It must match an uploaded file path. |
| `idlFiles[].isPrimary` | Yes, for one file when you reference individual `.proto` files | Set to `true` for exactly one file in each profile. Don't use it with a `.tgz` bundle. |
| `idlFiles[].primaryIdlFileName` | Yes, for a `.tgz` bundle | The entry-point `.proto` file inside the bundle, as a relative path as it appears in the bundle, for example `grpc_files/payment_service.proto`. |
| `idlFiles[].importUrl` | Required for non-primary files that other files import. Not needed with a `.tgz` bundle | The directory portion of the path used in `import` statements. See [Set importUrl](#set-importurl). |

The following example defines a profile with one primary file and four imported files:
```json
{
  "policy": {
    "name": "acme-grpc-policy",
    "enforcementMode": "blocking",
    "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
    "applicationLanguage": "utf-8",
    "grpc-profiles": [
      {
        "name": "payment-service-profile",
        "attackSignaturesCheck": true,
        "hasIdlFiles": true,
        "idlFiles": [
          {
            "idlFile": { "$ref": "file:///grpc_files/payment_service.proto" },
            "isPrimary": true
          },
          {
            "idlFile": { "$ref": "file:///grpc_files/common/money.proto" },
            "importUrl": "common"
          }
        ]
      }
    ]
  }
}
```

### Set importUrl

When a `.proto` file contains an `import` statement, the WAF compiler uses `importUrl` to find the imported file. Set `importUrl` on every non-primary file to the directory portion of the path used in the `import` statement. If you omit it, compilation can fail with a `File not found` error even when the file is uploaded.

| Path of the file | Import statement | `importUrl` |
|------------------|------------------|-------------|
| `/payments/billing/invoice.proto` | `import "payments/billing/invoice.proto"` | `payments/billing` |
| `/common/pagination.proto` | `import "common/pagination.proto"` | `common` |
| `/service.proto` (top level) | `import "service.proto"` | Empty, or omit the field |

The primary file doesn't need `importUrl`.

### Reference a .tgz bundle

When you upload a `.tgz` bundle, reference the bundle in a single `idlFiles` entry and use `primaryIdlFileName` to identify the entry-point file inside it. Don't set `isPrimary` or `importUrl`:

```json
{
  "policy": {
    "name": "acme-grpc-policy",
    "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "grpc-profiles": [
      {
        "name": "acme-service-profile",
        "hasIdlFiles": true,
        "idlFiles": [
          {
            "idlFile": { "$ref": "file:///grpc_files/payment_bundle.tgz" },
            "primaryIdlFileName": "grpc_files/payment_service.proto"
          }
        ]
      }
    ]
  }
}
```

## Create the policy with the files

### Encode the content in Base64

In a JSON request, you must Base64-encode the policy JSON and every file. Paste the output as the value of the `content` field.

```shell
# Linux
base64 -w 0 <FILE_NAME>

# macOS
base64 <FILE_NAME>
```

Replace `<FILE_NAME>` with the policy JSON, a `.proto` file, an OpenAPI file, or a `.tgz` bundle.

### Choose an upload path

| Scenario | Upload path |
|----------|-------------|
| Individual `.proto` files (any number, up to the limits) | JSON |
| One `.tgz` bundle with a decoded size of 2 MB or less | JSON, with the Base64-encoded bundle in `content` |
| One `.tgz` bundle with a decoded size over 2 MB | Multipart, with the bundle inside an outer `.tar.gz` archive |
| Multiple `.tgz` bundles, up to 10 MB uncompressed in total | Multipart, with all bundles inside one outer `.tar.gz` archive |

### Send the request

Choose one of the following methods. Use multipart for large proto trees.

{{<tabs name="grpc-upload-method">}}

{{%tab name="JSON"%}}

Send the files in the `file_references` array of a JSON request. Base64-encode each file.

```shell
curl -X POST https://<NIM_FQDN>/api/platform/v1/security/policies \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d @grpc-policy-request.json
```

Replace `<NIM_FQDN>` with the fully qualified domain name (FQDN) of your NGINX Instance Manager host and `<ACCESS_TOKEN>` with your access token.

{{< details summary="JSON request" open=true >}}

```json
{
  "metadata": {
    "name": "acme-grpc-policy",
    "displayName": "Acme gRPC policy"
  },
  "content": "<BASE64_ENCODED_POLICY>",
  "file_references": [
    {
      "file_path": "/acme_service.proto",
      "type": "proto",
      "content": "<BASE64_ENCODED_FILE>"
    },
    {
      "file_path": "/payments/amount.proto",
      "type": "proto",
      "content": "<BASE64_ENCODED_FILE>"
    }
  ]
}
```

{{< /details >}}

Each `file_references` entry has the following fields:

| Field | Required | Description |
|-------|----------|-------------|
| `file_path` | Yes | The absolute path of the file (starts with `/`). It must match the `$ref` path in the policy without the `file://` prefix. |
| `type` | Yes | The file type. Set to `proto`, `openapi`, or `tgz`. Instance Manager doesn't infer the type from the file extension, so you must set it for every file. |
| `content` | Yes | The Base64-encoded file content. |

To upload a `.tgz` bundle, add one entry with `"type": "tgz"` and the Base64-encoded bundle in `content`. The decoded bundle must be 2 MB or less:

```json
{
  "metadata": {
    "name": "acme-grpc-policy",
    "displayName": "Acme gRPC policy - bundle"
  },
  "content": "<BASE64_ENCODED_POLICY>",
  "file_references": [
    {
      "type": "tgz",
      "file_path": "/grpc_files/payment_bundle.tgz",
      "content": "<BASE64_ENCODED_BUNDLE>"
    }
  ]
}
```

To upload an OpenAPI specification, add an entry with `"type": "openapi"`:

```json
{
  "metadata": {
    "name": "acme-api-policy",
    "displayName": "Acme API protection policy"
  },
  "content": "<BASE64_ENCODED_POLICY>",
  "file_references": [
    {
      "type": "openapi",
      "file_path": "/openapi_files/payment_api.yaml",
      "content": "<BASE64_ENCODED_FILE>"
    }
  ]
}
```

The policy JSON for this request references the file in `open-api-files`:

```json
{
  "policy": {
    "name": "acme-api-policy",
    "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
    "applicationLanguage": "utf-8",
    "enforcementMode": "blocking",
    "open-api-files": [
      { "link": "file:///openapi_files/payment_api.yaml" }
    ]
  }
}
```

{{%/tab%}}

{{%tab name="Multipart"%}}

Send the files as a single `.tar.gz` archive in the `file_references_archive` field of a `multipart/form-data` request.

1. Create the archive from inside the directory that contains your proto root. The path of each entry in the archive must match the path in the policy `$ref`, without the `file://` prefix.

   ```shell
   cd /path/to/proto/root
   tar czf /tmp/archive.tar.gz acme_service.proto common/
   ```

   Don't create the archive from a parent directory. An extra directory prefix, such as `./myservice/payments/amount.proto`, doesn't match the policy path `file:///payments/amount.proto`, and compilation fails.

2. Check the entry paths:

   ```shell
   tar -tvf /tmp/archive.tar.gz
   ```

   The entries should look like `./payments/amount.proto`, with no extra leading directory.

3. Send the request:

   ```shell
   curl -X POST https://<NIM_FQDN>/api/platform/v1/security/policies \
     -H "Authorization: Bearer <ACCESS_TOKEN>" \
     -F 'metadata={"name":"acme-grpc-policy","displayName":"Acme gRPC policy"};type=application/json' \
     -F "content=$(base64 -w 0 policy.json)" \
     -F "file_references_archive=@/tmp/archive.tar.gz;type=application/gzip"
   ```

   The request has the following fields:

   | Field | Required | Description |
   |-------|----------|-------------|
   | `metadata` | Yes | A JSON-encoded string with the policy `name`. You can also include `displayName` and `description`. |
   | `content` | Yes | The Base64-encoded policy JSON, as a string. |
   | `file_references_archive` | Yes | The `.tar.gz` archive of your `.proto` files, uploaded as a binary file. |

Archive entries must use relative paths. Instance Manager rejects archives that contain `..` or absolute paths.

#### Upload multiple .tgz bundles via multipart *(experimental)*

Multipart upload support for `.tgz` IDL bundles — where one or more `.tgz` files are packaged inside an outer `.tar.gz` transport archive — is experimental in this release. The behavior may change in a future release. For a single `.tgz` bundle whose decoded size is 2 MB or less, use the JSON method instead.

Use this path when you have:

- More than one `.tgz` bundle, or
- A single `.tgz` bundle with a decoded size over 2 MB

Put all the `.tgz` files inside one outer `.tar.gz` transport archive:

1. Copy each `.tgz` bundle to the path that the policy `$ref` uses. For the bundles in [Reference a .tgz bundle](#reference-a-tgz-bundle), the `$ref` values are `file:///grpc_files/payment_bundle.tgz` and `file:///grpc_files/auth_bundle.tgz`:

   ```shell
   mkdir -p transport/grpc_files
   cp grpc_bundle/payment_bundle.tgz transport/grpc_files/
   cp grpc_bundle/auth_bundle.tgz transport/grpc_files/
   ```

2. Create the outer archive from inside the `transport` directory, so the entry paths have no extra leading directory:

   ```shell
   cd transport
   tar czf /tmp/archive.tar.gz grpc_files/
   ```

3. Check that the entries match the `$ref` paths:

   ```shell
   tar -tvf /tmp/archive.tar.gz
   ```

   The output should list:

   ```text
   grpc_files/payment_bundle.tgz
   grpc_files/auth_bundle.tgz
   ```

4. In the policy JSON, reference each bundle with its own `idlFiles` entry and its own `primaryIdlFileName`:

   ```json
   "idlFiles": [
     {
       "idlFile": { "$ref": "file:///grpc_files/payment_bundle.tgz" },
       "primaryIdlFileName": "payment_service.proto"
     },
     {
       "idlFile": { "$ref": "file:///grpc_files/auth_bundle.tgz" },
       "primaryIdlFileName": "auth_service.proto"
     }
   ]
   ```

5. Send the request with the outer archive in the `file_references_archive` field:

   ```shell
   curl -X POST https://<NIM_FQDN>/api/platform/v1/security/policies \
     -H "Authorization: Bearer <ACCESS_TOKEN>" \
     -F 'metadata={"name":"acme-grpc-policy","displayName":"Acme gRPC policy"};type=application/json' \
     -F "content=$(base64 -w 0 policy.json)" \
     -F "file_references_archive=@/tmp/archive.tar.gz;type=application/gzip"
   ```

   Instance Manager extracts the `.tgz` bundles from the outer archive, stores each one, and supplies them to the compiler at compile time.

{{< call-out class="caution" title="Experimental" >}}
Packaging `.tgz` bundles inside an outer `.tar.gz` for multipart upload is experimental in this release and subject to change in a future release. Do not use this method in production environments without testing. For stable single-bundle workflows, use the JSON body method described in [Send the request](#send-the-request).
{{< /call-out >}}

{{%/tab%}}

{{</tabs>}}

If the request succeeds, Instance Manager returns `201 Created` and the policy metadata, including the policy UID. By default, the response doesn't list the stored file references. To include the file reference metadata (path, type, size, and hash), add the `includePolicyContent=true` query parameter to the request.

{{< call-out class="note" title="Update a policy with file references" >}}
The `PUT` method is deprecated for updating a policy. To change the files or the policy, send a `POST` request with a JSON body that includes `file_references` to `/api/platform/v1/security/policies?isNewRevision=true`. This creates a new revision of the policy. You can't change the policy name when you create a new revision. Multipart requests aren't supported when you update a policy. See [Update a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/update-policy.md" >}}).
{{< /call-out >}}

{{< call-out class="note" title="OpenAPI files" >}}
A policy can't use both `openAPISpecContent` (legacy) and `file_references` in the same request. To upload OpenAPI specification files with your `.proto` files, use `file_references`:

1. Add an entry with `"type": "openapi"`. The `file_path` must end in `.yaml`, `.yml`, or `.json`.
2. Reference the file in the `open-api-files` section of the policy with a `file:///` URI, for example `"link": "file:///openapi_files/spec.yaml"`.
{{< /call-out >}}

## Verify the policy

1. Check that the policy compiled and that its bundle includes your `.proto` files.

To check compilation status in the web interface:

1. Go to **Security > Policies**.
2. Select the policy you created.
3. Select the **...** actions menu, then select **Compile**.
4. The compilation status appears on the policy detail page. If compilation fails, the error message describes the specific failure.

To retrieve a compiled bundle using the API, send a `GET` request to the policy endpoint with `includePolicyContent=true`:


2. Reference the compiled policy in your NGINX configuration and publish it to your instances.

   - Add the `app_protect_policy_file` directive to the server that handles gRPC traffic. See [Add WAF configuration]({{< ref "/nim/waf-integration/configuration/manage-waf-configurations/add-configuration.md" >}}) and [Edit WAF configuration]({{< ref "/nim/waf-integration/configuration/manage-waf-configurations/edit-waf-configuration.md" >}}).
   - Publish the policy to an NGINX instance or instance group. See [Publish updates to instances]({{< ref "/nim/waf-integration/policies-and-logs/publish/publish-to-instances.md" >}}).
   - Confirm that the deployment succeeded. See [Check publication status]({{< ref "/nim/waf-integration/policies-and-logs/publish/check-publication-status.md" >}}).


3. Send test requests to the gRPC service and confirm that the policy blocks attacks.


## Remove protection

To stop protecting the gRPC service:

1. Remove the `app_protect_policy_file` directive that references the policy, or set `app_protect_enable` to `off`, in the NGINX configuration for the gRPC server. See [Edit WAF configuration]({{< ref "/nim/waf-integration/configuration/manage-waf-configurations/edit-waf-configuration.md" >}}).
2. Publish the updated configuration to your instances. See [Publish updates to instances]({{< ref "/nim/waf-integration/policies-and-logs/publish/publish-to-instances.md" >}}).
3. Optional: Delete the policy if you no longer need it. See [Delete a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/delete-policy.md" >}}).
4. Send the same test requests that you used to verify the policy. The service should no longer block them.

When you delete a policy:

- **Stored file references are deleted.** Instance Manager removes all `.proto` files and other file references associated with the policy from its database. This operation can't be undone.
- **Temporary compilation files are already removed.** Instance Manager writes files to a temporary directory only for the duration of each compilation, and removes that directory when compilation finishes. There are no temporary files to clean up when you delete a policy.
- **Published NGINX configurations are not affected immediately.** If the policy is still referenced by a published NGINX configuration, NGINX continues to enforce the last compiled policy bundle until you publish an updated configuration. Deleting the policy from Instance Manager does not automatically update NGINX instances. Removing the `app_protect_policy_file` directive (step 1 above) and publishing the updated configuration is what stops enforcement.

## Troubleshooting

### The request fails with a 400 error

Instance Manager validates file references before it stores the policy.
The error response has code `13102` when creating a policy, or `13103` when updating
a policy with `isNewRevision=true`. The reason is in `details[0].description`.

| Error | Cause | Fix |
|-------|-------|-----|
| `policy contains a file reference but no files were uploaded` | The policy has a `file://` reference, but the request has no files. | Upload the files, or remove the reference. |
| `remote URL references are not supported` | A `$ref` uses an `http://` or `https://` URL. | Upload the file and use a `file:///` URI. |
| `referenced file not found in uploaded file references` | A `$ref` path doesn't match an uploaded path. Matching is case-sensitive. | Make the `file_path` match the `$ref` path exactly. |
| `file path must be absolute` | A `file_path` doesn't start with `/`. | Use `/grpc_files/service.proto`, not `grpc_files/service.proto`. |
| `uploaded file is not referenced by the policy` | A `file://` URI in the policy JSON that has no corresponding entry in `file_references` (missing upload). | A file in `file_references` has no matching `file://` reference in the policy. | Add a `$ref` for the file, or remove the file from the request. |
| `archive contains a file with an unsupported extension` | The archive has a file that isn't `.proto`, `.yaml`, `.yml`, `.json`, `.tgz`, or `.tar`. | Remove the file from the archive. |
| `the uploaded file is not a valid .tar.gz archive` | The archive isn't gzip-compressed tar. | Recreate the archive with `tar czf`. |
| `an archive entry contains an unsafe path` | An entry uses `..` or an absolute path. | Recreate the archive with relative paths. |
| `uploaded file is not referenced by any file:// URI in the policy` | A file in `file_references` was uploaded but the policy has no matching `file://` URI for it. Every uploaded file must be referenced. | Add a `$ref` in the policy for the file, or remove it from `file_references`. |
| `malformed file:// URI: "file://host/path" format is not supported` | A `$ref` uses two slashes followed by a path separator, for example `file://etc/myfile.proto`. The segment before the `/` is interpreted as a hostname. | Use three slashes: `file:///absolute/path`. |

### The policy is created but compilation fails

If compilation fails with `File not found`, check these causes:

- **Archive paths don't match the policy.** Compare the output of `tar -tvf archive.tar.gz` with the `$ref` paths in the policy.
- **A non-primary file has no `importUrl`.** Add `importUrl` for every file that other files import.
- **A transitive import is missing.** Add every file that the primary file imports, directly or indirectly, to both the upload and `idlFiles`.

Instance Manager doesn't validate `.proto` syntax. The WAF compiler does, so a syntax error appears as a compilation error, not as an upload error. The compilation error describes the specific failure.

## See also

- [How WAF policy management works]({{< ref "/nim/waf-integration/overview.md" >}})
- [Create a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/create-policy.md" >}})
- [Update a security policy]({{< ref "/nim/waf-integration/policies-and-logs/policies/update-policy.md" >}})
- [Publish updates to instances]({{< ref "/nim/waf-integration/policies-and-logs/publish/publish-to-instances.md" >}})
