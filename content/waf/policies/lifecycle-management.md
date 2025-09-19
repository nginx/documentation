---
# We use sentence case and present imperative tone
title: "Policy lifecycle management"
# Weights are assigned in increments of 100: determines sorting order
weight: 200
# Creates a table of contents and sidebar, useful for large documents
toc: true
nd-banner:
    enabled: true
    start-date: 2025-08-30
    md: /_banners/waf-early-access.md
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

There is some content remaining to migrate and rewrite from the equivalent NAP-WAF content.

{{< /call-out >}}

Policy lifecycle management (PLM) is a system for managing, compiling and deploying security policies in Kubernetes environments. 

It extends the WAF compiler capabilities by providing a native Kubernetes operater-based approach for policy orchestration.

The policy lifecycle management system revolves around a _Policy Controller_ which uses the Kubernetes operator pattern to manage the lifecycle of WAF security artifacts. 

It handles policy distribution at scale by removing manual steps and providing a declarative configuration model with Custom Resource Definitions (CRDs) for policies, logging profiles and signatures.

{{< call-out "note" >}}

This system is only available for Helm-based deployments.

{{< /call-out >}}

## Before you begin

To complete this guide, you will need the following prerequisites:

- [A functional Kubernetes cluster]({{< ref "/waf/install/kubernetes.md" >}})
- [Helm](https://helm.sh/docs/intro/install/)
- [Docker](https://docs.docker.com/get-started/get-docker/)
- An active F5 WAF for NGINX subscription (Purchased or trial)
- Credentials to the [MyF5 Customer Portal](https://account.f5.com/myf5), provided by email from F5, Inc.

## Download your subscription credentials 

1. Log in to [MyF5](https://my.f5.com/manage/s/).
1. Go to **My Products & Plans > Subscriptions** to see your active subscriptions.
1. Find your NGINX subscription, and select the **Subscription ID** for details.
1. Download the **SSL Certificate** and **Private Key files** from the subscription page.
1. Download the **JSON Web Token** file from the subscription page.

## Prepare environment variables

Set the following environment variables, which point towards your credential files:

```shell
export JWT=<your-nginx-jwt-token>
export NGINX_REGISTRY_TOKEN=<base64-encoded-docker-credentials>
export NGINX_CERT=<base64-encoded-nginx-cert>
export NGINX_KEY=<base64-encoded-nginx-key>
```

They will be used to download and apply necessary resources.

## Configure Docker for the F5 Container Registry 

Create a directory and copy your certificate and key to this directory:

```shell
mkdir -p /etc/docker/certs.d/private-registry.nginx.com
cp <path-to-your-nginx-repo.crt> /etc/docker/certs.d/private-registry.nginx.com/client.cert
cp <path-to-your-nginx-repo.key> /etc/docker/certs.d/private-registry.nginx.com/client.key
```

Log in to the Docker registry:

```shell
docker login private-registry.nginx.com
```

## Create a directory and volume for policy bundles
   
Create the directory on the cluster:

```shell
mkdir -p /mnt/nap5_bundles_pv_data
chown -R 101:101 /mnt/nap5_bundles_pv_data
```

Create the file `pv-hostpath.yaml` with the persistent volume file content:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
name: nginx-app-protect-shared-bundles-pv
labels:
    type: local
spec:
accessModes:
    - ReadWriteMany
capacity:
    storage: "2Gi"
hostPath:
    path: "/mnt/nap5_bundles_pv_data"
persistentVolumeReclaimPolicy: Retain
storageClassName: manual
``` 

Apply the `pv-hostpath.yaml` file to create the new persistent volume for policy bundles:

```shell
kubectl apply -f pv-hostpath.yaml
```

{{< call-out "note" >}}

The volume name defaults to `<release-name>-bundles-pv`, but can be customized using the `appprotect.storage.pv.name` setting in your values.yaml file.

If you do this, ensure that all corresponding values for persistent volumes point to the correct names.

{{< /call-out >}}

### Download and apply CRDs

Policy lifecycle management requires specific CRDs to be applied before deployment. 

These CRDs define the resources that the Policy Controller manages:

- `appolicies.appprotect.f5.com` - Defines WAF security policies
- `aplogconfs.appprotect.f5.com` - Manages logging profiles and configurations  
- `apusersigs.appprotect.f5.com` - Handles user-defined signatures
- `apsignatures.appprotect.f5.com` - Manages signature updates and collections

To obtain the CRDs, log into the Helm registry and pull the chart, changing the `--version` parameter for your desired version.

```shell
helm registry login private-registry.nginx.com
helm pull oci://private-registry.nginx.com/nap/nginx-app-protect --version <release-version> --untar
```

Then change into the directory and apply the CRDs using _kubectl apply_:

```shell
cd nginx-app-protect
kubectl apply -f crds/
```

### Update NGINX configuration

Policy lifecycle management requires NGINX configuration to integrate with the Policy Controller. 

The directive `app_protect_default_config_source` must be set to `"custom-resource"` to enable PLM integration.

```nginx
user nginx;
worker_processes auto;

load_module modules/ngx_http_app_protect_module.so;

error_log /var/log/nginx/error.log notice;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log stdout main;
    sendfile on;
    keepalive_timeout 65;

    app_protect_enforcer_address 127.0.0.1:50000;

    # Enable Policy Lifecycle Management
    app_protect_default_config_source "custom-resource";

    app_protect_security_log_enable on;
    app_protect_security_log my-logging-cr /opt/app_protect/bd_config/s.log;

    server {
        listen       80;
        server_name  localhost;
        proxy_http_version 1.1;

        location / {
            app_protect_enable on;

            # Reference to Custom Resource policy name
            app_protect_policy_file my-policy-cr;

            client_max_body_size 0;
            default_type text/html;
            proxy_pass  http://127.0.0.1/proxy$request_uri;
        }
       
        location /proxy {
            app_protect_enable off;
            client_max_body_size 0;
            default_type text/html;
            return 200 "Hello! I got your URI request - $request_uri\n";
        }
    }
}
```

These are the Policy lifecycle management directives:

- `app_protect_default_config_source "custom-resource"` - Enables the Policy Controller integration
- `app_protect_policy_file my-policy-cr` - References a Custom Resource policy name instead of bundle file paths
- `app_protect_security_log my-logging-cr` - References a Custom Resource logging configuration name

## Update Helm configuration

Policy lifecycle management is deployed as part of the F5 WAF for NGINX Helm chart. 

To enable it, you must configure the Policy Controller settings in your `values.yaml` file:

```yaml
appprotect:
  policyController:
    enable: true
    replicas: 1
    image:
      repository: private-registry.nginx.com/nap/waf-policy-controller
      tag: 5.8.0
      imagePullPolicy: IfNotPresent
    wafCompiler:
      image:
        repository: private-registry.nginx.com/nap/waf-compiler
        tag: 5.8.0
    enableJobLogSaving: false
    resources:
      requests:
        cpu: 100m
        memory: 128Mi
```

### NGINX Repository Configuration

To enable signature updates with the APSignatures CRD, add your NGINX repository credentials:

```yaml
appprotect:
  nginxRepo:
    nginxCrt: <base64-encoded-cert>
    nginxKey: <base64-encoded-key>
```

## Configure Docker
   
Create a Docker registry secret or add the details to _values.yaml_:

```shell
kubectl create secret docker-registry regcred -n <namespace> \
  --docker-server=private-registry.nginx.com \
  --docker-username=$JWT \
  --docker-password=none
```

## Deploy the Helm chart
   
Install the chart, adding the parameter to enable the Policy Controller:

```shell
helm install <release-name> . \
    --namespace <namespace> \
    --create-namespace \
    --set appprotect.policyController.enable=true \
    --set dockerConfigJson=$NGINX_REGISTRY_TOKEN \
    --set appprotect.config.nginxJWT=$JWT \
    --set appprotect.nginxRepo.nginxCert=$NGINX_CERT \
    --set appprotect.nginxRepo.nginxKey=$NGINX_KEY
```

## Verify the Policy Controller is running
   
Check that all components are deployed successfully using _kubectl get_:

```shell
kubectl get pods -n <namespace>
kubectl get crds | grep appprotect.f5.com
kubectl get all -n <namespace>
```

## Use Policy lifecycle management

### Create policy resources

Once Policy lifecycle management is deployed, you can create policy resources using Kubernetes manifests. 

Here are two examples, which you can use to create your own:

{{< tabs name="resource-examples">}}

{{% tab name="APPolicy" %}}

Create a file named `dataguard-blocking-policy.yaml` with the following content:

```yaml
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: dataguard-blocking
spec:
  policy:
    name: dataguard_blocking
    template:
      name: POLICY_TEMPLATE_NGINX_BASE
    applicationLanguage: utf-8
    enforcementMode: blocking
    blocking-settings:
      violations:
        - name: VIOL_DATA_GUARD
          alarm: true
          block: true
    data-guard:
      enabled: true
      maskData: true
      creditCardNumbers: true
      usSocialSecurityNumbers: true
      enforcementMode: ignore-urls-in-list
      enforcementUrls: []
```

Apply the policy:

```shell
kubectl apply -f dataguard-blocking-policy.yaml -n <namespace>
```

{{% /tab %}}

{{% tab name="APUserSig" %}}

Create a file named `apple-usersig.yaml` with the following content:

```yaml
apiVersion: appprotect.f5.com/v1
kind: APUserSig
metadata:
  name: apple
spec:
  signatures:
    - accuracy: medium
      attackType:
        name: Brute Force Attack
      description: Medium accuracy user defined signature with tag (Fruits)
      name: Apple_medium_acc
      risk: medium
      rule: content:"apple"; nocase;
      signatureType: request
      systems:
        - name: Microsoft Windows
        - name: Unix/Linux
  tag: Fruits
```

Apply the user signature:

```shell
kubectl apply -f apple-usersig.yaml -n <namespace>
```

{{% /tab %}}

{{< /tabs >}}

### Check policy status

Check the status of your policy resources:

```shell
kubectl get appolicy -n <namespace>
kubectl describe appolicy <policy-name> -n <namespace>
```

The Policy Controller will show status information including:
- Bundle location
- Compilation status
- Signature update timestamps

### Use specific security update versions

Once Policy lifecycle management is deployed, you can define a specific security update version on a per-feature basis.

This is accomplished by adding a `revision:` parameter to the feature.

The following example is for an _APSignatures_ resource, in a file named `signatures.yaml`:

```yaml {hl_lines=[7,9, 11]}
apiVersion: appprotect.f5.com/v1
kind: APSignatures
metadata:
  name: signatures
spec:
  attack-signatures:
    revision: "2025.06.19" # Attack signatures revision to be used
  bot-signatures:
    revision: "latest" # Bot signatures revision to be used
  threat-campaigns:
    revision: "2025.06.24" # Threat campaigns revision to be used
```

{{< call-out "warning" >}}
The APSignatures `name` argument _must_ be `signatures`. Only one APSignatures instance can exist.
{{< /call-out >}}

Apply the Manifest:

```shell
kubectl apply -f signatures.yaml
```

Downloading security updates may take several minutes, and the version of security updates available at the time of compilation is always used to compile policies.

If _APSignatures_ is not created or the specified versions are not available, it will default to the version stored in the compiler Docker image.


## Testing policy lifecycle management

### Apply a policy

Apply one of the sample policy Custom Resources to verify PLM is working correctly. For example, using the dataguard policy you created earlier:

```shell
kubectl apply -f dataguard-blocking-policy.yaml -n <namespace>
```

### Check policy compilation status

Verify that the policy has been compiled successfully by checking the Custom Resource status:

```shell
kubectl get appolicy <custom-resource-name> -n <namespace> -o yaml
```

You should see output similar to this, with `state: ready` and no errors:

```yaml
status:
  bundle:
    compilerVersion: 11.553.0
    location: /etc/app_protect/bundles/dataguard-blocking-policy/dataguard-blocking_policy20250904100458.tgz
    signatures:
      attackSignatures: "2025-08-28T01:16:06Z"
      botSignatures: "2025-08-27T11:35:31Z"
      threatCampaigns: "2025-08-25T09:57:39Z"
    state: ready
  processing:
    datetime: "2025-09-04T10:05:52Z"
    isCompiled: true
```

### Review Policy Controller logs

Check the Policy Controller logs for expected compilation messages:

```shell
kubectl logs <policy-controller-pod> -n <namespace>
```

Successful compilation logs will look similar to this example:

```text
2025-09-04T10:05:52Z    INFO    Job is completed        {"controller": "appolicy", "controllerGroup": "appprotect.f5.com", "controllerKind": "APPolicy", "APPolicy": {"name":"dataguard-blocking","namespace":"localenv-plm"}, "namespace": "localenv-plm", "name": "dataguard-blocking", "reconcileID": "6bab7054-8a8a-411f-8ecc-01399a308ef6", "job": "dataguard-blocking-appolicy-compile"}

2025-09-04T10:05:52Z    INFO    job state is    {"controller": "appolicy", "controllerGroup": "appprotect.f5.com", "controllerKind": "APPolicy", "APPolicy": {"name":"dataguard-blocking","namespace":"localenv-plm"}, "namespace": "localenv-plm", "name": "dataguard-blocking", "reconcileID": "6bab7054-8a8a-411f-8ecc-01399a308ef6", "job": "dataguard-blocking-appolicy-compile", "state": "ready"}

2025-09-04T10:05:52Z    INFO    bundle state was changed        {"controller": "appolicy", "controllerGroup": "appprotect.f5.com", "controllerKind": "APPolicy", "APPolicy": {"name":"dataguard-blocking","namespace":"localenv-plm"}, "namespace": "localenv-plm", "name": "dataguard-blocking", "reconcileID": "6bab7054-8a8a-411f-8ecc-01399a308ef6", "job": "dataguard-blocking-appolicy-compile", "from": "processing", "to": "ready"}
```

### Verify bundle creation

Check that the policy bundle has been created in the shared volume directory:

```shell
ls -la /mnt/nap5_bundles_pv_data/dataguard-blocking-policy/
```

You should see the compiled policy bundle file in the directory structure.

### Test policy enforcement

There are a few steps involved in testing that policy bundles are being deployed and enforced correctly.

First, use the Custom Resource name in your NGINX configuration:

```nginx
app_protect_policy_file dataguard-blocking;
```

Then, reload NGINX to apply the new policy:

```shell
nginx -s reload
```
   
You can then send a request that should be blocked by the dataguard policy to verify it's working:

```shell
curl "http://[CLUSTER-IP]:80/?a=<script>"
```

The request should be blocked, confirming that Policy lifecycle management has successfully compiled and deployed the policy.

## Upgrade the Helm chart

Follow these steps to upgrade the Helm chart: they are similar to the initial deployment.

You should first [prepare environment variables](#prepare-environment-variables) and [configure Docker registry credentials](#configure-docker-for-the-f5-container-registry).
   
Log into the Helm registry and pull the chart, changing the `--version` parameter for the new version.

```shell
helm registry login private-registry.nginx.com
helm pull oci://private-registry.nginx.com/nap/nginx-app-protect --version <new-release-version> --untar
```
   
Then change into the directory and apply the CRDs:

```shell
cd nginx-app-protect
kubectl apply -f crds/
```

4. **Create Storage**
   
   Create the directory on the cluster, and persistent volume for policy bundles:
   ```bash
   mkdir -p /mnt/nap5_bundles_pv_data
   chown -R 101:101 /mnt/nap5_bundles_pv_data
   ```
   
   Create a YAML file `pv-hostpath.yaml` with the PV file content:
   ```
   apiVersion: v1
   kind: PersistentVolume
   metadata:
   name: nginx-app-protect-shared-bundles-pv
   labels:
       type: local
   spec:
   accessModes:
       - ReadWriteMany
   capacity:
       storage: "2Gi"
   hostPath:
       path: "/mnt/nap5_bundles_pv_data"
   persistentVolumeReclaimPolicy: Retain
   storageClassName: manual
   ``` 
   Apply the `pv-hostpath.yaml` file to create the new PV:
   ```shell
   kubectl apply -f pv-hostpath.yaml
   ```
  
   {{< call-out "note" >}}
   The PV name defaults to `<release-name>-shared-bundles-pv`, but can be customized using the `appprotect.storage.pv.name` setting in your values.yaml file.
   {{< /call-out >}}


6. **Deploy the Helm Chart with Policy Controller**
   
   Install the chart with Policy Controller enabled:
   ```bash
   helm install <release-name> . \
     --namespace <namespace> \
     --create-namespace \
     --set appprotect.policyController.enable=true \
     --set dockerConfigJson=$NGINX_REGISTRY_TOKEN \
     --set appprotect.config.nginxJWT=$JWT \
     --set appprotect.nginxRepo.nginxCert=$NGINX_CERT \
     --set appprotect.nginxRepo.nginxKey=$NGINX_KEY
   ```

Afterwards, you may want to [verify the Policy controller is running](#verify-the-policy-controller-is-running).

## Uninstall the Helm chart

1. **Manually Delete the CRs**

   Delete all the existing CRs created for the deployment:

   ```bash
   kubectl -n <namespace> delete appolicy <policy-name>
   kubectl -n <namespace> delete aplogconf <logconf-name>
   kubectl -n <namespace> delete apusersigs <user-defined-signature-name>
   kubectl -n <namespace> delete apsignatures <signature-update-name>
   ```
2. **Uninstall/delete the release `<release-name>`**

   To delete the current release, you just need to delete it using helm:
   ```bash
   helm uninstall <release-name> -n <namespace>
   ```

3. **Delete any possible residual resources**

   Delete any remaining CRDs, PVC, PV, and the namespace:
   ```bash
   kubectl delete pvc nginx-app-protect-shared-bundles-pvc -n <namespace>
   kubectl delete pv nginx-app-protect-shared-bundles-pv
   kubectl delete crd --all
   kubectl delete ns <namespace>
   ```

## Possible issues

**Policy Controller does not start**
- Verify the CRDs are installed: `kubectl get crds | grep appprotect.f5.com`
- Check the pod logs: `kubectl logs <policy-controller-pod> -n <namespace>`
- Ensure proper RBAC permissions are configured

**Policies fail to compile**
- Check Policy Controller logs for compilation errors
- Verify the WAF compiler image is accessible
- Ensure the policy syntax is valid

**Issues with bundle storage**  
- Verify the persistent volume is properly mounted
- Check storage permissions (Should be 101:101)
- Confirm PVC is bound to the correct PV