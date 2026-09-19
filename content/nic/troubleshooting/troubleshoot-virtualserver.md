---
f5-docs: DOCS-1461
title: Troubleshooting VirtualServer resources
toc: true
weight: 600
f5-product: NGINX Ingress Controller
f5-content-type: how-to
---

This page describes how to troubleshoot VirtualServer and VirtualServer resource events.

## Inspecting VirtualServer and VirtualServerRoute resource events

After creating or updating a VirtualServer resource, you can immediately check if the NGINX configuration for that resource was successfully by using `kubectl describe vs <resource-name>`:

```shell
kubectl describe vs cafe
```
```shell
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
```shell
Events:
  Type     Reason                 Age   From                      Message
  ----     ------                 ----  ----                      -------
  Normal   AddedOrUpdated         1m    nginx-ingress-controller  Configuration for default/coffee was added or updated
```

### Warning events

When a VirtualServer's `routeSelector` matches no VirtualServerRoutes, F5 NGINX Ingress Controller emits a `Warning` event, and the VirtualServer reports `State: Warning`. The warning shows that the VirtualServer serves no routes for the selected paths. Use this event to find a VirtualServer whose selector no longer matches any VirtualServerRoutes.

A `routeSelector` matches no VirtualServerRoutes in these cases:

- The selected VirtualServerRoutes are deleted.
- Their `ingressClassName` changes, so NGINX Ingress Controller no longer owns them.
- Their labels change, so they no longer match the selector.

To see this event, describe the VirtualServer:

```shell
kubectl describe vs cafe
```

```shell
Events:
  Type     Reason                     Age   From                      Message
  ----     ------                     ----  ----                      -------
  Warning  AddedOrUpdatedWithWarning  16s   nginx-ingress-controller  Configuration for default/cafe was added or updated with warning(s): VirtualServerRoute routeSelector app=coffee matched no VirtualServerRoutes
```

To clear the warning, make sure at least one VirtualServerRoute matches the selector:

- Recreate a deleted VirtualServerRoute.
- Restore its `ingressClassName`.
- Reapply the labels the selector requires.

After you apply one of these fixes, `kubectl describe vs cafe` shows the `Normal` `AddedOrUpdated` event again. `State` returns to `Valid`.
