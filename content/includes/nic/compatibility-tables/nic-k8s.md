---
nd-docs: DOCS-152
nd-product: INGRESS
nd-files:
- content/nic/changelog/_index.md
- content/nic/technical-specifications.md
---

NGINX Ingress Controller supports the following versions of [NGINX Plus]({{< ref "/nginx/" >}}) and [Kubernetes](https://kubernetes.io/):

{{< table >}}

| NIC version | Kubernetes versions tested  | NIC Helm Chart version | NIC Operator version | NGINX / NGINX Plus version | End of Technical Support |
| --- | --- | --- | --- | --- | --- |
| {{< nic-version >}} | 1.27 - 1.34 | {{< nic-helm-version >}} | {{< nic-operator-version >}} | 1.29.4 / R36 | - |
| 5.2.1 | 1.27 - 1.34 | 2.3.1 | 3.3.1 | 1.29.1 / R35 | Oct 10, 2027 |
| 5.1.1 | 1.25 - 1.33 | 2.2.2 | 3.2.3 | 1.29.1 / R35 | Aug 15, 2027 |
| 5.0.0 | 1.25 - 1.32 | 2.1.0 | 3.1.0 | 1.27.4 / R34 | Apr 16, 2027 |
| 4.0.1 | 1.25 - 1.32 | 2.0.1 | 3.0.1 | 1.27.4 / R33 P2 | Feb 7, 2027 |
| 3.7.2 | 1.25 - 1.31 | 1.4.2 | 2.4.2 | 1.27.2 / R32 P1 | Nov 25, 2026 |
| 3.6.2 | 1.25 - 1.31 | 1.3.2 | 2.3.2 | 1.27.1 / R32 P1 | Aug 19, 2026 |
| 3.5.2 | 1.23 - 1.30 | 1.2.2 | 2.2.2 | 1.27.0 / R32 | May 31, 2026 |
| 3.4.3 | 1.23 - 1.29 | 1.1.3 | 2.1.2 | 1.25.4 / R31 P1 | Feb 19, 2026 |
| 3.3.2 | 1.22 - 1.28 | 1.0.2 | 2.0.2 | 1.25.3 / R30 | Nov 1, 2025 |

{{< /table >}}