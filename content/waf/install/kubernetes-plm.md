---
# We use sentence case and present imperative tone
title: "Kubernetes operations improvements (Early access)"
# Weights are assigned in increments of 100: determines sorting order
weight: 300
# Creates a table of contents and sidebar, useful for large documents
toc: true
nd-banner:
    enabled: true
    start-date: 2025-08-30
    md: /_banners/waf-early-availability.md
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

There are two new features available for Kubernetes through early access:

**Security policy orchestration**, which removes the need for compilation by updating existing security policies. The supported security policy formats are JSON, YAML (where the security policy is defined inline within the AppPolicy CR), and Bundle.

**Automated signature updates**, which can auto-update security signatures.

<!-- Policy lifecycle management (PLM) is a system for managing, compiling and deploying security policies in Kubernetes environments.  -->

They extends the WAF compiler capabilities by providing a native Kubernetes operator-based approach for policy orchestration.

These feature revolve around a _Policy Controller_ which uses the Kubernetes operator pattern to manage the lifecycle of WAF security artifacts. 

It handles policy distribution at scale by removing manual steps and providing a declarative configuration model with Custom Resource Definitions (CRDs) for policies, logging profiles and signatures.

{{< call-out "note" >}}

These enhancements are  only available for Helm-based deployments.

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

These enhancements require specific CRDs to be applied before deployment. 

These CRDs define the resources that the Policy Controller manages:

- `appolicies.appprotect.f5.com` - Defines WAF security policies
- `aplogconfs.appprotect.f5.com` - Manages logging profiles and configurations  
- `apusersigs.appprotect.f5.com` - Handles user-defined signatures
- `apsignatures.appprotect.f5.com` - Manages signature updates and collections

To obtain the CRDs, log into the Helm registry and pull the chart, changing the `--version` parameter for your desired version.

```shell
helm registry login private-registry.nginx.com
helm pull oci://private-registry.nginx.com/nap/nginx-app-protect --version 5.9.0-ea --untar
```

Then change into the directory and apply the CRDs using _kubectl apply_:

```shell
cd nginx-app-protect
kubectl apply -f crds/
```

### Update NGINX configuration

To activate these enhancements, NGINX requires configuration to integrate with the Policy Controller. 

The directive `app_protect_default_config_source` must be set to `"custom-resource"` to enable the features.

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

    # Enable enhancements
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

These are the directives:

- `app_protect_default_config_source "custom-resource"` - Enables the Policy Controller integration
- `app_protect_policy_file my-policy-cr` - References a Custom Resource policy name instead of bundle file paths
- `app_protect_security_log my-logging-cr` - References a Custom Resource logging configuration name

## Update Helm configuration

These new enhancements are deployed as part of the F5 WAF for NGINX Helm chart. 

To enable them, you must configure the Policy Controller settings in your `values.yaml` file:

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

          # Enable enhancements
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
                  
                  # WAF policy - use Custom Resource name when these enhancements are enabled
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
kubectl get pvc -n <namespace>
kubectl get pv
kubectl get all -n <namespace>
```

If you don't see a persistent volume claim in the namespace, first check that storage configuration in your values file is correct:

```shell
helm get values <release-name> -n <namespace>
```

You should see a section named _appprotect.storage_ with the parameter _bundlesPvc.storageRequest_. If it's missing, use `helm upgrade` to add it:

```shell
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

If the volume claim exists but shows "Pending", review the binding:

```shell
kubectl describe pvc -n <namespace>
kubectl describe pv nginx-app-protect-shared-bundles-pv
```

Ensure the `pv` _storageClassName_ matches the `pvc` requirements.

In totality, you should see the following:

- **Policy Controller pod**: `1/1 Running` status
- **F5 WAF for NGINX pod**: `3/3 Running` status (nginx, waf-config-mgr, waf-enforcer containers)
- **All 4 CRDs**: Each CRD should be installed and show creation timestamps
- **Service**: The NodePort service should be available with assigned port

