---
nd-docs: null
nd-files:
- content/nap-dos/deployment-guide/learn-about-deployment.md
- content/nap-dos/deployment-guide/kubernetes.md
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
    2020/09/07 15:33:44 [notice] 9307#9307: using the "epoll" event method
    2020/09/07 15:33:44 [notice] 9307#9307: nginx/1.19.0 (nginx-plus-r22)
    2020/09/07 15:33:44 [notice] 9307#9307: built by gcc 4.8.5 20150623 (Red Hat 4.8.5-39) (GCC)
    2020/09/07 15:33:44 [notice] 9307#9307: OS: Linux 3.10.0-327.28.3.el7.x86_64
    2020/09/07 15:33:44 [notice] 9307#9307: getrlimit(RLIMIT_NOFILE): 1024:4096
    2020/09/07 15:33:44 [notice] 9310#9310: start worker processes
    2020/09/07 15:33:44 [notice] 9310#9310: start worker process 9311
    PID <9311>, WORKER <0>, Function adm_ngx_init_process, line 684, version: 22+1.19.4-1.el7.ngx
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

To check F5 WAF for NGINX alongside F5 DoS for NGINX, just perform the normal tests as specified at [Admin Guide](https://docs.nginx.com/waf/install/virtual-environment/#post-installation-checks)
