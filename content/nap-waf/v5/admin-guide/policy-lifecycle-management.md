---
title: Policy Lifecycle Management
weight: 200
toc: true
type: how-to
product: NAP-WAF
---

## Overview

Policy Lifecycle Management (PLM) is an integrated feature of NGINX App Protect WAF that provides a comprehensive solution for automating the management, compilation, and deployment of security policies within Kubernetes environments. Policy Lifecycle Management is deployed as part of the NGINX App Protect Helm chart and extends the WAF compiler capabilities by providing a native Kubernetes operator-based approach to policy orchestration.

The Policy Lifecycle Management system is architected around a **Policy Controller** that implements the Kubernetes operator pattern to manage the complete lifecycle of WAF security artifacts. The system addresses the fundamental challenge of policy distribution at scale by eliminating manual intervention points and providing a declarative configuration model through Custom Resource Definitions (CRDs) for policies, logging profiles, signatures, and user-defined signatures.

## Prerequisites

Before deploying Policy Lifecycle Management, ensure you have the following prerequisites:

### System Requirements

- Helm 3 installed
- Docker installed and configured
- **[NGINX App Protect WAF Docker Image]({{< ref "/nap-waf/v5/admin-guide/deploy-on-docker.md#nginx-open-source-dockerfile" >}}) - REQUIRED**: You must build and push the NGINX App Protect WAF Docker image to your registry before proceeding with PLM installation. Use the NGINX Open Source Dockerfile for your preferred operating system.
- NGINX JWT License
- Docker registry credentials for private-registry.nginx.com

### Custom Resource Definitions (CRDs)

Policy Lifecycle Management requires specific Custom Resource Definitions to be applied before deployment. These CRDs define the resources that the Policy Controller manages:

**Required CRDs:**
- `appolicies.appprotect.f5.com` - Defines WAF security policies
- `aplogconfs.appprotect.f5.com` - Manages logging profiles and configurations  
- `apusersigs.appprotect.f5.com` - Handles user-defined signatures
- `apsignatures.appprotect.f5.com` - Manages signature updates and collections


## Configuration

Policy Lifecycle Management is deployed as part of the NGINX App Protect Helm chart and is configured through the Helm `values.yaml` file.

### Policy Controller Configuration

#### Helm Configuration (values.yaml)

The following is the complete Helm configuration required for Policy Lifecycle Management. The Policy Controller option is enabled by default (`appprotect.policyController.enable: true`).

