---
title: Gateway API Compatibility
weight: 200
toc: true
nd-content-type: reference
nd-product: NGF
nd-docs: DOCS-1412
---

Learn which Gateway API resources NGINX Gateway Fabric supports and to which level.

## Summary

{{< table >}}
| Resource                              | Core Support Level  | Extended Support Level | Implementation-Specific Support Level | API Version | API Release Channel |
|---------------------------------------|---------------------|------------------------|---------------------------------------|-------------|---------------------|
| [GatewayClass](#gatewayclass)         | Supported           | Not supported          | Supported                             | v1          | Standard            |
| [Gateway](#gateway)                   | Supported           | Partially supported    | Not supported                         | v1          | Standard            |
| [HTTPRoute](#httproute)               | Supported           | Partially supported    | Not supported                         | v1          | Standard            |
| [GRPCRoute](#grpcroute)               | Supported           | Partially supported    | Not supported                         | v1          | Standard            |
| [ReferenceGrant](#referencegrant)     | Supported           | N/A                    | Not supported                         | v1beta1     | Standard            |
| [TLSRoute](#tlsroute)                 | Supported           | Not supported          | Not supported                         | v1alpha2    | Experimental        |
| [TCPRoute](#tcproute)                 | Not supported       | Not supported          | Not supported                         | v1alpha2    | Experimental        |
| [UDPRoute](#udproute)                 | Not supported       | Not supported          | Not supported                         | v1alpha2    | Experimental        |
| [BackendTLSPolicy](#backendtlspolicy) | Partially Supported | Supported              | Partially supported                   | v1alpha3    | Experimental        |
| [Custom policies](#custom-policies)   | N/A                 | N/A                    | Supported                             | N/A         | N/A                 |
{{< /table >}}

## Terminology

Gateway API features has three [support levels](https://gateway-api.sigs.k8s.io/concepts/conformance/#2-support-levels): Core, Extended and Implementation-specific. We use the following terms to describe the support status for each level and resource field:

- _Supported_. The resource or field is fully supported.
- _Partially supported_. The resource or field is supported partially, with limitations. It will become fully
  supported in future releases.
- _Not supported_. The resource or field is not yet supported. It will become partially or fully supported in future
  releases.

{{< call-out "note" >}} It's possible that NGINX Gateway Fabric will never support some resources or fields of the Gateway API. They will be documented on a case by case basis. {{< /call-out >}}


## Resources

Each resource below includes the support status of their corresponding fields.

For a description of each field, visit the [Gateway API documentation](https://gateway-api.sigs.k8s.io/references/spec/).

### GatewayClass

{{< table >}}
| Resource     | Core Support Level | Extended Support Level | Implementation-Specific Support Level | API Version | API Release Channel |
|--------------|--------------------|------------------------|---------------------------------------|-------------|---------------------|
| GatewayClass | Supported          | Not supported          | Supported                             | v1          | Standard            |
{{< /table >}}

NGINX Gateway Fabric supports a single GatewayClass resource configured with the `--gatewayclass` flag of the [controller]({{< ref "/ngf/reference/cli-help.md#controller">}}) command.

**Fields**:

- `spec`
  - `controllerName` - supported.
  - `parametersRef` - NginxProxy resource supported.
  - `description` - supported.
- `status`
  - `conditions` - supported (Condition/Status/Reason):
    - `Accepted/True/Accepted`
    - `Accepted/False/InvalidParameters`
    - `Accepted/False/UnsupportedVersion`
    - `Accepted/False/GatewayClassConflict`: Custom reason for when the GatewayClass references this controller, but
          a different GatewayClass name is provided to the controller via the command-line argument.
    - `SupportedVersion/True/SupportedVersion`
    - `SupportedVersion/False/UnsupportedVersion`

### Gateway

{{< table >}}
| Resource | Core Support Level | Extended Support Level | Implementation-Specific Support Level | API Version | API Release Channel |
|----------|--------------------|------------------------|---------------------------------------|-------------|---------------------|
| Gateway  | Supported          | Partially supported    | Not supported                         | v1          | Standard            |
{{< /table >}}

NGINX Gateway Fabric supports multiple Gateway resources. The Gateway resources must reference NGINX Gateway Fabric's corresponding GatewayClass.

See the [controller]({{< ref "/ngf/reference/cli-help.md#controller">}}) command for more information.

**Fields**:

- `spec`
  - `gatewayClassName`: Supported.
  - `infrastructure`: Supported.
    - `parametersRef`: NginxProxy resource supported.
    - `labels`: Supported.
    - `annotations`: Supported.
  - `listeners`
    - `name`: Supported.
    - `hostname`: Supported.
    - `port`: Supported.
    - `protocol`: Partially supported. Allowed values: `HTTP`, `HTTPS`.
    - `tls`
      - `mode`: Partially supported. Allowed value: `Terminate`.
      - `certificateRefs` - The TLS certificate and key must be stored in a Secret resource of type `kubernetes.io/tls`. Only a single reference is supported.
      - `options`: Not supported.
    - `allowedRoutes`: Supported.
  - `addresses`: Not supported.
  - `backendTLS`: Not supported.
  - `allowedListeners`: Not supported.
- `status`
  - `addresses`: Partially supported (LoadBalancer and ClusterIP).
  - `conditions`: Supported (Condition/Status/Reason):
    - `Accepted/True/Accepted`
    - `Accepted/True/ListenersNotValid`
    - `Accepted/False/ListenersNotValid`
    - `Accepted/False/Invalid`
    - `Accepted/False/UnsupportedValue`: Custom reason for when a value of a field in a Gateway is invalid or not supported.
    - `Programmed/True/Programmed`
    - `Programmed/False/Invalid`
  - `listeners`
    - `name`: Supported.
    - `supportedKinds`: Supported.
    - `attachedRoutes`: Supported.
    - `conditions`: Supported (Condition/Status/Reason):
      - `Accepted/True/Accepted`
      - `Accepted/False/UnsupportedProtocol`
      - `Accepted/False/InvalidCertificateRef`
      - `Accepted/False/ProtocolConflict`
      - `Accpeted/False/HostnameConflict`
      - `Accepted/False/UnsupportedValue`: Custom reason for when a value of a field in a Listener is invalid or not supported.
      - `Programmed/True/Programmed`
      - `Programmed/False/Invalid`
      - `ResolvedRefs/True/ResolvedRefs`
      - `ResolvedRefs/False/InvalidCertificateRef`
      - `ResolvedRefs/False/InvalidRouteKinds`
      - `ResolvedRefs/False/RefNotPermitted`
      - `Conflicted/True/ProtocolConflict`
      - `Conflicted/True/HostnameConflict`
      - `Conflicted/False/NoConflicts`
      - `OverlappingTLSConfig/True/OverlappingHostnames`

### HTTPRoute

{{< table >}}
| Resource  | Core Support Level | Extended Support Level | Implementation-Specific Support Level | API Version | API Release Channel |
|-----------|--------------------|------------------------|---------------------------------------|-------------|---------------------|
| HTTPRoute | Supported          | Partially supported    | Not supported                         | v1          | Standard            |
{{< /table >}}
**Fields**:

- `spec`
  - `parentRefs`: Partially supported. Port not supported.
  - `hostnames`: Supported.
  - `rules`
    - `matches`
      - `path`: Partially supported. Only `PathPrefix` and `Exact` types.
      - `headers`: Supported.
      - `queryParams`: Supported.
      - `method`: Supported.
    - `filters`
      - `type`: Supported.
      - `requestRedirect`: Supported. If multiple filters are configured, NGINX Gateway Fabric will choose the first and ignore the rest. Incompatible with `urlRewrite`.
      - `requestHeaderModifier`: Supported. If multiple filters are configured, NGINX Gateway Fabric will choose the first and ignore the rest.
      - `urlRewrite`: Supported. If multiple filters are configured, NGINX Gateway Fabric will choose the first and ignore the rest. Incompatible with `requestRedirect`.
      - `responseHeaderModifier`: Supported. If multiple filters are configured, NGINX Gateway Fabric will choose the first and ignore the rest.
      - `requestMirror`: Supported. Multiple mirrors can be specified. Percent and fraction-based mirroring are supported.
      - `extensionRef`: Supported for SnippetsFilters.
    - `backendRefs`: Partially supported. Backend ref `filters` are not supported.
- `status`
  - `parents`
    - `parentRef`: Supported.
    - `controllerName`: Supported.
    - `conditions`: Partially supported. Supported (Condition/Status/Reason):
      - `Accepted/True/Accepted`
      - `Accepted/False/NoMatchingListenerHostname`
      - `Accepted/False/NoMatchingParent`
      - `Accepted/False/NotAllowedByListeners`
      - `Accepted/False/UnsupportedValue`: Custom reason for when the HTTPRoute includes an invalid or unsupported value.
      - `Accepted/False/InvalidListener`: Custom reason for when the HTTPRoute references an invalid listener.
      - `Accepted/False/GatewayNotProgrammed`: Custom reason for when the Gateway is not Programmed. HTTPRoute can be valid and configured, but will maintain this status as long as the Gateway is not Programmed.
      - `Accepted/False/GatewayIgnored`: Custom reason for when the Gateway is ignored by NGINX Gateway Fabric. NGINX Gateway Fabric only supports one Gateway.
      - `ResolvedRefs/True/ResolvedRefs`
      - `ResolvedRefs/False/InvalidKind`
      - `ResolvedRefs/False/RefNotPermitted`
      - `ResolvedRefs/False/BackendNotFound`
      - `ResolvedRefs/False/UnsupportedValue`: Custom reason for when one of the HTTPRoute rules has a backendRef with an unsupported value.
      - `ResolvedRefs/False/InvalidIPFamily`: Custom reason for when one of the HTTPRoute rules has a backendRef that has an invalid IPFamily.
      - `ResolvedRefs/False/UnsupportedProtocol`
      - `PartiallyInvalid/True/UnsupportedValue`

### GRPCRoute

{{< table >}}
| Resource  | Core Support Level | Extended Support Level | Implementation-Specific Support Level | API Version | API Release Channel |
|-----------|--------------------|------------------------|---------------------------------------|-------------|---------------------|
| GRPCRoute | Supported          | Partially supported    | Not supported                         | v1          | Standard            |
{{< /table >}}

**Fields**:

- `spec`
  - `parentRefs`: Partially supported. Port not supported.
  - `hostnames`: Supported.
  - `rules`
    - `matches`
      - `method`: Partially supported. Only `Exact` type with both `method.service` and `method.method` specified.
      - `headers`: Supported
    - `filters`
      - `type`: Supported.
      - `requestHeaderModifier`: Supported. If multiple filters are configured, NGINX Gateway Fabric will choose the first and ignore the rest.
      - `responseHeaderModifier`: Supported. If multiple filters are configured, NGINX Gateway Fabric will choose the first and ignore the rest.
      - `requestMirror`: Supported. Multiple mirrors can be specified.
      - `extensionRef`: Supported for SnippetsFilters.
    - `backendRefs`: Partially supported. Backend ref `filters` are not supported.
- `status`
  - `parents`
    - `parentRef`: Supported.
    - `controllerName`: Supported.
    - `conditions`: Partially supported. Supported (Condition/Status/Reason):
      - `Accepted/True/Accepted`
      - `Accepted/False/NoMatchingListenerHostname`
      - `Accepted/False/NoMatchingParent`
      - `Accepted/False/NotAllowedByListeners`
      - `Accepted/False/UnsupportedValue`: Custom reason for when the GRPCRoute includes an invalid or unsupported value.
      - `Accepted/False/InvalidListener`: Custom reason for when the GRPCRoute references an invalid listener.
      - `Accepted/False/GatewayNotProgrammed`: Custom reason for when the Gateway is not Programmed. GRPCRoute can be valid and configured, but will maintain this status as long as the Gateway is not Programmed.
      - `ResolvedRefs/True/ResolvedRefs`
      - `ResolvedRefs/False/InvalidKind`
      - `ResolvedRefs/False/RefNotPermitted`
      - `ResolvedRefs/False/BackendNotFound`
      - `ResolvedRefs/False/UnsupportedValue`: Custom reason for when one of the GRPCRoute rules has a backendRef with an unsupported value.
      - `PartiallyInvalid/True/UnsupportedValue`

### ReferenceGrant

{{< table >}}
| Resource       | Core Support Level | Extended Support Level | Implementation-Specific Support Level | API Version | API Release Channel |
|----------------|--------------------|------------------------|---------------------------------------|-------------|---------------------|
| ReferenceGrant | Supported          | N/A                    | Not supported                         | v1beta1     | Standard            |
{{< /table >}}

Fields:

- `spec`
  - `to`
    - `group` - supported.
    - `kind` - supports `Secret` and `Service`.
    - `name`- supported.
  - `from`
    - `group` - supported.
    - `kind` - supports `Gateway` and `HTTPRoute`.
    - `namespace`- supported.

### TLSRoute

{{< table >}}
| Resource | Core Support Level | Extended Support Level | Implementation-Specific Support Level | API Version | API Release Channel |
|----------|--------------------|------------------------|---------------------------------------|-------------|---------------------|
| TLSRoute | Supported          | Not supported          | Not supported                         | v1alpha2    | Experimental        |
{{< /table >}}

**Fields**:

- `spec`
  - `parentRefs`: Partially supported. Port not supported.
  - `hostnames`: Supported.
  - `rules`
    - `backendRefs`: Partially supported. Only one backend ref allowed.
      - `weight`: Not supported.
- `status`
  - `parents`
    - `parentRef`: Supported.
    - `controllerName`: Supported.
    - `conditions`: Supported (Condition/Status/Reason):
      - `Accepted/True/Accepted`
      - `Accepted/False/NoMatchingListenerHostname`
      - `Accepted/False/NoMatchingParent`
      - `Accepted/False/NotAllowedByListeners`
      - `Accepted/False/UnsupportedValue`: Custom reason for when the TLSRoute includes an invalid or unsupported value.
      - `Accepted/False/InvalidListener`: Custom reason for when the TLSRoute references an invalid listener.
      - `Accepted/False/GatewayNotProgrammed`: Custom reason for when the Gateway is not Programmed. TLSRoute can be valid and configured, but will maintain this status as long as the Gateway is not Programmed.
      - `Accepted/False/HostnameConflict`: Custom reason for when the TLSRoute has a hostname that conflicts with another TLSRoute on the same port.
      - `ResolvedRefs/True/ResolvedRefs`
      - `ResolvedRefs/False/InvalidKind`
      - `ResolvedRefs/False/RefNotPermitted`
      - `ResolvedRefs/False/BackendNotFound`
      - `ResolvedRefs/False/UnsupportedValue`: Custom reason for when one of the TLSRoute rules has a backendRef with an unsupported value.
      - `PartiallyInvalid/True/UnsupportedValue`

---

### TCPRoute

{{< table >}}
| Resource | Core Support Level | Extended Support Level | Implementation-Specific Support Level | API Version | API Release Channel |
|----------|--------------------|------------------------|---------------------------------------|-------------|---------------------|
| TCPRoute | Not supported      | Not supported          | Not supported                         | v1alpha2    | Experimental        |
{{< /table >}}

### UDPRoute

{{< table >}}
| Resource | Core Support Level | Extended Support Level | Implementation-Specific Support Level | API Version | API Release Channel |
|----------|--------------------|------------------------|---------------------------------------|-------------|---------------------|
| UDPRoute | Not supported      | Not supported          | Not supported                         | v1alpha2    | Experimental        |
{{< /table >}}

### BackendTLSPolicy

{{< table >}}
| Resource         | Core Support Level  | Extended Support Level | Implementation-Specific Support Level | API Version | API Release Channel |
|------------------|---------------------|------------------------|---------------------------------------|-------------|---------------------|
| BackendTLSPolicy | Partially Supported | Supported              | Partially Supported                   | v1alpha3    | Experimental        |
{{< /table >}}

Fields:

- `spec`
  - `targetRefs`
    - `group`: Supported.
    - `kind`: Supports `Service`.
    - `name`: Supported.
  - `validation`
    - `caCertificateRefs`: Supports single reference to a `ConfigMap` or `Secret`, with the CA certificate in a key named `ca.crt`.
      - `name`: Supported.
      - `group`: Supported.
      - `kind`: Supports `ConfigMap` and `Secret`.
    - `hostname`: Supported.
    - `wellKnownCertificates`: Supports `System`. This will set the CA certificate to the Alpine system root CA path `/etc/ssl/cert.pem`. NB: This option will only work if the NGINX image used is Alpine based. The NGF NGINX images are Alpine based by default.
    - `subjectAltNames`: Not supported.
  - `options`: Not supported.
- `status`
  - `ancestors`
    - `ancestorRef`: Supported.
    - `controllerName`: Supported.
    - `conditions`: Partially supported. Supported (Condition/Status/Reason):
      - `Accepted/True/PolicyReasonAccepted`
      - `Accepted/False/PolicyReasonInvalid`

{{< call-out "note" >}} If multiple `backendRefs` are defined for a HTTPRoute rule, all the referenced Services *must* have matching BackendTLSPolicy configuration. BackendTLSPolicy configuration is considered to be matching if 1. CACertRefs reference the same ConfigMap, or 2. WellKnownCACerts are the same, and 3. Hostname is the same. {{< /call-out >}}

### Custom Policies

{{< table >}}
| Resource        | Core Support Level | Extended Support Level | Implementation-Specific Support Level | API Version | API Release Channel |
|-----------------|--------------------|------------------------|---------------------------------------|-------------|---------------------|
| Custom policies | N/A                | N/A                    | Supported                             | N/A         | N/A                 |
{{< /table >}}

Custom policies are NGINX Gateway Fabric-specific CRDs (Custom Resource Definitions) that support features such as tracing, and client connection settings. These important data-plane features are not part of the Gateway API specifications.
While these CRDs are not part of the Gateway API, the mechanism to attach them to Gateway API resources is part of the Gateway API. See the [Policy Attachment documentation](https://gateway-api.sigs.k8s.io/references/policy-attachment/).

See the [custom policies]({{< ref "/ngf/overview/custom-policies.md" >}}) document for more information.