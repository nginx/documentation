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
UNINSTALL_NIM="false"
MODE="online"
INSTALL_PATH=""
SKIP_CLICKHOUSE_INSTALL="false"
CURRENT_TIME=$(date +%s)
TEMP_DIR="/tmp/${CURRENT_TIME}"
TARGET_DISTRIBUTION=""
NMS_NGINX_MGMT_BLOCK="mgmt { \n  usage_report endpoint=127.0.0.1 interval=30m; \n  ssl_verify off; \n}";
NIM_FQDN=""
OS_ARCH="amd64"
UBUNTU_2004="ubuntu20.04"
UBUNTU_2204="ubuntu22.04"
UBUNTU_2404="ubuntu24.04"
DEBIAN_11="debian11"
DEBIAN_12="debian12"
CENTOS_8="centos8"
REDHAT_8="rhel8"
REDHAT_9="rhel9"
ORACLE_8="oracle8"
ORACLE_9="oracle9"
CLICKHOUSE_VERSION="24.9.2.42"
PKG_EXTENSION="deb"
UBUNTU_OS=(
    "${UBUNTU_2004}"
    "${UBUNTU_2204}"
    "${UBUNTU_2404}"
)
DEB_OS=(
    "${DEBIAN_11}"
    "${DEBIAN_12}"
)
CENT_OS=(
    "${CENTOS_8}"
)
RPM_OS=(
    "${REDHAT_8}"
    "${REDHAT_9}"
    "${ORACLE_8}"
    "${ORACLE_9}"
)
SUPPORTED_OS=()
SUPPORTED_OS+=("${DEB_OS[@]}")
SUPPORTED_OS+=("${RPM_OS[@]}")
SUPPORTED_OS+=("${CENT_OS[@]}")
SUPPORTED_OS+=("${UBUNTU_OS[@]}")

declare -A OS_DISTRO_MAP
OS_DISTRO_MAP['ubuntu20.04']="focal"
OS_DISTRO_MAP['ubuntu22.04']="jammy"
OS_DISTRO_MAP['ubuntu24.04']="noble"
OS_DISTRO_MAP['debian11']="bullseye"
OS_DISTRO_MAP['debian12']="bookworm"
OS_DISTRO_MAP['centos8']=".el8.ngx.x86_64"
OS_DISTRO_MAP['rhel8']=".el8.ngx.x86_64"
OS_DISTRO_MAP['rhel9']=".el9.ngx.x86_64"
OS_DISTRO_MAP['oracle8']=".el8.ngx.x86_64"
OS_DISTRO_MAP['oracle9']=".el9.ngx.x86_64"
OS_DISTRO_MAP['amzn2']=".amzn2.ngx.x86_64"

declare -A NGINX_PLUS_REPO
NGINX_PLUS_REPO['ubuntu20.04']="https://pkgs.nginx.com/plus/ubuntu/pool/nginx-plus/n/nginx-plus"
NGINX_PLUS_REPO['ubuntu22.04']="https://pkgs.nginx.com/plus/ubuntu/pool/nginx-plus/n/nginx-plus"
NGINX_PLUS_REPO['ubuntu24.04']="https://pkgs.nginx.com/plus/ubuntu/pool/nginx-plus/n/nginx-plus"
NGINX_PLUS_REPO['debian11']="https://pkgs.nginx.com/plus/debian/pool/nginx-plus/n/nginx-plus"
NGINX_PLUS_REPO['debian12']="https://pkgs.nginx.com/plus/debian/pool/nginx-plus/n/nginx-plus"
NGINX_PLUS_REPO['centos8']="https://pkgs.nginx.com/plus/centos/8/x86_64/RPMS"
NGINX_PLUS_REPO['rhel8']="https://pkgs.nginx.com/plus/rhel/8/x86_64/RPMS"
NGINX_PLUS_REPO['rhel9']="https://pkgs.nginx.com/plus/rhel/9/x86_64/RPMS"
NGINX_PLUS_REPO['oracle8']="https://pkgs.nginx.com/plus/rhel/8/x86_64/RPMS"
NGINX_PLUS_REPO['oracle9']="https://pkgs.nginx.com/plus/rhel/9/x86_64/RPMS"
NGINX_PLUS_REPO['amzn2']="https://pkgs.nginx.com/plus/amzn2/2/x86_64/RPMS"

