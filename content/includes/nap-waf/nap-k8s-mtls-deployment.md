To secure traffic between NGINX and App Protect Enforcer using mTLS, follow the steps below:

{{< call-out "note" >}} Refer to the [Configuration Guide]({{< relref "/nap-waf/v5/configuration-guide/configuration.md#secure-traffic-between-nginx-and-app-protect-enforcer-using-mtls" >}}) to generate certificates and modify the `nginx.conf` for mTLS.
{{< /call-out >}}

First, create a Kubernetes Secret that contains the certificate and key files:
	
```shell
	kubectl create secret generic enforcer-certificates \
	--from-file=app_protect_server.crt=/path/to/app_protect_server.crt \
	--from-file=app_protect_server.key=/path/to/app_protect_server.key \
	--from-file=app_protect_client_ca.crt=/path/to/app_protect_client_ca.crt
```

Next, update or create the `nap5-deployment.yaml` to mount the Secret as a volume and set the environment variables to point to the mounted files: 

```yaml
	apiVersion: apps/v1
	kind: Deployment
	metadata:
	  name: nap5-deployment
	spec:
	  selector:
	    matchLabels:
	      app: nap5
	  replicas: 2
	  template:
	    metadata:
	      labels:
	        app: nap5
	    spec:
	      imagePullSecrets:
	          - name: regcred
	      containers:
	        - name: nginx
	          image: <your-private-registry>/nginx-app-protect-5:<your-tag>
	          imagePullPolicy: IfNotPresent
	          volumeMounts:
	            - name: app-protect-bd-config
	              mountPath: /opt/app_protect/bd_config
	            - name: app-protect-config
	              mountPath: /opt/app_protect/config
	            - name: certs
	              mountPath: /etc/ssl/certs
	              readOnly: true
	            - name: waf-enforcer
	              image: private-registry.nginx.com/nap/waf-enforcer:<version-tag>
	              imagePullPolicy: IfNotPresent
	              env:
	                - name: ENFORCER_PORT
	                  value: "4431"
	                - name: ENFORCER_SERVER_CERT
	                  value: "/etc/ssl/certs/app_protect_server.crt"
	                - name: ENFORCER_SERVER_KEY
	                  value: "/etc/ssl/certs/app_protect_server.key"
	                - name: ENFORCER_CA_FILE
	                  value: "/etc/ssl/certs/app_protect_client_ca.crt"
	              volumeMounts:
	                - name: app-protect-bd-config
	                  mountPath: /opt/app_protect/bd_config
	                - name: certs
	                  mountPath: /etc/ssl/certs
	                  readOnly: true
	            - name: waf-config-mgr
	              image: private-registry.nginx.com/nap/waf-config-mgr:<version-tag>
	              imagePullPolicy: IfNotPresent
	              securityContext:
	                allowPrivilegeEscalation: false
	                capabilities:
	                  drop:
	                    - all
	              volumeMounts:
	                - name: app-protect-bd-config
	                  mountPath: /opt/app_protect/bd_config
	                - name: app-protect-config
	                  mountPath: /opt/app_protect/config
	                - name: app-protect-bundles
	                  mountPath: /etc/app_protect/bundles
	          volumes:
	            - name: app-protect-bd-config
	              emptyDir: {}
	            - name: app-protect-config
	              emptyDir: {}
	            - name: app-protect-bundles
	              persistentVolumeClaim:
	                claimName: nap5-bundles-pvc
	            - name: certs
	              secret:
	                secretName: enforcer-certificates
```