To be resilient, a cluster requires three working nodes. That's two nodes for a quorum and one node for failure tolerance.

If one of the nodes in a multi-node cluster becomes degraded or fails, you must take action **as soon as possible** to recover or replace the failed node or risk losing resiliency.

To replace a failed node:

1. [Delete the failed node](#delete-a-node).
1. [Add a new node](#add-nodes-to-a-cluster).

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-307 -->