If you are using the IP intelligence feature, you will have a 4th F5 WAF for NGINX pod (waf-ip-intelligence).

## Update security policies

### Create custom policy resources

During installation, you can create policy resources using Kubernetes manifests. 

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
    compilerVersion: 11.559.0
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
    Compiler Version:  11.559.0
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
- **`status.processing.isCompiled`**: Boolean indicating if compilation completed successfully
- **`status.processing.datetime`**: Timestamp of the last compilation attempt

## Validate your installation

### Apply a policy

Apply one of the sample policy Custom Resources to verify your installation is working correctly.

For example, using the dataguard policy you created earlier:

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
    compilerVersion: 11.559.0
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

First, identify and confirm the deployment information:

```shell
kubectl get all -n <namespace>
```

Look for the fields _CLUSTER-IP_ and the full deployment name:

```
NAME                                           TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/localenv-plm-nginx-app-protect-nginx   NodePort   10.43.205.101   <none>        80:30970/TCP   21h

NAME                                                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/localenv-plm-nginx-app-protect-deployment   1/1     1            1           21h
```

Then open your `values.yaml` file in an editor and look for the policy directive:

```yaml
app_protect_policy_file app_protect_default_policy
```

Replace _app_protect_default_policy_ with the custom resource name, such as:

```yaml
app_protect_policy_file dataguard-blocking;
```

Use `helm upgrade` to apply the new configuration, replacing the name and namespace accordingly:

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

Restart your Kubernetes deployment to load the new configuration changes:

```shell
kubectl rollout restart deployment <deployment-name> -n <namespace>
```
   
Send a test request to trigger the dataguard policy:

```shell
curl "http://[CLUSTER-IP]:80/?a=<script>"
```

The request should be blocked, confirming the policy was successfully compiled and deployed.

## Update security signature versions

Once these enhancements are enabled, you can define specific security update versions on a per-feature basis.

This is accomplished by adding a `revision:` parameter to the feature.

The following example is for an _APSignatures_ resource, in a file named `signatures.yaml`:

```yaml {hl_lines=[7, 9, 11]}
apiVersion: appprotect.f5.com/v1
kind: APSignatures
metadata:
  name: signatures
spec:
  attack-signatures:
    revision: "2025.06.19" # The precise attack-signatures revision to be used
  bot-signatures:
    revision: "latest" # "latest" will use the most recent bog-signatures revision
  threat-campaigns:
    revision: "2025.06.24" # The precise threat-signatures revision to be used
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

{{< call-out "note" >}}
You must re-apply your policy when changing signature revisions.

This ensures the existing policy will be recompiled with the new signatures.
{{< /call-out >}}

If _APSignatures_ is not created or the specified versions are not available, it will default to the version stored in the compiler Docker image.

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
kubectl delete ns <namespace>
```

<!-- ## Disconnected or air-gapped environments

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

For more information relevant to this type of deployment, see the [Disconnected or air-gapped environments]({{< ref "/waf/install/disconnected-environment.md" >}}) topic. -->

## Policy types

F5 WAF for NGINX supports multiple ways to define and reference security policies through APPolicy Custom Resources. 

This flexibility allows you to choose the most appropriate approach based on your requirements.

There are three distinct approaches for defining WAF policies:

