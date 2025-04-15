---
docs: "DOCS-1511"
---

To work with custom policy and logging profile bundles, these files must be accessible to the `waf-config-mgr` container.

1. **Assumption**: Your bundle files are in `/bundles` on the host machine.
2. **Docker Compose Configuration**: In your `docker-compose.yml`, add a volume mount under the `waf-config-mgr` service to link the host directory `/bundles` to the same path inside the container.

```yaml
...
waf-config-mgr:
  container_name: waf-config-mgr
  image: "private-registry.nginx.com/nap/waf-config-mgr:1.0.0"
  volumes:
    - /bundles:/bundles # Mounting the host directory to the container
    - ... #existing volume mounts
```

By setting up this volume mount, the bundle files can be referenced within your NGINX configuration using the `/bundles` directory.

For instance:

   ```nginx
   app_protect_policy_file /bundles/custom_policy.tgz;
   app_protect_security_log /bundles/custom_logging_profile.tgz syslog:server=localhost:514;
   ```
