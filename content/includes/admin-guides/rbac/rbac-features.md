---
docs: DOCS-1245
---

{{<bootstrap-table "table table-striped table-bordered">}}

| User  | Module                   | Feature               | Description         | Access&nbsp;Type |
|-------|--------------------------|-----------------------|-----------------------------------------------------------------------------------|-------------|
| admin | NGINX&nbsp;Management&nbsp;Suite&nbsp;Settings                | Licensing                    | Allows access to view and manage licenses          | CRUD |
| admin | NGINX Management Suite Settings                  | User Management              | Allows access to view and manage roles, users, and user groups | CRUD |
| admin | Instance Manager         | Analytics             | Allows access to the analytics endpoints, including metrics, catalogs, and events | CRUD |
| admin | Instance Manager         | Certs                 | Allows access to view and manage certs for NGINX instances                        | CRUD |
| admin | Instance Manager         | Instance Groups       | Allows access to view and manage NGINX instance groups                            | CRUD |
| admin | Instance Manager         | Resource Groups       | Allows access to view and manage resource groups                                  | CRUD |
| admin | Instance Manager         | Instance Management   | Allows access to view and manage NGINX instances. Granting write access (Create, Update) allows a user to read and publish any valid certificate stored in NGINX Management Suite by name. | CRUD |
| admin | Instance Manager         | Scan                  | Allows access to scan for NGINX Instances                                         | CRUD |
| admin | Instance Manager         | Staged Configs        | Allows access to view and manage staged NGINX configurations                      | CRUD |
| admin | Instance Manager         | Security Policies     | Allows access to view and manage NGINX App Protect Policies                       | CRUD |
| admin | Instance Manager         | Security Log Profiles | Allows access to view and manage NGINX App Protect Log Profiles                   | CRUD |
| admin | Security Monitoring      | Security&nbsp;Monitoring | Allows access to the Security Monitoring dashboard and APIs                       | CRUD |

{{</bootstrap-table>}}
