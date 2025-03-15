---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller Application Delivery Module.
docs: DOCS-364
title: Release Notes 3.21.0
toc: true
weight: 98
type:
- reference
---

{{< include "controller/adc-rn-preamble.md" >}}

&nbsp;

---

October 27, 2021

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller App Delivery Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

  {{< caution >}} If you're upgrading from NGINX Controller 3.18 or earlier to the NGINX Controller App Delivery Module 3.20 or later, the Controller Agent will go offline during the upgrade process.{{< /caution >}}

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}} Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

## What's New

- **Custom Branding**

  Now, you can replace the NGINX Controller logo with your own custom logo in the top-left corner of the web interface.

- **BIG-IP Self Service**

  The BIG-IP Self Service feature enables NGINX Controller to configure BIG-IP devices to serve as a load balancer for groups of NGINX Instances (Instance Groups).

## Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future release notes.

- **When upgrading an NGINX Controller cluster, the system reports timeout errors waiting for services to scale up (27871)**

  When upgrading the third node of an NGINX Controller cluster, some services may take two or more minutes to scale up. During this period, the system displays an error similar to the following:

  ``` text
  While waiting for nats-streaming-cluster to scale up, the operation did not complete before timing out.
  ```

  You can safely ignore these warnings. The services will continue to scale up in the background and should not interfere with the upgrade.

- **NGINX Controller app-centric metrics may show inaccurate metrics data when HTTPS and TCP+TLS are configured on the same data path (28489)**

  Depending on whether connections close cleanly when both HTTP/HTTPS and TCP/TCP+TLS are configured on the same NGINX instance running the NGINX Controller Agent, inaccurate metrics values may be reported for either HTTP/HTTPS or TCP/TCP+TLS analytics data. The issue won't occur when only HTTP and HTTPS are configured on the same datapath.

