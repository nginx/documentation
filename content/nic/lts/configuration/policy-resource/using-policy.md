---
title: Manage Policy resources with kubectl
weight: 300
toc: true
f5-content-type: how-to
f5-product: NGINX Ingress Controller
---

Use standard `kubectl` commands to work with Policy resources, just as you would with built-in Kubernetes resources.

For example, the following command creates a Policy resource defined in `access-control-policy-allow.yaml` with the name `webapp-policy`:

```shell
kubectl apply -f access-control-policy-allow.yaml

policy.k8s.nginx.org/webapp-policy configured
```

Get the resource by running:

```shell
kubectl get policy webapp-policy

NAME            AGE
webapp-policy   27m
```

For `kubectl get` and similar commands, you can also use the short name `pol` instead of `policy`.

## Attach policies to a resource

You can attach policies to VirtualServer, VirtualServerRoute, and Ingress resources. For example:

- VirtualServer:

    ```yaml
    apiVersion: k8s.nginx.org/v1
    kind: VirtualServer
    metadata:
      name: cafe
      namespace: cafe
    spec:
      host: cafe.example.com
      tls:
        secret: cafe-secret
      policies: # spec policies
      - name: policy1
      upstreams:
      - name: coffee
        service: coffee-svc
        port: 80
      routes:
      - path: /tea
        policies: # route policies
        - name: policy2
          namespace: cafe
        route: tea/tea
      - path: /coffee
        policies: # route policies
        - name: policy3
          namespace: cafe
        action:
          pass: coffee
      ```

    For VirtualServer, you can apply a policy:
  * to all routes (spec policies)
  * to a specific route (route policies)

    Route policies of the same type override spec policies. In the example above, if `policy-1` and `policy-3` are both `accessControl` policies, NGINX applies `policy-3` to requests for `cafe.example.com/coffee`.

    NGINX enforces this override: the spec policies apply in the `server` context of the configuration, and the route policies apply in the `location` context. As a result, the route policies of the same type take precedence.

- VirtualServerRoute, referenced by the VirtualServer above:

    ```yaml
    apiVersion: k8s.nginx.org/v1
    kind: VirtualServerRoute
    metadata:
      name: tea
      namespace: tea
    spec:
      host: cafe.example.com
      upstreams:
      - name: tea
        service: tea-svc
        port: 80
      subroutes: # subroute policies
      - path: /tea
        policies:
        - name: policy4
          namespace: tea
        action:
          pass: tea
    ```

    For VirtualServerRoute, you can apply a policy to a subroute (subroute policies).

    Subroute policies of the same type override spec policies. In the example above, if `policy-1` (in the VirtualServer) and `policy-4` are both `accessControl` policies, NGINX applies `policy-4` to requests for `cafe.example.com/tea`. As with the VirtualServer, NGINX enforces this override.

    Subroute policies always override route policies, regardless of type. For example, NGINX Ingress Controller LTS ignores `policy-2` from the VirtualServer route for the `/tea` subroute, because the subroute has its own policies, `policy4` in this case. If the subroute had no policies, NGINX Ingress Controller LTS would apply `policy-2` instead. NGINX Ingress Controller LTS enforces this override: the `location` context for the subroute has either route policies or subroute policies, but never both.

