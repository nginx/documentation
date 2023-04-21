To use PostgreSQL for the Dev Portal database, take the following steps:

1. Run the following command(s) to install PostgreSQL:

    - CentOS, RHEL, RPM-based

        ```bash
        sudo yum install -y postgresql-server
        sudo postgresql-setup initdb
        ```

    - Debian, Ubuntu, Deb-based

        ```bash
        sudo apt-get install -y postgresql
        ```

2. Configure the PostgreSQL host-based authentication (HBA) file:

    - CentOS, RHEL, RPM-based

        ``` bash
        cat << EOF | sudo tee /var/lib/pgsql/data/pg_hba.conf

        # TYPE DATABASE USER ADDRESS METHOD

        local all postgres peer
        local all all md5
        # IPv4 local connections:
        host all all 127.0.0.1/32 md5
        # IPv6 local connections:
        host all all ::1/128 md5
        EOF
        ```

    - Debian, Ubuntu, Deb-based

        ``` bash
        cat << EOF | sudo tee /etc/postgresql/<pg_version>/main/pg_hba.conf

        # TYPE DATABASE USER ADDRESS METHOD

        local all postgres peer
        local all all md5
        # IPv4 local connections:
        host all all 127.0.0.1/32 md5
        # IPv6 local connections:
        host all all ::1/128 md5
        EOF
        ```

3. Restart PostgreSQL:

    ``` bash
    sudo systemctl restart postgresql
    ```

4. Create the `devportal` database, add the `nginxdm` user, and assign privileges:

    ```bash
    sudo -u postgres createdb devportal
    sudo -u postgres psql -c "CREATE USER nginxdm WITH LOGIN PASSWORD 'nginxdm';"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE devportal TO nginxdm;"
    ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-1017 -->