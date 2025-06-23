If the deployment intends to use the IP intelligence Feature (available from version 5.7.0), then the IP intelligence container needs to be added to the deployment in the docker compose file.

Modify the original `docker-compose.yml` file to include the additional IP Intelligence container:

```yaml
services:
  waf-enforcer:
    container_name: waf-enforcer
    image: private-registry.nginx.com/nap/waf-enforcer:5.7.0
    environment:
      - ENFORCER_PORT=50000
    ports:
      - "50000:50000"
    volumes:
      - /opt/app_protect/bd_config:/opt/app_protect/bd_config
      - /var/IpRep:/var/IpRep
    networks:
      - waf_network
    restart: always
    user: "101:101"
    depends_on:
      - waf-ip-intelligence

  waf-config-mgr:
    container_name: waf-config-mgr
    image: private-registry.nginx.com/nap/waf-config-mgr:5.7.0
    volumes:
      - /opt/app_protect/bd_config:/opt/app_protect/bd_config
      - /opt/app_protect/config:/opt/app_protect/config
      - /etc/app_protect/conf:/etc/app_protect/conf
    restart: always
    user: "101:101"
    network_mode: none
    depends_on:
      waf-enforcer:
        condition: service_started

  waf-ip-intelligence:
    container_name: waf-ip-intelligence
    image: private-registry.nginx.com/nap/waf-ip-intelligence:5.7.0
    volumes:
      - /var/IpRep:/var/IpRep
    networks:
      - waf_network
    restart: always
    user: "101:101"

networks:
  waf_network:
    driver: bridge
```

Notes:
- Replace `waf-config-mgr`, `waf-enforcer` and `waf-ip-intelligence` tags with the actual release version tag you are deploying. We are using version 5.7.0 for this example deployment.
- By default, the containers `waf-config-mgr`, `waf-enforcer` and `waf-ip-intelligence` operate with the user and group IDs set to 101:101. Ensure that the folders and files are accessible to these IDs.

Before creating the deployment in docker compose, create the required directories:

```shell
sudo mkdir -p /opt/app_protect/config /opt/app_protect/bd_config /var/IpRep
```

Then set correct ownership:

```shell
sudo chown -R 101:101 /opt/app_protect/ /var/IpRep
```
