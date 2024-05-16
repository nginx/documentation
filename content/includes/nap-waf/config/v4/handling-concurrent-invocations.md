---
docs: "DOCS-1523"
---

Concurrent NGINX reloads are enqueued and so are the entailed invocations to apreload by the NGINX App Protect WAF module.

However, when invoking apreload directly, it is possible to invoke it while the previous invocation is still in progress. In this case, apreload will wait until the current invocation completes. The new invocation will bring a new configuration and the most recent configuration will only happen when the previous one is loaded.

In a special scenario, when the first invocation comes from the NGINX reload followed immediately by a direct call to apreload. The NGINX workers with the new `nginx.conf` will be launched as soon as the Enforcer finishes the first configuration. Later, the most recent NGINX App Protect WAF configuration will be loaded (using with the same NGINX worker instances).