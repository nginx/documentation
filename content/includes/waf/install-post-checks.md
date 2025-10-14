---
nd-docs:
---

The following steps check that F5 WAF for NGINX enforcement is operational.

They should be ran in the environment with the WAF components.

Check that the three processes for F5 WAF for NGINX are running using `ps aux`:

- _bd-socket-plugin_
- _nginx: master process_
- _nginx: worker process_

```shell
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         8  1.3  2.4 3486948 399092 ?      Sl   09:11   0:02 /usr/share/ts/bin/bd-socket-plugin tmm_count 4 proc_cpuinfo_cpu_mhz 2000000 total_xml_memory 307200000 total_umu_max_size 3129344 sys_max_account_id 1024 no_static_config
root        14  0.0  0.1  71060 26680 ?        S    09:11   0:00 nginx: master process /usr/sbin/nginx -c /tmp/policy/test_nginx.conf -g daemon off;
root        26  0.0  0.3  99236 52092 ?        S    09:12   0:00 nginx: worker process
root        28  0.0  0.0  11788  2920 pts/0    Ss   09:12   0:00 bash
root        43  0.0  0.0  47460  3412 pts/0    R+   09:14   0:00 ps aux
```

Verify there are no errors in the file `/var/log/nginx/error.log` and that the policy compiled successfully:

```none
2020/05/10 13:21:04 [notice] 402#402: APP_PROTECT { "event": "configuration_load_start", "configSetFile": "/opt/f5waf/config/config_set.json" }
2020/05/10 13:21:04 [notice] 402#402: APP_PROTECT policy 'app_protect_default_policy' from: /etc/app_protect/conf/NginxDefaultPolicy.json compiled successfully
2020/05/10 13:21:04 [notice] 402#402: APP_PROTECT { "event": "configuration_load_success", "software_version": "1.1.1", "attack_signatures_package":{"revision_datetime":"2019-07-16T12:21:31Z"},"completed_successfully":true}
2020/05/10 13:21:04 [notice] 402#402: using the "epoll" event method
2020/05/10 13:21:04 [notice] 402#402: nginx/1.17.6 (nginx-plus-r20)
2020/05/10 13:21:04 [notice] 402#402: built by gcc 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC)
2020/05/10 13:21:04 [notice] 402#402: OS: Linux 3.10.0-957.27.2.el7.x86_64
2020/05/10 13:21:04 [notice] 402#402: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2020/05/10 13:21:04 [notice] 406#406: start worker processes
2020/05/10 13:21:04 [notice] 406#406: start worker process 407
```

Check that sending an attack signature in a request returns a response block page containing a support ID:

```shell
Request:
http://10.240.185.211/?a=<script>

Response:
The requested URL was rejected. Please consult with your administrator.

Your support ID is: 9847191526422998597

[Go Back]
```

If your policy includes JSON/XML profiles, check `/var/log/app_protect/bd-socket-plugin.log` for possible errors:

```shell
grep '|ERR' /var/log/app_protect/bd-socket-plugin.log
```

Verify that Enforcement functionality is working by checking the following request is rejected:

```shell
curl "localhost/<script>"
```

If you notice problems, there are ways to remediate them based on the context:

| Description             | Solution  |
| ----------------------- | --------  |
| *NGINX is not running or F5 WAF for NGINX does not behave as expected* | Review warning or error messages within [the log files]({{< ref "/waf/logging/logs-overview.md" >}}) |
| *unknown directive app_protect_xxx error message* | Ensure F5 WAF for NGINX is [loaded as a module](#update-configuration-files) in the main context of NGINX configuration. |
| *Too many open files error message* | Increase the maximum amount of open files with the [worker_rlimit_nofile](https://nginx.org/en/docs/ngx_core_module.html#worker_rlimit_nofile) directive. |
| *setrlimit ... failed (Permission denied) error message* | Increase the limit by by running the following command as root: `setsebool -P httpd_setrlimit 1` |