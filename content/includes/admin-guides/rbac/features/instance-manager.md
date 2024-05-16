---
docs: DOCS-1296
---

Instance Manager includes the following features:

{{<bootstrap-table "table table-striped table-bordered">}}

| Feature                    | Applicable Resource Objects                                 | Description                                                                                                                 |
|----------------------------|--------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| Analytics                  | Not Applicable                                   | Grants access to analytics endpoints, including metrics, catalogs, and events.                                              |
| Certificates               | Certs, Instance Groups, Resource Groups, Systems | View and manage certificates for NGINX instances.                                                                           |
| Instance Groups            | Instance Groups                                  | Create, configure, and manage NGINX instance groups.                                                                        |
| Instance&nbsp;Management   | Resource Groups, Systems                         | View and manage NGINX instances.                                                                                            |
| Scan                       | Not Applicable                                   | Permits scanning for NGINX instances.                                                                                       |
| Security Policies          | Not Applicable                                   | View and manage security policies for NGINX instances. Dependent on Instance Management and Instance Groups for publishing. |
| Staged&nbsp;Configurations | Instance Groups, Resource Groups, Systems       | View, create, update, and delete staged NGINX configurations.                                                                  |
| Templates | Instance Groups, Resource Groups, Systems, Templates | View, create, update, and delete NGINX config templates. |
| Template&nbsp;Submissions | Instance Groups, Resource Groups, Systems, Templates, Template Submissions | View, create, update, and delete NGINX config template submissions.

{{</bootstrap-table>}}
