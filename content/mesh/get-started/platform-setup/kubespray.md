---
title: Kubespray
description: Learn how to set up Kubespray for use with F5 NGINX Service Mesh.
toc: true
nd-docs: DOCS-685
type:
- how-to
---

[Kubespray](https://github.com/kubernetes-sigs/kubespray) is where Kubernetes meets [Ansible](https://www.ansible.com/). It's a composition of Ansible playbooks, provisioning tools, and domain knowledge for creating production-ready Kubernetes clusters. Kubespray builds on top of kubeadm. If you are using Kubespray v2.16.0 or later no changes are needed to deploy F5 NGINX Service Mesh. For older versions you need to enable some extra flags on the Kubernetes API Server to enable Service Account Token Volume Projection. See [Service Account Token Volume Projection]( {{< ref "kubeadm.md#service-account-token-volume-projection" >}} ) section to learn why this is needed.

## Configuration changes

{{< call-out "important" >}}
This section only applies to Kubespray versions older than v2.16.0.
{{< /call-out >}}

When creating a new cluster, you need to pass some extra flags to kubespray using [group_vars](https://github.com/kubernetes-sigs/kubespray/blob/master/docs/ansible/vars.md). Add the following to `inventory/<your cluster>/group_vars/k8s-cluster/k8s-cluster.yml`:

```yaml
kube_kubeadm_apiserver_extra_args:
  service-account-issuer: api
  service-account-signing-key-file: /etc/kubernetes/ssl/sa.key
  service-account-api-audiences: api
```

After making the changes, deploy kubespray as you usually would.

{{< call-out "note" >}}
If you have an existing kubespray deployment, you need to create a new cluster. First make the changes in this section and then deploy a new cluster using the same command when you deployed the cluster before. The new cluster will reflect the new configuration. After deploying the new cluster, you can delete the old one.
{{< /call-out >}}

## Persistent storage

Kubespray doesn't set up any persistent storage for you, but it's required to run NGINX Service Mesh in a production environment. See [Persistent Storage]( {{< ref "persistent-storage.md" >}} ) for more information.
