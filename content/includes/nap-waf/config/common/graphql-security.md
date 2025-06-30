---
nd-docs: "DOCS-1566"
---

Securing GraphQL APIs with NGINX App Protect WAF involves using WAF to monitor and protect against security threats and attacks. GraphQL, like REST, is usually [served over HTTP](http://graphql.org/learn/serving-over-http/), using GET and POST requests and a proprietary [query language](https://graphql.org/learn/schema/#the-query-and-mutation-types). It is prone to the typical Web APIs security vulnerabilities, such as injection attacks, Denial of Service (DoS) attacks and abuse of flawed authorization.

Unlike REST, where Web resources are identified by multiple URLs, GraphQL server operates on a single URL/endpoint, usually **/graphql**. All GraphQL requests for a given service should be directed to this endpoint.