```yaml
# Specify the target namespace for your deployment
# Replace <namespace> with your chosen namespace name (e.g., "nap-plm" or "production")
# This must match the namespace you will create in Step 4 or an existing namespace you plan to use
namespace: <namespace>

appprotect:
  ## Note: This option is useful if you use Nginx Ingress Controller for example.
  ## Enable/Disable Nginx App Protect Deployment
  enable: true
  
  ## The number of replicas of the Nginx App Protect deployment
  replicas: 1
  
  ## Configure root filesystem as read-only and add volumes for temporary data
  readOnlyRootFilesystem: false
  
  ## The annotations for deployment
  annotations: {}
  
  ## InitContainers for the Nginx App Protect pod
  initContainers: []
    # - name: init-container
    #   image: busybox:latest
    #   command: ['sh', '-c', 'echo this is initial setup!']
  
  nginx:
    image:
      ## The image repository of the Nginx App Protect WAF image you built
      ## This must reference the Docker image you built following the Docker deployment guide
      ## Replace <your-private-registry> with your actual registry and update the image name/tag as needed
      repository: <your-private-registry>/nginx-app-protect-5
      ## The tag of the Nginx image
      tag: latest
    ## The pull policy for the Nginx image
    imagePullPolicy: IfNotPresent
    ## The resources of the Nginx container.
    resources:
      requests:
        cpu: 10m
        memory: 16Mi
      # limits:
      #   cpu: 1
      #   memory: 1Gi

  wafConfigMgr:
    image:
      ## The image repository of the WAF Config Mgr
      repository: private-registry.nginx.com/nap/waf-config-mgr
      ## The tag of the WAF Config Mgr image
      tag: 5.9.0
    ## The pull policy for the WAF Config Mgr image
    imagePullPolicy: IfNotPresent
    ## The resources of the Waf Config Manager container
    resources:
      requests:
        cpu: 10m
        memory: 16Mi
      # limits:
      #   cpu: 500m
      #   memory: 500Mi

  wafEnforcer:
    image:
      ## The image repository of the WAF Enforcer
      repository: private-registry.nginx.com/nap/waf-enforcer
      ## The tag of the WAF Enforcer image
      tag: 5.9.0
    ## The pull policy for the WAF Enforcer image
    imagePullPolicy: IfNotPresent
    ## The environment variable for enforcer port to be set on the WAF Enforcer container
    env:
      enforcerPort: "50000"
    ## The resources of the WAF Enforcer container
    resources:
      requests:
        cpu: 20m
        memory: 256Mi
      # limits:
      #   cpu: 1
      #   memory: 1Gi

  wafIpIntelligence:
    enable: false
    image:
      ## The image repository of the WAF IP Intelligence
      repository: private-registry.nginx.com/nap/waf-ip-intelligence
      ## The tag of the WAF IP Intelligence
      tag: 5.9.0
    ## The pull policy for the WAF IP Intelligence
    imagePullPolicy: IfNotPresent
    ## The resources of the WAF IP Intelligence container
    resources:
      requests:
        cpu: 10m
        memory: 256Mi
      # limits:
      #   cpu: 200m
      #   memory: 1Gi
  
  policyController:
    ## Enable/Disable Policy Controller Deployment
    enable: true
    ## Number of replicas for the Policy Controller
    replicas: 1
    ## The image repository of the WAF Policy Controller
    image:
      repository: private-registry.nginx.com/nap/waf-policy-controller
      ## The tag of the WAF Policy COntroller
      tag: 5.9.0
      ## The pull policy for the WAF Policy Controller
      imagePullPolicy: IfNotPresent
    wafCompiler:
      ## The image repository of the WAF Compiler
      image:
        repository: private-registry.nginx.com/nap/waf-compiler
         ## The tag of the WAF Compiler image
        tag: 5.9.0
    ## Save logs before deleting a job or not
    enableJobLogSaving: false
    ## The resources of the WAF Policy Controller
    resources:
      requests:
        cpu: 100m
        memory: 128Mi
      # limits:
      #   memory: 256Mi
      #   cpu: 250m
    ## InitContainers for the Policy Controller pod
    initContainers: []
      # - name: init-container
      #   image: busybox:latest
      #   command: ['sh', '-c', 'echo this is initial setup!']

  storage:
    bundlesPath:
      ## Specifies the name of the volume to be used for storing policy bundles
      name: app-protect-bundles
      ## Defines the mount path inside the WAF Config Manager container where the bundles will be stored
      mountPath: /etc/app_protect/bundles
    pv:
      ## PV name that pvc will request
      ## if empty will be used <release-name>-shared-bundles-pv
      name: nginx-app-protect-shared-bundles-pv
    pvc:
      ## The storage class to be used for the PersistentVolumeClaim. 'manual' indicates a manually managed storage class
      bundlesPvc:
        storageClass: manual
        ## The amount of storage requested for the PersistentVolumeClaim
        storageRequest: 2Gi

  # Not needed as values will be set during helm install
  # nginxRepo:
  #   ## Used for Policy Controller to pull the security updates from the NGINX repository.
  #   ## The base64-encoded TLS certificate for the NGINX repository.
  #   nginxCrt: ""
  #   ## The base64-encoded TLS key for the NGINX repository.
  #   nginxKey: ""

  config:
    ## The name of the ConfigMap used by the Nginx container
    name: nginx-config
    ## The annotations of the configmap
    annotations: {}

    # Not needed as value will be set during helm install
    # ## The JWT token license.txt of the ConfigMap for customizing NGINX configuration.
    # nginxJWT: ""

    ## The nginx.conf of the ConfigMap for customizing NGINX configuration
    nginxConf: |-
      user nginx;
      worker_processes auto;

      load_module modules/ngx_http_app_protect_module.so;

      error_log /var/log/nginx/error.log notice;
      pid /var/run/nginx.pid;

      events {
          worker_connections 1024;
      }

      # Uncomment if using mtls
      # mTLS configuration
      # stream {
      #   upstream enforcer {
      #     # Replace with the actual App Protect Enforcer address and port if different
      #     server 127.0.0.1:4431;
      #   }
      #   server {
      #     listen 5000;
      #     proxy_pass enforcer;
      #     proxy_ssl_server_name on;
      #     proxy_timeout 30d;
      #     proxy_ssl on;
      #     proxy_ssl_certificate /etc/ssl/certs/app_protect_client.crt;
      #     proxy_ssl_certificate_key /etc/ssl/certs/app_protect_client.key;
      #     proxy_ssl_trusted_certificate /etc/ssl/certs/app_protect_server_ca.crt;
      #   }
      # }

      http {
          include /etc/nginx/mime.types;
          default_type application/octet-stream;

          log_format main '$remote_addr - $remote_user [$time_local] "$request" '
          '$status $body_bytes_sent "$http_referer" '
          '"$http_user_agent" "$http_x_forwarded_for"';

          access_log stdout main;
          sendfile on;
          keepalive_timeout 65;

          # Enable Policy Lifecycle Management
          # WAF default config source. For policies from CRDs, use "custom-resource"
          # Remove this line to use default bundled policies
          app_protect_default_config_source "custom-resource";

          # WAF enforcer address. For mTLS, use port 5000
          app_protect_enforcer_address 127.0.0.1:50000;

          server {
              listen       80;
              server_name  localhost;
              proxy_http_version 1.1;

              location / {
                  app_protect_enable on;
                  app_protect_security_log_enable on;
                  app_protect_security_log log_all stderr;
                  
                  # WAF policy - use Custom Resource name when PLM is enabled
                  app_protect_policy_file app_protect_default_policy;

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
          # include /etc/nginx/conf.d/*.conf;
      }

    ## The default.conf of the ConfigMap for customizing NGINX configuration
    nginxDefault: {}

    ## The extra entries of the ConfigMap for customizing NGINX configuration
    entries: {}

  ## It is recommended to use your own TLS certificates and keys
  mTLS:
    ## The base64-encoded TLS certificate for the App Protect Enforcer (server)
    ## Note: It is recommended that you specify your own certificate
    serverCert: ""
    ## The base64-encoded TLS key for the App Protect Enforcer (server)
    ## Note: It is recommended that you specify your own key
    serverKey: ""
    ## The base64-encoded TLS CA certificate for the App Protect Enforcer (server)
    ## Note: It is recommended that you specify your own certificate
    serverCACert: ""
    ## The base64-encoded TLS certificate for the NGINX (client)
    ## Note: It is recommended that you specify your own certificate
    clientCert: ""
    ## The base64-encoded TLS key for the NGINX (client)
    ## Note: It is recommended that you specify your own key
    clientKey: ""
    ## The base64-encoded TLS CA certificate for the NGINX (client)
    ## Note: It is recommended that you specify your own certificate
    clientCACert: ""

  ## The extra volumes of the Nginx container
  volumes: []
  # - name: extra-conf
  #   configMap:
  #     name: extra-conf

  ## The extra volumeMounts of the Nginx container
  volumeMounts: []
  # - name: extra-conf
  #   mountPath: /etc/nginx/conf.d/extra.conf
  #   subPath: extra.conf

  service:
    nginx:
      ports:
        - port: 80
          protocol: TCP
          targetPort: 80
      ## The type of service to create. NodePort will expose the service on each Node's IP at a static port.
      type: NodePort

# Not needed as value will be set during helm install
# ## This is a base64-encoded string representing the contents of the Docker configuration file (config.json).
# ## This file is used by Docker to manage authentication credentials for accessing private Docker registries.
# ## By encoding the configuration file in base64, sensitive information such as usernames, passwords, and access tokens are protected from being exposed directly in plain text.
# ## You can create this base64-encoded string yourself by encoding your config.json file, or you can create the Kubernetes secret containing these credentials before deployment and not use this value directly in the values.yaml file.
# dockerConfigJson: ""
```

