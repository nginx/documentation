---
title: "Instance Manager Examples"
draft: true
---

# Examples for Instance Manager Server UI/API and gRPC

NGINX Plus conf files for proxying traffic to the NGINX Instance Manager Server.  By default, Instance Manager runs on 127.0.0.1 (not external).
NGINX Plus is included for use to front end NGINX Instance Manager for more advanced use cases and to provide authentication options.
You may use NGINX Plus from the same repository for this purpose (you may not use this copy for other purposes).
The files here can be dropped into the /etc/nginx/conf.d directory and loaded into nginx for use.
Change the port in the appropriate conf file and adjust firewall and selinux rules accordingly to your organizations's practices.
These are suggestions only, for help configuring authentication, please reach out to your account team.
NGINX offers Professional Service engagements to ensure authentication is setup correctly, securely and quickly.

## nginx-manager-upstreams.conf

Provides upstream for 127.0.0.1 proxy, you need to include this file for all the API/UI proxy examples below.

## nginx-manager-noauth.conf

Provides no authentication, proxies API/UI traffic from a specific port to the 127.0.0.1 API/UI Instance Manager server.

## nginx-manager-basicauth.conf

Provides basic authentication, proxies API/UI traffic from a specific port to the 127.0.0.1 API/UI Instance Manager server.
You need to generate an .htpasswd files and put this in the /etc/nginx directory to use this function.
Add users and passwords as appropriate.

## nginx-manager-jwt.conf

Provides JWT authentication, proxies API/UI traffic from a specific port to the 127.0.0.1 API/UI Instance Manager server.

## nginx-manager-jwt-index.html

This is just a demo html page to help understand the Clain values and information, it has no other purpose.

## nginx-manager-oauth.conf

Provides oauth2/OpenID Connect authentication, proxies API/UI traffic from a specific port to the 127.0.0.1 API/UI Instance Manager server.
You need to also include the njs module and follow the instructions from our openidconnect repo. <https://github.com/nginxinc/nginx-openid-connect>
Please ensure you select the correct branch/tag for the NGINX Plus version you use.  We default to the latest (R23 as of January 1, 2021).
Adjust and add the files according to the instructions.  Use the nginx-manager-oauth.conf for the frontend.conf section.

Hints:

- Use private browsing or incognito mode for all testing.
- Be sure to close/restart your browser for new sessions.
- Check time and date on the server for expired token issues.
- Be sure you pulled the specific tag/branch for the NGINX Plus version on the git repo.

## compass-grpc.conf

Provides basic gRPC proxying of agent/server traffic from port 10002 to 10000 on the nginx-manager.
Agents should point to port 10002 in their configurations.  gRPC uses http2 in the listener.

## status-api.conf

Provides NGINX Plus Status Page over port 8080.  Useful for troubleshooting or learning more about NGINX.
Dashboard is accessible on <http://127.0.0.1:8080/dashboard.html> and the dynamic API is <http://127.0.0.1:8080/api>
