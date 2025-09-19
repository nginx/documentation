---
nd-docs: "DOCS-1615"
---

Geolocation refers to the process of assessing or determining the geographic location of an object. This feature helps in identifying the geographic location of a client or web application user.

In F5 WAF for NGINX, the Enforcer will look up the client IP address in the Geolocation file included in the app protect package, and extract the corresponding [ISO 3166](https://www.iso.org/obp/ui/#search) two-letter code, representing the country. For instance, "IL" denotes Israel. This information is denoted as "geolocation" in the condition and is also included in the request reporting.
