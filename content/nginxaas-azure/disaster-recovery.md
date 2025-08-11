---
title: Disaster recovery
weight: 750
toc: true
url: /nginxaas/azure/disaster-recovery/
type:
- how-to
---


This guide describes how to configure disaster recovery (DR) for F5 NGINX as a Service for Azure deployments in separate (ideally [paired](https://learn.microsoft.com/en-us/azure/reliability/regions-paired)) Azure regions, ensuring upstream access remains available even if the primary NGINXaaS deployment in a region fails. The deployment architecture ensures users can access backend application servers (upstreams) continuously from an alternative region if the primary NGINXaaS deployment becomes unavailable. The solution leverages Terraform, Azure Traffic Manager, Azure Virtual Network (VNet) peering, and unique subnets to support failover.

---

**Architecture Overview**

{{< img src="nginxaas-azure/n4a-dr-topology.png" alt="The diagram illustrates the configuration of F5 NGINXaaS for Azure deployments for disaster recovery. It shows how the end users can still access the applications provided by AppServer - Primary1 and AppServer - Primary2 if the primary NGINXaaS deployment goes down." >}}


- Each region has its own VNet, subnet, and NGINXaaS for Azure deployment.
- The NGINXaaS for Azure deployment needs to have a public frontend to leverage Azure Traffic Manager.
- Cross region connectivity ensures that upstreams are reachable from either deployment. We use VNet peering in this guide to establish that connectivity.
- Upstreams (for example, VMs) are accessible from either NGINX deployment.

---

## Prerequisites

- Two Azure regions selected for DR.
- Unique, non-overlapping VNet and subnet address spaces for each region.
- Terraform 1.3+ and AzureRM provider 4.23+.

{{< call-out "note" >}} Each NGINX deployment **must run on separate subnets and non-overlapping address spaces**. This is critical for [Virtual Network (VNet) peering](https://learn.microsoft.com/en-us/azure/virtual-network/how-to-configure-subnet-peering) between the two regions. For example:

  - Primary Region Virtual Network Address Space: `10.0.0.0/16`
  - Secondary Region Virtual Network Address Space: `172.16.0.0/16`
{{< /call-out >}}

---

## Configure disaster recovery

### Step 1: Terrraform setup

To get started, please review the [Terraform prerequisites]({{< ref "/nginxaas-azure/getting-started/create-deployment/deploy-terraform.md#prerequisites" >}}) for NGINX as a Service for Azure.
The following steps outline Terraform resources required to set up the disaster recovery topology; these resources can be placed in a `main.tf` file, variables used by these resources can go into `variables.tf`, and outputs you need to collect can be defined in `outputs.tf`. The directory structure looks as follows:

```bash
$ tree
.
|-- main.tf
|-- outputs.tf
`-- variables.tf
```

To execute the Terraform code, `cd` into the directory with these files and run:

```bash
terraform init
terraform plan
terraform apply --auto-approve
```

### Step 2: Deploy prerequisite infrastructure

Each region requires its own VNet, subnet(s), public IP and network security group.

<details closed>
<summary style="font-weight:bold">This sample Terraform code creates the prerequisite resources.</summary>

```hcl
# Primary Region
resource "azurerm_resource_group" "primary_resource_group" {
  # ...
  location = "eastus"
}

resource "azurerm_public_ip" "primary_pip" {
  # ...
  location = "eastus"
}

resource "azurerm_virtual_network" "primary_virtual_network" {
  # ...
  address_space = [var.primary_vnet_addr_space] # - 10.0.0.0/16
  location      = "eastus"
}

resource "azurerm_subnet" "primary_subnet_1" {
  # ...
  virtual_network_name = azurerm_virtual_network.primary_virtual_network.name
  address_prefixes     = [cidrsubnet(var.vnet_addr_space, 8, 0)] # - 10.0.0.0/24
  delegation {
    name = "nginx"
    service_delegation {
      name = "NGINX.NGINXPLUS/nginxDeployments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_network_security_group" "primary_virtual_network_nsg" {
  # ...
  location = "eastus"
  security_rule {
    # ...
    priority  = 100
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"
  }
}

resource "azurerm_subnet_network_security_group_association" "primary_virtual_network_nsg_association" {
  subnet_id                 = azurerm_subnet.primary_subnet_1.id
  network_security_group_id = azurerm_network_security_group.primary_virtual_network_nsg.id
}


# Secondary Region
resource "azurerm_resource_group" "secondary_resource_group" {
  # ...
  location = "centralus"
}

resource "azurerm_public_ip" "secondary_pip" {
  # ...
  location = "centralus"
}

resource "azurerm_virtual_network" "secondary_virtual_network" {
  # ...
  address_space = [var.secondary_vnet_addr_space] # - 172.16.0.0/16
  location      = "centralus"
}

resource "azurerm_subnet" "secondary_subnet_1" {
  # ...
  virtual_network_name = azurerm_virtual_network.secondary_virtual_network.name
  address_prefixes     = [cidrsubnet(var.vnet_addr_space, 8, 0)] # - 172.16.0.0/24
  delegation {
    name = "nginx"
    service_delegation {
      name = "NGINX.NGINXPLUS/nginxDeployments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_network_security_group" "secondary_virtual_network_nsg" {
  # ...
  location = "centralus"
  security_rule {
    # ...
    priority  = 100
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"
  }
}

resource "azurerm_subnet_network_security_group_association" "secondary_virtual_network_nsg_association" {
  subnet_id                 = azurerm_subnet.secondary_subnet_1.id
  network_security_group_id = azurerm_network_security_group.secondary_virtual_network_nsg.id
}
```
</details>

---

### Step 3: Configure app servers (upstreams)

You may already have upstreams in the primary region that you wish to reverse proxy using NGINXaaS. For the sake of completion, the following example shows creation of Primary Subnet 2, NICs for the upstreams and the upstreams themselves. The upstream VMs need to be in a subnet separate from the NGINXaaS deployment subnet in the **primary region**.

<details closed>
<summary style="font-weight:bold">This sample Terraform code creates and configures the upstreams.</summary>

```hcl
resource "azurerm_subnet" "primary_subnet_2" {
  # ...
  virtual_network_name = azurerm_virtual_network.primary_virtual_network.name
  address_prefixes     = [cidrsubnet(var.vnet_addr_space, 8, 1)] # - 10.0.1.0/24
}

resource "azurerm_network_interface" "app_server_nic" {
  # ...
  count               = 2
  name                = "nginx-vm${count.index + 1}-nic"
  location            = "eastus"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.upstreams.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "nginx_upstream_vm" {
  # ...
  count               = 2
  name                = "nginx-upstream${count.index + 1}"

  network_interface_ids = [
    azurerm_network_interface.app_server_nic[count.index].id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install nginx -y
    VM_ID=$(hostname)
    IP=$(ip addr show $(ip route show default | awk '/default/ {print $5}') | awk '/inet / {print $2}' | cut -d/ -f1)
    echo "Hello from $VM_ID: $IP" | sudo tee /var/www/html/index.html
    sudo systemctl enable nginx
    sudo systemctl restart nginx
  EOF
  )
}
```
</details>
<br>

> **Note**: As a best practice, maintain identical upstream resources in your secondary region as in your primary region to ensure full protection and availability in the event of a region-wide outage or disaster.

---

### Step 4: Peer the VNets

Peer the virtual networks so that the upstream app servers are accessible from either primary or secondary NGINXaaS deployment.

<details closed>
<summary style="font-weight:bold">This sample Terraform code configures peering for the virtual networks.</summary>

```hcl
resource "azurerm_virtual_network_peering" "primary_vnet_to_secondary_vnet" {
  name                      = "peering-primary-vnet-to-secondary-vnet"
  resource_group_name       = var.primary_resource_group
  virtual_network_name      = azurerm_virtual_network.primary_virtual_network.name
  remote_virtual_network_id = azurerm_virtual_network.secondary_virtual_network.id
}

resource "azurerm_virtual_network_peering" "secondary_vnet_to_primary_vnet" {
  name                      = "peering-secondary-vnet-to-primary-vnet"
  resource_group_name       = var.resource_group_secondary
  virtual_network_name      = azurerm_virtual_network.secondary_virtual_network.name
  remote_virtual_network_id = azurerm_virtual_network.primary_virtual_network.id
}
```
</details>
<br>

- **Subnet Peering for Overlapping VNets:**
If overlapping address spaces are unavoidable, use subnet-level peering to selectively peer only the required subnets.

   {{< call-out "note" >}}As of May 2025, subnet peering is not available by default for all subscriptions. To use this feature, you must have the subscription on which you want to configure subnet peering be registered with Azure. Please review the configuration details and limitations in this [document](https://learn.microsoft.com/en-us/azure/virtual-network/how-to-configure-subnet-peering).{{< /call-out >}}

---

### Step 5: Deploy NGINXaaS for Azure in each region

Reverse proxy your upstreams using NGINXaaS. Since the virtual networks are peered, both deployments would be able to access the upstreams.

<details closed>
<summary style="font-weight:bold">This sample Terraform code deploys and configures both primary and secondary NGINXaaS deployments.</summary>

```hcl
resource "azurerm_nginx_deployment" "primary_nginxaas_deployment" {
  name                = var.primary_deployment_name
  resource_group_name = var.primary_resource_group
  location            = "eastus"
  # ...
  network_interface {
    subnet_id = azurerm_subnet.primary_subnet_1.id
  }
}

resource "azurerm_nginx_configuration" "primary_nginxaas_config" {
  nginx_deployment_id = azurerm_nginx_deployment.primary_nginxaas_deployment.id
  root_file           = "/etc/nginx/nginx.conf"

  config_file {
    content = base64encode(<<-EOT
user nginx;
worker_processes auto;
worker_rlimit_nofile 8192;
pid /run/nginx/nginx.pid;

events {
    worker_connections 4000;
}

error_log /var/log/nginx/error.log error;

http {
    upstream backend_servers {
        server <Upstream-1-private-ip>:80;
        server <Upstream-2-private-ip>:80;
        keepalive 16;
    }
    server {
        listen 80 default_server;
        # /health will be used for Azure Traffic Manager Profile
        location /health {
            return 200 'nginx proxy alive';
        }
        location / {
            proxy_pass http://backend_servers;

            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_next_upstream error timeout http_500;
            proxy_http_version 1.1;
            proxy_set_header   "Connection" "";
        }
    }
}
EOT
    )
    virtual_path = "/etc/nginx/nginx.conf"
  }
}


# The secondary NGINXaaS deployment is identical to primary
resource "azurerm_nginx_deployment" "secondary_nginxaas_deployment" {
  name                = var.secondary_deployment_name
  resource_group_name = var.secondary_resource_group
  location            = "centralus"
  # ...
  network_interface {
    subnet_id = azurerm_subnet.secondary_subnet_1.id
  }
}

resource "azurerm_nginx_configuration" "secondary_nginxaas_config" {
  nginx_deployment_id = azurerm_nginx_deployment.secondary_nginxaas_deployment.id
  root_file           = "/etc/nginx/nginx.conf"

  config_file {
    content = base64encode(<<-EOT
user nginx;
worker_processes auto;
worker_rlimit_nofile 8192;
pid /run/nginx/nginx.pid;

events {
    worker_connections 4000;
}

error_log /var/log/nginx/error.log error;

http {
    upstream backend_servers {
        server <Upstream-1-private-ip>:80;
        server <Upstream-2-private-ip>:80;
        keepalive 16;
    }
    server {
        listen 80 default_server;
        # /health will be used for Azure Traffic Manager Profile
        location /health {
            return 200 'nginx proxy alive';
        }
        location / {
            proxy_pass http://backend_servers;

            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_next_upstream error timeout http_500;
            proxy_http_version 1.1;
            proxy_set_header   "Connection" "";
        }
    }
}
EOT
    )
    virtual_path = "/etc/nginx/nginx.conf"
  }
}
```
</details>

---

### Step 6: DNS and failover

- Use Azure Traffic Manager to direct traffic to the primary NGINXaaS deployment.
- When the primary deployment is detected as being unhealthy, Azure Traffic Manager updates the public DNS record of your service to point to the public IP of the NGINXaaS deployment in the secondary region.

<details closed>
<summary style="font-weight:bold">This sample Terraform code configures Azure Traffic Manager to point to both NGINXaaS deployments.</summary>

```hcl
resource "azurerm_traffic_manager_profile" "nginxaas_failover_monitor" {
  ...
  traffic_routing_method = "Priority" # Chooses one deployment or the other

  dns_config {
    # relative_name needs to be globally unique
    # <relative_name>.trafficmanager.net resolves to the public IP of either NGINXaaS deployment
    relative_name = "nginxaas-global-record"
    ttl           = 60
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/health" #endpoint implemented in NGINXaaS configuration
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
}

resource "azurerm_traffic_manager_external_endpoint" "primary" {
  name                = "nginx-primary"
  profile_id          = azurerm_traffic_manager_profile.nginxaas_failover_monitor.id
  priority            = 10 # Lower number results in higher priority
  target              = azurerm_nginx_deployment.primary_nginxaas_deployment.ip_address
}

resource "azurerm_traffic_manager_external_endpoint" "secondary" {
  name                = "nginx-secondary"
  profile_id          = azurerm_traffic_manager_profile.nginxaas_failover_monitor.id
  priority            = 20
  target              = azurerm_nginx_deployment.secondary_nginxaas_deployment.ip_address
}
```
</details>

---

## Failover process

1. **Monitor**: `/health` endpoint continuously monitors NGINXaaS deployment reachability in both regions.
1. **Failover**: If the primary region deployment is deemed unhealthy, Azure Traffic Manager updates the DNS record for the service to route traffic to the secondary region's NGINXaaS deployment.
1. **Recovery**: Once the primary region deployment recovers, Azure Traffic Manager automatically restores DNS records to the primary endpoint when its health probes detect recovery and confirm the primary endpoint is healthy again.

---

## Summary

By deploying NGINXaaS in separate regions with unique subnets and peered VNets, and configuring upstreams and DNS for failover, this topology ensures high availability and DR for your applications. Lastly, always monitor and test your failover paths.
