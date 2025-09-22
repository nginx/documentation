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

Guidance for [disconnected or air-gapped environments](#disconnected-or-air-gapped-environments) is available if it is applicable to your deployment.

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
export NGINX_CERT=$(cat /path/to/your/nginx-repo.crt | base64 -w 0)
export NGINX_KEY=$(cat /path/to/your/nginx-repo.key | base64 -w 0)
```

They will be used to download and apply necessary resources.

## Configure Docker for the F5 Container Registry

{{< call-out "note" >}}
You may be able to skip this step on an existing Kubernetes deployment, where guidance was already given to configure Docker.
{{< /call-out >}}

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
sudo mkdir -p /mnt/nap5_bundles_pv_data
sudo chown -R 101:101 /mnt/nap5_bundles_pv_data
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

The volume name defaults to `<release-name>-bundles-pv`, but can be customized using the `appprotect.storage.pv.name` setting in your `values.yaml` file.

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

## Configure Docker
   
Create a Docker registry secret:

```shell
kubectl create secret docker-registry regcred -n <namespace> \
  --docker-server=private-registry.nginx.com \
  --docker-username=$JWT \
  --docker-password=none
```

## Deploy or upgrade the Helm chart
   
Deploy the chart, adding the parameter to enable the Policy Controller:

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

If you would like to instead upgrade an existing deployment, use this `upgrade` command:

```shell
helm upgrade <release-name> . \
  --namespace <namespace> \
  --values /path/to/your/values.yaml \
  --set appprotect.policyController.enable=true \
  --set dockerConfigJson=$NGINX_REGISTRY_TOKEN \
  --set appprotect.config.nginxJWT=$JWT \
  --set appprotect.nginxRepo.nginxCrt=$NGINX_CERT \
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

You can check the status of your resources using `kubectl get` or `kubectl describe`.

The Policy Controller will show status information including:
- Bundle location
- Compilation status
- Signature update timestamps

```shell
kubectl get appolicy dataguard-blocking -n <namespace> -o yaml
```
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

```shell
kubectl describe appolicy dataguard-blocking -n <namespace>
```
```text
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

The key information to review is the following:

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
The APSignatures `metadata.name` argument _must_ be `signatures`. 

Only one APSignatures instance can exist.
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

Follow these steps to upgrade the Helm chart once installed: they are similar to the initial deployment.

You should first [prepare environment variables](#prepare-environment-variables) and [configure Docker registry credentials](#configure-docker-for-the-f5-container-registry).
   
Log into the Helm registry and pull the chart, changing the `--version` parameter for the new version.

```shell
helm registry login private-registry.nginx.com
helm pull oci://private-registry.nginx.com/nap/nginx-app-protect --version <new-release-version> --untar
```
   
{{< call-out "warning">}}
Helm charts come with a default `values.yaml` file: this should be ignored in favour of the customized file during set-up.
{{< /call-out >}}

Then change into the directory and apply the CRDs:

```shell
cd nginx-app-protect
kubectl apply -f crds/
```

Finish the the process by using `helm upgrade`:

```shell
helm upgrade <release-name> . \
  --namespace <namespace> \
  --values /path/to/your/values.yaml \
  --set appprotect.policyController.enable=true \
  --set dockerConfigJson=$NGINX_REGISTRY_TOKEN \
  --set appprotect.config.nginxJWT=$JWT \
  --set appprotect.nginxRepo.nginxCrt=$NGINX_CERT \
  --set appprotect.nginxRepo.nginxKey=$NGINX_KEY
```

You should [verify the Policy Controller is running](#verify-the-policy-controller-is-running) afterwards.

## Uninstall the Helm chart

To uninstall the Helm chart, first delete the custom resources created:

```shell
kubectl -n <namespace> delete appolicy <policy-name>
kubectl -n <namespace> delete aplogconf <logconf-name>
kubectl -n <namespace> delete apusersigs <user-defined-signature-name>
kubectl -n <namespace> delete apsignatures <signature-update-name>
```

Then uninstall the Helm chart, using the release name: 

```shell
helm uninstall <release-name> -n <namespace>
```

Finally, delete any remaining resources, including the namespace:

```shell
kubectl delete pvc nginx-app-protect-shared-bundles-pvc -n <namespace>
kubectl delete pv nginx-app-protect-shared-bundles-pv
kubectl delete crd --all
kubectl delete ns <namespace>
```

## Disconnected or air-gapped environments

{{< call-out "warning" >}}

In this type of environment, you should not create the _APSignatures_ resource.

{{< /call-out >}}

If you have followed the steps for [disconnected or air-gapped environments]({{< ref "/waf/install/disconnected-environment.md">}}) or cannot use the NGINX repository, you have two alternative ways to to manage policies:

**Manual bundle management**

- Create the directory `/mnt/nap5_bundles_pv_data/security_updates_data/`
- Download Debian security packages from a connected environment, ensuring the names are unmodified
- Move the security update packages to the directory  
- Ensure the files and directory have `101:101` ownership and permissions

**Custom Docker image**

- Build a [custom Docker image]({{< ref "/waf/configure/compiler.md" >}}) that includes the target bundles
- Use the custom Docker image instead of downloading bundles at runtime

You can use this custom image by updating the relevant parts of your `values.yaml` file, or the `--set` parameter:

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

```shell
helm install 
   ...
   --set appprotect.policyController.wafCompiler.image.repository="<your custom repo>"
   --set appprotect.policyController.wafCompiler.image.tag="<your custom tag>"
   ...
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