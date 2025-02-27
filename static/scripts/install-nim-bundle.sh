#!/bin/bash
# NGINX Instance Manager (NIM) bundle installer which installs (NIM) along with all the necessary dependencies.
export NIM_USER=${NIM_USER:-nms}
export NIM_GROUP=${NIM_GROUP:-${NIM_USER}}

if ((BASH_VERSINFO[0] < 4))
then
  echo "Bash version 4 or higher is required to run this script"
  exit 1
fi

# Oracle8 does not have tar installed by default
if ! cmd=$(command -v "tar") || [ ! -x "$cmd" ]; then
    echo "Cannot find tar binary. Install tar to run this script."
    exit 1
fi

NGINX_CERT_PATH="/etc/ssl/nginx/nginx-repo.crt"
NGINX_CERT_KEY_PATH="/etc/ssl/nginx/nginx-repo.key"
LICENSE_JWT_PATH=""
USE_NGINX_PLUS="false"
USE_SM_MODULE="false"
UNINSTALL_NIM="false"
MODE="online"
INSTALL_PATH=""
NIM_VERSION="latest"
NGINX_VERSION="latest"
NGINX_PLUS_VERSION="latest"
NIM_SM_VERSION="latest"
CLICKHOUSE_VERSION="latest"
CLICKHOUSE_LATEST_VERSION="24.9.2.42"
NGINX_LATEST_VERSION=1.27.3-1
NIM_LATEST_VERSION=2.19.0
CURRENT_TIME=$(date +%s)
TEMP_DIR="/tmp/${CURRENT_TIME}"
TARGET_DISTRIBUTION=""
PACKAGE_INSTALLER=""
NMS_NGINX_MGMT_BLOCK="mgmt { \n  usage_report endpoint=127.0.0.1 interval=30m; \n  ssl_verify off; \n}";
NIM_FQDN=""
NIM_CERTS_DIR="/etc/nms/certs"
# Added to account for the renaming of the adc dimension from application to app.
if [ -f "/usr/share/nms/catalogs/dimensions/application.yml" ]; then
    rm /usr/share/nms/catalogs/dimensions/application.yml
fi

set -o pipefail

check_last_command_status(){
   local status_code=$2
   local last_command=$1
   if [ ${status_code} -ne 0 ]; then
     echo "Error: '${last_command}' exited with exit code ${status_code}"
     exit 1;
   else
     echo "Success: '${last_command}' completed successfully."
   fi
}

generate() {
    character_pool='A-Za-z0-9'
    password_length=30
    admin_password=$(LC_ALL=C tr -dc "$character_pool" </dev/urandom | head -c $password_length)
    openssl_version=$(openssl version|cut -d' ' -f 2|cut -d'.' -f 1-)
     if [[ $openssl_version < "1.1.1" ]]; then
        # MD5 only only on older systems
        encrypted_password="$(openssl passwd -1 "$admin_password")"
        printf "WARNING: There is an insecure MD5 hash for the Basic Auth password. Your OpenSSL version is out of date. Update OpenSSL to the latest version.\n"
    else
        encrypted_password="$(openssl passwd -6 "$admin_password")"
    fi
    printf "\nRegenerated Admin password: %s\n\n" "${admin_password}"
    echo "admin:${encrypted_password}">/etc/nms/nginx/.htpasswd
}

updateClickhouseConfig(){
  if  [ ! -f "/etc/clickhouse-server/conf.d/nms-clickhouse.conf" ] ; then
    if [ ! -d "/etc/clickhouse-server/conf.d/" ]; then
      mkdir -p "/etc/clickhouse-server/conf.d"
    fi
cat <<EOL >> /etc/clickhouse-server/conf.d/nms-clickhouse.conf
 <clickhouse>
    <max_concurrent_queries>{{ 2 * number_of_cpu_cores }}</max_concurrent_queries>
    <max_waiting_queries>5</max_waiting_queries>
    <max_connections>100</max_connections>
    <!--- Lower mark cache size from 5GB to 1GB. --->
    <mark_cache_size>1073741824</mark_cache_size>
    <!--- Wait up to 1000ms. --->
    <queue_max_wait_ms>1000</queue_max_wait_ms>
    <!-- maximum query execution time in seconds -->
    <max_execution_time>10</max_execution_time>
    <!-- maximum number of threads that could be allocated from the OS and used for query execution and background operations, default 10000 -->
    <max_thread_pool_size>100</max_thread_pool_size>
    <thread_pool_queue_size>max_thread_pool_size</thread_pool_queue_size>
    <-- number of seconds that clickHouse waits for incoming requests before closing the connection. Defaults to 10 seconds. -->
    <keep_alive_timeout>5</keep_alive_timeout>
    <maximal number of requests through a single keep-alive connection until it will be closed by clickHouse server. Default to 10000.-->
    <max_keep_alive_requests>100</max_keep_alive_requests>
    <profiles>
      <default>
        <!--sets the number of threads performing background merges and mutations for tables with MergeTree engines. default value 16-->
        <background_pool_size>4</background_pool_size>
        <!-- number of rows that are read from the merged parts into memory. choose a value from 1024 and 4096.The default is 8192.-->
        <merge_max_block_size>1024</merge_max_block_size>
        <max_bytes_to_merge_at_max_space_in_pool>1073741824</max_bytes_to_merge_at_max_space_in_pool>
        <number_of_free_entries_in_pool_to_lower_max_size_of_merge>0</number_of_free_entries_in_pool_to_lower_max_size_of_merge>
      </default>
    </profiles>
  </clickhouse>
EOL
fi
}

createNginxMgmtFile(){
  # Check if the mgmt block exists in the file
    if grep -Eq '^[[:space:]]*mgmt' "/etc/nginx/nginx.conf"; then
        printf "Nginx 'mgmt' block found, skipping addition of nginx 'mgmt' block"
    elif grep -Eq '^[[:space:]]*#mgmt' "/etc/nginx/nginx.conf"; then
        printf "Nginx 'mgmt' block disabled, enabling 'mgmt' block"
        sed -i '/#mgmt {/,/#}/d' /etc/nginx/nginx.conf
        # shellcheck disable=SC2059
        printf "${NMS_NGINX_MGMT_BLOCK}" | tee -a /etc/nginx/nginx.conf
    else
        printf "Nginx 'mgmt' block not found, adding 'mgmt' block"
        # shellcheck disable=SC2059
        printf  "${NMS_NGINX_MGMT_BLOCK}" | tee -a /etc/nginx/nginx.conf
    fi
}

