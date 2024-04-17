---
docs: "DOCS-1533"
---

Attack signatures are rules or patterns that identify attack sequences or classes of attacks on a web application and its components. You can apply attack signatures to both requests and responses. App Protect includes predefined attack signatures to protect your application against all attack types identified by the system.

As new attack signatures are identified, they will become available for [download and installation]({{< ref "/nap-waf/v4/admin-guide/install.md#updating-app-protect-attack-signatures" >}}) so that your system will always have the most up-to-date protection. You can update the attack signatures without updating the App Protect release, and conversely, you can update App Protect without changing the attack signature package, unless you upgrade to a new NGINX Plus release.