declare -A NIM_REPO
NIM_REPO['ubuntu20.04']="https://pkgs.nginx.com/nms/ubuntu/pool/nginx-plus/n/nms-instance-manager"
NIM_REPO['ubuntu22.04']="https://pkgs.nginx.com/nms/ubuntu/pool/nginx-plus/n/nms-instance-manager"
NIM_REPO['ubuntu24.04']="https://pkgs.nginx.com/nms/ubuntu/pool/nginx-plus/n/nms-instance-manager"
NIM_REPO['debian11']="https://pkgs.nginx.com/nms/debian/pool/nginx-plus/n/nms-instance-manager"
NIM_REPO['debian12']="https://pkgs.nginx.com/nms/debian/pool/nginx-plus/n/nms-instance-manager"
NIM_REPO['centos8']="https://pkgs.nginx.com/nms/centos/8/x86_64/RPMS"
NIM_REPO['rhel8']="https://pkgs.nginx.com/nms/centos/8/x86_64/RPMS"
NIM_REPO['rhel9']="https://pkgs.nginx.com/nms/centos/9/x86_64/RPMS"
NIM_REPO['oracle8']="https://pkgs.nginx.com/nms/centos/8/x86_64/RPMS"
NIM_REPO['oracle9']="https://pkgs.nginx.com/nms/centos/9/x86_64/RPMS"
NIM_REPO['amzn2']="https://pkgs.nginx.com/nms/amzn2/2/x86_64/RPMS"

declare -A NGINX_REPO
NGINX_REPO['ubuntu20.04']="https://nginx.org/packages/mainline/ubuntu/pool/nginx/n/nginx"
NGINX_REPO['ubuntu22.04']="https://nginx.org/packages/mainline/ubuntu/pool/nginx/n/nginx"
NGINX_REPO['ubuntu24.04']="https://nginx.org/packages/mainline/ubuntu/pool/nginx/n/nginx"
NGINX_REPO['debian11']="https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx"
NGINX_REPO['debian12']="https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx"
NGINX_REPO['centos8']="https://nginx.org/packages/mainline/centos/8/x86_64/RPMS"
NGINX_REPO['rhel8']="https://nginx.org/packages/mainline/rhel/8/x86_64/RPMS"
NGINX_REPO['rhel9']="https://nginx.org/packages/mainline/rhel/9/x86_64/RPMS"
NGINX_REPO['oracle8']="https://nginx.org/packages/mainline/rhel/8/x86_64/RPMS"
NGINX_REPO['oracle9']="https://nginx.org/packages/mainline/rhel/9/x86_64/RPMS"
NGINX_REPO['amzn2']="https://nginx.org/packages/mainline/amzn2/2/x86_64/RPMS"

declare -A CLICKHOUSE_REPO
CLICKHOUSE_REPO['ubuntu20.04']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse"
CLICKHOUSE_REPO['ubuntu22.04']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse"
CLICKHOUSE_REPO['ubuntu24.04']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse"
CLICKHOUSE_REPO['debian11']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse"
CLICKHOUSE_REPO['debian12']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse"
CLICKHOUSE_REPO['centos8']="https://packages.clickhouse.com/rpm/stable"
CLICKHOUSE_REPO['rhel8']="https://packages.clickhouse.com/rpm/stable"
CLICKHOUSE_REPO['rhel9']="https://packages.clickhouse.com/rpm/stable"
CLICKHOUSE_REPO['oracle8']="https://packages.clickhouse.com/rpm/stable"
CLICKHOUSE_REPO['oracle9']="https://packages.clickhouse.com/rpm/stable"
CLICKHOUSE_REPO['amzn2']="https://packages.clickhouse.com/rpm/stable"

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

url_file_download() {
  url=$1
  dest=$2
  if ! http_code=$(curl -fs "${url}" --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} --output "${dest}" --write-out '%{http_code}'); then
    echo "-- Failed to download $url with HTTP code $http_code. Exiting."
    exit 1
  fi
}

