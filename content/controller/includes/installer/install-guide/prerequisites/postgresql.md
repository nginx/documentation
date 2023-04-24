When installing NGINX Controller, you can choose to have NGINX Controller install and manage a self-hosted -- also known as "embedded" -- [PostgreSQL](https://www.postgresql.org/) config database for you; this is the recommended implementation. If you choose to use the embedded, self-hosted config database, you can skip this section.

Alternatively, you can install your own PostgreSQL database for the config database, which you manage; this is sometimes referred to as an "external config database" because it is externally managed by you. Continue reading if you're providing your own PostgreSQL database.

Refer to the AskF5 KB article [K49481224](https://support.f5.com/csp/article/K49481224) for instructions on how to install PostgreSQL on CentOS 7 and Ubuntu 18.04 for use with NGINX Controller.

* NGINX Controller supports the following versions of PostgreSQL:

  * PostgreSQL 12.x -- works with NGINX Controller 3.9 and later.
  * PostgreSQL 9.5 -- works with NGINX Controller 3.0 and later.

* The PostgreSQL database must be accessible from the NGINX Controller server. You can use a DNS-resolvable name or an IP address to connect to the database server (names in `/etc/hosts` are not allowed).
* Create the user with the `Create DB` permission.
* Configure PostgreSQL to allow SSL connections; client certificates should also be used for user authentication.

  **We strongly discourage disabling SSL for PostgreSQL for security reasons.** Consult the *Secure TCP/IP Connections with SSL* topic in the PostgreSQL manual for instructions and details:

  * [PostgreSQL 9.5](https://www.postgresql.org/docs/9.5/ssl-tcp.html)
  * [PostgreSQL 12.x](https://www.postgresql.org/docs/12/ssl-tcp.html)

* When installed on external NFS or EFS volumes, the config database should support a throughput of 2 MiB/s or greater.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-291 -->