- **The `workloadGroup` section for the Components API is missing in the NGINX Controller REST API guide (26550)**

  In the NGINX Controller REST API guide, the `workloadGroup` section for the Components API is missing in both the Application Delivery and API Management specs.

  **Workaround:**

  Refer to the following OpenAPI Specification for the `workloadGroup`. There are two types of `workloadGroup`: {Web and TcpUdp}. Each type references a `WorkloadGroupCommon`, and then follows with its specific objects.

  ```text
  WebWorkloadGroup:
      description: Group of servers hosting a part of a Web application represented by a Component.
      allOf:
        - $ref: '#/components/schemas/WorkloadGroupCommon' # Settings common to Web and TCP/UDP workloadGroups.
        - type: object
          properties:
            proxy:
              $ref: '#/components/schemas/WebProxy' # Proxy retry and timeout settings applicable to servers in a Web workloadGroup.
            sessionPersistence:
              $ref: '#/components/schemas/SessionPersistence' # SessionPersistence settings in a Web workloadGroup.
            uris:
              type: object
              description: |
                The URI for a server hosting a part of a Web application.
                It must conform to the format `schema://address[:port]`
                where schema is chosen from http or https, address is IP or hostname,
                schema and address must be provided.
                For example:
                - `http://192.0.2.247`
                - `https://192.0.2.247:8443`
                - `https://www.f5workload.com`
              additionalProperties:
                $ref: '#/components/schemas/WorkloadUri'
  TcpUdpWorkloadGroup:
      description: Group of servers hosting a part of a TCP/UDP application represented by a Component.
      allOf:
        - $ref: '#/components/schemas/WorkloadGroupCommon' # Settings common to Web and TCP/UDP workloadGroups.
        - type: object
          properties:
            proxy:
              $ref: '#/components/schemas/TcpUdpProxy' # Proxy retry and timeout settings applicable to servers in a TcpUdp workloadGroup.
            uris:
              type: object
              description: |
                The URI for a server hosting a part of a TCP/UDP application.
                The URI must conform to the format `schema://address:port`
                where schema is chosen from tcp, udp, or tcp+tls, address is IP or hostname.
                All three of schema, address, and port must be provided.
                For example:
                - `tcp://192.0.2.247:8443`
                - `tcp+tls://192.0.2.247:8449`
                - `udp://www.f5workload.com:989`
              additionalProperties:
                $ref: '#/components/schemas/WorkloadUri'
  WorkloadGroupCommon:
      description: Settings common to Web and TCP/UDP workloadGroups.
      type: object
      properties:
        locationRefs:
          type: array
          items:
            $ref: 'https://gitlab.com/f5/nginx/controller/product/api-common/raw/master/schema/resource-common.yaml#/components/schemas/ResourceRef'
        loadBalancingMethod:
          $ref: '#/components/schemas/LoadBalancingMethod'
        dnsServiceDiscovery:
          $ref: '#/components/schemas/DNSServiceDiscovery'
    WorkloadUri:
      type: object
      properties:
        weight:
          type: integer
          minimum: 1
          default: 1
        maxConns:
          type: integer
          minimum: 0
          default: 0
        maxFails:
          type: integer
          minimum: 0
          default: 1
        failTimeout:
          x-f5-experimental: true
          type: string
          default: 10s
          pattern: '^[0-9]+[h|m|s]{1}$'
        isBackup:
          type: boolean
          default: false
        isDown:
          type: boolean
          default: false
        route:
          x-f5-experimental: true
          type: string
        srvService:
          type: string
        slowStart:
          x-f5-experimental: true
          type: integer
          minimum: 0
          default: 0
        isDrain:
          type: boolean
          default: false
  ```

- **Cannot define TCP and UDP Components URIs with the same port for Big-IP device integrations (28068)**

  When using the BIG-IP device integration, you cannot configure both TCP and UDP component URIs that share the same port number. Doing so will result in the creation of a single virtual server on the BIG-IP device.

  **Workaround:**

  None. You must use unique ports for both TCP and UDP.

- **`jq: command not found` error when installing NGINX Controller 3.20 on Red Hat (28470)**

  When NGINX Controller is installed on Red Hat, an error similar to the following may be displayed: `/opt/nginx-controller/helper.sh: line 726: jq: command not found.`

  This error can safely be ignored and does not indicate an issue with the installation.

- **Error about service redeploy failure during NGINX ADC Controller upgrade can be safely ignored (29752)**

  Under some circumstances, administrators performing an update to version 3.21.0 of the NGINX ADC Controller may see the following error reported:

  ``` text
  Failed to re-deploy services objects to the Data Plne Manager automatically. You may need to redeploy your services objects manually.
  ```

  This error can be safely ignored and will not interfere with the success of the update. You should still see the message:

  ``` text
  Successfully updated NGINX Controller to 3.21.0 at the end of your update.
  ```

- **Product documentation does not mention Controller App Security support on versions 3.20.1 and 3.21 (29800)**

  Product documentation does not mention NGINX Controller 3.20.1 and 3.21 in the [NGINX App Protect Compatibility Matrix](https://docs.nginx.com/nginx-controller/admin-guides/install/nginx-controller-tech-specs/#nginx-app-protect-compatibility-matrix) table in the [Technical Specifications](https://docs.nginx.com/nginx-controller/admin-guides/install/nginx-controller-tech-specs/) page.

  **Workaround:**

  Consult the [online documentation](https://docs.nginx.com/nginx-controller/admin-guides/install/nginx-controller-tech-specs/#nginx-app-protect-compatibility-matrix) for compatibility information for NGINX Controller 3.20.1 and 3.21 and NGINX App Protect.



## Supported NGINX Plus Versions

Check the [NGINX Controller Tech Specs guide]({{< relref "/controller/admin-guides/install/nginx-controller-tech-specs.md#nginx-plus-instances" >}}) to learn about the NGINX Plus versions supported by this release.