generate_admin_password() {
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

create_nginx_mgmt_file(){
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
        DEBIAN_FRONTEND=noninteractive apt-get install -y nginx-plus
        create_nginx_mgmt_file
    else
        printf "Installing NGINX...\n"
        DEBIAN_FRONTEND=noninteractive apt install -y nginx
        check_last_command_status "apt-get install -y nginx" $?
    fi
}

debian_install_clickhouse(){
    curl https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key | gpg --dearmor \
          | sudo tee /usr/share/keyrings/clickhouse-keyring.gpg >/dev/null
    check_last_command_status "curl https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key" $?

    echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg arch=${OS_ARCH}] https://packages.clickhouse.com/deb stable main" | sudo tee \
      /etc/apt/sources.list.d/clickhouse.list
    apt-get update
    echo "Installing clickhouse-server with version ${CLICKHOUSE_VERSION}"
    DEBIAN_FRONTEND=noninteractive apt-get install -y clickhouse-common-static="${CLICKHOUSE_VERSION}" clickhouse-server="${CLICKHOUSE_VERSION}"
    DEBIAN_FRONTEND=noninteractive apt-get install -y clickhouse-client="${CLICKHOUSE_VERSION}"
    check_last_command_status "apt-get install -y clickhouse-server=${CLICKHOUSE_VERSION}" $?
}

