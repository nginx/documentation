---
title: Troubleshooting
toc: true
weight: 700
docs: DOCS-000
nd-docs: DOCS-1878
---

## F5 NGINX Agent Troubleshooting 

**1. Container running but Agent is not connected to NGINX One Console?**
- Check Agent logs ```bash
        docker logs <container-id-or-name>
        ```
- If you are using NGINX Plus, a valid license will need to be passed into the container run command. 
- Ensure that the values sent with the container run command are correct.

**2. Container running but instance is showing offline on NGINX One Console?**
- Check Agent logs ```bash
        docker logs  c5e1e3234900 | grep "nginx"
        ```
- Verify the following log message is shown: ```2025/02/17 19:02:58 [notice] 32#32: nginx/1.27.2 (nginx-plus-r33-p2 ```
- If not found, it could mean the container image is missing the NGINX service
- Make sure NGINX is running ```ps -ef | grep "nginx"```
- Make sure NGINX is part of the image file.


**3. NGINX Agent is installed on my Virtual Machine, but not showing up on NGINX One Console?**
- Verify the agent is running ```sudo systemctl status nginx-agent```
- Check for any errors in the logs ```sudo tail -f /var/log/nginx-agent/agent.log```
- Check ```/etc/nginx-agent/nginx-agent.conf``` for any misconfigurations.