findVersionForPackage(){
   pkg_name=$1
   pkg_version=$2
   if [ "${PACKAGE_INSTALLER}" == "apt" ]; then
     readarray -t versions < <(apt-cache madison "${pkg_name}" | grep "${pkg_version}" | cut -d '|' -f2 | tr -d ' ')
     #readarray -t versions < <(echo "${available_versions[@]}"| grep "${pkg_version}") >&2
   else
     if [[ "$pkg_name" == "nginx" ]]; then
      readarray -t versions < <(yum list "${pkg_name}" --repo nginx-stable --showduplicates | grep "${pkg_version}" | cut -d' ' -f2)
     else
      readarray -t versions < <(yum list "${pkg_name}" --showduplicates | grep "${pkg_version}" | tr -s ' ' | cut -d' ' -f2)
     fi
     #readarray -t versions < <(echo "${available_versions[@]}"| grep "${pkg_version}" | cut -d' ' -f2) >&2
   fi
   # Print the array contents
   versions_count=${#versions[@]}
   if [ "${versions_count}" -eq 0 ]; then
      printf "Package %s with version %s not found. See available versions:" "${pkg_name}" "${pkg_version}"
      if [ "${PACKAGE_INSTALLER}" == "apt" ]; then
        apt-cache madison "${pkg_name}"
      else
        yum list "${pkg_name}" --showduplicates
      fi
      exit 110
   elif [ "${versions_count}" -gt 1 ]; then
      printf "Multiple versions found for the package %s. Select your desired version:\n" "${pkg_name}" >&2
      for i in "${!versions[@]}"; do
          printf "%s: %s\n" "$i" "${versions[$i]}" >&2
      done
      read -rp "" index
      echo "${versions[$index]}"
   else
      echo "${pkg_name} with version ${pkg_version} found">&2
      echo "${versions[0]}"
   fi
}

debian_install_nginx(){
    apt-get update \
        && DEBIAN_FRONTEND=noninteractive \
            apt-get install -y --no-install-recommends ca-certificates \
        && update-ca-certificates \
        && apt-get clean
    apt install -y curl gnupg2 ca-certificates lsb-release apt-transport-https
    if [ -f /etc/lsb-release ]; then
      apt install -y ubuntu-keyring
      DEBIAN_FLAVOUR="ubuntu"
    else
      apt install -y debian-archive-keyring
    fi
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
        | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    check_last_command_status "curl https://nginx.org/keys/nginx_signing.key" $?

    if [ -f "/etc/apt/sources.list.d/nginx.list" ]; then
      rm "/etc/apt/sources.list.d/nginx.list"
    fi
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
      http://nginx.org/packages/${DEBIAN_FLAVOUR} `lsb_release -cs` nginx" \
        | sudo tee /etc/apt/sources.list.d/nginx.list

    if [ -f "/etc/apt/sources.list.d/nginx-plus.list" ]; then
      rm "/etc/apt/sources.list.d/nginx-plus.list"
    fi
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/%s `lsb_release -cs` nginx-plus\n" ${DEBIAN_FLAVOUR} \
      | sudo tee /etc/apt/sources.list.d/nginx-plus.list

    if [ -f "/etc/apt/sources.list.d/nim.list" ]; then
          rm "/etc/apt/sources.list.d/nim.list"
    fi
    printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/nms/%s `lsb_release -cs` nginx-plus\n" ${DEBIAN_FLAVOUR} \
      | sudo tee /etc/apt/sources.list.d/nim.list

    if [ -f "/etc/apt/preferences.d/99nginx" ]; then
      rm "/etc/apt/preferences.d/99nginx"
    fi
    echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
      | sudo tee /etc/apt/preferences.d/99nginx

    if [ -f "/etc/apt/apt.conf.d/90pkgs-nginx" ]; then
      rm /etc/apt/apt.conf.d/90pkgs-nginx
    fi
    url_file_download "https://cs.nginx.com/static/files/90pkgs-nginx" "/etc/apt/apt.conf.d/90pkgs-nginx"
    check_last_command_status "curl https://cs.nginx.com/static/files/90pkgs-nginx" $?

    apt-get update

    if [ "${USE_NGINX_PLUS}" == "true" ]; then
      printf "Installing NGINX Plus...\n"
      if [ "${NGINX_PLUS_VERSION}" == "latest" ]; then
        apt-get install -y nginx-plus
      else
        package_version=$(findVersionForPackage "nginx-plus" "${NGINX_PLUS_VERSION}")
        cmd_status=$?
        if [ $cmd_status -ne 0 ]; then
          echo "Package nginx-plus with version ${NGINX_PLUS_VERSION} not found"
          exit $cmd_status
        fi
        apt-get install -y nginx-plus="${package_version}"
        check_last_command_status "apt-get install -y nginx-plus=${package_version}" $?
      fi
      createNginxMgmtFile
    else
      printf "Installing NGINX...\n"
      if [ "${NGINX_VERSION}" == "latest" ]; then
          apt install -y nginx
          check_last_command_status "apt-get install -y nginx" $?
      else
          package_version=$(findVersionForPackage "nginx" "${NGINX_VERSION}")
          cmd_status=$?
          if [ $cmd_status -ne 0 ]; then
            echo "Package nginx with version ${NGINX_VERSION} not found"
            exit $cmd_status
          fi
          echo "Installing nginx version ${package_version}"
          apt-get install -y nginx="${package_version}"
          check_last_command_status "apt-get install -y nginx='${package_version}'" $?
      fi
    fi
}

debian_install_clickhouse(){
    curl https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key | gpg --dearmor \
          | sudo tee /usr/share/keyrings/clickhouse-keyring.gpg >/dev/null
    check_last_command_status "curl https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key" $?

    echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg] https://packages.clickhouse.com/deb stable main" | sudo tee \
      /etc/apt/sources.list.d/clickhouse.list
    apt-get update

    printf "Installing clickhouse....\n"
    if [ "${CLICKHOUSE_VERSION}" == "latest" ]; then
      DEBIAN_FRONTEND=noninteractive  apt-get install -y clickhouse-common-static clickhouse-server clickhouse-client
      check_last_command_status "apt-get install -y clickhouse-server clickhouse-client" $?
    else
      ch_version=$(findVersionForPackage "clickhouse-server" "${CLICKHOUSE_VERSION}")
      cmd_status=$?
      if [ $cmd_status -ne 0 ]; then
        echo "Package clickhouse-server with version ${CLICKHOUSE_VERSION} not found"
        exit $cmd_status
      fi
      echo "Installing clickhouse-server with version ${ch_version}"
      DEBIAN_FRONTEND=noninteractive apt-get install -y clickhouse-common-static="${ch_version}" clickhouse-server="${ch_version}"
      DEBIAN_FRONTEND=noninteractive apt-get install -y clickhouse-client
      check_last_command_status "apt-get install -y clickhouse-server=${ch_version}" $?
    fi
}

debian_install_nim(){

  echo "Installing NGINX Instance Manager..."
  if [ "${NIM_VERSION}" == "latest" ]; then
    apt-get install -y nms-instance-manager
    check_last_command_status "installing NGINX Instance Manager" $?
  else
    package_version=$(findVersionForPackage "nms-instance-manager" "${NIM_VERSION}")
    cmd_status=$?
    if [ $cmd_status -ne 0 ]; then
       echo "Package nms-instance-manager with version ${NIM_VERSION} not found"
       exit $cmd_status
    fi
    apt-get install -y nms-instance-manager="${package_version}"
    check_last_command_status "apt-get install -y nms-instance-manager=${package_version}" $?
  fi

  echo "Enabling clickhouse-server..."
  systemctl enable clickhouse-server
  check_last_command_status "systemctl enable clickhouse-server" $?

  echo "Starting clickhouse-server..."
  systemctl start clickhouse-server
  check_last_command_status "systemctl start clickhouse-server" $?

  echo "Starting nginx..."
  systemctl start nginx
  check_last_command_status " systemctl start nginx" $?

  echo "Starting NGINX Instance Manager..."
  systemctl start nms
  check_last_command_status " systemctl start nms" $?
  echo "Installation is complete"

}