debian_install_nim(){

  if [ "${SKIP_CLICKHOUSE_INSTALL}" == "true" ]; then
    echo "SKIP_CLICKHOUSE_INSTALL = ${SKIP_CLICKHOUSE_INSTALL} | blocking clickhouse-server to be installed"
    echo "apt-mark hold clickhouse-server"
    apt-mark hold clickhouse-server
  fi

  echo "Installing NGINX Instance Manager..."
  DEBIAN_FRONTEND=noninteractive apt-get install -y nms-instance-manager
  check_last_command_status "installing NGINX Instance Manager" $?

  if [ "${SKIP_CLICKHOUSE_INSTALL}" == "false" ]; then
      echo "Enabling clickhouse-server..."
      systemctl enable clickhouse-server
      check_last_command_status "systemctl enable clickhouse-server" $?

      echo "Starting clickhouse-server..."
      systemctl start clickhouse-server
      check_last_command_status "systemctl start clickhouse-server" $?
  fi

  echo "Starting nginx..."
  systemctl start nginx
  check_last_command_status " systemctl start nginx" $?

  echo "Starting NGINX Instance Manager..."
  systemctl start nms

  sleep 5
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
  if [[ ${SKIP_CLICKHOUSE_INSTALL} == "false" ]]; then
      debian_install_clickhouse
  fi
  debian_install_nim
  systemctl restart nms
  sleep 5
  systemctl restart nginx
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
         yum install -y nginx-plus
         check_last_command_status "yum install -y nginx-plus" $?
         createNginxMgmtFile
    else
         echo "Installing nginx..."
         yum install -y nginx --repo nginx-stable
         check_last_command_status "yum install -y nginx" $?
    fi
    echo "Enabling nginx service"
    systemctl enable nginx.service
    check_last_command_status "systemctl enable nginx.service" $?

    if [[ ${SKIP_CLICKHOUSE_INSTALL} == "false" ]]; then
        yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo
        echo "Installing clickhouse-server and clickhouse-client"

        yum install -y "clickhouse-common-static-${CLICKHOUSE_VERSION}"
        check_last_command_status "yum install -y clickhouse-common-static-${CLICKHOUSE_VERSION}" $?

        yum install -y "clickhouse-server-${CLICKHOUSE_VERSION}"
        check_last_command_status "yum install -y clickhouse-server-${CLICKHOUSE_VERSION}" $?

        yum install -y "clickhouse-client-${CLICKHOUSE_VERSION}"
        check_last_command_status "yum install -y clickhouse-client-${CLICKHOUSE_VERSION}" $?

        echo "Enabling clickhouse-server"
        systemctl enable clickhouse-server
        check_last_command_status "systemctl enable clickhouse-server" $?

        echo "Starting clickhouse-server"
        systemctl start clickhouse-server
        check_last_command_status "systemctl start clickhouse-server" $?
    fi

    curl -o /etc/yum.repos.d/nms.repo https://cs.nginx.com/static/files/nms.repo
    check_last_command_status "get -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms.repo" $?

    if cat /etc/*-release | grep -iq 'Amazon Linux'; then
        sudo sed -i 's/centos/amzn2/g' /etc/yum.repos.d/nms.repo
    fi

    echo "Installing NGINX Instance Manager"
    yum install -y nms-instance-manager
    check_last_command_status "installing nginx-instance-manager(nim)" $?

    echo "Enabling  nms nms-core nms-dpm nms-ingestion nms-integrations"
    systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now

    echo "Restarting NGINX Instance Manager"
    systemctl restart nms

    sleep 5
    echo "Restarting nginx API gateway"
    systemctl restart nginx
}

install_nim_online(){
  if cat /etc/*-release | grep -iq 'debian\|ubuntu'; then
    installBundleForDebianDistro
    generate_admin_password
  elif cat /etc/*-release | grep -iq 'centos\|fedora\|rhel\|Amazon Linux'; then
    installBundleForRPMDistro
    generate_admin_password
  else
    printf "Unsupported distribution"
    exit 1
  fi
  if [[ -n ${NIM_FQDN} ]] ; then
    echo "Using FQDN - ${NIM_FQDN}"
    sudo rm -rf /etc/nms/certs/*
    sudo bash /etc/nms/scripts/certs.sh 0 ${NIM_FQDN}
  fi
  if [[ ${SKIP_CLICKHOUSE_INSTALL} == "true" ]]; then
    sed -i '/clickhouse:/a \  enabled: false' /etc/nms/nms.conf
  fi
  sudo systemctl restart nms
  curl -s -o /dev/null --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} "https://pkgs.nginx.com/nms/?using_install_script=true&app=nim&mode=online"
}

check_nim_dashboard_status(){
  sleep 10
  GREEN='\033[0;32m'
  NC='\033[0m'

  if ! curl -k https://localhost/ui/ 2>/dev/null | grep -q "NGINX"; then
    sleep 60
    if ! curl -k -v https://localhost/ui/ 2>/dev/null| grep -q "NGINX"; then
    	echo "NGINX Instance Manager failed to start"
    	cat /var/log/nms/nms.log
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

validate_nim_installation(){
  local all_services_present=0
  if nms-core --version > /dev/null 2>&1 && nms-dpm --version > /dev/null 2>&1 && nms-integrations --version > /dev/null 2>&1 \
   && nms-ingestion --version > /dev/null 2>&1; then
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

validate_nginx_paths(){
  if [[ ! -f "$NGINX_CERT_KEY_PATH" ]]; then
    echo "Error: NGINX key not found. Please give key path using -k"
    exit 1
  fi
  if [[ ! -f "$NGINX_CERT_PATH" ]]; then
    echo "Error: NGINX cert not found. Please give cert path using -c"
    exit 1
  fi
  if [[ "$USE_NGINX_PLUS" == true  ]]; then
    if [[ ! -f "$LICENSE_JWT_PATH" ]]; then
      echo "Error: JWT License $LICENSE_JWT_PATH not found. It is required with NGINX plus"
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

uninstall_nim(){

  echo -e "\nAre you ready to remove all packages and files related to NGINX Instance Manager ? \n\
This action deletes all files in the following directories: /etc/nms , /etc/nginx, /var/log/nms"

  read -p "Enter your choice (y/N) = " response

  if [[ "$response" =~ ^[Yy]$ ]]; then
      # Clickhouse server, Clickhouse client, clickhouse static, nms, nginx
    if systemctl status clickhouse-server &> /dev/null; then
        systemctl stop clickhouse-server
        check_last_command_status "systemctl stop clickhouse-server" $?
    fi

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
      cat /etc/*release
      printf "Unsupported distribution"
      exit 1
    fi
  else
    echo -e "\nUninstallation cancelled"
    echo -e "Note -> Back up the following directories: /etc/nms, /etc/nginx, /var/log/nms. Then you can use the script to remove NGINX Instance Manager.\n"
    exit 0
  fi
}

getLatestPkgVersionFromRepo(){
    repoUrl=$1
    version=$2
    sort_fields=$3
    response=$(curl --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} -sL  "${repoUrl}" | awk -F '"' '/href=/ {print $2}' | grep -E "$version"|  eval sort "$sort_fields" | tac)
    readarray -t versions < <(printf "%s" "${response}")
    if [ "${#versions[@]}" -eq 0 ]; then
        printf "Package %s not found. See available versions:" "${versions[@]}"
        exit 1;
    else
      echo "${versions[0]}"
    fi
  }

package_nim_offline(){
        if [[ -z ${TARGET_DISTRIBUTION} ]]; then
            echo "Error: target distribution is required when mode set to offline."
            exit 1
        fi
        if [[ !  ${SUPPORTED_OS[*]} =~ ${TARGET_DISTRIBUTION} ]]; then
            echo "Error: The TARGET_DISTRIBUTION ${TARGET_DISTRIBUTION} is not supported in this script... please select one of the following options - ${SUPPORTED_OS[*]}"
            exit 1
        fi
        if [[ ${RPM_OS[*]} =~ ${TARGET_DISTRIBUTION} || ${CENT_OS[*]} =~ ${TARGET_DISTRIBUTION} ]]; then
            PKG_EXTENSION="rpm"
        fi
        if [[ ! -d "${TEMP_DIR}/${TARGET_DISTRIBUTION}" ]]; then
            echo "creating ${TEMP_DIR}/${TARGET_DISTRIBUTION}"
            mkdir -p "${TEMP_DIR}/${TARGET_DISTRIBUTION}"
        fi
        CWD=$(pwd)
        cd "${TEMP_DIR}/${TARGET_DISTRIBUTION}" || echo "directory ${TEMP_DIR} does not exits"
        if [[ "${USE_NGINX_PLUS}" == "true" ]]; then
            NGINX_PLUS_PACKAGE="^nginx-plus_[0-9]+-([0-9]+)~${OS_DISTRO_MAP[${TARGET_DISTRIBUTION}]}_${OS_ARCH}\.${PKG_EXTENSION}$"
            SORT_FIELDS="-t'_' -k2,2V"
            if [[ "${PKG_EXTENSION}" == "rpm" ]]; then
               NGINX_PLUS_PACKAGE="^nginx-plus-[0-9]+-([0-9]+)${OS_DISTRO_MAP[${TARGET_DISTRIBUTION}]}\.${PKG_EXTENSION}$"
               SORT_FIELDS="-t'-' -k3,3V"
            fi
            echo "regex for looking latest version : ${NGINX_PLUS_PACKAGE}"
            NGINX_PLUS_VERSION=$(getLatestPkgVersionFromRepo "${NGINX_PLUS_REPO[${TARGET_DISTRIBUTION}]}" "${NGINX_PLUS_PACKAGE}" "${SORT_FIELDS}")
            echo "latest version for nginx_plus is ${NGINX_PLUS_VERSION}"
            echo "Downloading ${NGINX_PLUS_REPO[${TARGET_DISTRIBUTION}]}/${NGINX_PLUS_VERSION}...."
            curl -sfLO --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} "${NGINX_PLUS_REPO[${TARGET_DISTRIBUTION}]}/${NGINX_PLUS_VERSION}"
            check_last_command_status "curl -sfLO --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} \"${NGINX_PLUS_REPO[${TARGET_DISTRIBUTION}]}/${NGINX_PLUS_VERSION}\"" $?
        else
            NGINX_OSS_PACKAGE="^nginx_[0-9]+\.[0-9]+\.[0-9]+-([0-9]+)~${OS_DISTRO_MAP[${TARGET_DISTRIBUTION}]}_${OS_ARCH}\.${PKG_EXTENSION}$"
            SORT_FIELDS="-t'_' -k2,2V"
            if [[ "${PKG_EXTENSION}" == "rpm" ]]; then
              NGINX_OSS_PACKAGE="^nginx-[0-9]+\.[0-9]+\.[0-9]+-([0-9]+)${OS_DISTRO_MAP[${TARGET_DISTRIBUTION}]}\.${PKG_EXTENSION}$"
               SORT_FIELDS="-t'-' -k2,2V"
            fi
            echo "fetching latest version using ${NGINX_OSS_PACKAGE}"
            NGINX_OSS_VERSION=$(getLatestPkgVersionFromRepo "${NGINX_REPO[${TARGET_DISTRIBUTION}]}" "${NGINX_OSS_PACKAGE}" "${SORT_FIELDS}")
            echo "latest version for nginx is ${NGINX_OSS_VERSION}"
            echo "Downloading ${NGINX_REPO[${TARGET_DISTRIBUTION}]}/${NGINX_OSS_VERSION}...."
            curl -sfLO "${NGINX_REPO[${TARGET_DISTRIBUTION}]}/${NGINX_OSS_VERSION}"
            check_last_command_status "curl -sfLO \"${NGINX_REPO[${TARGET_DISTRIBUTION}]}/${NGINX_OSS_VERSION}\"" $?
        fi
        if [[ ${SKIP_CLICKHOUSE_INSTALL} == "false" ]]; then
            CLICKHOUSE_COMMON_PATH="${CLICKHOUSE_REPO[${TARGET_DISTRIBUTION}]}/clickhouse-common-static_${CLICKHOUSE_VERSION}_${OS_ARCH}.${PKG_EXTENSION}"
            if [[ "${PKG_EXTENSION}" == "rpm" ]]; then
               CLICKHOUSE_COMMON_PATH="${CLICKHOUSE_REPO[${TARGET_DISTRIBUTION}]}/clickhouse-common-static-${CLICKHOUSE_VERSION}.x86_64.${PKG_EXTENSION}"
            fi
            echo "Downloading ${CLICKHOUSE_COMMON_PATH}...."
            curl -sfLO "${CLICKHOUSE_COMMON_PATH}"
            check_last_command_status "curl -sfLO \"${CLICKHOUSE_COMMON_PATH}\"" $?

            CLICKHOUSE_SERVER_PATH="${CLICKHOUSE_REPO[${TARGET_DISTRIBUTION}]}/clickhouse-server_${CLICKHOUSE_VERSION}_${OS_ARCH}.${PKG_EXTENSION}"
            if [[ "${PKG_EXTENSION}" == "rpm" ]]; then
               CLICKHOUSE_SERVER_PATH="${CLICKHOUSE_REPO[${TARGET_DISTRIBUTION}]}/clickhouse-server-${CLICKHOUSE_VERSION}.x86_64.${PKG_EXTENSION}"
            fi
            echo "Downloading ${CLICKHOUSE_SERVER_PATH}...."
            curl -sfLO  "${CLICKHOUSE_SERVER_PATH}"
            check_last_command_status "curl -sfLO \"${CLICKHOUSE_SERVER_PATH}\"" $?

            CLICKHOUSE_CLIENT_PATH="${CLICKHOUSE_REPO[${TARGET_DISTRIBUTION}]}/clickhouse-client_${CLICKHOUSE_VERSION}_${OS_ARCH}.${PKG_EXTENSION}"
            if [[ "${PKG_EXTENSION}" == "rpm" ]]; then
               CLICKHOUSE_CLIENT_PATH="${CLICKHOUSE_REPO[${TARGET_DISTRIBUTION}]}/clickhouse-client-${CLICKHOUSE_VERSION}.x86_64.${PKG_EXTENSION}"
            fi
            echo "Downloading ${CLICKHOUSE_CLIENT_PATH}...."
            curl -sfLO "${CLICKHOUSE_CLIENT_PATH}"
            check_last_command_status "curl -sfLO \"${CLICKHOUSE_CLIENT_PATH}\"" $?
        fi
        NIM_PACKAGE_PATH="^nms-instance-manager_[0-9]+\.[0-9]+\.[0-9]+-([0-9]+)~${OS_DISTRO_MAP[${TARGET_DISTRIBUTION}]}_${OS_ARCH}\.${PKG_EXTENSION}$"
        SORT_FIELDS="-t'_' -k2,2V"
        if [[ "${PKG_EXTENSION}" == "rpm" ]]; then
           NIM_PACKAGE_PATH="^nms-instance-manager-[0-9]+\.[0-9]+\.[0-9]+-([0-9]+)${OS_DISTRO_MAP[${TARGET_DISTRIBUTION}]}\.${PKG_EXTENSION}$"
           SORT_FIELDS="-t'-' -k4,4V"
        fi
        NIM_PACKAGE_VERSION=$(getLatestPkgVersionFromRepo "${NIM_REPO[${TARGET_DISTRIBUTION}]}" "${NIM_PACKAGE_PATH}" "${SORT_FIELDS}")
        echo "Latest version for nginx instance manager is ${NIM_PACKAGE_VERSION}...."
        curl -sfLO --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH}  "${NIM_REPO[${TARGET_DISTRIBUTION}]}/${NIM_PACKAGE_VERSION}"
        check_last_command_status "curl -sfLO --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH}  \"${NIM_REPO[${TARGET_DISTRIBUTION}]}/${NIM_PACKAGE_VERSION}\"" $?

        NIM_ARCHIVE_FILE_NAME="nim-oss-${TARGET_DISTRIBUTION}.tar.gz"
        if [[ "${USE_NGINX_PLUS}" == "true" ]]; then
          NIM_ARCHIVE_FILE_NAME="nim-plus-${TARGET_DISTRIBUTION}.tar.gz"
        fi
        echo -n "Creating NGINX instance manager install bundle ... ${NIM_ARCHIVE_FILE_NAME}"
        cp ${NGINX_CERT_PATH}  "${TEMP_DIR}/${TARGET_DISTRIBUTION}/nginx-repo.crt"
        cp ${NGINX_CERT_KEY_PATH} "${TEMP_DIR}/${TARGET_DISTRIBUTION}/nginx-repo.key"
        cd "${CWD}" || echo "failed to change directory to ${CWD}"
        tar -zcf "/tmp/${NIM_ARCHIVE_FILE_NAME}" -C "${TEMP_DIR}/${TARGET_DISTRIBUTION}" .
        cp "/tmp/${NIM_ARCHIVE_FILE_NAME}" "${CWD}"
        echo -e "\nSuccessfully created the NGINX Instance Manager bundle - ${NIM_ARCHIVE_FILE_NAME}"
        rm -rf "${TEMP_DIR}" || echo "failed to delete the temporary directory ${TEMP_DIR}"
        curl -s -o /dev/null --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} "https://pkgs.nginx.com/nms/?using_install_script=true&app=nim&mode=offline"
}

install_nim_offline_from_file(){
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
          if [[ ${SKIP_CLICKHOUSE_INSTALL} == "false" ]]; then
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
          fi

          for pkg_nim in "${TEMP_DIR}"/nms-instance-manager*.deb; do
              echo "Installing NGINX Instance Manager from ${pkg_nim}"
              DEBIAN_FRONTEND=noninteractive dpkg -i "$pkg_nim"
              check_last_command_status "dpkg -i \"$pkg_nim\"" $?
          done
          generate_admin_password
          if [[ ${SKIP_CLICKHOUSE_INSTALL} == "false" ]]; then
              echo "Starting clickhouse-server"
              systemctl start clickhouse-server
          fi
          echo "Enabling and starting NGINX Instance Manager"
          systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now
          systemctl start nms nms-core nms-dpm nms-ingestion nms-integrations || journalctl -xeu nms*
          echo "Restart nginx configuration"
          systemctl restart nginx || journalctl -xeu nginx
          check_nim_dashboard_status

        elif cat /etc/*-release | grep -iq 'centos\|fedora\|rhel\|Amazon Linux'; then
          yum update -y
          for pkg_nginx in "${TEMP_DIR}"/nginx*.rpm; do
            echo "Installing nginx from ${pkg_nginx}"
            yum localinstall -y -v --disableplugin=subscription-manager --skip-broken "$pkg_nginx"
          done
          if [[ ${SKIP_CLICKHOUSE_INSTALL} == "false" ]]; then
              for pkg_clickhouse in "${TEMP_DIR}"/clickhouse-common*.rpm; do
                echo "Installing clickhouse dependencies from ${pkg_clickhouse}"
                yum localinstall -y -v --disableplugin=subscription-manager --skip-broken "$pkg_clickhouse"
              done
              for pkg_clickhouse_srv in "${TEMP_DIR}"/clickhouse-server*.rpm; do
                echo "Installing clickhouse dependencies from ${pkg_clickhouse}"
                yum localinstall -y -v --disableplugin=subscription-manager --skip-broken "$pkg_clickhouse_srv"
              done
          fi
          for pkg_nim in "${TEMP_DIR}"/nms-instance-manager*.rpm; do
            echo "Installing NGINX Instance Manager from ${pkg_nim}"
            yum localinstall -y -v --disableplugin=subscription-manager --skip-broken "$pkg_nim"
          done

          generate_admin_password
          if [[ ${SKIP_CLICKHOUSE_INSTALL} == "false" ]]; then
              echo "Starting clickhouse-server"
              systemctl start clickhouse-server
          fi

          echo "Enabling and starting NGINX Instance Manager"
          systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now
          systemctl start nms nms-core nms-dpm nms-ingestion nms-integrations || journalctl -xeu nms*
          systemctl restart nginx || journalctl -xeu nginx
          check_nim_dashboard_status

        else
          echo "Unsupported distribution"
          exit 1
        fi

      else
        echo "Provided install path ${INSTALL_PATH} doesn't exists"
        exit 1
      fi
      if [[ -n ${NIM_FQDN} ]] ; then
        echo "Using FQDN - ${NIM_FQDN}"
        sudo rm -rf /etc/nms/certs/*
        sudo bash /etc/nms/scripts/certs.sh 0 ${NIM_FQDN}
      fi
      curl -s -o /dev/null --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} "https://pkgs.nginx.com/nms/?using_install_script=true&app=nim&mode=offline"
}

confirm_action() {
    read -p "$1 (y/n)? " -n 1 -r
    echo # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled by user."
        exit 1
    fi
    echo ""
}

printUsageInfo(){
  echo "Usage: $0 [OPTIONS]"
  printf "\nThis script is used to install and setup Nginx Instance Manager\n"
  printf "\n\n Options:\n"
  printf "\n  -a  arch(amd64/arm64) for the offline packages to download. Valid only when mode is set to offline \n"
  printf "\n  -c  /path/to/your/<nginx-repo.crt> file.\n"
  printf "\n  -d  <distribution>. Include the label of a distribution. Requires -m Offline. This creates a file with NGINX Instance Manager dependencies and NGINX Instance Manager install packages for the specified distribution"
  printf "\n      [ubuntu20.04,ubuntu22.04,ubuntu24.04,debian11,debian12,centos8,rhel8,rhel9,oracle8,oracle9]\n"
  printf "\n  -f  <NIM_FQDN> use to specify the fully qualified domain name to use for generating nim certificates.\n"
  printf "\n  -h  Print this help message.\n"
  printf "\n  -i  <installable_tar_file_path>. Include the path with an archive file to support NGINX Instance Manager installation. Requires -m Offline.\n"
  printf "\n  -j  <JWT_TOKEN_FILE_PATH>. Path to the JWT token file used for license and usage consumption reporting.\n"
  printf "\n  -k  /path/to/your/<nginx-repo.key> file.\n"
  printf "\n  -l  Print supported operating systems.\n"
  printf "\n  -m  <mode> online/offline. Controls whether to install from the internet or from a package created using this script. \n"
  printf "\n  -p  Include NGINX Plus as an API gateway. \n"
  printf "\n  -r  To uninstall NGINX Instance Manager and its dependencies. \n"
  printf "\n  -s  Skip packaging/installing clickhouse packages. \n"
  printf "\n  -v  clickhouse version to install/package. \n"
  printf "\n  -y  Install Nginx Instance Manager if all the requirements are passed. \n"
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
  printf "\n  9. oracle8(Oracle Linux Version 8)\n"
  printf "\n  10. oracle9(Oracle Linux Version 9)\n"
  exit 0
}

OPTS_STRING="a:c:d:f:hi:j:k:lm:prsv:y"

while getopts ${OPTS_STRING} opt; do
  case ${opt} in
    a)
      if [[ "${OPTARG}" != "amd64" && "${OPTARG}" != "arm64" ]]; then
          echo "invalid OS arch type ${OPTARG}"
          echo "supported values are 'amd64' or 'arm64'"
          exit 1
      fi
      OS_ARCH=${OPTARG}
      ;;
    c)
      if [ ! -d "/etc/ssl/nginx" ]; then
        mkdir /etc/ssl/nginx
        check_last_command_status "mkdir /etc/ssl/nginx" $?
      fi
      cp "${OPTARG}" ${NGINX_CERT_PATH}
      check_last_command_status "cp ${OPTARG} ${NGINX_CERT_PATH}" $?
      ;;
    d)
      TARGET_DISTRIBUTION=${OPTARG}
      ;;
    f)
      NIM_FQDN=${OPTARG}
      ;;
    h)
      printUsageInfo
      exit 0
      ;;
    i)
      INSTALL_PATH=${OPTARG}
      ;;
    j)
      LICENSE_JWT_PATH=${OPTARG}
      ;;
    k)
      if [ ! -d "/etc/ssl/nginx" ]; then
          mkdir /etc/ssl/nginx
          check_last_command_status "mkdir /etc/ssl/nginx" $?
      fi
      cp "${OPTARG}" ${NGINX_CERT_KEY_PATH}
      check_last_command_status "cp ${OPTARG} ${NGINX_CERT_KEY_PATH}" $?
      ;;
    l)
      printSupportedOS
      exit 0
      ;;
    m)
      MODE="${OPTARG}"
      if [[ "${MODE}" != "online" && "${MODE}" != "offline" ]]; then
        echo "invalid mode ${MODE}"
        echo "supported values for mode are 'online' or 'offline'"
        exit 1
      fi
      ;;
    p)
      USE_NGINX_PLUS="true"
      ;;
    r)
      UNINSTALL_NIM="true"
      ;;
    s)
      SKIP_CLICKHOUSE_INSTALL="true"
      ;;
    v)
      CLICKHOUSE_VERSION=${OPTARG}
      ;;
    y)
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

if [[ "$#" == "0" ]]; then
  printUsageInfo
  exit 0
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script is not being executed with sudo permissions."
   echo "Please run it with sudo, e.g., sudo bash install-nim-bundle.sh"
   exit 1
fi

validate_nim_installation
validate_nginx_paths

if [ "${MODE}" == "online" ]; then
  install_nim_online
  check_nim_dashboard_status
else
  if [ -z "${INSTALL_PATH}" ]; then
    package_nim_offline
  else
    install_nim_offline_from_file
  fi
fi
