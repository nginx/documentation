---
---

```dos-nginx-conf-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: dos-nginx-conf
  namespace: app-protect-dos
data:
  nginx.conf: |

    user  nginx;
    worker_processes  auto;
    error_log  /var/log/nginx/error.log error;
    worker_rlimit_nofile 65535;

    load_module modules/ngx_http_app_protect_dos_module.so;

    working_directory /tmp/cores;

    events {
      worker_connections 65535;
    }

    http {

        app_protect_dos_arb_fqdn svc-appprotect-dos-arb.arb.svc.cluster.local;

        sendfile        on;
        tcp_nopush      on;
        keepalive_timeout 65;

        log_format log_dos
            ', vs_name_al=$app_protect_dos_vs_name, ip=$remote_addr, tls_fp=$app_protect_dos_tls_fp, '
            'outcome=$app_protect_dos_outcome, reason=$app_protect_dos_outcome_reason, '
            'ip_tls=$remote_addr:$app_protect_dos_tls_fp, ';

        app_protect_dos_accelerated_mitigation on syn_drop=on;


        # Health endpoints for probes
        server {
            listen 8090;
            location /app_protect_dos_liveness { return 200; }
            location /app_protect_dos_readiness { return 200; }
        }

        server {
            listen          80 reuseport;
            server_name     serv;

            access_log /var/log/nginx/access.log log_dos if=$loggable;
            app_protect_dos_security_log_enable on;
            app_protect_dos_security_log "/etc/app_protect_dos/log-default.json" syslog:server=10.197.30.219:5261;
            app_protect_dos_policy_file "/etc/app_protect_dos/BADOSDefaultPolicy.json";

            location / {
                app_protect_dos_enable on;
                app_protect_dos_name "main_serv";
                app_protect_dos_monitor uri=http://serv:80/ protocol=http1;
                proxy_pass  http://127.0.0.1/proxy$request_uri;
            }
    
            location /proxy {
                app_protect_dos_enable off;
                client_max_body_size 0;
                default_type text/html;
                return 200 "Hello! I got your URI request - $request_uri\n";
            }
       }
    }
```