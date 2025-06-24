Enable Forward Proxy settings to enable proxy settings for IP Intellegence client, edit configuration file:
```shell
/etc/app_protect/tools/iprepd.cfg
```
and set the following, for example:
```shell
EnableProxy=True 
ProxyHost=5.1.2.4
ProxyPort=8080
ProxyUsername=admin (optional)
ProxyPassword=admin (optional)
CACertPath=/etc/ssl/certs/ca-certificates.crt (optional)
```
Then re re-run the client again:
```shell
/opt/app_protect/bin/iprepd /etc/app_protect/tools/iprepd.cfg > ipi.log 2>&1 &
```
