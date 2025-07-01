---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller Application Delivery Module.
nd-docs: DOCS-833
title: Release Notes 3.22.0
toc: true
weight: 97
type:
- reference
---

{{< include "controller/adc-rn-preamble.md" >}}

&nbsp;

---

December 15, 2021

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller App Delivery Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

  {{< caution >}} If you're upgrading from NGINX Controller 3.18 or earlier to the NGINX Controller App Delivery Module 3.20 or later, the Controller Agent will go offline during the upgrade process.{{< /caution >}}

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}} Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

## What's New

- **Snippets**

  Full support for insertion of configuration snippets via the user interface and API is available in Controller ADC release 3.22. You can use snippets to apply custom NGINX configurations that are not natively supported by the NGINX Controller API in the NGINX configuration file at the `main`, `http`, `stream`, `server`, `location`, or `upstream` blocks.

  **Caution**: When you use snippets to customize your NGINX configuration, your changes are applied to the nginx.conf file *as is*. NGINX Controller does not verify that your configuration is valid before applying the snippet. We strongly recommend verifying snippets in a lab environment before making any changes in production.

- **Workload Health Check Events**

  NGINX Controller ADC Release 3.22 includes support for two new workload health events; these events are generated per component per instance:
  - A triggered event to signify a change in the health state of workload group members – to Healthy or Unhealthy. This event is triggered on changes in state of workload group members.
  - A periodic event that gives a snapshot of the present state of workload group members and is sent once every few minutes.

- **Workload Health Check Header Programmability**

  NGINX Controller ADC Release 3.22 includes support for configuring the headers in http health check probes. These health check probes are sent by NGINX Plus to workload group members.

