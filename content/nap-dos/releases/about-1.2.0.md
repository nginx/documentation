---
title: NGINX App Protect DoS Arbitrator 1.2.0
toc: true
weight: 61
docs: DOCS-000
---

Here you can find the release information for F5 NGINX App Protect DoS Arbitrator v1.2.0

## Arbitrator Service Release 1.2.0

Mar 24, 2025

### Enhanced Sync Mechanism in ADMD Based on Arbitrator Version
In this release, ADMD now dynamically selects the appropriate synchronization method based on the Arbitrator's version:
Arbitrator 1.2.0 and above – ADMD uses Batch Sync, allowing all VSs to be synchronized in a single request, improving efficiency and reducing overhead.
Arbitrator versions below 1.2.0 – ADMD continues to use per-VS Sync, ensuring compatibility with earlier versions.
This enhancement optimizes synchronization performance while maintaining backward compatibility.