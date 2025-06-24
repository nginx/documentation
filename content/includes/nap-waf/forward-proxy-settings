Enable Forward Proxy settings
in order to Enable proxy setting for Ip Intellegnice client, edit:
```shell
/etc/app_protect/tools/iprepd.cfg
```
and set following, For example:: 
```shell
EnableProxy=True 
ProxyHost=5.1.2.4
ProxyPort=8080
ProxyUsername=admin (optional)
ProxyPassword=admin (optional)
CACertPath=/etc/ssl/certs/ca-certificates.crt (optional)
```
then re run the client again
```shell
/opt/app_protect/bin/iprepd /etc/app_protect/tools/iprepd.cfg > ipi.log 2>&1 &
```