- **Caching**

  NGINX Controller ADC Release 3.22 includes support for caching http content. A cache (or split caches) can be defined at the component level and maps to the `proxy_cache_path` and `proxy_cache` directives. Use of logic involving the set of caching directives other than `proxy_cache_path` and `proxy_cache` is done by including the applicable logic and directives in snippet(s). Generated caching metrics include dimensions relevant to the NGINX Controller ADC information architecture (env, app, component, etc.). Caching dashboards have been added to the NGINX Controller user interface.

  See [Content Caching](https://docs.nginx.com/nginx/admin-guide/content-cache/content-caching/) for more information.

- **Instance Group Support**

  NGINX Controller ADC Release 3.22 includes support for instance groups. Instance group support allows grouping of NGINX+ data plane instances into a logical group which receive identical configuration. This simplifies the task of configuration updates, where the admin thinks in terms of the group, instead of having to worry about individual members.

- **NGINX+ Worker Process Tuning**

  NGINX Controller ADC Release 3.22 includes support for tuning NGINX Plus worker processes. The associated directives are: `worker_connections`, `worker_priority`, `worker_processes`, `worker_rlimit_nofile`, and `multi_accept`. Note that this tuning is only supported via the API, and not via the user interface.

- **Proxying Requests with NTLM Authentication to App Workloads**

  Controller ADC Release 3.22 includes support for enabling proxying of requests with NTLM authentication to upstreams.

- **User Interface support for configuring Rate Limiting and JWT authentication**

  NGINX Controller ADC Release 3.22 includes user interface support for configuring rate limiting and JWT authentication for ADC web components.

- **Ability to specify Server Port as the Destination Port for traffic to a Backend server**

  NGINX Controller ADC Release 3.22 includes support for referencing the NGINX variable `server_port` as the destination port for traffic to a backend server. This can be used, for example, to enable passive FTP scenarios.

- **OIDC Authentication with Microsoft Entra as the IDP**

  NGINX Controller ADC Release 3.22 includes [support for OpenID Connect (OIDC) authentication]({{< ref "/controller/platform/access-management/manage-active-directory-auth-provider.md" >}}) when the Identity Provider is Microsoft Entra.

- **Support for SELinux**

  This release includes support for using NGINX Controller with SELinux. Refer to this [kb article](https://support.f5.com/csp/article/K12955470) for more information about adapting your SELinux policies for use with NGINX Controller.

- **Added Technology Preview of RHEL 8 Support for Controller Hosts**

  Support for RHEL 8 is a technology preview. Installing NGINX Controller and agent on RHEL 8 seems to work well in low-scale deployments for testing and proof of concept purposes. Installing NGINX Controller on RHEL 8 for large-scale deployments has not been tested. Possibility of performance or stability issues exist. Therefore, we strongly recommend testing Controller on RHEL 8 for scale in a test environment before deploying to production. See the [Install NGINX Controller on RHEL 8]({{< ref "/controller/admin-guides/install/install-nginx-controller-rhel-8.md" >}}) document to prepare your RHEL 8 system to install NGINX Controller and the NGINX Controller Agent.

- **Adds support for NGINX App Protect v3.7**

  NGINX Controller Application Delivery module 3.22 fully supports NGINX App Protect 3.7.

- **Application Security - All blocked app requests generate a Security Event in NGINX Controller**

  Previously, blocked app requests with a Violation Rating score of `1 (Possible False Positive)` or `2 (Most Likely False Positive)` would not generate a Security Event in NGINX Controller. As of NGINX Controller ADC 3.22, all blocked app requests, regardless of the Violation Rating score, generate a Security Event in NGINX Controller.

## Resolved Issues

This release includes the following fixes. To locate the details for an issue when it was first reported, search the NGINX Docs for the issue ID.

- **Non-admin users receive "unathorized" API error when updating components in the web interface (30627)**

  Non-admin users might receive the following error when attempting to create or update components using the NGINX Controller web interface:

  "Error Fetching Component API Error (403): unauthorized."

  This issue occurs because the user doesn't have the permissions needed to access the API endpoints `/security/strategies/` and/or `/security/identity-providers/`.

## Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future release notes.

### When upgrading an NGINX Controller cluster, the system reports timeout errors waiting for services to scale up (27871)

  When upgrading the third node of an NGINX Controller cluster, some services may take two or more minutes to scale up. During this period, the system displays an error similar to the following:

  ``` text
  While waiting for nats-streaming-cluster to scale up, the operation did not complete before timing out.
  ```

  You can safely ignore these warnings. The services will continue to scale up in the background and should not interfere with the upgrade.

### NGINX Controller app-centric metrics may show inaccurate metrics data when HTTPS and TCP+TLS are configured on the same data path (28489)

  Depending on whether connections close cleanly when both HTTP/HTTPS and TCP/TCP+TLS are configured on the same NGINX instance running the NGINX Controller Agent, inaccurate metrics values may be reported for either HTTP/HTTPS or TCP/TCP+TLS analytics data. The issue won't occur when only HTTP and HTTPS are configured on the same datapath.

### The `workloadGroup` section for the Components API is missing in the NGINX Controller REST API guide (26550)

  In the NGINX Controller REST API guide, the `workloadGroup` section for the Components API is missing in both the Application Delivery and API Management specs.

#### Workaround

  Refer to the following OpenAPI Specification for the `workloadGroup`. There are two types of `workloadGroup`: {Web and TcpUdp}. Each type references a `WorkloadGroupCommon`, and then follows with its specific objects.

  ```yaml
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
            useServerPort:
              $ref: '#/components/schemas/ServiceConfigState'
            uris:
              type: object
              description: |
              The URI of a server that hosts a TCP/UDP application.
                The URI must conform to the format `schema://address:port`.
                - The schema must be one of the following: `tcp`, `udp`, or `tcp+tls`.
                - The address value can be an IP address or a host name.
                - All three elements -- schema, address, and port -- are required.
                Note: When `useServerPort` is `ENABLED`, then you should define a single URI that uses the `schema://address` format.
                Defining a `port` value for the URI when also using `useServerPort` will result in an error.
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

### Failure to enable WAF on a component with the error: "Error: config.apply - operation timed out" (28983)

  If the intended configuration includes a large number of components (> 175) being deployed to datapaths with WAF installed and enabled in those components, the error noted may occassionaly occur.

#### Workaround

- Retrying deployment of the individual component may resolve the issue.
- Installing or upgrading to NGINX App Protect 3.7 or later resolves the issue.

### Agent upgrade is needed for TCP/UDP app centric metrics to work (30338)

  After upgrading NGINX Controller from 3.20.x/3.21.x to 3.22 the collection of new TCP/UDP app centric metrics stops working. This can be fixed by upgrading the agent.

### False Positive reported after upgrading NGINX Controller 3.18 to 3.20 or 3.21 (30672)

  The default security policy (balanced_default) in NGINX Controller 3.20 and 3.21 differs from the one in NGINX Controller 3.18. As a result, when you upgrade from NGINX Controller 3.18 to 3.20 or 3.21, you might see a False Positive.

#### Workaround

  Upgrade to NGINX Controller 3.22, which has the same default security policy as NGINX Controller 3.18.

### In a multi-node NGINX Controller configuration, stopping kubelet process on one of the nodes may disrupt failover process (30982)

  There are multiple nodes in a NGINX Controller configuration. When `kubelet` process is stopped in a node, the node is marked as not ready. As a result, other nodes in the cluster re-assign containers from faulty node to other healthy nodes. However, stopping a `kubelet` process does not remove running containers. Those containers which are still running, continue using shared resources, preventing containers scheduled on other nodes from starting.

#### Identifying the Issue

  Identifying commands are executed on each of the controller nodes in the high availability (HA) configuration.

- `ClickHouse` pod crashes with "Cannot lock file" error.

    ```yaml
    kubectl get po -o wide | grep clickhouse
    clickhouse-0                 0/1     CrashLoopBackOff   5          3m53s

    kubectl logs clickhouse-0
    2021.12.14 14:53:13.631963 [ 1 ] {} <Error> Application: DB::Exception: Cannot lock file /var/lib/clickhouse/status. Another server instance in same directory is already running.
    ```

- On a node where `kubelet` process is stopped, `Clickhouse` container is still running.

    ```yaml
    sudo docker ps | grep clickhouse
    71f665be4c35        1f973676953e           "./setup.sh"             2 hours ago         Up 2 hours                              k8s_clickhouse_clickhouse-0_nginx-controller_5521450f-b286-4be8-951b-408164184883_19
    c888050cc198        k8s.gcr.io/pause:3.1   "/pause"                 2 hours ago         Up 2 hours                              k8s_POD_clickhouse-0_nginx-controller_5521450f-b286-4be8-951b-408164184883_0
    ```

#### Workaround

- Option 1. Start kubelet process

    If `kubelet` process was stopped intentionally or the reasons known to stop it are resolved, start the `kubelet` process again. It will clean up containers that were re-assigned to other nodes.

    Run the following commands on the node with stopped `kubelet` process:

    `sudo systemctl start kubelet`

- Option 2. Stop leftover NGINX Controller containers on a node with stopped `kubelet`

    If there are no running Docker containers on a node other than containers managed by NGINX Controller, restart the Docker process. Docker containers managed by kubelet won't restart if `kubelet` is stopped.

    `sudo systemctl restart docker`

    If you prefer to refrain from stopping docker process, run following commands to stop only containers causing the issue.

    ```yaml
    `sudo docker stop $(sudo docker container ls | grep "k8s_clickhouse" | awk '{print $1}')`
    `sudo docker stop $(sudo docker container ls | grep "k8s_stan-proxy" | awk '{print $1}')`
    `sudo docker stop $(sudo docker container ls | grep "k8s_nats_nats" | awk '{print $1}')`
    ```

### UDP statistics may not be reported following installation in rare circumstances (31117)

  After installing NGINX ADC Controller 3.22, it is possible that you may not see UDP statistics correctly registered. You need to manually restart the NGINX Controller Agent component on your datapaths. It takes approximately 10 minutes after the connection is made for the UDP statistics to be reported.

#### Workaround

  If you do not see any UDP app-centric metrics reported even after 10 minutes, please run the following command on your datapaths:

  `sudo systemctl restart controller-agent`

### Expired Kubernetes kubelet certificate prevents NGINX Controller from starting (25412)

  The Kubernetes kubelet certificate that NGINX Controller applies during installation is valid for one year. If NGINX Controller is not updated for longer than one year, and the kublet certificate expires, Kubernetes will stop or fail to start. When this happens, NGINX Controller fails to start.

  To check the kubernetes certificates, run the following command:

  ```bash
  kubeadm alpha certs check-expiration
  ```

#### Identifying the issue

- `kubectl` fails with an error similar to the following:

    ```text
    The connection to the server <host>:6443 was refused - did you specify the right host or port?
    ```

- In the container logs, such as `kubeapi-server`, there are error messages similar to the following example:

    ```text
    441585 1 clientconn.go:1251] grpc: addrConn.createTransport failed to connect to {127.0.0.1:2379 0 <nil>}. Err :connection error: desc = "transport: authentication handshake failed: x509: certificate has expired or is not yet valid". Reconnecting...
    ```

#### Workaround

  Note: Upgrading NGINX Controller after the kubelet certificate expires will not fix the issue.

  If you find yourself in this situation, you'll need to take the following steps:

  1. `sudo systemctl stop kubelet`
  2. `sudo kubeadm alpha certs renew all`
  3. `cd` to the home directory of the user who installed NGINX Controller.
  4. `mv .kube/config .kube/config.old`
  5. `sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config`
  6. `sudo chown $(id -u):$(id -g) $HOME/.kube/config`
  7. `sudo chmod 777 $HOME/.kube/config`
  8. `export KUBECONFIG=.kube/config`
  9. `sudo shutdown now -r`

  When the instance comes back online, you should be at the current date and time via NTP, and the system should function normally.

  In rare cases, if the NGINX Controller host was down when the kubelet certificate expired, you'll need to take the following additional steps between steps 1 and 2 above:

  1. `sudo systemctl stop kubelet`

     a. `sudo journalctl -xeu kubelet` (The output of this command includes the kubelet certificate expiry date/time. Make a note of this value.)

     b. `sudo timedatectl set-ntp off`

     c. `sudo timedatectl set-time "2021-08-16 00:00:00"` (Adjust the date and time value to a time that's one day before the kubelet cert expiry that you noted in step 1a.)

     d. `sudo systemctl start kubelet`

     e. `cd /var/lib/kubelet/pki; ls -l` (Monitor this directory to ensure a new PEM file is written, and verify that the symbolic link in the same directory points to the new PEM. Make sure the time matches your time change from step 1c.)

  2. Continue with step 2 in the previous procedure.

### Adding or changing an Identity Provider resets configurations when placed on an Instance Group (31396)

  Adding or changing an Identity Provider resets configurations placed on Instance Groups in the same environment as the Identity Provider.

### The `reuseport` option is dropped from IPv6 listen directive in certain configurations (34285)

  NGINX Controller requires listen directives to include the `reuseport` option to prevent potential port bind issues when changing configurations that modify the listen directive. Even if users add `reuseport` in a snippet, NGINX Controller may remove it under certain conditions. This happens, for example, when the IPv6 port matches an IPv4 port, and the IPv4 listen directive does not specify a specific IP address.

#### Workaround

  To modify the IPv6 listen directive that doesn't have `reuseport` set, you should first delete the listen directive and apply the configuration. You can then re-add the directive and make the desired change.

## Supported NGINX Plus Versions

Check the [NGINX Controller Tech Specs guide]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#nginx-plus-instances" >}}) to learn about the NGINX Plus versions supported by this release.
