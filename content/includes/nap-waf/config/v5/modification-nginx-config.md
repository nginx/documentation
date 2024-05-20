---
docs: ""
---

When both `nginx.conf` file and App Protect configurations are modified, apreload enforces only the App Protect configurations but nginx reload enforces both. apreload is a script that you run remotely on the `nginx` container after you have modified the policy in the `nginx` container.  The result of the apreload script is viewable in the `waf-config-mgr` container log.

For apreload, use the following command:
```shell
kubectl -n [namespace] exec -it [podname] -c waf-nginx -- bash /opt/app_protect/bin/apreload
```

Output:

```shell
kubectl -n [namespace] logs [podname] -c config-mgr
sudo docker logs waf-config-mgr
```