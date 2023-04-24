The diagram below shows how the different objects in a multi-node NGINX Controller cluster relate to each other. The control nodes communicate with an embedded, self-hosted database that is stored on an external volume. The NGINX Controller Agent -- and NGINX Controller users -- can access the cluster via a load balancer or floating IP address that is associated with NGINX Controller's FQDN. If a node in the cluster becomes unavailable for any reason, traffic is re-routed automatically to an available node.

{{< img src="/ctlr/img/multi-node-diagram.png" alt="Diagram showing the relationship of objects in a multi-node cluster." width="639" height="689" >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-301 -->