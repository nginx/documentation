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
### Warning events

If a `routeSelector` in a VirtualServer matches no VirtualServerRoutes, F5 NGINX Ingress Controller reports a warning. It emits a `Warning` event and sets the VirtualServer `State` to `Warning`. The warning doesn't block the configuration. NGINX Ingress Controller applies the rest of the VirtualServer, but no VirtualServerRoute serves the path of that route.

A `routeSelector` matches no VirtualServerRoutes in these cases:

- No VirtualServerRoute has labels that match the selector. For example, a label in the selector has a typo.
- The selected VirtualServerRoutes are deleted.
- The `ingressClassName` of the selected VirtualServerRoutes changes, so NGINX Ingress Controller no longer handles them.
- The labels of the selected VirtualServerRoutes change, so the labels no longer match the selector.

To see the warning, describe the VirtualServer:

```shell
kubectl describe vs cafe
```

```text
Events:
  Type     Reason                     Age   From                      Message
  ----     ------                     ----  ----                      -------
  Warning  AddedOrUpdatedWithWarning  16s   nginx-ingress-controller  Configuration for default/cafe was added or updated with warning(s): VirtualServerRoute routeSelector app=coffee matched no VirtualServerRoutes
```

To clear the warning, do one of the following:

- Make sure at least one VirtualServerRoute matches the selector. For example, correct the labels, recreate a deleted VirtualServerRoute, or restore its `ingressClassName`.
- If you no longer need the VirtualServerRoutes for that path, remove the route from the VirtualServer.

After the fix, `kubectl describe vs cafe` shows a `Normal` event with the `AddedOrUpdated` reason, and `State` returns to `Valid`.
