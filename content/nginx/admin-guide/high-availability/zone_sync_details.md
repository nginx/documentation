---
description: Design and limitations of the zone synchronization feature that allows
  synchronizing data in an nginx cluster.
nd-docs: DOCS-408
title: How NGINX Plus Performs Zone Synchronization
toc: true
weight: 500
type:
- how-to
---

This chapter describes the design and limitations of the zone synchronization feature that allows synchronizing data in an nginx cluster.

<span id="intro"></span>
## Introduction

<span id="usecases"></span>
### Use Cases

Given the specific functionality of the feature, namely:

- processing requests on each node separately without consulting other nodes
- eventual delivery of changes
- expirable records

The following use cases are considered:

- **Session caching**: the first request creates a session which is shared with other nodes. Subsequent requests use the same session on any cluster node. A missing session on a node is more of a performance penalty rather than a fatal error.

- **Resource limiting**: each node assesses local resources and notifies others. In average, the cluster limit is properly imposed.

- **Dynamic configuration**: dynamic configuration entries (for example, temporary redirection rules, access rules and limits) are automatically shared within the cluster after being entered on one node. As soon as other nodes receive them, new rules are applied.


<span id="modules"></span>
## Modules

The feature is complex, and its support is split between the nginx `core`, the [ngx_stream_zone_sync_module](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html) module, and the modules that actually use shared zones (for example, [sticky](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky) or [limit_req](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html) modules; here, we will refer to such modules as `functional`).

Here, the [zone synchronization module](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html) is responsible for:

- all network-related functionality, including:
  - cluster nodes discovery
  - managing network connections to cluster nodes
  - providing transport layer security (using the [ssl module](https://nginx.org/en/docs/http/ngx_http_ssl_module.html))
  - pushing data provided by the functional modules to remote nodes
  - accepting data from remote nodes and dispatching it to the functional modules
- tracking changes in zones and processing the zone’s output queue

On the server side, the [zone synchronization module](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html) is a regular stream module, so access control, transport layer security, and limiting are supported.

The functional modules are responsible for:

- serializing zone records so they can be sent over the network along with key and timestamp metadata
- deserializing messages and updating the local zone with remote data
- maintaining a queue of records that were updated locally and have to be distributed within the cluster

The core provides necessary interfaces between the zone synchronization module and the functional modules.


<span id="sync"></span>
## Synchronization

<span id="datamodel"></span>
### Data Model

Each functional module represents its data as a queue of records. Records are opaque for the zone synchronization module; it deals only with a serialized representation of the records while sending them to other nodes. The queue contains records that need to be sent to the cluster. Only records created locally on a node may appear in the output queue. The queue is intrusive and may include all records stored in a zone.

The zone synchronization module polls the output queues of configured zones at a constant [interval](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_interval) which controls how large the inconsistency window of the cluster is. Also, it allows reducing the amount of data transferred in case of frequent updates of a single record (a typical use case with sessions, when a session is created and later updated multiple times).

Synchronized records may be `created` or `updated`. Currently, the `delete` operation is not supported; instead, each record has a configuration-defined lifetime. When a record expires, it is deleted locally, and no updates are sent to the cluster.

The functional modules control whether the record lifetime is extended upon access/update or not.

The data becomes consistent `eventually`: there is always a time span when an updated value varies between the cluster nodes. The span can be reduced (but not eliminated) by tuning the [zone synchronization interval](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_interval). In terms of the [CAP theorem](https://en.wikipedia.org/wiki/CAP_theorem), the zone sync cluster can be categorized as an AP system.

Consistency is ensured by the fact that each node eventually receives all events that have happened in the cluster ordered by timestamp, processes them using a common algorithm, and arrives at the same state as other nodes.

Obviously, the algorithm depends on proper temporal synchronization of all cluster nodes, so it is important to setup NTP or similar technology on all nodes.


<span id="dataflow"></span>
### Data flow

1. The functional module creates a new record (for example, a new sticky session)
2. The record is inserted into the output queue
3. The functional module may continue its normal operation. As a result, the record can be updated multiple times or even deleted (for example, locally on the node after a direct request) before being shared with other nodes.
4. Periodic timer triggers, and the zone synchronization module inspects the output queue of the functional module.
5. If the queue is not empty, the zone synchronization module asks the functional module to serialize the outgoing records and writes them into its own [buffer](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_buffers).
6. The functional module serializes a record using its own serialization format. Typically, it includes `key`, `timestamp`, and `payload`.
7. The zone synchronization module consumes the output queue until it has no buffer space available or the queue is empty.
8. Finally, the zone synchronization module sends all information it has read to nodes it has established connections with, framing the records into messages that contain zone name and version details.
If an error occurs and a record cannot be delivered to a node, the connection to the node is closed to be reestablished. See the explanation of the initial state of a cluster portion below.
9. The remote node receives the message and dispatches it to the appropriate functional module and zone.
The functional module now has to refresh its local state using the information from the remote node (`key`, `timestamp`, and `payload`) by:

- Inserting the new record at the key if no such key exists
- Updating an existing record if the remote timestamp is newer
- Ignoring the update if the local timestamp is newer

10. The functional module, that is capable to serialize zone state to disk (i.e. keyval with the “state” enabled) saves record timestamps to ensure proper handling of records lifetime after server restart.

<span id="topology"></span>
### Topology

Topologically, the cluster is a full mesh where each node connects to all the others and any changes are pushed to other nodes.

All cluster nodes are equal. There are no special `central` or `main` nodes; each node processes requests without waiting for other nodes.

Nodes commit any changes to local memory and continue processing requests. Other nodes will be eventually notified about local changes.

A node does not know whether its local values are "best/latest"; it relies on them until updates from other nodes are applied.

A node listens for changes from other nodes and applies them as they arrive.


<span id="initial_state"></span>
### Initial State

When a node is connected to the cluster, it already has a state and it is not known whether any parts of this state were sent to the cluster previously. The ultimate solution is to merge the entire node state with the cluster. This process is called `snapshotting`: when the network connection is established with the new node, the cluster and the node exchange snapshots. The most recent versions of records are selected to form the new joint state. This process runs in parallel with regular operations, so the node does not need to wait until snapshotting ends.

The same process happens after a cluster brain split: new nodes appear in the cluster and exchange their current state with peers. If the state is large and there are many nodes in the cluster, synchronization can take some time and introduce additional sporadic system load.

When a node goes offline, it temporarily affects other nodes: next data read from the zones is delayed until the write timeout expires, or a connection write error is detected, and the faulty node is disconnected. Then, synchronization continues among the remaining nodes until the connection to the offline node is reestablished.


<span id="wire_format"></span>
### Wire Format

The module uses a set of [buffers](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_buffers) pre-allocated per node connection to deliver changes. A buffer contains a message header and serialized records. The message header contains:

- full message length, including its payload
- protocol version (currently `1`)
- zone name length
- module tag - unique module id
- module version
- destination zone name

The size of the fixed-length header section is `12` bytes. For a message to be successfully dispatched, the signature (module tag and version) must match the destination. Messages with unknown signatures are ignored (for example, adding a new zone to another node can yield such a message). Length of the serialized record depends on the specific functional module; for example, the sticky module generates a `21`-byte fixed-length header and a session ID of up to `32` bytes. If a single serialized record is too large to fit in the buffer, an error is logged and the record is ignored during synchronization. This also suggests that the buffer size should be increased.


<span id="monitoring"></span>
### Monitoring

The standard functionality of access log allows watching stream sessions with other cluster nodes and log supported variables such as [`$remote_addr`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_addr), [`$status`](https://nginx.org/en/docs/http/ngx_http_core_module.html#var_status), [`$upstream_bytes_sent`](https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#var_upstream_bytes_sent) or [`$bytes_received`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#var_bytes_received). The error log registers `NOTICE`-level entries with details of various events: node discovery, node connection, accepted client, and others. Occurring errors are reported at the appropriate level.

The zone synchronization module exports several counters via the [API](https://nginx.org/en/docs/http/ngx_http_api_module.html) module:
the [`stream/zone_sync`](https://nginx.org/en/docs/http/ngx_http_api_module.html#stream_zone_sync_) endpoint includes the [status](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_zone_sync) endpoint with per-instance information; [`zones/`](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_zone_sync_zone) endpoints list statistics per zone.

The [`nodes online`](https://nginx.org/en/docs/http/ngx_http_api_module.html#def_nginx_stream_zone_sync_zone) metric displays the count of established connections to other nodes. Usually, it is expected to equal `N` minus `1` where `N` is the number of all cluster nodes.

Additionally, the endpoint contains cumulative counters of inbound and outbound messages and bytes.

The per-zone statistics include the total number of records in the shared memory zone and the number of records in the output queue.


<span id="scaling"></span>
### Scaling

Note that with synchronization your nodes start receiving multiple updates from other nodes which typically requires locking a certain amount of shared memory to insert/update records.

With many workers and nodes, this can become a bottleneck. If the number of events is high, consumed network bandwidth and CPU usage increase accordingly.


<span id="faq"></span>
## FAQ

**Q.** What happens when a node is isolated from the cluster?

**A.** When a node is isolated from the cluster, it continues to operate as a single node: i.e. it manages sessions locally and continues to respond to clients, while continually trying to connect to others.


**Q.** What happens when an isolated node reconnects to the cluster?

**A.** When a node reconnects, it performs full resync: it sends all local sessions to cluster, and, in turn, receives data from other nodes.Thus, when all nodes are connected, they will eventually reach a consistent state.


**Q.** If multiple nodes sync with the same data, how are conflicts resolved?

**A.** The conflict resolution is based on time, thus it is critical to have synchronized clocks across the cluster. If two nodes created a record with same key, the newest record wins.


**Q.** Is there a state file for cluster sync data?

**A.** No. Cluster sync data is shared across the cluster so there is no need to write it out to disk. The keyval module is capable of saving local node state to disk.


**Q.** Can F5 NGINX Plus be configured to reject connections before sync has completed?

**A.** No, because there is no such state. Each node just receives stream of updates from others and sends own updates to others. If no new data is arriving to cluster, all nodes will have an empty backlog queue and this can be counted as 'complete sync', but in reality such situation is usually never met: there are always clients.


**Q.** How do I deliberately put a node offline?

**A.** The documentation describes how to control cluster nodes.


**Q.** How can we monitor cluster state data?

**A.** There are 2 counters available for each synchronized zone in the NGINX Plus API: Total number of records on node, and a number of records that needs to be sent. If all nodes have approximately the same number of records and almost empty outgoing queue, we may consider the cluster to be healthy.


**Q.** How can we monitor cluster health?

**A.** There are 2 further metrics exposed by the NGINX Plus API:

1. Number of connected nodes: this is expected to be equal on all nodes and be equal to total number of nodes in cluster minus one. That is, you can monitor cluster connectivity: if some nodes are dead/disconnected, this counters will change

2. Length of send queue: ideally, this is zero (low load) or some constant number (average load). If a backlog is growing and you did not made changes (i.e. adding or removing nodes to cluster), this indicates problems (network connection issues, dead nodes, etc)

3. As usual, monitor error logs: all related events are logged. By default, only errors are logged. It is possible to view more cluster events at INFO level.


<span id="history"></span>
## History

In NGINX Plus [R15]({{< ref "nginx/releases.md#r15" >}}), the ability to synchronize memory zones between instances was introduced; only sticky sessions with [learn](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_learn_sync) method were supported at the moment.

In NGINX Plus [R16]({{< ref "nginx/releases.md#r16" >}}), shared zones synchronization was extended to support [keyval](https://nginx.org/en/docs/http/ngx_http_keyval_module.html) and [limit_req](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req) modules.

In NGINX Plus [R18]({{< ref "nginx/releases.md#r18" >}}), a single zone_sync configuration can be applied between all instances in a cluster using wildcards in the [listen](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#listen) directive.

