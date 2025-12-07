---
nd-docs: null
nd-files:
- content/nap-dos/deployment-guide/learn-about-deployment.md
- content/nap-dos/deployment-guide/kubernetes.md
- content/nap-dos/deployment-guide/kubernetes-with-L3-mitigation.md
---

You can run the following commands to ensure that F5 DoS for NGINX enforcement is operational.

1. Check that the three processes needed for F5 DoS for NGINX are running using `ps aux`:

    - admd
    - nginx: master process
    - nginx: worker process

    ```shell
    USER       PID   %CPU   %MEM    VSZ    RSS TTY      STAT  START     TIME  COMMAND
    nginx      7759   0.0    0.0   113120  1200 ?       Ss    Sep06     0:00  /bin/sh -c /usr/bin/admd -d --log info > /var/log/adm/admd.log 2>&1
    root       7765   0.0    0.0   87964   1464 ?       Ss    Sep06     0:00  nginx: master process /usr/sbin/nginx -g daemon off;
    nginx      7767   0.0    0.1   615868  8188 ?       Sl    Sep06     0:04  nginx: worker process
    ```

2. Verify that there are no NGINX errors in the `/var/log/nginx/error.log` and that the policy compiled successfully:

    ```shell
    2025/12/07 09:14:34 [notice] 675#675: APP_PROTECT_DOS { "event": "shared_memory_connected", "worker_pid": 675, "mode": "operational", "mode_changed": true }
    2025/12/07 09:14:34 [notice] 675#675: using the "epoll" event method
    2025/12/07 09:14:34 [notice] 675#675: APP_PROTECT_DOS { "event": "configuration_load_success", "software_version": "36+4.8.3-1.el8.ngx"}
    2025/12/07 09:14:34 [notice] 675#675: nginx/1.29.3 (nginx-plus-r36)
    2025/12/07 09:14:34 [notice] 675#675: built by gcc 8.5.0 20210514 (Red Hat 8.5.0-28) (GCC)
    2025/12/07 09:14:34 [notice] 675#675: OS: Linux 6.8.0-88-generic
    2025/12/07 09:14:34 [notice] 675#675: getrlimit(RLIMIT_NOFILE): 1048576:1048576
    2025/12/07 09:14:34 [notice] 675#675: start worker processes
    2025/12/07 09:14:34 [notice] 675#675: start worker process 679
    2025/12/07 09:14:34 [notice] 679#679: APP_PROTECT_DOS { "event": "shared_memory_connected", "worker_pid": 679, "mode": "operational", "mode_changed": true }
    ```

3. Check that by applying an attack, the attacker IP addresses are blocked while the good traffic pass through:

   a. Simulate good traffic:

    ```shell
    echo "Start Good Traffic 2"
    while true; do
      curl ${VS}/good1 &
      curl ${VS}/good2 &
      curl ${VS}/good3 &
      curl ${VS}/good4
      sleep 0.1
      done &
    ```

   b. After 7 minutes start the attack:

   ```shell
   while [ true ]
   do
   ab -B ${BAD_IP1} -l -r -n 1000000 -c 150 -d -H "Host: evil.net" -H "Pragma: no-cache" -H "Cache-Control: no-cache" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: WireXBot" -H "x-requested-with:" -H "Referer: http://10.0.2.1/none.html" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: en-US" http://${VS}/ &
   ab -B ${BAD_IP2} -l -r -n 1000000 -c 150 -d -H "Host: evil.net" -H "Pragma: no-cache" -H "Cache-Control: no-cache" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: WireXBot" -H "x-requested-with:" -H "Referer: http://10.0.2.1/none.html" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: en-US" http://${VS}/ &
   ab -B ${BAD_IP3} -l -r -n 1000000 -c 150 -d -s 10 -H "Host: evil.net" -H "Pragma: no-cache" -H "Cache-Control: no-cache" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: WireXBot" -H "x-requested-with:" -H "Referer: http://10.0.2.1/none.html" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: en-US" http://${VS}/

    killall ab
    done
    ```

   c. See that the good traffic continue as usual while the attackers receive denial of service.

4. For DOS with L3 mitigation enabled

Check that the ebpf_manager_dos process needed for F5 DoS for NGINX is running using `ps aux | grep /usr/bin/ebpf_manager_dos`:

```
root           1  0.0  0.0   4324  3072 ?        Ss   19:32   0:00 bash -c /usr/bin/ebpf_manager_dos 2>&1 | tee /shared/ebpf_dos.log
root           7  0.2  0.0 1722732 14208 ?       Sl   19:32   0:01 /usr/bin/ebpf_manager_dos
root          46  0.0  0.0   3528  1792 pts/0    S+   19:44   0:00 grep --color=auto /usr/bin/ebpf_manager_dos
```

Verify that there are no errors in the `/shared/ebpf_dos.log` and that the XDP program uploaded successfully:

```[2025-12-02 19:32:12] INFO: Uninstall old eBPF maps and XDP program
[2025-12-02 19:32:13] INFO: Install eBPF maps and XDP program
[2025-12-02 19:32:13] INFO: Start ebpf manager
[2025-12-02 19:32:13] INFO: Version: 36+4.8.3-1~noble
[2025-12-02 19:32:13] INFO: Start Periodic task for update time
[2025-12-02 19:32:13] INFO: Owner of the UDS has been changed to user nginx and group nginx.
[2025-12-02 19:32:13] INFO: Permissions of the UDS have been changed successfully for user nginx and group nginx.
[2025-12-02 19:32:13] INFO: Async Callback Server listening on unix:/shared/ebpf_manager_dos_uds
```

To check F5 WAF for NGINX alongside F5 DoS for NGINX, just perform the normal tests as specified at [Admin Guide](https://docs.nginx.com/waf/install/virtual-environment/#post-installation-checks)
