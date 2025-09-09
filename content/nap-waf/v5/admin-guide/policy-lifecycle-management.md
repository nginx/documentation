---
title: Policy Lifecycle Management
weight: 200
toc: true
type: how-to
product: NAP-WAF
---

## Overview

Policy Lifecycle Management (PLM) provides a comprehensive solution for automating the management, compilation, and deployment of security policies within Kubernetes environments. PLM extends the WAF compiler capabilities by providing a native Kubernetes operator-based approach to policy orchestration.

The Policy Lifecycle Management system is architected around a **Policy Controller** that implements the Kubernetes operator pattern to manage the complete lifecycle of WAF security artifacts. The system addresses the fundamental challenge of policy distribution at scale by eliminating manual intervention points and providing a declarative configuration model through Custom Resource Definitions (CRDs) for policies, logging profiles, signatures, and user-defined signatures.

## Prerequisites

Before deploying Policy Lifecycle Management, ensure you have the following prerequisites:

### System Requirements

- Kubernetes cluster (tested with k3s)
- Helm 3 installed
- Docker installed and configured
- NGINX Docker Image
- NGINX JWT License
- Docker registry credentials for private-registry.nginx.com

### Custom Resource Definitions (CRDs)

Policy Lifecycle Management requires specific Custom Resource Definitions to be applied before deployment. These CRDs define the resources that the Policy Controller manages:

**Required CRDs:**
- `appolicies.appprotect.f5.com` - Defines WAF security policies
- `aplogconfs.appprotect.f5.com` - Manages logging profiles and configurations  
- `apusersigs.appprotect.f5.com` - Handles user-defined signatures
- `apsignatures.appprotect.f5.com` - Manages signature updates and collections

Apply the CRDs using the following command:
```bash
kubectl apply -f crds/
```

### NGINX Configuration

Policy Lifecycle Management requires specific NGINX configuration to integrate with the Policy Controller. The key directive `app_protect_default_config_source` must be set to `"custom-resource"` to enable PLM integration.

**Required NGINX Configuration:**

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

**Key PLM-specific directives:**
- `app_protect_default_config_source "custom-resource"` - Enables Policy Controller integration
- `app_protect_policy_file my-policy-cr` - References the Custom Resource policy name instead of bundle file paths
- `app_protect_security_log my-logging-cr` - References the Custom Resource logging configuration name

## Helm Chart Configuration

Policy Lifecycle Management is deployed as part of the NGINX App Protect Helm chart. To enable PLM, you must configure the Policy Controller settings in your `values.yaml` file.

### Enabling Policy Controller

Set the following configuration in your `values.yaml`:

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

To enable signature updates with the APSignatures CRD, configure the NGINX repository credentials:

```yaml
appprotect:
  nginxRepo:
    nginxCrt: <base64-encoded-cert>
    nginxKey: <base64-encoded-key>
```

## Installation Flow

### Step-by-Step Installation Process

1. **Prepare Environment Variables**
   
   Set the required environment variables:
   ```bash
   export JWT=<your-nginx-jwt-token>
   export NGINX_REGISTRY_TOKEN=<base64-encoded-docker-credentials>
   export NGINX_CERT=<base64-encoded-nginx-cert>
   export NGINX_KEY=<base64-encoded-nginx-key>
   ```

2. **Pull the Helm Chart**
   
   Login to the registry and pull the chart:
   ```bash
   helm registry login private-registry.nginx.com
   helm pull oci://private-registry.nginx.com/nap/nginx-app-protect --version <release-version> --untar
   cd nginx-app-protect
   ```

3. **Apply Custom Resource Definitions**
   
   Apply the required CRDs before deploying the chart:
   ```bash
   kubectl apply -f crds/
   ```

4. **Create Storage**
   
   Create the directory and persistent volume for policy bundles:
   ```bash
   mkdir -p /mnt/nap5_bundles_pv_data
   chown -R 101:101 /mnt/nap5_bundles_pv_data
   kubectl apply -f <your-pv-yaml-file>
   ```
   
   {{< call-out "note" >}}
   The PV name defaults to `<release-name>-bundles-pv`, but can be customized using the `appprotect.storage.pv.name` setting in your values.yaml file.
   {{< /call-out >}}

5. **Configure Docker Registry Credentials**
   
   Create the Docker registry secret or configure in values.yaml:
   ```bash
   kubectl create secret docker-registry regcred -n <namespace> \
     --docker-server=private-registry.nginx.com \
     --docker-username=<JWT-Token> \
     --docker-password=none
   ```

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

7. **Verify Installation**
   
   Check that all components are deployed successfully:
   ```bash
   kubectl get pods -n <namespace>
   kubectl get crds | grep appprotect.f5.com
   kubectl get all -n <namespace>
   ```

## Using Policy Lifecycle Management

### Setting up desired security update versions

Once PLM is deployed, you can create APSignatures resource using Kubernetes manifests and specify desired security update versions. Apply the following Custom Resource example or create your own based on the template:

**Sample APSignatures Resource:**

Create a file named `signatures.yaml` with the following content:

