To install directly from package files, you'll need to download the files from the [MyF5 Customer Portal](https://account.f5.com/myf5) or use the package files provided by your NGINX Sales Team. The file you need is `agent-install.sh`.

To install from package files, take the following steps:

1. Copy `agent-install.sh` to the data plane host where you want to install the NGINX Agent.
2. Run the following command to install OR update NGINX Agent:

    ```bash
    sudo PACKAGE_HOST=<NMS_FQDN> ./agent-install.sh 
    ```

   {{<note>}}
   In the example above, `<NMS_FQDN>` is the the fully qualified domain name or IP address for the Instance Manager API gateway.
   {{</note>}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1032 -->