installBundleForDebianDistro() {
  # creating nms group and nms user if it isn't already there
  declare DEBIAN_FLAVOUR="debian"
  if ! getent group "${NIM_GROUP}" >/dev/null; then
    printf "Creating %s group" "${NIM_GROUP}"
    groupadd --system "${NIM_GROUP}" >/dev/null
  fi
  # creating nms user if it isn't already there
  if ! getent passwd "${NIM_USER}" >/dev/null; then
    printf "Creating %s user" "${NIM_USER}"
    useradd \
      --system \
      -g ${NIM_GROUP} \
      --home-dir /nonexistent \
      --comment "${NIM_USER} user added by nim bundle script" \
      --shell /bin/false \
      "${NIM_USER}" >/dev/null
  fi
  debian_install_nginx
  debian_install_clickhouse
  debian_install_nim
  echo "security module installation opted : ${USE_SM_MODULE}"
  if [ "${USE_SM_MODULE}" == "true" ]; then
      nim_major_version=$(nms-core --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | awk -F. '{print $1}')
      nim_minor_version=$(nms-core --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | awk -F. '{print $2}')
      echo "Installed NIM major Version: ${nim_major_version}, minor Version:${nim_minor_version}"
      if [[ $nim_major_version -ge 2 && $nim_minor_version -ge 19 ]]; then
        echo "Note: NGINX Instance Manager version 2.19.0 or later comes with security monitoring installed. skipping installing security monitoring"
      else
        printf "Installing security module...\n"
        if [ "${NIM_SM_VERSION}" == "latest" ]; then
          apt-get install -y nms-sm
          check_last_command_status "apt-get install -y nms-sm" $?
        else
          sm_pkg_version=$(findVersionForPackage "nms-sm" "${NIM_SM_VERSION}")
          cmd_status=$?
          if [ $cmd_status -ne 0 ]; then
             echo "Package nms-sm with version ${NIM_SM_VERSION} not found"
             exit $cmd_status
          fi
          apt-get install -y nms-sm="${sm_pkg_version}"
          check_last_command_status "apt-get install -y nms-sm=${NIM_SM_VERSION}" $?
        fi
        systemctl restart nms
        sleep 5
        systemctl restart nginx
        systemctl start nms-sm
      fi
  else
    systemctl restart nms
    sleep 5
    systemctl restart nginx
  fi
}

