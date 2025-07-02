---
description: Learn how to deploy a vSphere NGINX instance using F5 NGINX Controller.
nd-docs: DOCS-771
title: Add a vSphere NGINX Instance
toc: true
weight: 35
type:
- tutorial
---

## Overview



You can use F5 NGINX Controller to deploy and manage NGINX instances on [VMware vSphere](https://www.vmware.com/products/vsphere.html).

This tutorial explains how to deploy NGINX Plus on vSphere by defining a vSphere Integration, a Location, and an Instance Template in NGINX Controller.

{{< important >}}

You are responsible for applying software and security updates on your NGINX instances. NGINX Controller does not manage these updates for you.

{{< /important >}}

&nbsp;


---

## Before You Begin



Before you can create a vSphere Integration in NGINX Controller, you need to have an account in the vSphere instance you are using with privileges to create and delete a VM. You'll need the following information when creating a vSphere Integration:

- vSphere hostname or IP
- vSphere account username
- vSphere account password
- NGINX Plus VM template

### Create an NGINX Plus VM template

Select a suitable base OS from the [NGINX Plus release docs](https://docs.nginx.com/nginx/releases/#) for the version of NGINX Plus that will be installed.

Install the following prerequisites:

- [cloud-init](https://cloud-init.io/)
- [cloud-init-vmware-guestinfo](https://github.com/vmware-archive/cloud-init-vmware-guestinfo)
- python3
- python3-pip
- [distlib>=0.3.1](https://pypi.org/project/distlib/)


Install NGINX Plus [as described.](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/)

A template created from a VM that has the prerequisites mentioned above can be used in the vSphere integration.


{{< important >}}

You are responsible for securing the connection between the vSphere cloud and any VMs that are created. NGINX Controller can't secure those connections.

{{< /important >}}

&nbsp;


---

## Create a vSphere Integration



Integrations allow NGINX Controller to deploy and manage NGINX instances on external systems (cloud providers like vSphere).

To create an Integration for vSphere using the [NGINX Controller API]({{< ref "/controller/api/_index.md" >}}), send a POST request similar to the following example to the Integrations API endpoint.

In the JSON request, provide the `hostname or IP`, `username`, and `password` for the vSphere instance as mentioned in [this section](#before-you-begin).

```json
{
    "metadata": {
        "name": "my-v-integration"
    },
    "desiredState": {
        "type": "VSPHERE_INTEGRATION",
        "hostname": "xx.xx.xx.xx",
        "credential": {
            "type": "USER_PASS",
            "username": "vsphereUser",
            "password": "*****"
        }
    }
}
```

&nbsp;


---

## Create a Location



Locations are a way to logically group your NGINX Plus instances by their physical locations. After you have [created an Integration for vSphere](#create-an-vsphere-integration), take the following steps to create a Location.

### Prerequisites

To create a Location, you'll need your vSphere datacenter name and a vSphere VM folder(optional):

### Create a Location by using the REST API

To create a Location using the [NGINX Controller API]({{< ref "/controller/api/_index.md" >}}), send a POST request similar to the following example to the Locations API endpoint.

In the JSON request, provide the `datacenter` name, and `folder` name.

```json
{
  "metadata": {
    "name": "my-v-location"
  },
  "desiredState": {
    "type": "VSPHERE_LOCATION",
    "datacenter": "dc1",
    "folder": "v_test",
    "integrationRef": {
      "ref": "/api/v1/platform/integrations/my-v-integration"
    }
  }
}
```

&nbsp;


---

## Create an Instance Template for vSphere NGINX Instances



An [Instance Template]({{< ref "/controller/infrastructure/instances/manage-instance-templates.md" >}}) defines the parameters to use when creating an NGINX instance. Instance Templates are ideal for cloud orchestration and make managing your cloud resources easy and quick.

For the Instance Template, you need to provide a VM template with NGINX Plus, [cloud-init](https://cloudinit.readthedocs.io/en/latest/) and [cloud-init-vmware-guestinfo](https://github.com/vmware/cloud-init-vmware-guestinfo) installed. Refer to [this](#create-a-nginxplus-vm-template) to create a NGINX Plus VM template. Use this [NGINX Controller Technical Specifications]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md" >}}) guide for the NGINX Plus requirements.

- To create an Instance Template using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a POST request similar to the following example to the Instance Templates API endpoint. You can find descriptions of the instance parameters in the API Reference documentation.


&nbsp;

```json
{
  "metadata": {
    "name": "my-v-template"
  },
  "desiredState": {
    "type": "VSPHERE_INSTANCE_TEMPLATE",
    "image": "v_orch_test/nginxplus-template",
    "computeResource": "cluster1",
    "datastore": ["vsanDatastore"],
    "network": ["VLAN-1234"],
    "numCPUs": 1,
    "memoryMB": 4096
  }
}
```

&nbsp;


---

## Add a vSphere NGINX Instance to NGINX Controller



Now that you've [defined a Location](#create-a-location) and [created an Instance Template](#create-an-instance-template-for-vsphere-nginx-instances) for an  NGINX instance on vSphere, you are ready to add the instance to  NGINX Controller.

To add a vSphere NGINX instance to NGINX Controller using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}), send a POST request as shown below to the Instances API endpoint. For the `templateRef` parameter, use the Instance Template that you created in the previous procedure.

```json
{
  "metadata": {
    "name": "v-inst"
  },
  "desiredState": {
    "type": "VSPHERE_INSTANCE",
    "templateRef": {
      "ref": "/infrastructure/locations/my-v-location/instance-templates/my-v-template"
    }
    }
}
```

&nbsp;


---

## What's Next

- [Manage Your NGINX Instances]({{< ref "/controller/infrastructure/instances/manage-instances.md#add-an-existing-instance" >}})
- [Add, Edit, and Update Locations]({{< ref "/controller/infrastructure/locations/manage-locations.md" >}})
- [View Performance Reports for Your Instances]({{< ref "/controller/infrastructure/instances/analyzer.md" >}})
- [Deploy an App]({{< ref "/controller/app-delivery/deploy-simple-app.md" >}})

{{< versions "3.12" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
