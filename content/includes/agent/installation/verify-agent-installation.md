Run the following command on your data plane to verify that the NGINX Agent process is running:

```bash
ps aux | grep nginx-agent
```

You should see output that looks similar to the following example:

```text
root      293850  109  1.1 1240056 23536 ?       Ssl  22:00   0:07 /usr/local/bin/nginx-agent
vagrant   293866  0.0  0.0   8160   736 pts/0    S+   22:00   0:00 grep --color=auto nginx-agent
```

Once you've verified the NGINX Agent is running on your data plane, you should confirm it's registered with Instance Manager. You can do this two ways:

{{<tabs name="verify-nginx">}}

{{%tab name="API"%}}

Send an API request similar to the following example to get the inventory list. Your instance should be listed.

  ```bash
  curl -u <user>:<password> https://<NMS-FQDN>/api/platform/v1/systems | jq
  ```

{{%/tab%}}

{{%tab name="WEBUI"%}}

Open the NGINX Management Suite web interface and log in. The registered instance is shown in the **Instances** list.

  {{< img src="/getting-started/install/registered-instance.png" alt="Registered instances" >}}

{{%/tab%}}

{{</tabs>}}

<br>

Once you've verified the NGINX Agent instance is registered with Instance Manager, no additional action is required for monitoring the instance.

{{<note>}}
If you need to remove the instance, ensure that the NGINX Agent service is stopped first. Then you can remove the instance from the inventory.
{{</note>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1035 -->