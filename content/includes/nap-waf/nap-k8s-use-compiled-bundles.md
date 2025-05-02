In this setup, copy your compiled policy and logging profile bundles to `/mnt/nap5_bundles_pv_data` on a cluster node. Make sure that input files are accessible to UID 101. Then, in your NGINX configuration, refer to these files from `/etc/app_protect/bundles`.

For example, to apply `custom_policy.tgz` that you've placed in `/mnt/nap5_bundles_pv_data/`, use:

```nginx
app_protect_policy_file "/etc/app_protect/bundles/custom_policy.tgz";
```