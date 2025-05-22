---
docs:
---

You can add an instance to NGINX One Console in the following ways:

- Directly, under **Instances**
- Indirectly, by selecting a Config Sync Group, and selecting **Add Instance to Config Sync Group**

In either case, NGINX One Console gives you a choice for data plane keys:

- Create a new key
- Use an existing key

NGINX One Console takes the option you use, and adds the data plane key to a command that you'd use to register your target instance. You should see the command in the **Add Instance** screen in the console.

Connect to the host where your NGINX instance is running. Run the provided command to [install NGINX Agent]({{< ref "/nginx-one/getting-started#install-nginx-agent" >}}) dependencies and packages on that host.

```bash
curl https://agent.connect.nginx.com/nginx-agent/install | DATA_PLANE_KEY="<data_plane_key>" sh -s -- -y
```

Once the process is complete, you can configure that instance in your NGINX One Console.