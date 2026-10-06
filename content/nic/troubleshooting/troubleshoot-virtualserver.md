---
f5-docs: DOCS-1461
title: Troubleshooting VirtualServer resources
toc: true
weight: 600
f5-product: NGINX Ingress Controller
f5-content-type: how-to
---

This page describes how to troubleshoot VirtualServer and VirtualServerRoute resource events.

## Inspecting VirtualServer and VirtualServerRoute resource events

After you create or update a VirtualServer resource, run `kubectl describe vs <RESOURCE_NAME>` to check whether NGINX applied the configuration for that resource:

```shell
kubectl describe vs cafe
```

```text
Events:
  Type    Reason          Age   From                      Message
  ----    ------          ----  ----                      -------
  Normal  AddedOrUpdated  16s   nginx-ingress-controller  Configuration for default/cafe was added or updated
```

In the above example, we have a `Normal` event with the `AddedOrUpdate` reason, which informs us that the configuration was successfully applied.

Checking the events of a VirtualServerRoute is similar:

```shell
kubectl describe vsr coffee
```

```text
Events:
  Type     Reason                 Age   From                      Message
  ----     ------                 ----  ----                      -------
  Normal   AddedOrUpdated         1m    nginx-ingress-controller  Configuration for default/coffee was added or updated
```

## Common troubleshooting scenarios

### Host mismatch rejection

If a VirtualServerRoute defines a `spec.host` that doesn't match the referencing VirtualServer, F5 NGINX Ingress Controller rejects the route attachment and logs a warning event on the resource.

To fix a host mismatch, do one of the following:

- Update `spec.host` in the VirtualServerRoute to match the VirtualServer `host` exactly.
- Omit `spec.host` from the VirtualServerRoute (hostless mode) so any VirtualServer can reference it.
