---
title: Persistent Storage
description: Learn how to set up persistent storage for use with F5 NGINX Service
  Mesh.
weight: 101
toc: true
nd-docs: DOCS-686
type:
- how-to
---

F5 NGINX Service Mesh generates data that needs to persist across restarts and failures to ensure uninterrupted operations. For example, if the SPIRE Server restarts, the new instance can pick up the the existing database of identities without having to rebuild everything. Depending on the environment, persistent storage may already be set up and ready for use by NGINX Service Mesh.

The big three hosted Kubernetes environments (Elastic Kubernetes Service (EKS), Azure Kubernetes Service (AKS), and Google Kubernetes Engine (GKE)) all have built-in persistent storage that NGINX Service Mesh will automatically pick up and use.

{{< call-out "important" >}}
**EKS Users:** in Kubernetes v1.23+ the in-tree to container storage interface (CSI) volume migration feature is enabled for EKS.
This means the Amazon EBS CSI driver must be installed in your cluster in order for persistent storage to work.
If the CSI driver is not installed prior to installing NGINX Service Mesh, the `PersistentVolumeClaim` required by SPIRE Server gets stuck in a pending state and the mesh will fail to install.

See the [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html) for instructions on how to install the EBS CSI driver on your EKS cluster.
If you are unable to install the CSI driver you can disable persistent storage, although this is not recommended for production environments.
Use the `--persistent-storage off` flag if deploying the mesh with `nginx-meshctl` or set the `mtls.persistentStorage` value to `"off"` if using Helm.
{{< /call-out >}}

## Determining Persistent Storage on your Cluster

NGINX Service Mesh will automatically use the default Kubernetes `StorageClass` if it's configured.

```bash
kubectl get storageclass
NAME                 PROVISIONER            AGE
standard (default)   kubernetes.io/gce-pd   153d
```

In the above output from GKE, NGINX Service Mesh will use the `standard` `StorageClass` to persist data. It's possible to have multiple Storage Classes configured, in that case NGINX Service Mesh will use the one configured as default. Specifying a specific `StorageClass` to use isn't supported at this time.

## Deploying Without Persistent Storage

If there is no default `StorageClass` set up, NGINX Service Mesh will still work, but will print the below warning during installation:

```text
Warning: Deploying without persistent storage, not suitable for production environments.
         For production environments ensure a default StorageClass is set.
```

Without persistent storage, if SPIRE Server restarts for any reason, the entire identity database will need to be rebuilt, which will significantly increase time to recovery.

## Setting up Persistent Storage

Kubernetes has an extensive ecosystem of plugins for persistent storage. These range from vSphere Volumes to Amazon Web Services (AWS) Elastic Block Store. For more details refer to the [Kubernetes Storage Classes documentation](https://kubernetes.io/docs/concepts/storage/storage-classes/).

{{< call-out "important" >}}
Based on our testing, NFS Storage Classes introduce too much latency and aren't recommended for use with NGINX Service Mesh.
{{< /call-out >}}


## Troubleshooting

By default NGINX Service Mesh detects if a default StorageClass is configured and uses it if present. If the StorageClass is misconfigured NGINX Service Mesh will fail to start. If you suspect persistent storage is misconfigured, try to deploy NGINX Service Mesh with `--persistent-storage off`.
