To enable mTLS in NGINX, you need to perform the following steps:

1. Generate certificates and keys for both components - NGINX (client) and the App Protect Enforcer (server). 

    Below are the steps for using self-signed certificates:

    {{< note >}} The below commands will generate a self-signed certificates in `/etc/ssl/certs/`  valid for the default period of 30 days. You can adjust the command to fit your needs. For instance, to specify a different validity period, add the `-days` option followed by the number of days you want the certificate to be valid (for example, `-days 90`).
	{{< /note >}}

    ```shell
	mkdir -p /etc/ssl/certs
	openssl genpkey -algorithm RSA -out /etc/ssl/certs/app_protect_server_ca.key
	openssl genpkey -algorithm RSA -out /etc/ssl/certs/app_protect_client_ca.key
	openssl req -x509 -new -key /etc/ssl/certs/app_protect_server_ca.key -out /etc/ssl/certs/app_protect_server_ca.crt -subj "/O=F5/OU=app-protect/CN=mTLS Server Root CA"
	openssl req -x509 -new -key /etc/ssl/certs/app_protect_client_ca.key -out /etc/ssl/certs/app_protect_client_ca.crt -subj "/O=F5/OU=app-protect/CN=mTLS Client Root CA"
	```

    Generate a certificate and key for the App Protect Enforcer (server):
	
    ```shell
    openssl genpkey -algorithm RSA -out /etc/ssl/certs/app_protect_server.key
	openssl req -new -key /etc/ssl/certs/app_protect_server.key -out /etc/ssl/certs/app_protect_server_csr.crt -subj "/O=F5/OU=app-protect/CN=mTLS"
	openssl x509 -req -in /etc/ssl/certs/app_protect_server_csr.crt -CA /etc/ssl/certs/app_protect_server_ca.crt -CAkey /etc/ssl/certs/app_protect_server_ca.key -out /etc/ssl/certs/app_protect_server.crt -CAcreateserial
	```

    Generate a client certificate and key for the NGINX (client):

    ```shell
	openssl genpkey -algorithm RSA -out /etc/ssl/certs/app_protect_client.key
	openssl req -new -key /etc/ssl/certs/app_protect_client.key -out /etc/ssl/certs/app_protect_client_csr.crt -subj "/O=F5/OU=app-protect/CN=mTLS"
	openssl x509 -req -in /etc/ssl/certs/app_protect_client_csr.crt -CA /etc/ssl/certs/app_protect_client_ca.crt -CAkey /etc/ssl/certs/app_protect_client_ca.key -out /etc/ssl/certs/app_protect_client.crt -CAcreateserial
	```

2. Open the NGINX configuration file `nginx.conf` and perform the following steps:
	
	Create a top‑level [`stream {}`](https://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream) block or modify the existing one and add the following configuration:
	
	```nginx
	stream {
	    upstream enforcer {
	        # Replace with the actual App Protect Enforcer address and port if different
	        server 127.0.0.1:4431;
	    }
	        
	    server {
	        listen 5000;
	        proxy_pass enforcer;
	        proxy_ssl_server_name on;
	        proxy_timeout 60m;
	        proxy_ssl on;
            proxy_ssl_certificate /etc/ssl/certs/app_protect_client.crt;
		    proxy_ssl_certificate_key /etc/ssl/certs/app_protect_client.key;
		    proxy_ssl_trusted_certificate /etc/ssl/certs/app_protect_server_ca.crt;
	    }
	```
	
	In the above configuration:
	
	- The `upstream enforcer` block specifies the App Protect Enforcer server listening on port `4431`
	- The `proxy_pass` is used to proxy requests to the enforcer upstream
	- `ssl_certificate` and `ssl_certificate_key` specify the NGINX (client) certificate and key
	- The `proxy_ssl_trusted_certificate` enables the enforcer (server) certificate verification.

	Use this stream server as the `app_protect_enforcer_address` value: 
	    
	```nginx
	app_protect_enforcer_address 127.0.0.1:5000; 
	```

    Configuration Example: 

    ```nginx
    user nginx;
    worker_processes auto;
    worker_shutdown_timeout 10s; # NGINX gives worker processes 10 seconds to gracefully terminate before it will actively close connections
    load_module modules/ngx_http_app_protect_module.so;
    error_log /var/log/nginx/error.log notice;

    events {
            worker_connections 65536;
        }

    stream {
    upstream enforcer {
        server 127.0.0.1:4431;
    }
    
    server {
        listen 5000;
        proxy_pass enforcer;
        proxy_ssl_server_name on;
        proxy_timeout 60m;
        proxy_ssl on;
        proxy_ssl_certificate /etc/ssl/certs/app_protect_client.crt;
	    proxy_ssl_certificate_key /etc/ssl/certs/app_protect_client.key;
	    proxy_ssl_trusted_certificate /etc/ssl/certs/app_protect_server_ca.crt;
    }
    
    http {
        include /etc/nginx/mime.types;
        default_type application/octet-stream;
        sendfile on;
        keepalive_timeout 65;

        app_protect_enforcer_address 127.0.0.1:5000; 
    
        server {
            listen 80;
            server_name localhost;
            proxy_http_version 1.1;

            app_protect_enable on;
            app_protect_policy_file "/etc/app_protect/conf/app_protect_default_policy.tgz";
            app_protect_security_log_enable on;
            app_protect_security_log "/etc/app_protect/conf/log_all.tgz" syslog:server=127.0.0.1:514;
    
            location / {
                client_max_body_size 0;
                default_type text/html;
                # Pass traffic to backend
                proxy_pass http://127.0.0.1:8080/;
            }
        }
    }
    ```

3. Add the following environment variables to the `waf-enforcer` container in your Docker Compose or Kubernetes deployment file:

    - ENFORCER_PORT
    - ENFORCER_SERVER_CERT
    - ENFORCER_SERVER_KEY
    - ENFORCER_CA_FILE

    Refer to the example for mTLS deployment in the admin guide, whether you're using [Docker]({{< relref "/nap-waf/v5/admin-guide/deploy-on-docker.md#docker-compose-file-with-mtls" >}}) or [Kubernetes]({{< relref "/nap-waf/v5/admin-guide/deploy-on-kubernetes.md#mtls-deployment" >}}).
    
