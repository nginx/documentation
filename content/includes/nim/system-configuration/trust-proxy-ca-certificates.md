---
---

1. Copy the proxy CA certificate into the system’s trusted certificate directory, for example **/usr/local/share/ca-certificates/** or **/etc/ssl/certs/** (path varies by distribution).
1. Run the appropriate command to update the system’s trusted certificates:

    - **Debian/Ubuntu**:

       ```bash
       sudo update-ca-certificates
       ``` 

    - **RHEL/CentOS**:

        ```shell
        sudo update-ca-trust
        ```