#### Enable/Disable the Policy Controller

The Policy Controller option is enabled by default (`appprotect.policyController.enable: true`). Helm will also install the required custom resource definitions (CRDs) required by the policy controller pod.

**Important**: Before applying the Policy Controller, the required Custom Resource Definitions (CRDs) must be installed first. If the CRDs are not installed, the Policy Controller pod will fail to start and show CRD-related errors in the logs.

If you do not use the custom resources that require those CRDs (with `appprotect.policyController.enable` set to false), the installation of the CRDs can be skipped by specifying `--skip-crds` in your helm install command. Please also note that when upgrading helm charts, the current CRDs will need to be deleted and the new ones will be created as part of the helm install of the new version.

If you wish to pull security updates from the NGINX repository (with APSignatures CRD), you should set the `appprotect.nginxRepo` value in values.yaml file.

#### NGINX Configuration Requirements

When Policy Controller is enabled in Helm, the NGINX configuration in your values.yaml must include the `app_protect_default_config_source` directive to enable Policy Controller integration. The values.yaml above already includes this configuration.

**Key PLM-specific directives in the nginx.conf:**
- `app_protect_default_config_source "custom-resource"` - Enables Policy Controller integration
- `app_protect_policy_file app_protect_default_policy;` - Default policy (can be changed to reference Custom Resource names)

**To disable Policy Controller:**
1. Set `appprotect.policyController.enable: false` in your values.yaml
2. Remove or comment out the `app_protect_default_config_source` directive from your nginx.conf in values.yaml
3. Use traditional bundle file paths with `app_protect_policy_file`

## Installation Flow

### New Installations vs. Upgrades

**For New Installations**: Follow the complete step-by-step process below to install NGINX App Protect WAF with Policy Lifecycle Management enabled.

**For Existing Customers**: If you have an existing NGINX App Protect WAF deployment without Policy Lifecycle Management, you need to upgrade your installation to enable PLM functionality. Use `helm upgrade` instead of `helm install` in step 6, and ensure you have the required CRDs and storage configured before upgrading.

