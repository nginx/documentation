### Platform Requirements {#acm-devportal-requirements}

The Developer Portal has the following platform requirements:

- A **dedicated** Linux host. **Do not** install the Developer Portal on a host that is serving as a management or data plane.
- [NGINX Plus R24 or later](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/)

    <details closed>
    <summary><i class="fa-solid fa-circle-info"></i> Supported Linux distributions</summary>

    {{< include "tech-specs/acm-dev-portal-supported-distros.md" >}}

    </details>

- [NGINX njs module](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/)
- A PostgreSQL or SQLite database to store configuration settings and analytics information. (Step 3 below)


### Installation Steps

1. Follow the steps to [add the NGINX Instance Manager Repo](#add-yum-apt) to Yum or Apt.

1. Run the following command(s) for your Linux distribution to install the Developer Portal:

   - CentOS, RHEL, RPM-based

       ```bash
       sudo yum -y install nginx-devportal nginx-devportal-ui
       ```

   - Debian, Ubuntu, Deb-based

       ```bash
       sudo apt-get update
       sudo apt-get -y install nginx-devportal nginx-devportal-ui
       ```

1. Select one of the following database options for your installation:
  
    <details>
    <summary>Install PostgreSQL</summary>

    {{< include "acm/installation/install-postgresql.md" >}}

    </details>

    <details>
    <summary>Install SQLite</summary>

    To use SQLite for the Dev Portal database, take the following steps:

    1. Set up the SQLite database:

        ```bash
        echo 'DB_TYPE="sqlite"' | sudo tee -a /etc/nginx-devportal/devportal.conf
        echo 'DB_PATH="/var/lib/nginx-devportal"' | sudo tee -a /etc/nginx-devportal/devportal.conf
        ```

    </details>

1. Start the Dev Portal:

    ```bash
    sudo systemctl start nginx-devportal
    ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1014 -->