1. [Inline policy definition](#inline-policy-definition): Define the complete policy configuration directly within the Custom Resource specification.
1. [JSON policy reference](#json-policy-reference): Reference a JSON policy file stored in the shared persistent volume.
1. [Precompiled bundle reference](#precompiled-bundle-reference): Reference a precompiled policy bundle (.tgz file) stored in the shared persistent volume.

### Inline policy definition

Inline policy definition allows you to specify the complete WAF policy configuration directly within the APPolicy Custom Resource. 

This method provides full declarative management through Kubernetes manifests and is ideal for version-controlled policy configurations.

An example is as follows, in a file named `inline-policy.yaml`:

```yaml
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: dataguard-blocking-inline
  namespace: <namespace>
spec:
  policy:
    name: dataguard_blocking_inline
    template:
      name: POLICY_TEMPLATE_NGINX_BASE
    applicationLanguage: utf-8
    enforcementMode: blocking
    blocking-settings:
      violations:
        - name: VIOL_DATA_GUARD
          alarm: true
          block: true
        - name: VIOL_ATTACK_SIGNATURE
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
kubectl apply -f inline-policy.yaml
```

### JSON policy reference

JSON policy reference allows you to store your policy configuration as a separate JSON file in the shared persistent volume and reference it from the APPolicy Custom Resource. 

This method separates policy content from Kubernetes resource management while maintaining compilation automation.

To use JSON policy reference:

- The policy JSON file must be stored in the shared persistent volume
- The JSON file must be accessible at the specified path within the container
- The JSON file must have correct file permissions (readable by the Policy Controller)

The Policy Controller can automatically monitor policy files for changes and trigger recompilation when modifications are detected. This feature is controlled through the `externalReferenceDetails.tracking` configuration:

- **`tracking.enabled`**: Enable/disable automatic file monitoring (default: true)
- **`tracking.intervalInSeconds`**: Polling interval for file changes (default: 5 seconds)

To exemplify how this works, first create a policy JSON file in the shared volume. 

This policy file is `/mnt/nap5_bundles_pv_data/dg_policy.json`:

```json
{
  "name": "dataguard_blocking_json",
  "template": {
    "name": "POLICY_TEMPLATE_NGINX_BASE"
  },
  "applicationLanguage": "utf-8",
  "enforcementMode": "blocking",
  "blocking-settings": {
    "violations": [
      {
        "name": "VIOL_DATA_GUARD",
        "alarm": true,
        "block": true
      },
      {
        "name": "VIOL_ATTACK_SIGNATURE", 
        "alarm": true,
        "block": true
      }
    ]
  },
  "data-guard": {
    "enabled": true,
    "maskData": true,
    "creditCardNumbers": true,
    "usSocialSecurityNumbers": true,
    "enforcementMode": "ignore-urls-in-list",
    "enforcementUrls": []
  },
  "signature-settings": {
    "signatureStaging": false
  }
}
```

Create a second file named `json-policy.yaml`:

```yaml
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: dataguard-blocking-ref
  namespace: <namespace>
spec:
  policy:
    $ref: /etc/app_protect/bundles/dg_policy.json
  externalReferenceDetails:
    tracking:
      enabled: true
      intervalInSeconds: 10
```

Apply the APPolicy resource:

```shell
kubectl apply -f json-policy.yaml
```

There are a few considerations when creating your policy files:

- **Container path**: The `$ref` path must be the path as seen from within the Policy Controller container
- **Shared volume**: The file must be in the shared persistent volume mounted to both Policy Controller and NGINX containers
- **Default mount path**: The shared volume is typically mounted at `/etc/app_protect/bundles`
- **Absolute paths**: Always use absolute paths in the `$ref` field

Once you have applied the APPolicy custom resource, you can update the policy by modifying the JSON file:

1. Edit the JSON file directly (Such as`/mnt/nap5_bundles_pv_data/dg_policy.json`)
1. Save your changes
1. The Policy Controller automatically handles the rest

The Policy Controller resolves the change with the following steps:

1. **Automatic Detection**: If tracking is enabled, file changes are detected automatically
1. **Recompilation Trigger**: Policy Controller triggers automatic recompilation
1. **Status Updates**: Custom Resource status reflects the new compilation state
1. **Bundle Replacement**: New policy bundle replaces the previous version

{{< call-out "warning" >}}

You do not need to reapply the APPolicy resource when updating the JSON file.

The Policy Controller will detect the file changes and recompile automatically.

{{< /call-out >}}

### Precompiled bundle reference

Precompiled bundle reference allows you to use policy bundles that have been pre-compiled using external WAF compiler tools. 

This approach is useful for policies compiled outside of the Kubernetes environment or when integrating with external policy management systems.

To use a precompiled bundle reference: 

- The precompiled bundle (.tgz) file must be stored in the shared persistent volume
- The bundle must be compatible with the current WAF Enforcer version
- The bundle file must have correct file permissions (readable by the Policy Controller)

Bundles are managed at the following stages:

1. **Validation phase**: Policy Controller validates the bundle structure
1. **Deployment**: Bundle is made available to NGINX containers
1. **Change detection**: If tracking is enabled, bundle file changes trigger updates
1. **Status reporting**: Custom Resource status shows bundle deployment state

The Policy Controller performs validation of precompiled bundles using `apcompile --dump` to ensure:

- **Bundle integrity**: Verification that the bundle is properly formed
- **Version compatibility**: Confirmation that the bundle works with current enforcer
- **Content validation**: Basic checks on policy structure and syntax

To exemplify how this works, first ensure your precompiled policy bundle is available in the shared volume. 

For example, place `policy2.tgz` in `/mnt/nap5_bundles_pv_data/`.

Then create a file named `precompiled-bundle-policy.yaml`:

```yaml
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: dataguard-tgz
  namespace: <namespace>
spec:
  policy:
    $ref: /etc/app_protect/bundles/policy2.tgz
  externalReferenceDetails:
    tracking:
      enabled: true
      intervalInSeconds: 10
```

Apply the new APPolicy resource:

```shell
kubectl apply -f precompiled-bundle-policy.yaml
```

Once the APPolicy Custom Resource has been applied, updating your policy bundle is straightforward:

1. Replace the existing bundle file with your new bundle (keeping the same filename)
1. For example, replace `/mnt/nap5_bundles_pv_data/policy2.tgz` with your updated bundle
1. The Policy Controller automatically handles the rest

The Policy Controller resolves the change with the following steps:

1. **Change detection**: If tracking is enabled, the Policy Controller detects the file modification
1. **Revalidation**: The new bundle is validated using `apcompile --dump`
1. **Deployment**: If validation passes, the new bundle is deployed
1. **Status updates**: Custom Resource status reflects the new validation and deployment state

{{< call-out "warning" >}}

You do not need to reapply the APPolicy resource when replacing the file.

Replace the bundle file with another (With the exact same name).

The Policy Controller will detect the file changes and recompile automatically.

{{< /call-out >}}

### Monitor policy status

Regardless of the policy type used, you can monitor the status of your policies using standard Kubernetes commands:


```shell
kubectl get appolicy -n <namespace>
kubectl describe appolicy <policy-name> -n <namespace>
kubectl get appolicy <policy-name> -n <namespace> -o yaml
```

All policy types provide similar status information:

- **`status.bundle.state`**: Policy compilation/validation state (`ready`, `processing`, `error`)
- **`status.bundle.location`**: Path to the deployed policy bundle
- **`status.bundle.compilerVersion`**: Version of the compiler used
- **`status.bundle.signatures`**: Signature package timestamps
- **`status.processing.isCompiled`**: Compilation success indicator
- **`status.processing.datetime`**: Last processing timestamp

Status output may look similar to the following:

```yaml
status:
  bundle:
    compilerVersion: 11.553.0
    location: /etc/app_protect/bundles/dataguard-blocking-ref-policy/dataguard-blocking-ref_policy20250925101234.tgz
    signatures:
      attackSignatures: "2025-09-20T08:36:25Z"
      botSignatures: "2025-09-20T10:50:19Z"
      threatCampaigns: "2025-09-18T07:28:43Z"
    state: ready
  processing:
    datetime: "2025-09-25T10:12:45Z"
    isCompiled: true
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