### Step-by-Step Installation Process

{{< call-out "important" >}}
**Before You Begin**: Ensure you have already built and pushed your NGINX App Protect WAF Docker image to your private registry following the [Docker deployment guide]({{< ref "/nap-waf/v5/admin-guide/deploy-on-docker.md#nginx-open-source-dockerfile" >}}). Choose the NGINX Open Source Dockerfile for your preferred operating system. The values.yaml configuration below assumes this image is available in your registry.
{{< /call-out >}}

1. **Prepare Environment Variables**
   
   Set the required environment variables:
   ```bash
   export JWT=<your-nginx-jwt-token>
   export NGINX_REGISTRY_TOKEN=<base64-encoded-docker-credentials>
   export NGINX_CERT=$(cat /path/to/your/nginx-repo.crt | base64 -w 0)
   export NGINX_KEY=$(cat /path/to/your/nginx-repo.key | base64 -w 0)
   ```
   
   {{< call-out "note" >}}
   **NGINX Repository Credentials**: Replace `/path/to/your/nginx-repo.crt` and `/path/to/your/nginx-repo.key` with the actual paths to your NGINX repository certificate and key files. These are typically provided by NGINX when you get access to the private registry. The files may have similar names like `nginx-repo.crt` and `nginx-repo.key` or `nginx.crt` and `nginx.key`.
   {{< /call-out >}}

2. **Pull the Helm Chart**
   
   Login to the registry and pull the chart:
   ```bash
   helm registry login private-registry.nginx.com
   helm pull oci://private-registry.nginx.com/nap/nginx-app-protect --version <release-version> --untar
   cd nginx-app-protect
   ```
   
   {{< call-out "important" >}}
   **Important**: The extracted Helm chart includes a default `values.yaml` file. Ignore this file and use your custom values.yaml created from the Configuration section above.
   {{< /call-out >}}

3. **Create Storage**
   
   Create the directory on the cluster:
   ```bash
   sudo mkdir -p /mnt/nap5_bundles_pv_data
   sudo chown -R 101:101 /mnt/nap5_bundles_pv_data
   ```
   
   Create a YAML file `pv-hostpath.yaml` with the persistent volume file content:
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

