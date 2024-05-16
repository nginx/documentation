The following sizing guidelines are for Instance Manager deployments with data plane instances that have standard configurations; that is, up to **40** upstream servers with associated location and server blocks and up to 350 associated certificates.

We recommend using solid-state drives (SSDs) for better storage performance.

{{<bootstrap-table "table table-striped table-bordered">}}

| # of Data Plane Instances | CPU    | Memory   | Network   | Storage |
|---------------------------|--------|----------|-----------|---------|
| 10                        | 2 vCPU | 4 GB RAM | 1 GbE NIC | 100 GB  |
| 100                       | 2 vCPU | 4 GB RAM | 1 GbE NIC | 1 TB    |
| 1000                      | 4 vCPU | 8 GB RAM | 1 GbE NIC | 3 TB    |

{{</bootstrap-table>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1070 -->