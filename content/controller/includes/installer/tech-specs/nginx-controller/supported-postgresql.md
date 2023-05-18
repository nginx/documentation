NGINX Controller supports the following versions of PostgreSQL:

- PostgreSQL 12.x -- works with NGINX Controller 3.9 and later.
- PostgreSQL 9.5 -- works with NGINX Controller 3.0 and later.

For a system monitoring **100 NGINX Plus instances**, we recommend at least **32 GB of database storage**. Database storage requirements can vary, depending on the number of NGINX Plus instances, components, published API specs, and the churn rate for configuration changes. For monitor-only implementations, the database storage needs are small; for API Management (APIM) and/or App Delivery Controller (ADC) implementations in production, the storage needs are greater.

{{< important >}}
If you use PostgreSQL 12, we recommend disabling [Just-in-Time (JIT)](https://www.postgresql.org/docs/12/jit.html) compilation to improve NGINX Controller's performance. To disable JIT, edit the `postgresql.conf` file and set `jit=off`.
{{< /important >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-327 -->