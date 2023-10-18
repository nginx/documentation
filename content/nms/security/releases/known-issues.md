---
title: "Known Issues"
description: "This document lists and describes the known issues and possible workarounds in the NGINX Management Suite Security Monitoring module. Fixed issues are removed after **45 days**."
weight: 200
toc: true
tags: [ "docs" ]
docs: "DOCS-1077"
categories: ["known issues"]
---

{{<rn-styles>}}

{{< tip >}}We recommend you upgrade to the latest version of the Security Monitoring module to take advantage of new features, improvements, and bug fixes.{{< /tip >}}


---

## 1.7.0
October 18, 2023

### {{% icon-bug %}} Web interface fails to load after restarting NGINX Management Suite {#44587}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 44587 | Open   |

{{</bootstrap-table>}}
#### Description
The NGINX Management Suite web interface can fail to load with a "Page not found"  error after restarting its service. The security monitoring module will fail to appear on the launchpad until the page is manually reloaded.

#### Workaround

Reload the page in the browser to resolve this issue.

---


## 1.5.0
June 12, 2023

### {{% icon-resolved %}} Using empty values as filters returns inaccurate results {#42941}

{{<bootstrap-table "table table-striped table-bordered">}}
| Issue ID       | Status |
|----------------|--------|
| 42941 | Fixed in Security Monitoring -1.6.0   |

{{</bootstrap-table>}}
#### Description
Using an empty string as a key or value results in an empty dataset.

---