4. **Create Namespace**
   
   Create a namespace for the deployment (if you don't already have one):
   ```bash
   kubectl create namespace <namespace>
   ```
   
   {{< call-out "important" >}}
   **Important**: The namespace name you choose here must be used consistently in ALL subsequent commands throughout this guide AND must also be specified in your values.yaml file. Replace `<namespace>` with your actual namespace name in every command that follows and update the `namespace:` field in your values.yaml file to match. If you already have an existing namespace, you can skip this step and use your existing namespace name in all subsequent commands and configuration files.
   {{< /call-out >}}

5. **Configure Docker Registry Credentials**
   
   Create the Docker registry secret:
   ```bash
   kubectl create secret docker-registry regcred -n <namespace> \
     --docker-server=private-registry.nginx.com \
     --docker-username=<JWT-Token> \
     --docker-password=none
   ```

6. **Deploy the Helm Chart with Policy Controller**
   
   {{< call-out "note" >}}
   **Release Name**: Replace `<release-name>` with your chosen Helm release name (e.g., "nginx-app-protect", "nap-plm", or "production-waf"). This name identifies your deployment and is used by Helm to manage the installation.
   {{< /call-out >}}
   
   **For new installations:**
   ```bash
   helm install <release-name> . \
     --namespace <namespace> \
     --values /path/to/your/values.yaml \
     --set appprotect.policyController.enable=true \
     --set dockerConfigJson=$NGINX_REGISTRY_TOKEN \
     --set appprotect.config.nginxJWT=$JWT \
     --set appprotect.nginxRepo.nginxCrt=$NGINX_CERT \
     --set appprotect.nginxRepo.nginxKey=$NGINX_KEY
   ```
   
   **For existing deployments (upgrade):**
   ```bash
   helm upgrade <release-name> . \
     --namespace <namespace> \
     --values /path/to/your/values.yaml \
     --set appprotect.policyController.enable=true \
     --set dockerConfigJson=$NGINX_REGISTRY_TOKEN \
     --set appprotect.config.nginxJWT=$JWT \
     --set appprotect.nginxRepo.nginxCrt=$NGINX_CERT \
     --set appprotect.nginxRepo.nginxKey=$NGINX_KEY
   ```

7. **Verify Storage Setup**
   
   After Helm deployment, verify that the PersistentVolumeClaim has been created and bound:
   ```bash
   kubectl get pvc -n <namespace>
   kubectl get pv
   ```
   
   You should see output similar to:
   ```
   NAME                              STATUS   VOLUME                               CAPACITY   ACCESS MODES   STORAGECLASS   AGE
   <release-name>-shared-bundles-pvc   Bound    nginx-app-protect-shared-bundles-pv   2Gi        RWX            manual         1m
   ```
   
   {{< call-out "warning" >}}
   **Troubleshooting PVC Issues**: If you don't see a PVC in your namespace or the PVC shows "Pending" status:
   
   1. **Check if storage configuration is complete in values.yaml:**
      ```bash
      helm get values <release-name> -n <namespace>
      ```
      Ensure you have the complete `appprotect.storage` section including `bundlesPvc.storageRequest`
   
   2. **If storage configuration is missing, upgrade with proper storage settings:**
      ```bash
      helm upgrade <release-name> . --namespace <namespace> \
        --values /path/to/your/values.yaml \
        --set appprotect.policyController.enable=true \
        --set dockerConfigJson=$NGINX_REGISTRY_TOKEN \
        --set appprotect.config.nginxJWT=$JWT \
        --set appprotect.nginxRepo.nginxCrt=$NGINX_CERT \
        --set appprotect.nginxRepo.nginxKey=$NGINX_KEY \
        --set appprotect.storage.pvc.bundlesPvc.storageClass=manual \
        --set appprotect.storage.pvc.bundlesPvc.storageRequest=2Gi
      ```
   
   3. **If PVC exists but shows "Pending", check PV binding:**
      ```bash
      kubectl describe pvc -n <namespace>
      kubectl describe pv nginx-app-protect-shared-bundles-pv
      ```
      Ensure the PV `storageClassName` matches the PVC requirements.
   {{< /call-out >}}

8. **Verify Installation**
   
   Check that all components are deployed successfully:
   ```bash
   kubectl get pods -n <namespace>
   kubectl get crds | grep appprotect.f5.com
   kubectl get all -n <namespace>
   ```

   You should see output similar to this:

   **Pods Status:**
   ```
   NAME                                                         READY   STATUS    RESTARTS   AGE
   <release-name>-policy-controller-cbd97c8db-tbq7j               1/1     Running   0          3d23h
   <release-name>-nginx-app-protect-deployment-5c99b8df65-g4nfn   3/3     Running   0          3d23h
   ```

   **CRDs Verification:**
   ```
   aplogconfs.appprotect.f5.com                 2025-08-27T10:23:34Z
   appolicies.appprotect.f5.com                 2025-08-27T10:23:34Z
   apsignatures.appprotect.f5.com               2025-08-27T10:23:34Z
   apusersigs.appprotect.f5.com                 2025-08-27T10:23:34Z
   ```

   **All Resources:**
   ```
   NAME                                                             READY   STATUS    RESTARTS   AGE
   pod/<release-name>-policy-controller-cbd97c8db-tbq7j               1/1     Running   0          3d23h
   pod/<release-name>-nginx-app-protect-deployment-5c99b8df65-g4nfn   4/4     Running   0          3d23h

   NAME                                           TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
   service/<release-name>-nginx-app-protect-nginx   NodePort   10.43.125.76   <none>        80:30847/TCP   3d23h

   NAME                                                        READY   UP-TO-DATE   AVAILABLE   AGE
   deployment.apps/<release-name>-policy-controller              1/1     1            1           3d23h
   deployment.apps/<release-name>-nginx-app-protect-deployment   1/1     1            1           3d23h

   NAME                                                                   DESIRED   CURRENT   READY   AGE
   replicaset.apps/<release-name>-policy-controller-cbd97c8db               1         1         1       3d23h
   replicaset.apps/<release-name>-nginx-app-protect-deployment-5c99b8df65   1         1         1       3d23h
   ```

   **Key components to verify:**
   - **Policy Controller Pod**: Should show `1/1 Running` status
   - **NGINX App Protect Pod**: Should show `4/4 Running` status (nginx, waf-config-mgr, waf-enforcer, waf-ip-intelligence containers)
   - **All 4 CRDs**: Should be installed and show creation timestamps
   - **Service**: NodePort service should be available with assigned port

## Using Policy Lifecycle Management

### Setting up desired security update versions

Once PLM is deployed, you can create APSignatures resource using Kubernetes manifests and specify desired security update versions. 

**Organize Your Custom Resources:**

It's recommended to create a dedicated directory to organize your Custom Resource files:

```bash
mkdir -p custom-resources
cd custom-resources
```

**Sample APSignatures Resource:**

APSignatures CR is required for download the security update packages directly from the NGINX repository.
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
The APSignatures `metadata.name` must be `signatures`. Only one APSignatures instance can exist
{{< /call-out >}}

Apply the manifest:

```bash
kubectl apply -f signatures.yaml -n <namespace>
```

{{< call-out "note" >}}
If you're not in the `custom-resources` directory, include the path: `kubectl apply -f custom-resources/signatures.yaml -n <namespace>`
{{< /call-out >}}

{{< call-out "note" >}}
Downloading security updates may take several minutes. The version of security updates available at the time of compilation is always used to compile policies. If APSignatures is not created or the specified versions are not downloaded, the versions contained in the compiler docker image will be used.
{{< /call-out >}}

#### Using Security Update for users who can't use the nginx repo - Offline solution

For users who prefer not to download the security update packages directly from the NGINX repository, there are two supported options:

{{< call-out "note" >}}
You should not create APSignatures CR in this case.
{{< /call-out >}}


**1. Manual Package Placement**

 - Create `/mnt/nap5_bundles_pv_data/security_updates_data/` directory.
 - Download the required security update packages (attack-signatures/bot-signatures/threat-campaigns). Use Debian packages. Don't change package file names.
 - Place them in the `/mnt/nap5_bundles_pv_data/security_updates_data/` directory.
 - Ensure the files and `security_updates_data` directory have `101:101` ownership and permissions.

**2. Custom Compiler Image**

 - Build a Docker image that includes the desired packages. See [Building Compiler Image]({{< ref "/nap-waf/v5/admin-guide/compiler.md" >}})
 - Use this custom image in helm chart deployment:
  
  Change `appprotect.policyController.wafCompiler.image.repository` and `appprotect.policyController.wafCompiler.image.tag` values in your `values.yaml` file:
  ```yaml
  appprotect:
    policyController:
      wafCompiler:
        image:
          ## The image repository of the WAF Compiler.
          repository: <your custom repo>
          ## The tag of the WAF Compiler image.
          tag: <your custom tag>
  ```
    
  OR use `--set`:
  ```bash
  helm install 
     ...
     --set appprotect.policyController.wafCompiler.image.repository="<your custom repo>"
     --set appprotect.policyController.wafCompiler.image.tag="<your custom tag>"
     ...
  ```
    
### Creating Policy Resources

Once PLM is deployed, you can create policy resources using Kubernetes manifests. 

**Organize Your Custom Resources (if not already done):**

If you haven't created a directory for your Custom Resources yet, create one:

```bash
mkdir -p custom-resources
cd custom-resources
```

Apply the following Custom Resource examples or create your own based on these templates:

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

{{< call-out "note" >}}
If you're not in the `custom-resources` directory, include the path: `kubectl apply -f custom-resources/dataguard-blocking-policy.yaml -n <namespace>`
{{< /call-out >}}

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

{{< call-out "note" >}}
If you're not in the `custom-resources` directory, include the path: `kubectl apply -f custom-resources/apple-usersig.yaml -n <namespace>`
{{< /call-out >}}

### Monitoring Policy Status

Check the status of your policy resources:

```bash
kubectl get appolicy -n <namespace>
kubectl describe appolicy <policy-name> -n <namespace>
kubectl get appolicy <policy-name> -n <namespace> -o yaml
```

**Using kubectl describe for human-readable output:**

```bash
kubectl describe appolicy dataguard-blocking -n <namespace>
```

**Sample describe output:**
```
Name:         dataguard-blocking
Namespace:    localenv-plm
Labels:       <none>
Annotations:  <none>
API Version:  appprotect.f5.com/v1
Kind:         APPolicy
Metadata:
  Creation Timestamp:  2025-09-10T11:17:07Z
  Finalizers:
    appprotect.f5.com/finalizer
  Generation:  3
  # ... other metadata fields
Spec:
  Policy:
    Application Language:  utf-8
    Blocking - Settings:
      Violations:
        Alarm:  true
        Block:  true
        Name:   VIOL_DATA_GUARD
    Data - Guard:
      Credit Card Numbers:  true
      Enabled:              true
      Enforcement Mode:     ignore-urls-in-list
      # ... other policy settings
Status:
  Bundle:
    Compiler Version:  11.553.0
    Location:          /etc/app_protect/bundles/dataguard-blocking-policy/dataguard-blocking_policy20250914102339.tgz
    Signatures:
      Attack Signatures:  2025-09-03T08:36:25Z
      Bot Signatures:     2025-09-03T10:50:19Z
      Threat Campaigns:   2025-09-02T07:28:43Z
    State:                ready
  Processing:
    Datetime:     2025-09-14T10:23:48Z
    Is Compiled:  true
Events:           <none>
```

**Using kubectl get for YAML output:**

```bash
kubectl get appolicy dataguard-blocking -n <namespace> -o yaml
```

**Sample YAML output:**

```yaml
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: dataguard-blocking
  namespace: localenv-plm
  # ... other metadata fields
spec:
  policy:
    # ... policy configuration
status:
  bundle:
    compilerVersion: 11.553.0
    location: /etc/app_protect/bundles/dataguard-blocking-policy/dataguard-blocking_policy20250914102339.tgz
    signatures:
      attackSignatures: "2025-09-03T08:36:25Z"
      botSignatures: "2025-09-03T10:50:19Z"
      threatCampaigns: "2025-09-02T07:28:43Z"
    state: ready
  processing:
    datetime: "2025-09-14T10:23:48Z"
    isCompiled: true
```

**Key Status Fields to Monitor:**

- **`Status.Bundle.State`**: Policy compilation state
  - `ready` - Policy successfully compiled and available
  - `processing` - Policy is being compiled
  - `error` - Compilation failed (check Policy Controller logs)

- **`Status.Bundle.Location`**: File path where the compiled policy bundle is stored

- **`Status.Bundle.Compiler Version`**: Version of the WAF compiler used for compilation

- **`Status.Bundle.Signatures`**: Timestamps showing when security signatures were last updated
  - `Attack Signatures` - Attack signature update timestamp
  - `Bot Signatures` - Bot signature update timestamp  
  - `Threat Campaigns` - Threat campaign signature update timestamp

- **`Status.Processing.Is Compiled`**: Boolean indicating if compilation completed successfully

- **`Status.Processing.Datetime`**: Timestamp of the last compilation attempt

- **`Events`**: Shows any Kubernetes events related to the policy (usually none for successful policies)

- **`status.bundle.signatures`**: Timestamps showing when security signatures were last updated
  - `attackSignatures` - Attack signature update timestamp
  - `botSignatures` - Bot signature update timestamp  
  - `threatCampaigns` - Threat campaign signature update timestamp

- **`status.processing.isCompiled`**: Boolean indicating if compilation completed successfully

- **`status.processing.datetime`**: Timestamp of the last compilation attempt

## Confirming Setup is Functioning

### 1. Test Policy Compilation

Apply one of the sample policy Custom Resources to verify PLM is working correctly. For example, using the dataguard policy you created earlier:

```bash
kubectl apply -f dataguard-blocking-policy.yaml -n <namespace>
```

{{< call-out "note" >}}
If you're not in the `custom-resources` directory, include the path: `kubectl apply -f custom-resources/dataguard-blocking-policy.yaml -n <namespace>`
{{< /call-out >}}

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

First, get the Policy Controller pod name:
```bash
kubectl get pods -n <namespace> | grep policy-controller
```

Then check the logs using the pod name from the output above:
```bash
kubectl logs <policy-controller-pod-name> -n <namespace>
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

1. **Get Deployment Information**
   
   First, get the deployment name and cluster IP by running:
   ```bash
   kubectl get all -n <namespace>
   ```
   
   In the output, look for:
   - **Service CLUSTER-IP**: Under the `service/` entries, note the `CLUSTER-IP` value (e.g., `10.43.205.101`)
   - **Deployment name**: Under the `deployment.apps/` entries, note the full deployment name (e.g., `localenv-plm-nginx-app-protect-deployment`)

   Example output:
   ```
   NAME                                           TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
   service/localenv-plm-nginx-app-protect-nginx   NodePort   10.43.205.101   <none>        80:30970/TCP   21h

   NAME                                                        READY   UP-TO-DATE   AVAILABLE   AGE
   deployment.apps/localenv-plm-nginx-app-protect-deployment   1/1     1            1           21h
   ```

2. **Update NGINX Configuration via values.yaml**
   
   Open your `values.yaml` file with your preferred editor:
   ```bash
   nano values.yaml
   # or
   vi values.yaml
   # or any editor of your choice
   ```
   
   Find the nginx configuration section and update the policy directive. Look for this line:
   ```yaml
   app_protect_policy_file app_protect_default_policy;
   ```
   
   Change it to use your Custom Resource name:
   ```yaml
   app_protect_policy_file dataguard-blocking;
   ```
   
   Save and close the file.

3. **Apply the Updated Configuration**
   
   Run the Helm upgrade command to apply the new configuration (replace with your actual release name and namespace):
   ```bash
   helm upgrade <release-name> . \
     --namespace <namespace> \
     --values /path/to/your/values.yaml \
     --set appprotect.policyController.enable=true \
     --set dockerConfigJson=$NGINX_REGISTRY_TOKEN \
     --set appprotect.config.nginxJWT=$JWT \
     --set appprotect.nginxRepo.nginxCrt=$NGINX_CERT \
     --set appprotect.nginxRepo.nginxKey=$NGINX_KEY
   ```
   
   Example:
   ```bash
   helm upgrade localenv-plm . \
     --namespace localenv-plm \
     --values /tmp/helm-chart/values.yaml \
     --set appprotect.policyController.enable=true \
     --set dockerConfigJson=$NGINX_REGISTRY_TOKEN \
     --set appprotect.config.nginxJWT=$JWT \
     --set appprotect.nginxRepo.nginxCrt=$NGINX_CERT \
     --set appprotect.nginxRepo.nginxKey=$NGINX_KEY
   ```

4. **Restart the NGINX Deployment**
   
   Restart the deployment to apply the configuration changes (replace with your actual deployment name and namespace):
   ```bash
   kubectl rollout restart deployment <deployment-name> -n <namespace>
   ```
   
   Example:
   ```bash
   kubectl rollout restart deployment localenv-plm-nginx-app-protect-deployment -n localenv-plm
   ```

5. **Test Policy Enforcement**
   
   Send a request that should be blocked by the dataguard policy using the cluster IP you noted earlier:
   ```bash
   curl "http://<CLUSTER-IP>:80/680-15-0817"
   ```

   Example:
   ```bash
   curl "http://10.43.205.101:80/680-15-0817"
   ```

   The request should be blocked, confirming that PLM has successfully compiled and deployed the policy.

## Upgrade the chart

1. **Prepare Environment Variables**
   
   Set the required environment variables:
   ```bash
   export JWT=<your-nginx-jwt-token>
   export NGINX_REGISTRY_TOKEN=<base64-encoded-docker-credentials>
   export NGINX_CERT=$(cat /path/to/your/nginx-repo.crt | base64 -w 0)
   export NGINX_KEY=$(cat /path/to/your/nginx-repo.key | base64 -w 0)
   ```

2. **Pull the new Helm Chart version**
   
   Login to the registry and pull the chart:
   ```bash
   helm registry login private-registry.nginx.com
   helm pull oci://private-registry.nginx.com/nap/nginx-app-protect --version <new-release-version> --untar
   cd nginx-app-protect
   ```
   
   {{< call-out "important" >}}
   **Important**: The extracted Helm chart includes a default `values.yaml` file. Ignore this file and use your custom values.yaml created from the Configuration section above.
   {{< /call-out >}}

3. **Apply Custom Resource Definitions**
   
   Apply the required CRDs before deploying the chart:
   ```bash
   kubectl apply -f crds/
   ```

4. **Create Storage**
   
   Create the directory on the cluster, and persistent volume for policy bundles:
   ```bash
   sudo mkdir -p /mnt/nap5_bundles_pv_data
   sudo chown -R 101:101 /mnt/nap5_bundles_pv_data
   ```
   
   Create a YAML file `pv-hostpath.yaml` with the PV file content:
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
   Apply the `pv-hostpath.yaml` file to create the new PV:
   ```shell
   kubectl apply -f pv-hostpath.yaml
   ```
  
   {{< call-out "note" >}}
   The PV name defaults to `<release-name>-shared-bundles-pv`, but can be customized using the `appprotect.storage.pv.name` setting in your values.yaml file.
   {{< /call-out >}}

5. **Create Namespace**
   
   Create a namespace for the deployment (if you don't already have one):
   ```bash
   kubectl create namespace <namespace>
   ```
   
   {{< call-out "note" >}}
   You can name the namespace whatever you want. If you already have an existing namespace, you can skip this step and use your existing namespace in the subsequent commands.
   {{< /call-out >}}

6. **Configure Docker Registry Credentials**
   
   Create the Docker registry secret or configure in values.yaml:
   ```bash
   kubectl create secret docker-registry regcred -n <namespace> \
     --docker-server=private-registry.nginx.com \
     --docker-username=<JWT-Token> \
     --docker-password=none
   ```

7. **Upgrade the Helm Chart with Policy Controller**
   
   Upgrade the chart with Policy Controller enabled:
   ```bash
   helm upgrade <release-name> . \
     --namespace <namespace> \
     --values /path/to/your/values.yaml \
     --set appprotect.policyController.enable=true \
     --set dockerConfigJson=$NGINX_REGISTRY_TOKEN \
     --set appprotect.config.nginxJWT=$JWT \
     --set appprotect.nginxRepo.nginxCrt=$NGINX_CERT \
     --set appprotect.nginxRepo.nginxKey=$NGINX_KEY
   ```

8. **Verify Upgrade**
   
   Check that all components are deployed successfully:
   ```bash
   kubectl get pods -n <namespace>
   kubectl get crds | grep appprotect.f5.com
   kubectl get all -n <namespace>
   ```

## Uninstall the chart

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

## Troubleshooting

### Common Issues

**Policy Controller Not Starting**
- Verify CRDs are installed: `kubectl get crds | grep appprotect.f5.com`
- Check pod logs: `kubectl logs $(kubectl get pods -n <namespace> -l app=policy-controller -o jsonpath='{.items[0].metadata.name}') -n <namespace>`
- Ensure proper RBAC permissions are configured

**Policy Compilation Failures**
- Check Policy Controller logs for compilation errors
- Verify WAF compiler image is accessible
- Ensure policy syntax is valid

**Bundle Storage Issues**  
- Verify persistent volume is properly mounted
- Check storage permissions (should be 101:101)
- Confirm PVC is bound to the correct PV
