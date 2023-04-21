---
title: "Helm Installation Guide (deprecated)"
date: 2022-03-28T21:42:29-07:00
draft: true
description: "Follow the steps in the guide to install NGINX Management Suite modules and components, such as the Developer Portal, on Kubernetes using a Helm chart."
# Assign weights in increments of 100
weight: 1000
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-852"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "kubernetes", "container"]
doctypes: ["task"]
journeys: ["getting started", "using"]
personas: ["devops", "netops", "secops"]
versions: []
authors: []
aliases:
- /nginx-instance-manager/installation/helm-chart/
---

{{< custom-styles >}}

{{< shortversions "2.5.0" "latest" "nimvers" >}}

## Overview

We recommend using the Instance Manager Helm chart to install Instance Manager on Kubernetes.

Among the benefits of deploying from a Helm chart, the chart includes the required services, which you can scale independently as needed; upgrades can be done with a single helm command; and there's no requirement for root privileges.

---

## Before You Begin

To install or upgrade NGINX Management Suite using a Helm chart, you need the following:

- Kubernetes 1.21.3+ (linux/amd64) with client access to the Kubernetes API server
- An externally-accessible [private Docker registry](https://docs.docker.com/registry/deploying/) to which you can push the container images
- The following binaries:

  - Docker 20.10+ (linux/amd64)
  - `helm` v3.10.0+
  - `kubectl` v1.21.3+
  - `openssl` v1.1.1+
  - `tar` v1.20+

---

## Download Helm Bundle {#download-helm-bundle}

Take the following steps to download the Helm chart bundle to your virtual machine:

 1. On the [MyF5 website](https://my.f5.com/manage/s/downloads), select **Resources > NGINX Downloads**.
 2. In the NGINX products list, select **Instance Manager**.
 3. Select the following download options:

     - **Product version**: \<version>
     - **Linux distribution**
     - **Architecture**

 4. Download the `nms-helm-<version>.tar.gz` files.

---

## Extract Helm Bundle {#extract-helm-bundle}

The `nms-helm-<version>.tar.gz` file includes several Docker container images and the Helm package tarball. To extract these files, take the following steps:

1. Make a directory to extract the package into:

   ``` shell
   mkdir -p <directory name>
   ```

1. Extract the package into the target directory:

   ``` shell
   tar -xzf nms-helm-<version>.tar.gz -C <directory name>
   ```

   <br>

   The extracted files include the following Docker images:

   **Docker images**

   - `nms-apigw-<version>.tar.gz`
   - `nms-core-<version>.tar.gz`
   - `nms-dpm-<version>.tar.gz`
   - `nms-ingestion-<version>.tar.gz`
   - `nms-integrations-<version>.tar.gz`

---

## Load Docker Images {#load-docker-images}

Take the following steps to extract and load the Docker container images:

1. Change to the directory where you [extracted the Docker images](#extract-helm-bundle):

   ``` shell
   cd <directory name>
   ```

1. Load the Docker images:

   ``` shell
   docker load -i nms-apigw-<version>.tar.gz
   docker load -i nms-core-<version>.tar.gz
   docker load -i nms-ingestion-<version>.tar.gz
   docker load -i nms-dpm-<version>.tar.gz
   docker load -i nms-integrations-<version>.tar.gz
   ```

   The output looks similar to the following:

   ``` shell
   $ docker load -i nms-apigw-<version>.tar.gz
   1b5933fe4b5: Loading layer [==================================================>]  5.796MB/5.796MB
   fbe0fc9bcf95: Loading layer [==================================================>]  17.86MB/17.86MB
   ...
   112ae1f604e0: Loading layer [==================================================>]   67.8MB/67.8MB
   4b6a693b90f4: Loading layer [==================================================>]  3.072kB/3.072kB
   Loaded image: nms-apigw:2.1.0
   ```

1. For the output of each `docker load` command, note the loaded image's name and tag. For example, in the output directly above, `nms-apigw` is the image name and `2.1.0` is the tag. You'll need to reference these images and tags in the next section when pushing the images to your private registry. The tag `2.1.0` could be different depending on the product version you [downloaded from MyF5](#download-helm-bundle).

---

## Push Images to Private Registry {#push-images-private-registry}

{{<before-you-begin>}}To complete this step, you need an [externally-accessible private Docker registry](https://docs.docker.com/registry/deploying/) to push the container images to.{{</before-you-begin>}}

After loading the Docker images, you can now tag and push the images to your private Docker registry. Replace `<my-docker-registry>` in the examples below with the path to your private Docker registry.

1. Log in to your private registry:

   ```shell
   docker login <my-docker-registry>
   ```

1. Tag the images with the values you noted in the [Load Docker Images](#load-docker-images) step above. In this example, the images are tagged with version `2.1.0`.

   ```shell
   docker tag nms-apigw:2.1.0 <my-docker-registry>/nms-apigw:2.1.0
   docker tag nms-core:2.1.0 <my-docker-registry>/nms-core:2.1.0
   docker tag nms-dpm:2.1.0 <my-docker-registry>/nms-dpm:2.1.0
   docker tag nms-ingestion:2.1.0 <my-docker-registry>/nms-ingestion:2.1.0
   docker tag nms-integrations:2.1.0 <my-docker-registry>/nms-integrations:2.1.0
   ```

1. Push the images to your private registry:

   ```shell
   docker push <my-docker-registry>/nms-apigw:2.1.0
   docker push <my-docker-registry>/nms-core:2.1.0
   docker push <my-docker-registry>/nms-dpm:2.1.0
   docker push <my-docker-registry>/nms-ingestion:2.1.0
   docker push <my-docker-registry>/nms-integrations:2.1.0
   ```

---

## Extract Helm Chart {#extract-helm-chart}

Run the following command to extract the Helm chart:

``` shell
tar -xzf nms-hybrid-<version>.tgz
```

The package contents are extracted to a directory called `nms-hybrid`.

---

## Configure Helm Chart

After you [extract the Helm chart](#extract-helm-chart), you can edit the bundled `values.yaml` file to customize the deployment settings for your environment.

See the following sections for recommended settings.

### Image Repositories and Tags {#image-repositories-tags}

Configure the Helm chart to pull from your private Docker registry.

1. Open the `values.yaml` file for editing.
1. Locate `imagePullSecrets` and add the credentials for your private Docker registry. For instructions on creating a secret, see the Kubernetes documentation [Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).
1. Update the `image:repository` and `image:tag` values for the `apigw`, `core`, `dpm`, `ingestion`, and `integrations` services with the values you used in when completing the steps in the [Push Images to Private Registry](#push-images-private-registry) section.
1. Save and close the `values.yaml` file.

Alternatively, you can use the `helm install --set` command to set values from the command line. The following example shows how to set values for `imagePullSecrets`, `repository`, and `tag`, where `./nms-hybrid` is the extracted Helm chart directory:

``` shell
helm install \
--set "imagePullSecrets[0].name=regcred" \
--set apigw.image.repository=nms-apigw \
--set apigw.image.tag=2.1.0 \
--set core.image.repository=nms-core \
--set core.image.tag=2.1.0 \
--set dpm.image.repository=nms-dpm \
--set dpm.image.tag=2.1.0 \
--set ingestion.image.repository=nms-ingestion \
--set ingestion.image.tag=2.1.0 \
--set integrations.image.repository=nms-integrations \
--set integrations.image.tag=2.1.0 \
nim ./nms-hybrid
```

### ClickHouse Server

Instance Manager requires a [ClickHouse](https://clickhouse.com) database server for storing metrics information.

The Helm chart installs ClickHouse server by default. This setting is enabled in the `values.yaml` file by setting `nmsClickhouse.enabled` = `true`.

Optionally, to use your own installation of ClickHouse, take the following steps:

1. Open `values.yaml` for editing. You can find this file is in the helm package you downloaded.

2. Set `nmsClickhouse.enabled` = `false`.

3. Add values for `externalClickhouse.address`, `.user`, and `.password` matching your ClickHouse installation.

   **Note**: `externalClickhouse` is required when `nmsClickhouse` is disabled.

### Certificates

Instance Manager generates a certificate authority and self-signs its certificates by default.

If you are deploying in a production environment, you should use your own certificates instead of the defaults. To do so, take the following steps.

1. Open `values.yaml` for editing.
1. Add the name of a Kubernetes secret to `apigw.tlsSecret`. The following fields are required:

   - `tls.crt`
   - `tls.key`
   - `ca.pem`

   <details open>
   <summary>Example Kubernetes secret</summary>

   ```text
   apiVersion: v1
   kind: Secret
   metadata:
   name: apigw-tls
   type: kubernetes.io/tls
   data:
   tls.crt: |
      LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURXakNDQWtLZ0F3SUJBZ0lRSVBFUFduTXVKRGZWbzVTMHJNaTJuREFOQmdrcWhraUc5dzBCQVFzRkFEQU8KTVF3d0NnWURWUVFERXdOdWJYTXdJQmNOTWpJd05ERXlNakV4TkRFeldoZ1BNakV5TWpBMk1qY3lNVEUwTVROYQpNQlF4RWpBUUJnTlZCQU1UQ1dGd2FXZDNMbTV0Y3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDCkFRb0NnZ0VCQU1CdmxtVzZnWTJrTkx4akswMVVIcGQ4MmJDMkg5SDBmMUgzN21XVmdpV2VYWmYrdnRoaG50WDgKVEk1N0ZwMkNyVDhkZy94NDZGYURHa09pcUs4R0ovbzVmeXBCcG0xSnlKWElGWEdWLzZnbGY3NmxhSzQwUTFTYQpDc04xNUx6YjIrVWxQRVBtSnVtajRHcFlPUldUamVxNEtSZ0M3Z2ZKVVdVQStPVFA4OWJxYmtSRmM2TmRvQTEzCmVyZjl5WWVTV1JTOXRheVFObm1xOElWTDN0Q054TUpLVEJ0b0VPME43WjdPZm9vQWlzSW5UbVFIUGtVb3JXcjcKSnVMUlRuNXAyNmYrMVM2N0syZ29wbWxLNkY4SWlGTEZxSnBidXZQZm1nSkZaaVpFU0Y1RjUwTkxkMzRTZ1M5Ygo4Z1ZkMDdFV3dNVDV3VEVvL1k4N2J1eUowTmJXbDNjQ0F3RUFBYU9CcXpDQnFEQU9CZ05WSFE4QkFmOEVCQU1DCkJhQXdIUVlEVlIwbEJCWXdGQVlJS3dZQkJRVUhBd0VHQ0NzR0FRVUZCd01DTUF3R0ExVWRFd0VCL3dRQ01BQXcKSHdZRFZSMGpCQmd3Rm9BVVhvZi91dHNmQVRuT0owMGhCbjFITUxQUFFVSXdTQVlEVlIwUkJFRXdQNElGWVhCcApaM2VDRFdGd2FXZDNMbTV0Y3k1emRtT0NHMkZ3YVdkM0xtNXRjeTV6ZG1NdVkyeDFjM1JsY2k1c2IyTmhiSWNFCkFBQUFBSWNFZndBQUFUQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFWdkdMRlJWRjY1Z2xwNUVHSGlxWnNmNXAKS3pKTXczT0RiTVBmVWMxZWtBZDZDYmY0bVJVbTUzeXRWU045Mk1QbzI2ZUFUdk5sekh6d0RvVE9QMm9PRnVMVApackZDVmt0UThHSGlYYVdDdmtkVnVUZ0FUOWZUTkVhcXdneUpsNVpFOU1DNEtwU0EvbjFLbklkc0lTM04vK2tEClgrNWJZcUlEK0d2aDdYWDZUNFpwYzc2M2p6dzZBSHZaK2ZURER4ZGk1MkQzL0ZWTEplMjQvU3l3TUtwRDhhUjQKcFRwMFlISVBjemdrZUcyQVJ5bWNaV1JmNU04MUpsb3VBbkFMTDVyQUU1RU1ZclRsUDN1WUhyZkkrU2pEVXNoQQp4WUVMZWE2amd6emNvbmZydFMxT0VoQWw4OUZUV1JsUlFrYUtZQk55SzQwMkM1RVB4L0JCRFJZNXZNRStkUT09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
   tls.key: |
      LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBd0crV1picUJqYVEwdkdNclRWUWVsM3pac0xZZjBmUi9VZmZ1WlpXQ0paNWRsLzYrCjJHR2UxZnhNam5zV25ZS3RQeDJEL0hqb1ZvTWFRNktvcndZbitqbC9La0dtYlVuSWxjZ1ZjWlgvcUNWL3ZxVm8KcmpSRFZKb0t3M1hrdk52YjVTVThRK1ltNmFQZ2FsZzVGWk9ONnJncEdBTHVCOGxSWlFENDVNL3oxdXB1UkVWegpvMTJnRFhkNnQvM0poNUpaRkwyMXJKQTJlYXJ3aFV2ZTBJM0V3a3BNRzJnUTdRM3RuczUraWdDS3dpZE9aQWMrClJTaXRhdnNtNHRGT2ZtbmJwLzdWTHJzcmFDaW1hVXJvWHdpSVVzV29tbHU2ODkrYUFrVm1Ka1JJWGtYblEwdDMKZmhLQkwxdnlCVjNUc1JiQXhQbkJNU2o5anp0dTdJblExdGFYZHdJREFRQUJBb0lCQVFDRC9VV2ordHVYWWpTRgpybU5xQTdPRDVpK09CQzBwSGRFaVVMTGtYRHJMUUtjamRLaEQxQmxVM2x0SU11YmRIRjlsOWdHc2J1VzFTUEQvCnlSWjREZm5ucC80djVwMlhRazloWkw1SWpVQ3dmUi8wakpHVFF1ZVhwSnlUV2s2TXR5UkpORlAwb215NFBoM1QKOHpVY05udlZyWUVLSmlCTG1PcktJM09UeFlxVE1rRTZydWRTdlJyRHZhS3BPQkVpTExQT0tzZHBwODBIMFZibwpqUlhGT2NucVZDVENTeGpxVStVYnNXREZzVzVKdFJOZEo1UEtSaFE1VXhYV0dIQmNWVm1xLzYwdlVXa1RBTDdDCjJXSnRmSG9ySU9rNmVFcHlSamdBVHZtaVByKzAyS0hFVlAyRzFiZ0xzaUJyQ1RzNWxwWDZ3RzcyYk1JSDNoY2YKSSsyeURzVHhBb0dCQU80aVBSbTlXQTlZL0MyeThFSzd6OHcwUlRhL2ZvTklKTmN6Sm00ZTNMbHk2QUlETVhBMQpOYVpNOVM0d1djc2phaVRHdUU3QXVRMkZuSEgxa3F3a2k2WnBwRFh1eDJwN2pkNUdsakx2bTVUOTJkUEJFMzVMCkhMR1U1R2pXNHRIeE1FbldnMThDLzNpZDBVdnp1RllOWVJBM3ZPNkhpVUE3NlllZHQ5eitudFA1QW9HQkFNN2YKcE9vejU4VjRqTWhSdTZ0RUUwdWZqSXowenJ1eXlmT25lRnByT1JsZGFwTkdKU1g4alM0L0lGaVlwamdQSGprOApIRTU3MnJIMVlJaXhJeG45TmVVdy96NUpCV09hSlh5dkFtSHE0T3Z1SzRHWERvU0hMZWZjUmhlSGJmc09RT2xGCnVHcjRMVSt4TUMvdlM3QnBpUk9uM3dWTVp4T1YzMEFEWjh3R1RNTHZBb0dBQWZWZ0lVVVFZMWZ0QXdjMHVLZkkKeHJvclU0N3hvR3pJZU1pZjZVbnhzTWpFSmJnWEFRQS9CN1ljVWh2dHNTRUNiM2orN1E3aXRyekJrNkpjYVhRSApmZi9pYk5zZzRyeFBaMk9YT3FZRDFvN2I2c1Rzdng0cEIwRGRQQXVBWkEraXdRaTFuZU50YkhXSDBpTVlBZ1VzCkpqRC9LY3NOa3V5ck9BVlJETTAvU3lrQ2dZQTlKWGVPVGhkRWsvUXd4WS9OK0lvbmdSby9FNkVEYzc0amlhMlcKTkRrbFdTcEdLNmFSU3N2RURwNlY4VkM0SXlmUXpRYWs0QkR0SnRVSXNpcm81S0lJZzJuK1ZBRUd4cW9yNTJLeAo1SVhrMW5uL2pOR2F0SVlLRVY2YVY4cFhPWWhRS3U1dWw3cDA0cStXaTRsNHRFanpDVnh2S1gwU0dldHA5VmU1CncyYnUrd0tCZ0RXZlFZLzBRcW02Z0VacDMybDdXbjRWT3JvMVBBS3JuU1g2cHFSejVTekF3UVlTYnMvZ2h5d3MKYUIrVG1vWmVkcTlsc1hvUmtLVjlFYkQxTldYa2tHZ05sWmRRQ1l0Y2lDdm9jczYvbmYzemFZTXZENlhGWEhQSApzNXliM3BHcDdhMlpDeFJJR1NkcUxXWjExRW5nRjhwWGMxOUpWNHB4UndzazRrZ3RvMzRvCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==
   ca.pem: |
      LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURDVENDQWZHZ0F3SUJBZ0lRVFVEVTlNY3puWUZObHJwMDdrSGtWREFOQmdrcWhraUc5dzBCQVFzRkFEQU8KTVF3d0NnWURWUVFERXdOdWJYTXdJQmNOTWpJd05ERXlNakV4TkRFeldoZ1BNakV5TWpBMk1qY3lNVEUwTVROYQpNQTR4RERBS0JnTlZCQU1UQTI1dGN6Q0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ0VCCkFNQWdUVUlvZjZTUnpMTmg2SnlUTTJEazU4VzJvT0dyQUtJS0dHcnJaaWZMSno4V21WNk1jb0RMNU9jdSs1YlIKdk9HMHlOdWdxaWQ0YmhuVHlNWnhlR3p1T09TZ2VSTzA3bE9SNUJCczFDRUFidEtuSUh2d1J2aDRGUXBnbmQvTAo1ek1ZN1FFN0N4TjBXSFRBYWR1Q1M0NEZSVkFkdzVXRzQ5YVFVd3VCajlqRlNlbCtVemxQdkExWGFBTWRrSkF0CktmTDRUY3FuK1JDR2FrYWI3aUg3b25zMHFZdDFTSlJuOENzdFFvbGJ2aXduM2VKTzRtVTFnY1hxRnV6N2ZLZGUKMjk4V3FNaG94NHJib2hTWFlUSXBYTWtMOHhBNU1TeE5WZ1NIM09heDN5ZWpzYy9NZnpjMHA0bEYxVDBLamZJWgpEcjUwL1Z2QXNZc2lUbWF5UktUeU13MENBd0VBQWFOaE1GOHdEZ1lEVlIwUEFRSC9CQVFEQWdLa01CMEdBMVVkCkpRUVdNQlFHQ0NzR0FRVUZCd01CQmdnckJnRUZCUWNEQWpBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWQKRGdRV0JCUmVoLys2Mng4Qk9jNG5UU0VHZlVjd3M4OUJRakFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBRmZ5VgpKakptTHcxYzR2ejg2ME12UXpiejZFK0p6NnhmbW5VZHlleEZnQ1Q4Nm1YbCticlNZRjRodS9uOFRicXEzTFRuClFKZlR2a2JUamoydmhyUHdERnVtbXBXQmt1WVVKN2tmN2tpa24rYlkzQnh2OUIyR2x2UDJSWEhhd3pzejdMM1kKVHRRSlExS01IVFpIa0xYRWNDRVdES2dtNEVVK2JRNlBydm5meGk5VlVicHpBc051SU9MMklsUVl0RUxCOEJOYwpsREtLQjBJYVk0TTdmTTkrMjhXVkkyRVJjblJETTAycjVZMXkxaUNvTDZ3TVVuL0FHRjluVU1tZTREcWpLUEVXCnRveGliYmZRUHdaUy9sWmVCV1lpRlo0MVNINGZaeURUVHJVY3lsVk9DU3AzdVAyYlpYM3N0MVl2VGlKS2hxL0MKMUlETWhuWDBiMWhYY1Z5YnhnPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
   ```

   </details>

### Storage Settings

Review the deployment's default resource and storage settings by editing the `values.yaml` file in the helm package you downloaded. Adjust the values to meet your data needs.

Persistent volumes are enabled by default for the ClickHouse database server and `core` and `dpm` services. To disable persistent storage for a configuration, set `persistence.enable` = `false`.

---

## Configure Helm Chart to use NGINX Plus for API Gateway

1. Build your own NGINX Plus API Gateway Docker image by providing your `nginx-repo.crt` and `nginx-repo.key`. Download the certificate (`nginx-repo.crt`) and key (`nginx-repo.key`) from the [MyF5 customer portal](https://my.f5.com) and add them to your build context.

    You can use the following Docker image and instructions within it. Here we're using `apigw:<version>` as the base image, which we got when we completed the [Extract Helm Bundle](#extract-helm-bundle) steps and extending it to use NGINX Plus instead of NGINX OSS.

    <details closed>
    <summary>NGINX Plus API Gateway Docker image</summary>

   ```shell
   # syntax=docker/dockerfile:1

   # NGINX PLUS API-GW
   # NOTE:
     # NGINX Management does not publish this Docker image and are only instructions on how to build API-GW with NGINX-PLUS
     # This docker build should be performed by customer using their own nginx-repo.crt and nginx-repo.key
     # API-GW with NGINX-PLUS to enable OIDC.

     # Download NMS api gateway docker image from MyF5 Downloads, https://docs.nginx.com/nginx-management-suite/admin-guides/installation/helm-chart/
     # Replace "apigw:<version>" with a known release tag.
     # For example: apigw:2.5.0

   FROM apigw:<version> as apigw-plus

   ARG REPO_PATH=.

   # Define NGINX versions for NGINX Plus and NGINX Plus modules
   # Uncomment this block and the versioned nginxPackages in the main RUN
   # instruction to install a specific release
   # ENV NGINX_VERSION 21
   # ENV NJS_VERSION   0.3.9
   # ENV PKG_RELEASE   1

   # Remove any previous version of nginx
   RUN apk del nginx*

   # Download certificate and key from the customer portal (https://cs.nginx.com)
   # and copy to the build context
   COPY ${REPO_PATH}/nginx-repo.crt /etc/apk/cert.pem
   COPY ${REPO_PATH}/nginx-repo.key /etc/apk/cert.key

   RUN set -x \
   # Install the latest release of NGINX Plus and/or NGINX Plus modules
   # Uncomment individual modules if necessary
   # Use versioned packages over defaults to specify a release
       && nginxPackages=" \
           nginx-plus \
           # nginx-plus=${NGINX_VERSION}-${PKG_RELEASE} \
           nginx-plus-module-njs \
           # nginx-plus-module-lua \
           # nginx-plus-module-xslt \
           # nginx-plus-module-xslt=${NGINX_VERSION}-${PKG_RELEASE} \
           # nginx-plus-module-geoip \
           # nginx-plus-module-geoip=${NGINX_VERSION}-${PKG_RELEASE} \
           # nginx-plus-module-image-filter \
           # nginx-plus-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE} \
           # nginx-plus-module-perl \
           # nginx-plus-module-perl=${NGINX_VERSION}-${PKG_RELEASE} \
           # nginx-plus-module-njs=${NGINX_VERSION}.${NJS_VERSION}-${PKG_RELEASE} \
       " \
       KEY_SHA512="e7fa8303923d9b95db37a77ad46c68fd4755ff935d0a534d26eba83de193c76166c68bfe7f65471bf8881004ef4aa6df3e34689c305662750c0172fca5d8552a *stdin" \
       && apk add --no-cache --virtual .cert-deps \
           openssl vim \
       && wget -O /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
       && if [ "$(openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout | openssl sha512 -r)" = "$KEY_SHA512" ]; then \
           echo "key verification succeeded!"; \
           mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/; \
       else \
           echo "key verification failed!"; \
           exit 1; \
       fi \
       && apk del .cert-deps \
       && apk add -X "https://plus-pkgs.nginx.com/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $nginxPackages \
       && if [ -n "/etc/apk/keys/nginx_signing.rsa.pub" ]; then rm -f /etc/apk/keys/nginx_signing.rsa.pub; fi \
       && if [ -n "/etc/apk/cert.key" && -n "/etc/apk/cert.pem"]; then rm -f /etc/apk/cert.key /etc/apk/cert.pem; fi \
   # Bring in gettext so we can get `envsubst`, then throw
   # the rest away. To do this, we need to install `gettext`
   # then move `envsubst` out of the way so `gettext` can
   # be deleted completely, then move `envsubst` back.
       && apk add --no-cache --virtual .gettext gettext \
       && mv /usr/bin/envsubst /tmp/ \
       \
       && runDeps="$( \
           scanelf --needed --nobanner /tmp/envsubst \
               | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
               | sort -u \
               | xargs -r apk info --installed \
               | sort -u \
       )" \
       && apk add --no-cache $runDeps \
       && apk del .gettext \
       && mv /tmp/envsubst /usr/local/bin/ \
   # Bring in tzdata so users could set the timezones through the environment
   # variables
       && apk add --no-cache tzdata \
   # Bring in curl and ca-certificates to make registering on DNS SD easier
       && apk add --no-cache curl ca-certificates \
   # Forward request and error logs to Docker log collector
       && ln -sf /dev/stdout /var/log/nginx/access.log \
       && ln -sf /dev/stderr /var/log/nginx/error.log

   CMD ["nginx", "-g", "daemon off;"]

   # vim:syntax=Dockerfile
   ```

   </details>

2. Tag and push the Docker image (built above) to your private Docker registry by following the steps in the [Push Images to Private Registry](#push-images-private-registry) section.

   ```shell
   docker tag apigw-plus <my-docker-registry>/nms-apigw-plus:<version>
   ```

   ```shell
   docker push <my-docker-registry>/nms-apigw-plus:<version>
   ```

3. Follow the steps in [Image Repositories and Tags](#image-repositories-tags) to install Instance Manager and use the appropriate Docker image for the API Gateway.

   For NGINX Plus, use the following:

    ```bash
    --set apigw.image.repository=nms-apigw-plus \
    --set apigw.image.tag=<your-tagged-version> \
    ```

---

## Perform a Dry Run Installation

Use the `helm` command to perform a dry run. The Kubernetes API server returns the resources that the Helm chart will create in your Kubernetes environment.

Start by creating a namespace `nms` using the following command:

```shell
kubectl create namespace nms
```

---

## Install Instance Manager from a Helm Chart

Run the `helm install` command to install Instance Manager from the Helm chart.

The following example command uses the namespace `nms` created above, sets a hashed password using OpenSSL, and installs Instance Manager as an app called `nim` from the Helm chart in `./nms-hybrid`:

```shell
helm install -n nms --set adminPasswordHash=$(openssl passwd -6 'YourPassword123#') nim ./nms-hybrid
```

{{< important >}}Make sure to copy and save the password for future reference. Only the encrypted password is stored in Kubernetes. There's no way to recover or reset a lost password.{{< /important >}}

---

## Validate Deployment {#validate-deployment}

To check the status of the deployment, run the following command. In this example, `nms` is the namespace and `nim` is the application name specified during installation.

``` shell
helm -n nms status nim
```

If the deployment was successful, the status should be `STATUS: deployed`.

---

## Access Web Interface

You can access the Instance Manager web interface using the external IP address for the API Gateway.

1. To look up the external IP address for the API Gateway, run the following command:

   ```shell
   kubectl -n nms get svc apigw
   ```

   The output includes information similar to the following example. Note the value in the `EXTERNAL-IP` column.

   ```text
   NAME    TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
   apigw   LoadBalancer   10.100.153.15   localhost     443:30414/TCP   2m1s
   ```

1. Using the value from the previous step, go to `https://<apigw-EXTERNAL-IP>:443/ui`.

   For example, `https://localhost:443/ui`.

---

## Upgrade Instance Manager from a Helm Chart

See the [Upgrade Guide]({{< relref "/admin-guides/installation/upgrade-guide.md#upgrade-instance-manager" >}}) for instructions on upgrading Instance Manger from a Helm chart.

---

## Uninstall Instance Manager

- To uninstall Instance Manager from Kubernetes, run the following command. In this example, `nms` is the namespace and `nim` is the application name specified during installation.

```shell
helm uninstall --namespace nms nim
```

---

## What's Next

- [License Instance Manager]({{< relref "/admin-guides/getting-started/add-license.md" >}})
- [Install and Configure NGINX Agent]({{< relref "/nginx-agent/install-nginx-agent.md" >}})
- [Set Up Authentication for Instance Manager]({{< relref "/admin-guides/access-control/configure-authentication.md" >}})