```yaml
apiVersion: appprotect.f5.com/v1
kind: APSignatures
metadata:
  name: signatures
spec:
  attack-signatures:
    revision: "2025.06.19" # attack signatures revision to be used
  bot-signatures:
    revision: "latest" # bot signatures revision to be used
  threat-campaigns:
    revision: "2025.06.24" # threat campaigns revision to be used
```

{{< call-out "note" >}}
The APSignatures must have name `signatures`. Only one APSignatures instance can exist
{{< /call-out >}}

Apply the manifest:

```bash
kubectl apply -f config/policy-manager/samples/appprotect_v1_apsignatures.yaml
```

{{< call-out "note" >}}
Downloading security updates may take several minutes. The version of security updates available at the time of compilation is always used to compile policies. If APSignatures is not created or the specified versions are not downloaded, the versions contained in the compiler docker image will be used.
{{< /call-out >}}

### Creating Policy Resources

Once PLM is deployed, you can create policy resources using Kubernetes manifests. Apply the following Custom Resource examples or create your own based on these templates:

**Sample APPolicy Resource:**

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

```bash
kubectl apply -f dataguard-blocking-policy.yaml -n <namespace>
```

**Sample APUserSig Resource:**

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

```bash
kubectl apply -f apple-usersig.yaml -n <namespace>
```

### Monitoring Policy Status

Check the status of your policy resources:

```bash
kubectl get appolicy -n <namespace>
kubectl describe appolicy <policy-name> -n <namespace>
```

The Policy Controller will show status information including:
- Bundle location
- Compilation status
- Signature update timestamps

## Confirming Setup is Functioning

### 1. Test Policy Compilation

Apply one of the sample policy Custom Resources to verify PLM is working correctly. For example, using the dataguard policy you created earlier:

```bash
kubectl apply -f dataguard-blocking-policy.yaml -n <namespace>
```

### 2. Check Policy Compilation Status

Verify that the policy has been compiled successfully by checking the Custom Resource status:

```bash
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

### 3. Verify Policy Controller Logs

Check the Policy Controller logs for expected compilation messages:

```bash
kubectl logs <policy-controller-pod> -n <namespace>
```

Look for successful compilation messages like:

```
2025-09-04T10:05:52Z    INFO    Job is completed        {"controller": "appolicy", "controllerGroup": "appprotect.f5.com", "controllerKind": "APPolicy", "APPolicy": {"name":"dataguard-blocking","namespace":"localenv-plm"}, "namespace": "localenv-plm", "name": "dataguard-blocking", "reconcileID": "6bab7054-8a8a-411f-8ecc-01399a308ef6", "job": "dataguard-blocking-appolicy-compile"}

2025-09-04T10:05:52Z    INFO    job state is    {"controller": "appolicy", "controllerGroup": "appprotect.f5.com", "controllerKind": "APPolicy", "APPolicy": {"name":"dataguard-blocking","namespace":"localenv-plm"}, "namespace": "localenv-plm", "name": "dataguard-blocking", "reconcileID": "6bab7054-8a8a-411f-8ecc-01399a308ef6", "job": "dataguard-blocking-appolicy-compile", "state": "ready"}

2025-09-04T10:05:52Z    INFO    bundle state was changed        {"controller": "appolicy", "controllerGroup": "appprotect.f5.com", "controllerKind": "APPolicy", "APPolicy": {"name":"dataguard-blocking","namespace":"localenv-plm"}, "namespace": "localenv-plm", "name": "dataguard-blocking", "reconcileID": "6bab7054-8a8a-411f-8ecc-01399a308ef6", "job": "dataguard-blocking-appolicy-compile", "from": "processing", "to": "ready"}
```

### 4. Verify Bundle Creation

Check that the policy bundle has been created in the shared volume directory:

```bash
ls -la /mnt/nap5_bundles_pv_data/dataguard-blocking-policy/
```

You should see the compiled policy bundle file in the directory structure.

### 5. Test Policy Enforcement

To verify that the policy bundles are being deployed and enforced correctly:

1. **Update NGINX Configuration**
   
   Use the Custom Resource name in your NGINX configuration:
   ```nginx
   app_protect_policy_file dataguard-blocking;
   ```

2. **Reload NGINX**
   
   Reload NGINX to apply the new policy:
   ```bash
   nginx -s reload
   ```

3. **Test Policy Enforcement**
   
   Send a request that should be blocked by the dataguard policy to verify it's working:
   ```bash
   curl "http://[CLUSTER-IP]:80/?a=<script>"
   ```

   The request should be blocked, confirming that PLM has successfully compiled and deployed the policy.

## Troubleshooting

### Common Issues

**Policy Controller Not Starting**
- Verify CRDs are installed: `kubectl get crds | grep appprotect.f5.com`
- Check pod logs: `kubectl logs <policy-controller-pod> -n <namespace>`
- Ensure proper RBAC permissions are configured

**Policy Compilation Failures**
- Check Policy Controller logs for compilation errors
- Verify WAF compiler image is accessible
- Ensure policy syntax is valid

**Bundle Storage Issues**  
- Verify persistent volume is properly mounted
- Check storage permissions (should be 101:101)
- Confirm PVC is bound to the correct PV

For additional troubleshooting information, see the [Troubleshooting Guide]({{< ref "/nap-waf/v5/troubleshooting-guide/troubleshooting.md#nginx-app-protect-5" >}}).
