To upgrade the NGINX Agent, take the following steps:

1. Open an SSH connection to the server where you've installed the NGINX Agent and log in.

1. Make a backup copy of the following locations to ensure that you can successfully recover if the upgrade has issues:

   - `/etc/nginx-agent`
   - `config_dirs` values for any configuration specified in `/etc/nginx-agent/nginx-agent.conf`

1. Stop the NGINX Agent:

   ```bash
   sudo systemctl stop nginx-agent
   ```

1. Install the updated version of the NGINX Agent:

   - CentOS, RHEL, RPM-Based

      ```bash
      sudo yum -y makecache
      sudo yum update -y nginx-agent
      ```

   - Debian, Ubuntu, Deb-Based

      ```bash
      sudo apt-get update
      sudo apt-get install -y --only-upgrade nginx-agent -o Dpkg::Options::="--force-confold" 
      ```

1. Start the NGINX Agent:

   ```bash
   sudo systemctl start nginx-agent
   ```
<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1034 -->