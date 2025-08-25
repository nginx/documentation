---
nd-docs:
---

Create a _docker-compose.yml_ file with the following contents in your host environment, replacing image tags as appropriate:

```yaml
services:
  waf-enforcer:
    container_name: waf-enforcer
    image: waf-enforcer:5.2.0
    environment:
      - ENFORCER_PORT=50000
    ports:
      - "50000:50000"
    volumes:
      - /opt/app_protect/bd_config:/opt/app_protect/bd_config
    networks:
      - waf_network
    restart: always

  waf-config-mgr:
    container_name: waf-config-mgr
    image: waf-config-mgr:5.2.0
    volumes:
      - /opt/app_protect/bd_config:/opt/app_protect/bd_config
      - /opt/app_protect/config:/opt/app_protect/config
      - /etc/app_protect/conf:/etc/app_protect/conf
    restart: always
    network_mode: none
    depends_on:
      waf-enforcer:
        condition: service_started

networks:
  waf_network:
    driver: bridge
```

{{< call-out "caution" >}}

In some operating systems, security mechanisms like SELinux or AppArmor are enabled by default, potentially blocking necessary file access for the nginx process and waf-config-mgr and waf-enforcer containers.

To ensure NGINX App Protect WAF operates smoothly without compromising security, consider setting up a custom SELinux policy or AppArmor profile. 

For short-term troubleshooting, you may use permissive (SELinux) or complain (AppArmor) mode to avoid these restrictions, but this is inadvisable for prolonged use.

{{< /call-out >}}

To start the F5 WAF for NGINX services, use `docker compose up` in the same folder as the _docker-compose.yml_ file:

```shell
sudo docker compose up -d
```