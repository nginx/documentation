---
draft: true
title: JWT Examples
---

## Examples for Instance Manager Server UI/API and gRPC

NGINX Plus conf files for proxying traffic to the NGINX Instance Manager Server.  By default, Instance Manager runs on 127.0.0.1 (not external).
NGINX Plus is included for use to front end NGINX Instance Manager for more advanced use cases and to provide authentication options.
You may use NGINX Plus from the same repository for this purpose (you may not use this copy for other purposes).
The files here can be dropped into the /etc/nginx/conf.d directory and loaded into nginx for use.
Change the port in the appropriate conf file and adjust firewall and selinux rules accordingly to your organizations's practices.
These are suggestions only, for help configuring authentication, please reach out to your account team.
NGINX offers Professional Service engagements to ensure authentication is setup correctly, securely and quickly.

### nginx-manager-jwt-index.html

This is just a demo html page to help understand the Clain values and information, it has no other purpose.

### api_secret.jwk

JWT Key for nginx-manager-jwt.conf.  DO NOT USE IN PROD but fine for internal testing pipelines.
From Alan Murphy simple JWT Demo in show-demos. <https://github.com/nginxinc/show-demos/blob/master/alan-simple-jwt-example/api_secret.jwk>

### uid-111.jwt and uid-222.jwt

JWTs for uid 111 and 222 from the same repo as above to test with if needed.  You can use these to test uid matching.

### Testing

You can test with a curl command similar to the one below to pass in "111 UID" JWT as an argument

```bash
curl -v example.com/nginx-manager-jwt-index.html?myjwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDUxNjk5MjQsIm5hbWUiOiJDcmVhdGUgTmV3IFVzZXIiLCJzdWIiOiJjdXNlciIsImduYW1lIjoid2hlZWwiLCJndWlkIjoiMTAiLCJmdWxsTmFtZSI6IkpvaG4gRG9lIiwidW5hbWUiOiJqZG9lIiwidWlkIjoiMTExIiwic3VkbyI6dHJ1ZSwiZGVwdCI6IklUIiwidXJsIjoiaHR0cDovL3d3dy5uZ2lueC5jb20ifQ._YgsBmEADHL20G1XifQNygbFtl3TosyLCJ7_6C7X6Ss
```

You can also test a cookie with a curl command similar to the one below to pass in "111 UID" JWT as a cookie

```bash
curl -v --cookie myjwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDUxNjk5MjQsIm5hbWUiOiJDcmVhdGUgTmV3IFVzZXIiLCJzdWIiOiJjdXNlciIsImduYW1lIjoid2hlZWwiLCJndWlkIjoiMTAiLCJmdWxsTmFtZSI6IkpvaG4gRG9lIiwidW5hbWUiOiJqZG9lIiwidWlkIjoiMTExIiwic3VkbyI6dHJ1ZSwiZGVwdCI6IklUIiwidXJsIjoiaHR0cDovL3d3dy5uZ2lueC5jb20ifQ._YgsBmEADHL20G1XifQNygbFtl3TosyLCJ7_6C7X6Ss example.com/nginx-manager-jwt-index.html
```