- Ingress:

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: cafe-ingress
      annotations:
        nginx.org/policies: "webapp-policy"
    spec:
      ingressClassName: nginx
      tls:
      - hosts:
        - cafe.example.com
        secretName: tls-secret
      rules:
      - host: cafe.example.com
        http:
          paths:
          - path: /tea
            pathType: Prefix
            backend:
              service:
                name: tea-svc
                port:
                  number: 80
          - path: /coffee
            pathType: Prefix
            backend:
              service:
                name: coffee-svc
                port:
                  number: 80
    ```

    For Ingress, you can apply policies:
  * to a single Ingress
  * to a master Ingress, where minion Ingresses inherit the policies
  * to minion Ingresses, where minion policies override master policies

## Invalid policies

NGINX treats a policy as invalid if any of the following conditions is true:

- The policy doesn't pass [comprehensive validation](#comprehensive-validation).
- The policy isn't present in the cluster.
- The policy doesn't meet its type-specific requirements. For example, an `ingressMTLS` policy requires TLS termination turned on in the VirtualServer.

For an invalid policy, NGINX returns the 500 status code for client requests, following these rules:

- If a policy is referenced in a VirtualServer `route` or a VirtualServerRoute `subroute`, NGINX returns the 500 status code for requests to the URIs of that route or subroute.
- If a policy is referenced in the VirtualServer `spec`, NGINX returns the 500 status code for requests to all URIs of that VirtualServer.

If a policy is invalid, the VirtualServer or VirtualServerRoute gets the [status]({{< ref "/nic/lts/configuration/global-configuration/reporting-resources-status.md#virtualserver-and-virtualserverroute-resources" >}}) state `Warning`, with a message that explains why the policy is invalid.

## Validation

Two types of validation are available for the Policy resource:

- *Structural validation*, done by `kubectl` and the Kubernetes API server.
- *Comprehensive validation*, done by NGINX Ingress Controller LTS.

### Structural validation

The custom resource definition for the Policy includes a structural OpenAPI schema, which describes the type of every field of the resource.

If you try to create or update a resource that violates the structural schema, for example, if the resource uses a string value instead of an array of strings in the `allow` field, `kubectl` and the Kubernetes API server reject the resource.

- Example of `kubectl` validation:

    ```shell
    kubectl apply -f access-control-policy-allow.yaml

    error: error validating "access-control-policy-allow.yaml": error validating data: ValidationError(Policy.spec.accessControl.allow): invalid type for org.nginx.k8s.v1.Policy.spec.accessControl.allow: got "string", expected "array"; if you choose to ignore these errors, turn validation off with --validate=false
    ```

- Example of Kubernetes API server validation:

    ```shell
    kubectl apply -f access-control-policy-allow.yaml --validate=false

    The Policy "webapp-policy" is invalid: spec.accessControl.allow: Invalid value: "string": spec.accessControl.allow in body must be of type array: "string"
    ```

If a resource passes structural validation, NGINX Ingress Controller LTS's comprehensive validation runs next.

### Comprehensive validation

NGINX Ingress Controller LTS validates the fields of a Policy resource. If a resource is invalid, NGINX Ingress Controller LTS rejects it. The resource continues to exist in the cluster, but NGINX Ingress Controller LTS ignores it.

Use `kubectl` to check whether NGINX Ingress Controller LTS successfully applied a Policy configuration. For the example `webapp-policy` Policy, run:

```shell
kubectl describe pol webapp-policy

. . .
Events:
  Type    Reason          Age   From                      Message
  ----    ------          ----  ----                      -------
  Normal  AddedOrUpdated  11s   nginx-ingress-controller  Policy default/webapp-policy was added or updated
```

The events section includes a Normal event with the AddedOrUpdated reason, which tells you the configuration applied successfully.

If you create an invalid resource, NGINX Ingress Controller LTS rejects it and emits a Rejected event. For example, if you create a Policy `webapp-policy` with an invalid IP `10.0.0.` in the `allow` field, you get:

```shell
kubectl describe policy webapp-policy

. . .
Events:
  Type     Reason    Age   From                      Message
  ----     ------    ----  ----                      -------
  Warning  Rejected  7s    nginx-ingress-controller  Policy default/webapp-policy is invalid and was rejected: spec.accessControl.allow[0]: Invalid value: "10.0.0.": must be a CIDR or IP
```

The events section includes a Warning event with the Rejected reason.

This information is also available in the `status` field of the Policy resource. Note the Status section of the Policy:

```shell
kubectl describe pol webapp-policy

. . .
Status:
  Message:  Policy default/webapp-policy is invalid and was rejected: spec.accessControl.allow[0]: Invalid value: "10.0.0.": must be a CIDR or IP
  Reason:   Rejected
  State:    Invalid
```

{{< call-out class="warning" >}}

If you make an existing resource invalid, NGINX Ingress Controller LTS rejects it.

{{< /call-out >}}