installBundleForRPMDistro(){
    # creating nms group and nms user if it isn't already there
    if ! getent group "${NIM_GROUP}" >/dev/null; then
      groupadd --system "${NIM_GROUP}" >/dev/null
    fi

    # creating naas user if he isn't already there
    if ! getent passwd "${NIM_USER}" >/dev/null; then
      useradd \
        --system \
        -g "${NIM_GROUP}" \
        --home-dir /nonexistent \
        --comment "${NIM_USER} user added by manager" \
        --shell /bin/false \
        "${NIM_USER}" >/dev/null
    fi

    if cat /etc/*-release | grep -iq 'Amazon Linux'; then
      os_type="amzn2"
    else
      os_type="centos"
    fi

    if [ -f "/etc/yum.repos.d/nginx.repo" ]; then
      rm -f /etc/yum.repos.d/nginx.repo
    fi
    printf "[nginx-stable]\nname=nginx stable repo\nbaseurl=http://nginx.org/packages/$os_type/\$releasever/\$basearch/\ngpgcheck=1\nenabled=1\ngpgkey=https://nginx.org/keys/nginx_signing.key\nmodule_hotfixes=true"  >> /etc/yum.repos.d/nginx.repo

    if [ -f "/etc/yum.repos.d/nginx-plus.repo" ]; then
          rm -f /etc/yum.repos.d/nginx-plus.repo
    fi
    printf "[nginx-plus]\nname=nginx-plus repo\nbaseurl=https://pkgs.nginx.com/plus/$os_type/\$releasever/\$basearch/\nsslclientcert=/etc/ssl/nginx/nginx-repo.crt\nsslclientkey=/etc/ssl/nginx/nginx-repo.key\ngpgcheck=0\nenabled=1" >> /etc/yum.repos.d/nginx-plus.repo

    yum install -y yum-utils curl epel-release ca-certificates
    yum-config-manager --enable  nginx-stable
    yum-config-manager --enable  nginx-plus

    yum -y update
    check_last_command_status "yum update" $?

    if [ "${USE_NGINX_PLUS}" == "true" ]; then
         echo "Installing nginx plus..."
         if [ "${NGINX_PLUS_VERSION}" == "latest" ]; then
            yum install -y nginx-plus
            check_last_command_status "yum install -y nginx-plus" $?
         else
            nginx_plus_pkg_version=$(findVersionForPackage "nginx-plus" "${NGINX_PLUS_VERSION}")
            cmd_status=$?
            if [ $cmd_status -ne 0 ]; then
               echo "Package nginx-plus with version ${NGINX_PLUS_VERSION} not found"
               exit $cmd_status
            fi
            yum install -y nginx-plus-"${nginx_plus_pkg_version}"
            check_last_command_status "yum install -y nginx-plus-${nginx_plus_pkg_version}" $?
         fi
         createNginxMgmtFile
    else
         echo "Installing nginx..."
         if [ "${NGINX_VERSION}" == "latest" ]; then
            yum install -y nginx --repo nginx-stable
            check_last_command_status "yum install -y nginx" $?
         else
            nginx_pkg_version=$(findVersionForPackage "nginx" "${NGINX_VERSION}")
            cmd_status=$?
            if [ $cmd_status -ne 0 ]; then
               echo "Package nginx with version ${NGINX_VERSION} not found"
               exit $cmd_status
            fi
            yum install -y nginx-"${nginx_pkg_version}" --repo nginx-stable
            check_last_command_status "yum install -y nginx-${nginx_pkg_version}" $?
       fi
    fi
    echo "Enabling nginx service"
    systemctl enable nginx.service
    check_last_command_status "systemctl enable nginx.service" $?

    yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo
    echo "Installing clickhouse-server and clickhouse-client"
    yum install -y clickhouse-server clickhouse-client
    check_last_command_status "yum install -y clickhouse-server clickhouse-client" $?

    echo "Enabling clickhouse-server"
    systemctl enable clickhouse-server
    check_last_command_status "systemctl enable clickhouse-server" $?

    echo "Starting clickhouse-server"
    systemctl start clickhouse-server
    check_last_command_status "systemctl start clickhouse-server" $?

    curl -o /etc/yum.repos.d/nms.repo https://cs.nginx.com/static/files/nms.repo
    check_last_command_status "get -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms.repo" $?

    if cat /etc/*-release | grep -iq 'Amazon Linux'; then
        sudo sed -i 's/centos/amzn2/g' /etc/yum.repos.d/nms.repo
    fi

    echo "Installing NGINX Instance Manager"
    if [ "${NIM_VERSION}" == "latest" ]; then
      yum install -y nms-instance-manager
      check_last_command_status "installing nginx-instance-manager(nim)" $?
    else
      nim_pkg_version=$(findVersionForPackage "nms-instance-manager" "${NIM_VERSION}")
      yum install -y nms-instance-manager-"${nim_pkg_version}"
      check_last_command_status "apt-get install -y nms-instance-manager=${nim_pkg_version}" $?
    fi
    echo "Enabling  nms nms-core nms-dpm nms-ingestion nms-integrations"
    systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now

    echo "Restarting NGINX Instance Manager"
    systemctl restart nms

    if [ "${USE_SM_MODULE}" == "true" ]; then
      nim_major_version=$(nms-core --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | awk -F. '{print $1}')
      nim_minor_version=$(nms-core --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | awk -F. '{print $2}')
      echo "Installed NIM major Version: ${nim_major_version}, minor Version:${nim_minor_version}"
      if [[ $nim_major_version -ge 2 && $nim_minor_version -ge 19 ]]; then
        echo "Note: NGINX Instance Manager version 2.19.0 or later comes with security monitoring installed. skipping installing security monitoring"
      else
        printf "Installing security module...\n"
        if [ "${NIM_SM_VERSION}" == "latest" ]; then
          yum install -y nms-sm
          check_last_command_status "yum install -y nms-sm" $?
        else
          sm_pkg_version=$(findVersionForPackage "nms-sm" "${NIM_SM_VERSION}")
          cmd_status=$?
          if [ $cmd_status -ne 0 ]; then
             echo "Package nms-sm with version ${NIM_SM_VERSION} not found"
             exit $cmd_status
          fi
          yum install -y nms-sm="${sm_pkg_version}"
          check_last_command_status "yum install -y nms-sm=${NIM_SM_VERSION}" $?
        fi
        systemctl restart nms
        sleep 5
        systemctl restart nginx
        systemctl start nms-sm
      fi
    fi
    sleep 5
    echo "Restarting nginx API gateway"
    systemctl restart nginx
}

url_file_download() {
  url=$1
  dest=$2
  if ! http_code=$(curl -fs "${url}" --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} --output "${dest}" --write-out '%{http_code}'); then
    echo "-- Failed to download $url with HTTP code $http_code. Exiting."
    exit 1
  fi
}

install_nim_online(){
  if cat /etc/*-release | grep -iq 'debian\|ubuntu'; then
    PACKAGE_INSTALLER="apt"
    installBundleForDebianDistro
    generate
  elif cat /etc/*-release | grep -iq 'centos\|fedora\|rhel\|Amazon Linux'; then
    PACKAGE_INSTALLER="rpm"
    installBundleForRPMDistro
    generate

  else
    printf "Unsupported distribution"
    exit 1
  fi
  if [[ -n ${NIM_FQDN} ]] ; then
     if [ -d "${NIM_CERTS_DIR}" ]; then
        echo "removing existing NIM certs"
        rm -rf "/etc/nms/certs"
     fi
     bash -c "source /etc/nms/scripts/certs.sh 0 \"${NIM_FQDN}\" || /etc/nms/scripts/certs.sh 0 ${NIM_FQDN}"
  fi
  curl -s -o /dev/null --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} "https://pkgs.nginx.com/nms/?using_install_script=true&app=nim&mode=online"
}

printUsageInfo(){
  echo "Usage: $0 [-c /path/to/nginx-repo.crt] [-k /path/to/nginx-repo.key] [-p nginx_plus_version] [-s security_module_version] -i [installable_tar_file_path] [-n nginx_oss_version] [-m mode(online/offline)] [-d distribution (ubuntu20.04,ubuntu22.04,ubuntu24.04,debian11,debian12,centos8,rhel8,rhel9,oracle7,oracle8,amzn2)] [-h print help]"
  printf "\n\n  -m  <mode> online/offline. Controls whether to install from the internet or from a package created using this script. \n"
  printf "\n  -c  /path/to/your/<nginx-repo.crt> file.\n"
  printf "\n  -k  /path/to/your/<nginx-repo.key> file.\n"
  printf "\n  -p  <nginx_plus_version>. Include NGINX Plus version to install as an API gateway. Valid values are 'latest' and specific versions like R32. For a list, see https://docs.nginx.com/nginx/releases/. Supersedes -n.\n"
  printf "\n  -n  <nginx_oss_version>. Provide NGINX OSS version to install as an API gateway. Valid values are 'latest' or a specific version like 1.27.1. Ignored if you use -p to specify an NGINX Plus version. For a list, see https://nginx.org/en/download.html .\n"
  printf "\n  -s  <security-module-version>. Installs a security module along with NGINX Instance Manager. You can specify latest or a version specified in https://docs.nginx.com/nginx-instance-manager/monitoring/security-monitoring/releases/release-notes/.\n"
  printf "\n  -i  <installable_tar_file_path>. Include the path with an archive file to support NGINX Instance Manager installation. Requires -m Offline."
  printf "\n  -d  <distribution>. Include the label of a distribution. Requires -m Offline. This creates a file with NGINX Instance Manager dependencies and NGINX Instance Manager install packages for the specified distribution.\n"
  printf "\n  -v  <NIM_VERSION>. NGINX Instance Manager version to install/package.\n"
  printf "\n  -j  <JWT_TOKEN_FILE_PATH>. Path to the JWT token file used for license and usage consumption reporting.\n"
  printf "\n  -r  To uninstall NGINX Instance Manager and its dependencies. \n"
  printf "\n  -l  Print supported operating systems.\n"
  printf "\n  -h  Print this help message.\n"
  exit 0
}

printSupportedOS(){
  printf "This script can be run on the following operating systems"
  printf "\n  1. ubuntu20.04(focal)"
  printf "\n  2. ubuntu22.04(jammy)"
  printf "\n  3. ubuntu24.04(noble)"
  printf "\n  4. debian11(bullseye)"
  printf "\n  5. debian12(bookworm)"
  printf "\n  6. centos8(CentOS 8)"
  printf "\n  7. rhel8(Redhat Enterprise Linux Version 8)"
  printf "\n  8. rhel9( Redhat Enterprise Linux Version 9)"
  printf "\n  9. oracle7(Oracle Linux Version 7)"
  printf "\n 10. oracle8(Oracle Linux Version 8)"
  printf "\n 11. amzn2(Amazon Linux 2)\n"
  exit 0
}

check_NIM_status(){
  sleep 5
  GREEN='\033[0;32m'
  NC='\033[0m'

  if ! curl -k https://localhost/ui 2>/dev/null | grep -q "NGINX"; then
    sleep 2
    if ! curl -k https://localhost/ui 2>/dev/null | grep -q "NGINX"; then
    	echo "NGINX Instance Manager failed to start"
      exit 1
    else
      echo -e "${GREEN}NGINX Instance Manager Successfully Started${NC}"
      echo -e "\n[NOTE] - If NGINX Instance Manager dashboard is still not accessible, Please ensure port 443 is exposed and accessible via firewall"
      exit 0
    fi
  else
	  echo -e "${GREEN}NGINX Instance Manager Successfully Started${NC}"
    echo -e "\n[NOTE] - If NGINX Instance Manager dashboard is still not accessible, Please ensure port 443 is exposed and accessible via firewall"
    exit 0
  fi
}

check_cert_key_jwt_path(){
  if [[ ! -f "$NGINX_CERT_KEY_PATH" ]]; then
    echo "Error: NGINX key not found. Please give cert path using -k"
    exit 1
  fi

  if [[ ! -f "$NGINX_CERT_PATH" ]]; then
    echo "Error: NGINX cert not found. Please give key path using -c"
    exit 1
  fi

  if [[ "$USE_NGINX_PLUS" == true &&  "$NGINX_PLUS_VERSION" == "latest" ]]; then
    if [[ ! -f "$LICENSE_JWT_PATH" ]]; then
      echo "Error: JWT License not found. It is required with NGINX plus"
      exit 1
    fi
    echo "Copying jwt"
    if [ ! -d "/etc/nginx" ]; then
      mkdir /etc/nginx
      check_last_command_status "mkdir /etc/nginx" $?
    fi
    cp "${LICENSE_JWT_PATH}" "/etc/nginx/license.jwt"
    check_last_command_status "cp $LICENSE_JWT_PATH /etc/nginx/license.jwt" $?
  fi
}

check_if_nim_installed(){

  local all_services_present=0

  if nms-core --version > /dev/null 2>&1 && nms-dpm --version > /dev/null 2>&1 && nms-integrations --version > /dev/null 2>&1 \
   && nms-ingestion --version > /dev/null 2>&1 && nginx -version > /dev/null 2>&1; then
    all_services_present=1
  fi

  if [[ "$all_services_present" == 1 ]]; then
    if [ "$UNINSTALL_NIM" == "true" ]; then
      uninstall_nim
    else
      echo "NGINX Instance Manager already installed."
      exit 1
    fi
  else
    if [ "$UNINSTALL_NIM" == "true" ]; then
      echo "Cannot uninstall NGINX Instance Manager as it is not installed"
      exit 1
    fi
  fi
}

uninstall_nim(){

  echo -e "\nAre you ready to remove all packages and files related to NGINX Instance Manager ? \n\
This action deletes all files in the following directories: /etc/nms , /etc/nginx, /var/log/nms"

  read -p "Enter your choice (y/N) = " response

  if [[ "$response" =~ ^[Yy]$ ]]; then
      # Clickhouse server, Clickhouse client, clickhouse static, nms, nginx
    systemctl stop clickhouse-server
    check_last_command_status "systemctl stop clickhouse-server" $?
    systemctl stop nginx
    check_last_command_status "systemctl stop nginx" $?
    systemctl stop nms nms-core nms-dpm nms-ingestion nms-integrations
    check_last_command_status "systemctl stop nms nms-core nms-dpm nms-ingestion nms-integrations" $?

    if cat /etc/*-release | grep -iq 'debian\|ubuntu'; then
      apt-get -y remove clickhouse-common-static clickhouse-server clickhouse-client
      apt-get -y remove nms-instance-manager --purge
      check_last_command_status "apt-get remove nms-instance-manager" $?
      apt-get -y remove nginx --purge
      apt-get -y remove nginx-plus --purge
      rm -rf /etc/nginx
      rm -rf /etc/nms
      rm -rf /var/log/nms
      echo "NGINX Instance Manager Uninstalled successfully"
      exit 0
    elif cat /etc/*-release | grep -iq 'centos\|fedora\|rhel\|Amazon Linux'; then
      yum -y remove clickhouse-common-static clickhouse-server clickhouse-client
      yum -y remove nms-instance-manager
      check_last_command_status "yum remove nms-instance-manager" $?
      yum -y remove nginx
      yum -y remove nginx-plus
      rm -rf /etc/nginx
      rm -rf /etc/nms
      rm -rf /var/log/nms
      yum autoremove
      echo "NGINX Instance Manager Uninstalled successfully"
      exit 0
    else
      printf "Unsupported distribution"
      exit 1
    fi
  else
    echo -e "\nUninstallation cancelled"
    echo -e "Note -> Back up the following directories: /etc/nms, /etc/nginx, /var/log/nms. Then you can use the script to remove NGINX Instance Manager.\n"
    exit 0
  fi
}

download_third_party_dependencies(){
  if cat /etc/*-release | grep -iq 'debian\|ubuntu'; then
      if echo "${target_distribution}" | grep -iq 'debian\|ubuntu'; then
          mkdir "${TEMP_DIR}/${target_distribution}/keepalived"
          apt-get install --download-only -o Dir::Cache="${TEMP_DIR}/${target_distribution}/keepalived" keepalived
      else
        if command -v docker >/dev/null 2>&1; then
            mkdir "${TEMP_DIR}/${target_distribution}/keepalived"
            docker run --rm -it -v "${TEMP_DIR}/${target_distribution}/keepalived":/downloads fedora dnf download --resolve --destdir=/downloads keepalived
        else
            echo "Cross platform packing requires Docker. Please install Docker and try again."
            exit 1
        fi
      fi
  elif cat /etc/*-release | grep -iq 'centos\|fedora\|rhel\|Amazon Linux'; then
      if echo "${target_distribution}" | grep -iq 'centos\|fedora\|rhel\|Amazon Linux'; then
          mkdir "${TEMP_DIR}/${target_distribution}/keepalived"
          yumdownloader --destdir="${TEMP_DIR}/${target_distribution}/keepalived" --resolve keepalived
      else
          if command -v docker >/dev/null 2>&1; then
              mkdir -p "${TEMP_DIR}/keepalived"
              docker run --rm -it -v "${TEMP_DIR}/keepalived":/tmp/nim ubuntu bash -c "apt-get update && mkdir -p /tmp/nim && apt-get install -y --download-only -o Dir::Cache=\"/tmp/nim\" keepalived"
              mkdir "${TEMP_DIR}/${target_distribution}/keepalived"
              mv ${TEMP_DIR}/keepalived/archives/* ${TEMP_DIR}/${target_distribution}/keepalived
          else
              echo "Cross platform packing requires Docker. Please install Docker and try again."
              exit 1
          fi
      fi
  else
      printf "Unsupported distribution"
      exit 1
  fi
}

OPTS_STRING="k:c:m:d:i:s:p:n:hv:t:j:rf:l"
while getopts ${OPTS_STRING} opt; do
  case ${opt} in
    c)
      if [ ! -d "/etc/ssl/nginx" ]; then
        mkdir /etc/ssl/nginx
        check_last_command_status "mkdir /etc/ssl/nginx" $?
      fi
      cp "${OPTARG}" ${NGINX_CERT_PATH}
      check_last_command_status "cp ${OPTARG} ${NGINX_CERT_PATH}" $?
      ;;
    k)
      if [ ! -d "/etc/ssl/nginx" ]; then
        mkdir /etc/ssl/nginx
        check_last_command_status "mkdir /etc/ssl/nginx" $?
      fi
      cp "${OPTARG}" ${NGINX_CERT_KEY_PATH}
      check_last_command_status "cp ${OPTARG} ${NGINX_CERT_KEY_PATH}" $?
      ;;
    p)
      USE_NGINX_PLUS="true"
      NGINX_PLUS_VERSION=${OPTARG}
      ;;
    s)
      USE_SM_MODULE="true"
      NIM_SM_VERSION="${OPTARG}"
      ;;
    i)
      INSTALL_PATH=${OPTARG}
      ;;
    n)
      NGINX_VERSION=${OPTARG}
      ;;
    m)
      MODE="${OPTARG}"
      if [[ "${MODE}" != "online" && "${MODE}" != "offline" ]]; then
          echo "invalid mode ${MODE}"
          echo "supported values for mode are 'online' or 'offline'"
          exit 1
      fi
      ;;
    d)
      TARGET_DISTRIBUTION=${OPTARG}
      ;;
    v)
      NIM_VERSION=${OPTARG}
      ;;
    j)
      LICENSE_JWT_PATH=${OPTARG}
      ;;
    t)
      CLICKHOUSE_VERSION=${OPTARG}
      ;;
    r)
      UNINSTALL_NIM="true"
      ;;
    f)
      NIM_FQDN=${OPTARG}
      ;;
    h)
       printUsageInfo
       exit 0
      ;;
    l)
       printSupportedOS
       exit 0
       ;;
    :)
      echo "Option -${OPTARG} requires an argument."
      exit 1
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

check_if_nim_installed
check_cert_key_jwt_path

if [ "${MODE}" == "online" ]; then
  install_nim_online
  check_NIM_status

else
  if [ "${NGINX_VERSION}" == "latest" ]; then
      NGINX_VERSION=${NGINX_LATEST_VERSION}
  fi
  if [ "${NIM_VERSION}" == "latest" ]; then
      NIM_VERSION=${NIM_LATEST_VERSION}
  fi
  if [ "${CLICKHOUSE_VERSION}" == "latest" ]; then
      CLICKHOUSE_VERSION=${CLICKHOUSE_LATEST_VERSION}
  fi

  declare -A CLICKHOUSE_REPO
  CLICKHOUSE_REPO['ubuntu20.04']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse/"
  CLICKHOUSE_REPO['ubuntu22.04']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse/"
  CLICKHOUSE_REPO['ubuntu24.04']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse/"
  CLICKHOUSE_REPO['debian11']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse/"
  CLICKHOUSE_REPO['debian12']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse/"
  CLICKHOUSE_REPO['centos8']="https://packages.clickhouse.com/rpm/stable/"
  CLICKHOUSE_REPO['rhel8']="https://packages.clickhouse.com/rpm/stable/"
  CLICKHOUSE_REPO['rhel9']="https://packages.clickhouse.com/rpm/stable/"
  CLICKHOUSE_REPO['oracle8']="https://packages.clickhouse.com/rpm/stable/"
  CLICKHOUSE_REPO['oracle9']="https://packages.clickhouse.com/rpm/stable/"
  CLICKHOUSE_REPO['amzn2']="https://packages.clickhouse.com/rpm/stable/"

  declare -A NGINX_REPO
  NGINX_REPO['ubuntu20.04']="https://nginx.org/packages/mainline/ubuntu/pool/nginx/n/nginx/"
  NGINX_REPO['ubuntu22.04']="https://nginx.org/packages/mainline/ubuntu/pool/nginx/n/nginx/"
  NGINX_REPO['ubuntu24.04']="https://nginx.org/packages/mainline/ubuntu/pool/nginx/n/nginx/"
  NGINX_REPO['debian11']="https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx/"
  NGINX_REPO['debian12']="https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx/"
  NGINX_REPO['centos8']="https://nginx.org/packages/mainline/centos/8/x86_64/RPMS/"
  NGINX_REPO['rhel8']="https://nginx.org/packages/mainline/rhel/8/x86_64/RPMS/"
  NGINX_REPO['rhel9']="https://nginx.org/packages/mainline/rhel/9/x86_64/RPMS/"
  NGINX_REPO['oracle8']="https://nginx.org/packages/mainline/rhel/8/x86_64/RPMS/"
  NGINX_REPO['oracle9']="https://nginx.org/packages/mainline/rhel/9/x86_64/RPMS/"
  NGINX_REPO['amzn2']="https://nginx.org/packages/mainline/amzn2/2/x86_64/RPMS/"
  CLICKHOUSE_KEY="https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key"
  NGINX_KEY="https://nginx.org/keys/nginx_signing.key"

  declare -A NMS_REPO
  NMS_REPO['ubuntu20.04']="https://pkgs.nginx.com/nms/ubuntu/pool/nginx-plus/n/nms-instance-manager/"
  NMS_REPO['ubuntu22.04']="https://pkgs.nginx.com/nms/ubuntu/pool/nginx-plus/n/nms-instance-manager/"
  NMS_REPO['ubuntu24.04']="https://pkgs.nginx.com/nms/ubuntu/pool/nginx-plus/n/nms-instance-manager/"
  NMS_REPO['debian11']="https://pkgs.nginx.com/nms/debian/pool/nginx-plus/n/nms-instance-manager/"
  NMS_REPO['debian12']="https://pkgs.nginx.com/nms/debian/pool/nginx-plus/n/nms-instance-manager/"
  NMS_REPO['centos8']="https://pkgs.nginx.com/nms/centos/8/x86_64/RPMS/"
  NMS_REPO['rhel8']="https://pkgs.nginx.com/nms/centos/8/x86_64/RPMS/"
  NMS_REPO['rhel9']="https://pkgs.nginx.com/nms/centos/9/x86_64/RPMS/"
  NMS_REPO['oracle8']="https://pkgs.nginx.com/nms/centos/8/x86_64/RPMS/"
  NMS_REPO['oracle9']="https://pkgs.nginx.com/nms/centos/9/x86_64/RPMS/"
  NMS_REPO['amzn2']="https://pkgs.nginx.com/nms/amzn2/2/x86_64/RPMS/"

  declare -A CLICKHOUSE_PACKAGES
  # for Clickhouse package names are static between distributions
  # we use ubuntu/centos entries as placeholders
  CLICKHOUSE_PACKAGES['ubuntu']=$(printf "clickhouse-server_%s_amd64.deb\nclickhouse-common-static_%s_amd64.deb" ${CLICKHOUSE_VERSION} ${CLICKHOUSE_VERSION})
  CLICKHOUSE_PACKAGES['centos']=$(printf "clickhouse-server-%s.x86_64.rpm\nclickhouse-common-static-%s.x86_64.rpm"  ${CLICKHOUSE_VERSION} ${CLICKHOUSE_VERSION})
  CLICKHOUSE_PACKAGES['ubuntu20.04']=${CLICKHOUSE_PACKAGES['ubuntu']}
  CLICKHOUSE_PACKAGES['ubuntu22.04']=${CLICKHOUSE_PACKAGES['ubuntu']}
  CLICKHOUSE_PACKAGES['ubuntu24.04']=${CLICKHOUSE_PACKAGES['ubuntu']}
  CLICKHOUSE_PACKAGES['debian11']=${CLICKHOUSE_PACKAGES['ubuntu']}
  CLICKHOUSE_PACKAGES['debian12']=${CLICKHOUSE_PACKAGES['ubuntu']}
  CLICKHOUSE_PACKAGES['centos8']=${CLICKHOUSE_PACKAGES['centos']}
  CLICKHOUSE_PACKAGES['rhel8']=${CLICKHOUSE_PACKAGES['centos']}
  CLICKHOUSE_PACKAGES['rhel9']=${CLICKHOUSE_PACKAGES['centos']}
  CLICKHOUSE_PACKAGES['oracle8']=${CLICKHOUSE_PACKAGES['centos']}
  CLICKHOUSE_PACKAGES['oracle9']=${CLICKHOUSE_PACKAGES['centos']}
  CLICKHOUSE_PACKAGES['amzn2']=${CLICKHOUSE_PACKAGES['centos']}

  declare -A NGINX_PACKAGES
  NGINX_PACKAGES['ubuntu20.04']="nginx_${NGINX_VERSION}~focal_amd64.deb"
  NGINX_PACKAGES['ubuntu22.04']="nginx_${NGINX_VERSION}~jammy_amd64.deb"
  NGINX_PACKAGES['ubuntu24.04']="nginx_${NGINX_VERSION}~noble_amd64.deb"
  NGINX_PACKAGES['debian11']="nginx_${NGINX_VERSION}~bullseye_amd64.deb"
  NGINX_PACKAGES['debian12']="nginx_${NGINX_VERSION}~bookworm_amd64.deb"
  NGINX_PACKAGES['centos8']="nginx-${NGINX_VERSION}.el8.ngx.x86_64.rpm"
  NGINX_PACKAGES['rhel8']="nginx-${NGINX_VERSION}.el8.ngx.x86_64.rpm"
  NGINX_PACKAGES['rhel9']="nginx-${NGINX_VERSION}.el9.ngx.x86_64.rpm"
  NGINX_PACKAGES['oracle8']="nginx-${NGINX_VERSION}.el8.ngx.x86_64.rpm"
  NGINX_PACKAGES['oracle9']="nginx-${NGINX_VERSION}.el9.ngx.x86_64.rpm"
  NGINX_PACKAGES['amzn2']="nginx-${NGINX_VERSION}.amzn2.ngx.x86_64.rpm"

  declare -A NIM_PACKAGES
  NIM_PACKAGES['ubuntu20.04']="nms-instance-manager_${NIM_VERSION}-\d*~focal_amd64\.deb"
  NIM_PACKAGES['ubuntu22.04']="nms-instance-manager_${NIM_VERSION}-\d*~jammy_amd64\.deb"
  NIM_PACKAGES['ubuntu24.04']="nms-instance-manager_${NIM_VERSION}-\d*~jammy_amd64\.deb"
  NIM_PACKAGES['debian11']="nms-instance-manager_${NIM_VERSION}-\d*~bullseye_amd64\.deb"
  NIM_PACKAGES['debian12']="nms-instance-manager_${NIM_VERSION}-\d*~bookworm_amd64\.deb"
  NIM_PACKAGES['centos8']="nms-instance-manager-${NIM_VERSION}-\d*.el8.ngx.x86_64\.rpm"
  NIM_PACKAGES['rhel8']="nms-instance-manager-${NIM_VERSION}-\d*.el8.ngx.x86_64\.rpm"
  NIM_PACKAGES['rhel9']="nms-instance-manager-${NIM_VERSION}-\d*.el9.ngx.x86_64\.rpm"
  NIM_PACKAGES['oracle8']="nms-instance-manager-${NIM_VERSION}-\d*.el8.ngx.x86_64\.rpm"
  NIM_PACKAGES['oracle9']="nms-instance-manager-${NIM_VERSION}-\d*.el9.ngx.x86_64\.rpm"
  NIM_PACKAGES['amzn2']="nms-instance-manager-${NIM_VERSION}-\d*.amzn2.ngx.x86_64\.rpm"

  if [ -z "${INSTALL_PATH}" ]; then
    target_distribution="$TARGET_DISTRIBUTION"
    echo "Target distro - $target_distribution"
    if [[ "${#CLICKHOUSE_REPO[$target_distribution]}" -eq 0 ]]; then
        echo "Invalid target distribution. Supported target distributions: " "${!CLICKHOUSE_REPO[@]}"
        exit 1
    fi
    echo  "Creating NGINX Instance Manager installation bundle for distribution ${CLICKHOUSE_PACKAGES[${target_distribution}]}..."
    if [ -z "${target_distribution}" ]; then
        echo "${target_distribution} - no target distribution specified"
        exit 1
    fi
    mkdir -p "${TEMP_DIR}/${target_distribution}"
    echo "Downloading clickhouse signing keys ${CLICKHOUSE_KEY}... "
    url_file_download ${CLICKHOUSE_KEY} "${TEMP_DIR}/${target_distribution}/clickhouse-key.gpg"
    echo "Downloaded clickhouse signing keys"

    echo "downloading nginx signing keys ${NGINX_KEY}... "
    url_file_download ${NGINX_KEY} "${TEMP_DIR}/${target_distribution}/nginx-key.gpg"
    echo "Downloaded nginx signing keys"

    readarray -t clickhouse_files <<<"${CLICKHOUSE_PACKAGES[$target_distribution]}"
    readarray -t nginx_files <<<"${NGINX_PACKAGES[$target_distribution]}"
    readarray -t nim_files <<<"${NIM_PACKAGES[$target_distribution]}"

    for package_file in "${clickhouse_files[@]}"; do
      if [ -z "$package_file" ]; then
         continue
      fi
      file_to_download="${CLICKHOUSE_REPO[$target_distribution]}$package_file"
      save_path="${TEMP_DIR}/${target_distribution}/$package_file"
      echo -n "Downloading ${file_to_download} ... "
      url_file_download "$file_to_download" "$save_path"
      echo "Downloaded clickhouse package - $save_path"
    done
    for package_file in "${nginx_files[@]}"; do
      if [ -z "$package_file" ]; then
         continue
      fi
      file_to_download="${NGINX_REPO[$target_distribution]}$package_file"
      save_path="${TEMP_DIR}/${target_distribution}/$package_file"
      echo -n "Downloading ${package_file} ... "
      url_file_download "$file_to_download" "$save_path"
      echo "Downloaded nginx package - $save_path"
    done
    for package_file in "${nim_files[@]}"; do
      if [ -z "$package_file" ]; then
        continue
      fi
      nim_with_version=$(curl -fs --cert "${NGINX_CERT_PATH}" --key "${NGINX_CERT_KEY_PATH}" "${NMS_REPO[$target_distribution]}" \
       | grep -P "${package_file}" | sed -n 's/.*<a[^>]*href="\([^"]*\)".*/\1/p')
      if [[ "${#nim_with_version}" -eq 0 ]]; then
        echo "Error: NGINX Instance Manager $NIM_VERSION ($target_distribution) version not found on ${NMS_REPO[$target_distribution]}"
        exit 1
      fi
      file_to_download="${NMS_REPO[$target_distribution]}${nim_with_version}"
      save_path="${TEMP_DIR}/${target_distribution}/$nim_with_version"
      echo -n "Downloading ${nim_with_version} ... "
      url_file_download "$file_to_download" "$save_path"
      echo "Downloaded NGINX Instance Manager package - $save_path"
    done
    download_third_party_dependencies
    bundle_file="nim-${NIM_VERSION}-${target_distribution}.tar.gz"
    echo -n "Creating NGINX Instance Manager install bundle ... ${bundle_file}"
    cp ${NGINX_CERT_PATH}  "${TEMP_DIR}/${target_distribution}/nginx-repo.crt"
    cp ${NGINX_CERT_KEY_PATH} "${TEMP_DIR}/${target_distribution}/nginx-repo.key"
    tar -zcf "$bundle_file" -C "${TEMP_DIR}/${target_distribution}/" .
    echo -e "\nSuccessfully created the NGINX Instance Manager bundle - $bundle_file"
    curl -s -o /dev/null --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} "https://pkgs.nginx.com/nms/?using_install_script=true&app=nim&mode=offline"

  else
    echo "Installing NGINX Instance Manager bundle from the path ${INSTALL_PATH}"
    if [ -f "${INSTALL_PATH}" ]; then
      if [ ! -f "${TEMP_DIR}" ]; then
        mkdir -p "${TEMP_DIR}"
      fi
      tar xvf "${INSTALL_PATH}" -C "${TEMP_DIR}"
      chmod -R 777 "${TEMP_DIR}"
      chown -R "${USER}" "${TEMP_DIR}"
      if cat /etc/*-release | grep -iq 'debian\|ubuntu'; then
        for pkg_nginx in "${TEMP_DIR}"/nginx*.deb; do
            echo "Installing nginx from ${pkg_nginx}"
            DEBIAN_FRONTEND=noninteractive dpkg -i "$pkg_nginx"
            check_last_command_status "dpkg -i \"$pkg_nginx\"" $?
        done
        for pkg_clickhouse in "${TEMP_DIR}"/clickhouse-common*.deb; do
            echo "Installing clickhouse dependencies from ${pkg_clickhouse}"
            DEBIAN_FRONTEND=noninteractive dpkg -i  "$pkg_clickhouse"
            check_last_command_status "dpkg -i \"$pkg_clickhouse\"" $?
        done
        for pkg_clickhouse_srv in "${TEMP_DIR}"/clickhouse-server*.deb; do
            echo "Installing clickhouse dependencies from ${pkg_clickhouse_srv}"
            DEBIAN_FRONTEND=noninteractive dpkg -i  "$pkg_clickhouse_srv"
            check_last_command_status "dpkg -i \"$pkg_clickhouse_srv\"" $?
        done
        if [ -d "${TEMP_DIR}/keepalived" ]; then
            echo "Installing keepalived from ${TEMP_DIR}/keepalived"
            DEBIAN_FRONTEND=noninteractive dpkg -i ${TEMP_DIR}/keepalived/*.deb
            check_last_command_status "dpkg -i ${TEMP_DIR}/keepalived/*.deb" $?
        fi
        for pkg_nim in "${TEMP_DIR}"/nms-instance-manager*.deb; do
            echo "Installing NGINX Instance Manager from ${pkg_nim}"
            DEBIAN_FRONTEND=noninteractive dpkg -i "$pkg_nim"
            check_last_command_status "dpkg -i \"$pkg_nim\"" $?
        done

        generate
        echo "Starting clickhouse-server"
        systemctl start clickhouse-server

        echo "Starting nginx"
        systemctl start nginx

        echo "Reloading nginx configuration"
        systemctl restart nginx

        echo "Enabling and starting NGINX Instance Manager"
        systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now

        check_NIM_status

      elif cat /etc/*-release | grep -iq 'centos\|fedora\|rhel\|Amazon Linux'; then
        for pkg_nginx in "${TEMP_DIR}"/nginx*.rpm; do
          echo "Installing nginx from ${pkg_nginx}"
          yum localinstall -y -v --disableplugin=subscription-manager --skip-broken "$pkg_nginx"
        done
        for pkg_clickhouse in "${TEMP_DIR}"/clickhouse-common*.rpm; do
          echo "Installing clickhouse dependencies from ${pkg_clickhouse}"
          yum localinstall -y -v --disableplugin=subscription-manager --skip-broken "$pkg_clickhouse"
        done
        for pkg_clickhouse_srv in "${TEMP_DIR}"/clickhouse-server*.rpm; do
          echo "Installing clickhouse dependencies from ${pkg_clickhouse}"
          yum localinstall -y -v --disableplugin=subscription-manager --skip-broken "$pkg_clickhouse_srv"
        done
        if [ -d "${TEMP_DIR}/keepalived" ]; then
            echo "Installing keepalived from ${TEMP_DIR}/keepalived"
            yum localinstall -y -v --disableplugin=subscription-manager --skip-broken "${TEMP_DIR}/keepalived/*.rpm"
            check_last_command_status "dpkg -i yum localinstall -y -v --disableplugin=subscription-manager --skip-broken ${TEMP_DIR}/keepalived/*.rpm" $?
        fi
        for pkg_nim in "${TEMP_DIR}"/nms-instance-manager*.rpm; do
          echo "Installing NGINX Instance Manager from ${pkg_nim}"
          yum localinstall -y -v --disableplugin=subscription-manager --skip-broken "$pkg_nim"
        done

        generate
        echo "Starting clickhouse-server"
        systemctl start clickhouse-server

        echo "Starting nginx"
        systemctl start nginx

        echo "Reloading nginx configuration"
        systemctl restart nginx

        echo "Enabling and starting NGINX Instance Manager"
        systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now

        check_NIM_status

      else
        echo "Unsupported distribution"
        exit 1
      fi

    else
      echo "Provided install path ${INSTALL_PATH} doesn't exists"
      exit 1
    fi
    if [[ -n ${NIM_FQDN} ]] ; then
         if [ -d "${NIM_CERTS_DIR}" ]; then
             echo "removing existing nim certs"
             rm -rf "/etc/nms/certs"
         fi
         bash -c "source /etc/nms/scripts/certs.sh 0 \"${NIM_FQDN}\" || /etc/nms/scripts/certs.sh 0 ${NIM_FQDN}"
    fi
    curl -s -o /dev/null --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} "https://pkgs.nginx.com/nms/?using_install_script=true&app=nim&mode=offline"
  fi
fi
