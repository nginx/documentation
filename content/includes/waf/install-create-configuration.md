---
---

Copy or move your subscription files into a new folder.

In the same folder, create three files:

- _nginx.conf_ - An NGINX configuration file with F5 WAF for NGINX enabled
- _entrypoint.sh_ - A Docker startup script which spins up all F5 WAF for NGINX processes, requiring executable permissions
- _custom_log_format.json_ - An optional user-defined security log format file

{{< call-out "note" >}}

If you are not using using `custom_log_format.json`, you should remove any references to it from your nginx.conf and entrypoint.sh files.

{{< /call-out >}}

Here are examples of the file contents: 