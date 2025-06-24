Enable Forward Proxy Settings for IP Intelligence Client. 

To configure proxy settings, edit the client configuration file:
Path:
```shell
/etc/app_protect/tools/iprepd.cfg
```
Example configuration:
```shell
EnableProxy=True 
ProxyHost=5.1.2.4
ProxyPort=8080
ProxyUsername=admin        # Optional
ProxyPassword=admin        # Optional
CACertPath=/etc/ssl/certs/ca-certificates.crt  # Optional 
```
After saving the changes, restart the client to apply the new settings.
```shell
/opt/app_protect/bin/iprepd /etc/app_protect/tools/iprepd.cfg > ipi.log 2>&1 &
```
