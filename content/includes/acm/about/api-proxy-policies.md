The following table shows the available API Proxy Policies you can use when creating an API gateway.

<br>

**Legend:**

- <i class="fa-solid fa-check"></i> = Supported
- <i class="fa-solid fa-x"></i> = Not supported
- <i class="fa-solid fa-circle-check center"></i> = Applied by default

{{<bootstrap-table "table table-striped table-bordered">}}

| Policy&nbsp;Name                                                                                                                  | HTTP&nbsp;Proxy                                 | gRPC&nbsp;Proxy                                 | Applied&nbsp;On | Description                                                                                                                                          |
| --------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- | ----------------------------------------------- | --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Access Control Routing]({{< relref "/nms/acm/how-to/policies/access-control-routing" >}})                                            | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-x"></i>                   | Inbound         | Restrict access to your application servers based on JWT claims or header values.                                                                    |
| [ACL Consumer Restriction]({{< relref "/nms/acm/how-to/policies/api-access-control-lists#create-acl-consumer-restriction-policy" >}}) | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-check center"></i>        | Inbound         | Protect your upstream TCP application servers by denying/allowing access from certain consumers client IDs or authenticated JWT claims.              |
| [ACL IP Restriction]({{< relref "/nms/acm/how-to/policies/api-access-control-lists#create-acl-ip-restriction-policy" >}})             | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-check center"></i>        | Inbound         | Protect your upstream TCP application servers by denying/allowing access from certain client IP addresses or CIDR blocks                             |
| [Advanced Security]({{< relref "/nms/acm/how-to/policies/advanced-security" >}})                                                      | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-check center"></i>        | Inbound         | Protect your upstream TCP application servers by applying an NGINX App Protect WAF policy to the traffic to your proxy                               |
| [Allowed HTTP Methods]({{< relref "/nms/acm/how-to/policies/allowed-http-methods" >}})                                                | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-x"></i>                   | Inbound         | Restrict access to specific request methods and set a custom response code for non-matching requests.                                                |
| [APIKey Authentication]({{< relref "/nms/acm/how-to/policies/apikey-authn" >}})                                                       | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-check center"></i>        | Inbound         | Secure the API gateway proxy by adding an API key.                                                                                                   |
| [HTTP Backend Config]({{< relref "/nms/acm/how-to/policies/http-backend-configuration" >}})                                           | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-x"></i>                   | Inbound         | Customize settings to ensure fault tolerance, maximize throughput, reduce latency, and optimize resource usage.                                      |
| [GRPC Backend Config]({{< relref "/nms/acm/how-to/policies/grpc-policies" >}})                                                                                                  | <i class="fa-solid fa-x"></i>                   | <i class="fa-solid fa-check center"></i>        | Inbound         | Customize settings to ensure fault tolerance, maximize throughput, reduce latency, and optimize resource usage.                                      |
| [Backend Health Check]({{< relref "/nms/acm/how-to/policies/health-check" >}})                                                       | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-x"></i>                   | Backend         | Perform regular health checks to the backend API service to avoid and recover from server issues. Customize the policy with your desired thresholds. |
| [Basic&nbsp;Authentication]({{< relref "/nms/acm/how-to/policies/basic-authn" >}})                                                    | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-check center"></i>        | Inbound         | Restrict access to APIs by requiring a username and password.                                                                                        |
| [CORS]({{< relref "/nms/acm/how-to/policies/cors" >}})                                                                                | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-x"></i>                   | Inbound         | Configure cross-origin resource sharing (CORS) to control resource access from outside domains.                                                      |
| [JSON Web Token Assertion]({{< relref "/nms/acm/how-to/policies/jwt-assertion" >}})                                                   | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-check center"></i>        | Inbound         | Secure your API gateway proxy with JSON web token verification.                                                                                      |
| [OAuth2 Token Introspection]({{< relref "/nms/acm/how-to/policies/introspection" >}})                                                 | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-check center"></i>        | Inbound         | Secure your API gateway proxy with OAuth2 Tokens.                                                                                                    |
| [Proxy Cache]({{< relref "/nms/acm/how-to/policies/proxy-cache" >}})  | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-x"></i>                   | Outbound        | Enable and configure caching to improve the performance of your API gateway proxy.                                                                   |
| [Proxy Request Headers]({{< relref "/nms/acm/how-to/policies/proxy-request-headers" >}})                                              | <i class="fa-solid fa-circle-check center"></i> | <i class="fa-solid fa-circle-check center"></i> | Backend         | Configure the headers to pass to the backend API service.                                                                                            |
| [Rate Limit]({{< relref "/nms/acm/how-to/policies/rate-limit" >}})                                                                        | <i class="fa-solid fa-check center"></i>        | <i class="fa-solid fa-check center"></i>        | Inbound         | Add rate limits to limit incoming requests and secure API workloads.                                                                                 |

{{</bootstrap-table>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1000 -->