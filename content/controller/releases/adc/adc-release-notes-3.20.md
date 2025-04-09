---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller Application Delivery Module.
docs: DOCS-363
title: Release Notes 3.20.0
toc: true
weight: 100
type:
- reference
---

{{< include "controller/adc-rn-preamble.md" >}}

&nbsp;

---

September 14, 2021

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller App Delivery Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

  {{< caution >}}If you're upgrading from NGINX Controller 3.18 or earlier to the NGINX Controller App Delivery Module 3.20 or later, the Controller Agent will go offline during the upgrade process.{{< /caution >}}

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}}Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

## What's New

- **Adds support for NGINX App Protect v3.3, v3.4, and v3.5**

  NGINX Controller Application Delivery module 3.20 fully supports [NGINX App Protect 3.3](https://docs.nginx.com/nginx-app-protect/releases/#release-33), [NGINX App Protect 3.4](https://docs.nginx.com/nginx-app-protect/releases/#release-34), and [NGINX App Protect 3.5](https://docs.nginx.com/nginx-app-protect/releases/#release-35).

- **Adds high-performance communication path between NGINX Controller and the Controller Agent**

  {{< caution >}}NGINX Controller ADC 3.20 adds a high-performance communication path between NGINX Controller and the Controller Agents running on NGINX Plus.

  When upgrading to NGINX Controller ADC 3.20+ from 3.18 or earlier, the data paths will go offline. **To restore communication, you must upgrade the Controller Agents to the latest available version. This will force a restart of NGINX resulting in the termination of all active connections.** Once the Controller Agents have been upgraded, the data paths will reconnect.{{< /caution >}}

  &nbsp;

- **Use the `/security/strategies/balanced_default` API endpoint for the default Security Strategy**

  In NGINX Controller 3.20 and later, when enabling WAF on an app component, we recommend you use the `/security/strategies/balanced_default` API endpoint instead of `/services/strategies/balanced_default`.

  The `/services/strategies/balanced_default` endpoint will be deprecated in a future release.

  For more information, see the AskF5 article [K02089505](https://support.f5.com/csp/article/K02089505).

- **Bring your own custom NGINX App Protect WAF Policy to configure app security**

  Now, you can [use your own custom NGINX App Protect WAF JSON declarative policy]({{< ref "/controller/app-delivery/security/concepts/bring-your-own-policy.md" >}}) as your WAF policy with NGINX Controller, in addition to using the default policy. F5 Advanced WAF and BIG-IP Application Security Module (ASM) customers can convert their standardized WAF policy to an App Protect policy to use with NGINX Controller.

## NAP Vulnerability Fixes

Vulnerability issues are disclosed only when a fix is available. For information about a vulnerability fix, including the recommended action to take, see the linked AskF5 article for details.

The following three security vulnerabilities were found in NGINX App Protect. To fix these security vulnerabilities, you should upgrade to NAP 3.5.

- [K44553214](https://support.f5.com/csp/article/K44553214): Web application firewall vulnerability CVE-2021-23050
- [K30150004](https://support.f5.com/csp/article/K30150004): The attack signature check may fail to detect and block malicious requests
- [K30291321](https://support.f5.com/csp/article/K30291321): The attack signature check may fail to detect and block illegal requests for a case-insensitive policy

## Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future release notes.

- **Expired Kubernetes kubelet certificate prevents NGINX Controller from starting (25412)**

  The Kubernetes kubelet certificate that NGINX Controller applies during installation is valid for one year. If NGINX Controller is not updated for longer than one year, and the kublet certificate expires, Kubernetes will stop or fail to start. When this happens, NGINX Controller fails to start.

  To check the kubernetes certificates, run the following command:

  ```bash
  kubeadm alpha certs check-expiration
  ```

  **Identifying the issue**

  - `kubectl` fails with an error similar to the following:

    ```text
    The connection to the server <host>:6443 was refused - did you specify the right host or port?
    ```

  - In the container logs, such as `kubeapi-server`, there are error messages similar to the following example:

    ```text
    441585 1 clientconn.go:1251] grpc: addrConn.createTransport failed to connect to {127.0.0.1:2379 0 <nil>}. Err :connection error: desc = "transport: authentication handshake failed: x509: certificate has expired or is not yet valid". Reconnecting...
    ```

  **Workaround:**

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

  1. If this does not resolve the issue, then you may need to renew the kubelet server cert as well. You can check whether the server cert is expired by running `openssl x509 -in /var/lib/kubelet/server.pem -text -noout` and looking at the expiration date. If it is expired, here are the steps to renew.

    a. Back up and remove the existing server certs in `/var/lib/kubelet/pki` (there should be server.csr, server.key, and server.pem)

    b. Copy the following script to the NGINX Controller host and run it.

    ```bash
    #!/bin/bash

    function join_by { local IFS="$1"; shift; echo "$*"; }

    usrmask=$(umask)

    mapfile -t altnames < <(awk '/32 host/ { print "IP:"f } {f=$2}' /proc/net/fib_trie | sort -u)

    umask u=rwx,go=

    sudo openssl genrsa -out /var/lib/kubelet/pki/server.key 2048
    sudo openssl req -new -key /var/lib/kubelet/pki/server.key \
      -subj "/C=US/ST=Washington/L=Seattle/O=F5, Inc./OU=Controller/CN=kubelet" \
      -out /var/lib/kubelet/pki/server.csr
    sudo bash -c "openssl x509 -req -in /var/lib/kubelet/pki/server.csr \
      -extfile <(printf \"subjectAltName=$(join_by , "${altnames[@]}")\") \
      -CA /etc/kubernetes/pki/ca.crt \
      -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial \
      -out /var/lib/kubelet/pki/server.pem -days 365 -sha256"

    umask "$usrmask"
    ```

    c. Check that new server.csr/key/pem files are created in `/var/lib/kubelet/pki`.

    d. Restart kubelet `sudo systemctl restart kubelet`.

    e. Run `sudo helper.sh controller stop`, wait for all pods to terminate, and then run `sudo helper.sh controller start`.

  1. Continue with step 2 in the procedure to renew the Kubernetes certs.

- **Component rewrite rules are not combined correctly in some cases (25951)**

  When adding multiple components that have rewrite rules -- where one of the rewrite rules specifies an Applicable URI that targets the gateway URI -- the first component with a rewrite rule may be overwritten if the components share a gateway configuration.

  **Workaround:**

  If possible, if you don't need to limit the scope, avoid defining an Applicable URI that targets the gateway URI when defining a component. Otherwise, after adding the second component with a rewrite rule, resubmit the component definition for the first component with an Applicable URI.

- **System configuration state should be `isConfigured` before upgrading to NGINX Controller 3.20+ from 3.18 or earlier (27869)**

  NGINX Controller 3.20 deploys a new backend service to communicate with the NGINX agents. Because of this, before upgrading to NGINX Controller 3.20+ from 3.18 or earlier, the existing configuration should be in a good steady-state condition.  That is, all configuration objects should be in an `isConfigured` state.

- **When upgrading an NGINX Controller cluster, the system reports timeout errors waiting for services to scale up (27871)**

  When upgrading the third node of an NGINX Controller cluster, some services may take two or more minutes to scale up. During this period, the system displays an error similar to the following:

  ``` text
  While waiting for nats-streaming-cluster to scale up, the operation did not complete before timing out.
  ```

  You can safely ignore these warnings. The services will continue to scale up in the background and should not interfere with the upgrade.

- **A confusing error message is displayed when a gateway or component cannot update an instance (28387)**

  When a configuration cannot be pushed to an instance, an error message similar to the following is displayed: `Error: instance = instance:[instanceName]:[locationName]:: did not qualify for placement. Connected status = false.`

  In many cases, this error indicates that the Controller Agent on that instance could not receive the new NGINX configuration from NGINX Controller. This may be due to a network issue, or the Agent may not be running. You should verify the network connection is good and that the Agent is running on the specified instance.

- **"`jq: command not found`" error is shown when installing NGINX Controller 3.20 on Red Hat (28470)**

  When NGINX Controller is installed on Red Hat, an error similar to the following may be displayed: `/opt/nginx-controller/helper.sh: line 726: jq: command not found.`

  This error can safely be ignored and does not indicate an issue with the installation.

- **NGINX Controller app-centric metrics may show inaccurate metrics data when HTTPS and TCP+TLS are configured on the same data path (28489)**

  Depending on whether connections close cleanly when both HTTP/HTTPS and TCP/TCP+TLS are configured on the same NGINX instance running the NGINX Controller Agent, inaccurate metrics values may be reported for either HTTP/HTTPS or TCP/TCP+TLS analytics data. The issue won't occur when only HTTP and HTTPS are configured on the same datapath.

- **All locations in a gateway must be specified when using workload affinity and health monitoring (28497)**

  Components allow workloads to be uniquely specified based on a location. When using workload affinity in NGINX Controller 3.20, the workload groups must include all locations referenced by the associated gateway(s).  Otherwise, a configuration error will occur.

  **Workaround:**

  To use workload affinity, take one of the following three workarounds:

  - Option 1: Make sure every location in the referenced gateways has a matching workload group.
  - Option 2: Remove the instances in the gateway if their location is not referenced within the component's workload groups.
  - Option 3: Remove the monitoring section within the component.

- **False Positive reported after upgrading from NGINX Controller 3.18 to 3.20 or 3.21 (30672)**

  The Default Security policy (balance_default) in NGINX Controller 3.20 and 3.21 differs from NGINX Controller 3.18. As a result, when you upgrade from NGINX Controller 3.18 to 3.20 or 3.21, you might see a False Positive.
  <br><br>
  **Workaround:**

  Upgrade to NGINX Controller 3.22, which has the same Default Security Policy as NGINX Controller 3.18.

## Supported NGINX Plus Versions

Check the [NGINX Controller Tech Specs guide]({{< ref "/controller/admin-guides/install/nginx-controller-tech-specs.md#nginx-plus-instances" >}}) to learn about the NGINX Plus versions supported by this release.
