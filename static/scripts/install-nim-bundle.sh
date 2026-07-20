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
INSTALL_WAF_COMPILER="false"
CROSS_OS_PACKAGING="false"
MODE="online"
INSTALL_PATH=""
SKIP_CLICKHOUSE_INSTALL="false"
CURRENT_TIME=$(date +%s)
TEMP_DIR="/tmp/${CURRENT_TIME}"
TARGET_DISTRIBUTION=""
NMS_NGINX_MGMT_BLOCK="mgmt { \n  usage_report endpoint=127.0.0.1 interval=30m; \n  ssl_verify off; \n}";
NIM_FQDN=""
OS_ARCH="amd64"
UBUNTU_2204="ubuntu22.04"
UBUNTU_2404="ubuntu24.04"
DEBIAN_11="debian11"
DEBIAN_12="debian12"
DEBIAN_13="debian13"
REDHAT_8="rhel8"
REDHAT_9="rhel9"
REDHAT_10="rhel10"
ORACLE_8="oracle8"
ROCKY_8="rocky8"
ROCKY_9="rocky9"
ROCKY_10="rocky10"
CLICKHOUSE_VERSION="24.9.2.42"
PKG_EXTENSION="deb"
UBUNTU_OS=(
    "${UBUNTU_2204}"
    "${UBUNTU_2404}"
)
DEB_OS=(
    "${DEBIAN_11}"
    "${DEBIAN_12}"
    "${DEBIAN_13}"
)
RPM_OS=(
    "${REDHAT_8}"
    "${REDHAT_9}"
    "${REDHAT_10}"
    "${ORACLE_8}"
    "${ROCKY_8}"
    "${ROCKY_9}"
    "${ROCKY_10}"
)
SUPPORTED_OS=()
SUPPORTED_OS+=("${DEB_OS[@]}")
SUPPORTED_OS+=("${RPM_OS[@]}")
SUPPORTED_OS+=("${UBUNTU_OS[@]}")

declare -A OS_DISTRO_MAP
OS_DISTRO_MAP['ubuntu22.04']="jammy"
OS_DISTRO_MAP['ubuntu24.04']="noble"
OS_DISTRO_MAP['debian11']="bullseye"
OS_DISTRO_MAP['debian12']="bookworm"
OS_DISTRO_MAP['debian13']="trixie"
OS_DISTRO_MAP['rhel8']=".el8.ngx.x86_64"
OS_DISTRO_MAP['rhel9']=".el9.ngx.x86_64"
OS_DISTRO_MAP['rhel10']=".el10.ngx.x86_64"
OS_DISTRO_MAP['oracle8']=".el8.ngx.x86_64"
OS_DISTRO_MAP['rocky8']=".el8.ngx.x86_64"
OS_DISTRO_MAP['rocky9']=".el9.ngx.x86_64"
OS_DISTRO_MAP['rocky10']=".el10.ngx.x86_64"
OS_DISTRO_MAP['amzn2']=".amzn2.ngx.x86_64"

declare -A NGINX_PLUS_REPO
NGINX_PLUS_REPO['ubuntu22.04']="https://pkgs.nginx.com/plus/ubuntu/pool/nginx-plus/n/nginx-plus"
NGINX_PLUS_REPO['ubuntu24.04']="https://pkgs.nginx.com/plus/ubuntu/pool/nginx-plus/n/nginx-plus"
NGINX_PLUS_REPO['debian11']="https://pkgs.nginx.com/plus/debian/pool/nginx-plus/n/nginx-plus"
NGINX_PLUS_REPO['debian12']="https://pkgs.nginx.com/plus/debian/pool/nginx-plus/n/nginx-plus"
NGINX_PLUS_REPO['debian13']="https://pkgs.nginx.com/plus/debian/pool/nginx-plus/n/nginx-plus"
NGINX_PLUS_REPO['rhel8']="https://pkgs.nginx.com/plus/rhel/8/x86_64/RPMS"
NGINX_PLUS_REPO['rhel9']="https://pkgs.nginx.com/plus/rhel/9/x86_64/RPMS"
NGINX_PLUS_REPO['rhel10']="https://pkgs.nginx.com/plus/rhel/10/x86_64/RPMS"
NGINX_PLUS_REPO['oracle8']="https://pkgs.nginx.com/plus/rhel/8/x86_64/RPMS"
NGINX_PLUS_REPO['rocky8']="https://pkgs.nginx.com/plus/rhel/8/x86_64/RPMS"
NGINX_PLUS_REPO['rocky9']="https://pkgs.nginx.com/plus/rhel/9/x86_64/RPMS"
NGINX_PLUS_REPO['rocky10']="https://pkgs.nginx.com/plus/rhel/10/x86_64/RPMS"
NGINX_PLUS_REPO['amzn2']="https://pkgs.nginx.com/plus/amzn2/2/x86_64/RPMS"

declare -A NIM_REPO
NIM_REPO['ubuntu22.04']="https://pkgs.nginx.com/nms/ubuntu/pool/nginx-plus/n/nms-instance-manager"
NIM_REPO['ubuntu24.04']="https://pkgs.nginx.com/nms/ubuntu/pool/nginx-plus/n/nms-instance-manager"
NIM_REPO['debian11']="https://pkgs.nginx.com/nms/debian/pool/nginx-plus/n/nms-instance-manager"
NIM_REPO['debian12']="https://pkgs.nginx.com/nms/debian/pool/nginx-plus/n/nms-instance-manager"
NIM_REPO['debian13']="https://pkgs.nginx.com/nms/debian/pool/nginx-plus/n/nms-instance-manager"
NIM_REPO['rhel8']="https://pkgs.nginx.com/nms/centos/8/x86_64/RPMS"
NIM_REPO['rhel9']="https://pkgs.nginx.com/nms/centos/9/x86_64/RPMS"
NIM_REPO['rhel10']="https://pkgs.nginx.com/nms/centos/10/x86_64/RPMS"
NIM_REPO['oracle8']="https://pkgs.nginx.com/nms/centos/8/x86_64/RPMS"
NIM_REPO['rocky8']="https://pkgs.nginx.com/nms/centos/8/x86_64/RPMS"
NIM_REPO['rocky9']="https://pkgs.nginx.com/nms/centos/9/x86_64/RPMS"
NIM_REPO['rocky10']="https://pkgs.nginx.com/nms/centos/10/x86_64/RPMS"
NIM_REPO['amzn2']="https://pkgs.nginx.com/nms/amzn2/2/x86_64/RPMS"

declare -A NGINX_REPO
NGINX_REPO['ubuntu22.04']="https://nginx.org/packages/mainline/ubuntu/pool/nginx/n/nginx"
NGINX_REPO['ubuntu24.04']="https://nginx.org/packages/mainline/ubuntu/pool/nginx/n/nginx"
NGINX_REPO['debian11']="https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx"
NGINX_REPO['debian12']="https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx"
NGINX_REPO['debian13']="https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx"
NGINX_REPO['rhel8']="https://nginx.org/packages/mainline/rhel/8/x86_64/RPMS"
NGINX_REPO['rhel9']="https://nginx.org/packages/mainline/rhel/9/x86_64/RPMS"
NGINX_REPO['rhel10']="https://nginx.org/packages/mainline/rhel/10/x86_64/RPMS"
NGINX_REPO['oracle8']="https://nginx.org/packages/mainline/rhel/8/x86_64/RPMS"
NGINX_REPO['rocky8']="https://nginx.org/packages/mainline/rhel/8/x86_64/RPMS"
NGINX_REPO['rocky9']="https://nginx.org/packages/mainline/rhel/9/x86_64/RPMS"
NGINX_REPO['rocky10']="https://nginx.org/packages/mainline/rhel/10/x86_64/RPMS"
NGINX_REPO['amzn2']="https://nginx.org/packages/mainline/amzn2/2/x86_64/RPMS"

declare -A CLICKHOUSE_REPO
CLICKHOUSE_REPO['ubuntu22.04']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse"
CLICKHOUSE_REPO['ubuntu24.04']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse"
CLICKHOUSE_REPO['debian11']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse"
CLICKHOUSE_REPO['debian12']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse"
CLICKHOUSE_REPO['debian13']="https://packages.clickhouse.com/deb/pool/main/c/clickhouse"
CLICKHOUSE_REPO['rhel8']="https://packages.clickhouse.com/rpm/stable"
CLICKHOUSE_REPO['rhel9']="https://packages.clickhouse.com/rpm/stable"
CLICKHOUSE_REPO['rhel10']="https://packages.clickhouse.com/rpm/stable"
CLICKHOUSE_REPO['oracle8']="https://packages.clickhouse.com/rpm/stable"
CLICKHOUSE_REPO['rocky8']="https://packages.clickhouse.com/rpm/stable"
CLICKHOUSE_REPO['rocky9']="https://packages.clickhouse.com/rpm/stable"
CLICKHOUSE_REPO['rocky10']="https://packages.clickhouse.com/rpm/stable"
CLICKHOUSE_REPO['amzn2']="https://packages.clickhouse.com/rpm/stable"

# Note: compiler packages are fetched via the nms yum/apt repo
# (configured in /etc/yum.repos.d/nms.repo or /etc/apt/sources.list.d/nms.list)
# using yum search / apt-cache search, so no separate URL map is needed.

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

  # Ensure rsyslog is installed — Debian 13+ does not include it by default
  # but nms-instance-manager declares it as a hard dependency.
  if ! dpkg -l rsyslog 2>/dev/null | grep -q "^ii"; then
      echo "Installing rsyslog dependency (not present on this system)..."
      DEBIAN_FRONTEND=noninteractive apt-get update -y
      DEBIAN_FRONTEND=noninteractive apt-get install -y rsyslog
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

debian_install_compiler(){
  echo "Installing WAF compiler (nms-nap-compiler)..."

  # Create required directories with correct ownership
  mkdir -p /etc/nms-nap-compiler
  mkdir -p /opt/nms-nap-compiler
  chown -R ${NIM_USER}:${NIM_GROUP} /etc/nms-nap-compiler
  chown -R ${NIM_USER}:${NIM_GROUP} /opt/nms-nap-compiler

  LATEST_COMPILER_VERSION=$(apt-cache search nms-nap-compiler | awk '{print $1}' | sort -V | tail -1)
  if [ -z "$LATEST_COMPILER_VERSION" ]; then
    echo "Warning: No nms-nap-compiler package found. Skipping WAF compiler installation."
    return
  fi
  echo "Installing $LATEST_COMPILER_VERSION..."
  DEBIAN_FRONTEND=noninteractive apt-get install -y "$LATEST_COMPILER_VERSION"
  check_last_command_status "apt-get install -y $LATEST_COMPILER_VERSION" $?
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
  if [[ ${INSTALL_WAF_COMPILER} == "true" ]]; then
      debian_install_compiler
  fi
  systemctl restart nms
  sleep 5
  systemctl restart nginx
}

check_restorecon(){
  local path="$1"

    if ! sudo restorecon -F -R "$path"; then
        YELLOW='\033[1;33m'
        NC='\033[0m'
        echo -e "${YELLOW}WARNING: Something happened${NC}"
    else
        echo "restorecon succeeded for $path"
    fi
}

rpm_install_compiler(){
  echo "Installing WAF compiler (nms-nap-compiler)..."

  # Create required directories with correct ownership
  mkdir -p /etc/nms-nap-compiler
  mkdir -p /opt/nms-nap-compiler
  chown -R ${NIM_USER}:${NIM_GROUP} /etc/nms-nap-compiler
  chown -R ${NIM_USER}:${NIM_GROUP} /opt/nms-nap-compiler

  # For EL8, add CentOS Vault PowerTools repo for dependencies
  source /etc/os-release 2>/dev/null || true
  if [[ "${VERSION_ID%%.*}" == "8" && "$ID" =~ ^(rhel|rocky|ol|centos)$ ]]; then
tee /etc/yum.repos.d/centos-vault-powertools.repo << 'EOF'
[centos-vault-powertools]
name=CentOS Vault - PowerTools
baseurl=https://vault.centos.org/centos/8/PowerTools/x86_64/os/
enabled=1
gpgcheck=1
gpgkey=https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
EOF
  fi

  # EL10: EPEL + CRB/CodeReady-Builder required for compiler deps
  if [[ "${VERSION_ID%%.*}" == "10" && "$ID" =~ ^(rhel|rocky|ol|centos)$ ]]; then
    rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-10
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
    if [[ "$ID" == "rocky" ]]; then
      dnf config-manager --set-enabled crb
    else
      dnf config-manager --set-enabled codeready-builder-for-rhel-10-rhui-rpms
    fi
  fi

  yum makecache -y
  LATEST_COMPILER_VERSION=$(yum search nms-nap-compiler --repo=nms 2>/dev/null | grep "nms-nap-compiler-v" | awk '{print $1}' | sort -V | tail -1)
  if [ -z "$LATEST_COMPILER_VERSION" ]; then
    echo "Warning: No nms-nap-compiler package found. Skipping WAF compiler installation."
    return
  fi
  echo "Installing $LATEST_COMPILER_VERSION..."
  yum install -y "$LATEST_COMPILER_VERSION"
  check_last_command_status "yum install -y $LATEST_COMPILER_VERSION" $?
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
  
    yum -y update
    check_last_command_status "yum update" $?
  
    yum install -y yum-utils curl epel-release ca-certificates
  
    if [ "${USE_NGINX_PLUS}" == "true" ]; then
         echo "Installing nginx plus..."
         yum install -y nginx-plus
         check_last_command_status "yum install -y nginx-plus" $?
         create_nginx_mgmt_file
    else
         echo "Installing nginx..."
         yum install -y nginx --repo nginx-stable
         check_last_command_status "yum install -y nginx" $?
    fi
    echo "Enabling nginx service"
    systemctl enable nginx.service
    check_last_command_status "systemctl enable nginx.service" $?

    if [[ ${SKIP_CLICKHOUSE_INSTALL} == "false" ]]; then
        dnf config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo
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

    # Disable the 'adm' (App Delivery Manager) repo from nms.repo — it does not
    # publish packages for all OS versions (e.g., RHEL 9, RHEL 10) and causes
    # metadata download failures (404). Only the 'nms' repo is needed for NIM.
    sed -i '/^\[adm\]/,/^\[/{s/^enabled[[:space:]]*=[[:space:]]*1/enabled=0/}' /etc/yum.repos.d/nms.repo 2>/dev/null || true

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
    
    sleep 2
    check_restorecon /usr/bin/nms-core
    check_restorecon /usr/bin/nms-dpm
    check_restorecon /usr/bin/nms-ingestion
    check_restorecon /usr/bin/nms-integrations
    check_restorecon /usr/bin/nms-sm
    check_restorecon /usr/lib/systemd/system/nms.service
    check_restorecon /usr/lib/systemd/system/nms-core.service
    check_restorecon /usr/lib/systemd/system/nms-dpm.service
    check_restorecon /usr/lib/systemd/system/nms-sm.service
    check_restorecon /usr/lib/systemd/system/nms-ingestion.service
    check_restorecon /usr/lib/systemd/system/nms-integrations.service
    check_restorecon /var/lib/nms/modules/manager.json
    check_restorecon /var/lib/nms/modules.json
    check_restorecon /var/lib/nms/secrets
    check_restorecon /var/lib/nms/streaming
    check_restorecon /var/lib/nms
    check_restorecon /var/lib/nms/dqlite
    check_restorecon /var/run/nms
    check_restorecon /var/lib/nms/modules
    check_restorecon /var/log/nms

    if [[ ${INSTALL_WAF_COMPILER} == "true" ]]; then
        rpm_install_compiler
    fi

    sleep 5
}

install_nim_online(){
  sleep 1
  if cat /etc/*-release | grep -iq 'debian\|ubuntu'; then
    installBundleForDebianDistro
    generate_admin_password
  elif cat /etc/*-release | grep -iq 'centos\|fedora\|rhel\|Amazon Linux\|rocky'; then
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
    sleep 1

    if cat /etc/*-release | grep -iq 'debian\|ubuntu'; then
      apt-get -y remove clickhouse-common-static clickhouse-server clickhouse-client
      apt-get -y remove nms-instance-manager --purge
      check_last_command_status "apt-get remove nms-instance-manager" $?
      # Remove WAF compiler packages
      apt -y remove $(dpkg -l | grep "^ii" | grep nms-nap-compiler | awk '{print $2}') 2>/dev/null || true
      rm -rf /etc/nms-nap-compiler
      rm -rf /opt/nms-nap-compiler
      apt-get -y remove nginx --purge
      apt-get -y remove nginx-plus --purge
      rm -rf /etc/nginx
      rm -rf /etc/nms
      rm -rf /var/log/nms
      echo "NGINX Instance Manager Uninstalled successfully"
      exit 0
    elif cat /etc/*-release | grep -iq 'centos\|fedora\|rhel\|Amazon Linux\|rocky'; then
      yum -y remove clickhouse-common-static clickhouse-server clickhouse-client
      yum -y remove nms-instance-manager
      check_last_command_status "yum remove nms-instance-manager" $?
      # Remove WAF compiler packages
      yum -y remove $(rpm -qa | grep nms-nap-compiler) 2>/dev/null || true
      rm -rf /etc/nms-nap-compiler
      rm -rf /opt/nms-nap-compiler
      yum -y remove nginx
      yum -y remove nginx-plus
      rm -rf /etc/nginx
      rm -rf /etc/nms
      rm -rf /var/log/nms
      yum -y autoremove
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

package_rpm_compiler_dependencies(){
  echo "Creating NMS NAP Compiler rpm offline package"
  source /etc/os-release 2>/dev/null || true
  if [[ "${VERSION_ID%%.*}" == "8" && "$ID" =~ ^(rhel|rocky|ol|centos)$ ]]; then
tee /etc/yum.repos.d/centos-vault-powertools.repo << 'EOF'
[centos-vault-powertools]
name=CentOS Vault - PowerTools
baseurl=https://vault.centos.org/centos/8/PowerTools/x86_64/os/
enabled=1
gpgcheck=1
gpgkey=https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
EOF
  elif [[ "${VERSION_ID%%.*}" =~ ^(9|10)$ && "$ID" =~ ^(rhel|rocky|ol|centos)$ ]]; then
    echo ""
  else
    echo "Skipping NAP compiler packaging as the OS is not supported"
    return
  fi

  curl -o /etc/yum.repos.d/nms.repo https://cs.nginx.com/static/files/nms.repo

  # Disable the 'adm' (App Delivery Manager) repo from nms.repo — it does not
  # publish packages for all OS versions (e.g., RHEL 9, RHEL 10) and causes
  # metadata download failures (404). Only the 'nms' repo is needed.
  sed -i '/^\[adm\]/,/^\[/{s/^enabled[[:space:]]*=[[:space:]]*1/enabled=0/}' /etc/yum.repos.d/nms.repo 2>/dev/null || true

  mkdir -p /etc/ssl/nginx/
  cp "${NGINX_CERT_PATH}" /etc/ssl/nginx/
  cp "${NGINX_CERT_KEY_PATH}" /etc/ssl/nginx/
  yum makecache -y
  if [[ "${VERSION_ID%%.*}" == "10" && "$ID" =~ ^(rhel|rocky|ol|centos)$ ]]; then
    rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-10
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
    if [[ "$ID" == "rocky" ]]; then
      dnf config-manager --set-enabled crb
    else
      dnf config-manager --set-enabled codeready-builder-for-rhel-10-rhui-rpms
    fi
  fi
  sudo yum update -y
  yum install -y yum-utils
  mkdir -p nms-nap-compiler
  LATEST_COMPILER_VERSION=$(yum search nms-nap-compiler --repo=nms 2>/dev/null | grep "nms-nap-compiler-v" | awk '{print $1}' | sort -V | tail -1)
  if [ -z "$LATEST_COMPILER_VERSION" ]; then
    echo "Warning: No nms-nap-compiler package found. Skipping WAF compiler packaging."
    rm -rf nms-nap-compiler
    return
  fi
  echo "Packaging NAP compiler version - $LATEST_COMPILER_VERSION"
  # Use an empty installroot so dnf downloads the full transitive dependency tree
  # (including perl, re2, xalan-c, etc.) even if they are already installed on
  # the packaging machine. Without this, yumdownloader --resolve skips installed
  # packages, causing missing-dependency errors on clean offline target systems.
  INSTALLROOT=$(mktemp -d)
  dnf install -y --downloadonly \
      --installroot="${INSTALLROOT}" \
      --releasever="$(rpm -E %rhel)" \
      --setopt=install_weak_deps=False \
      --setopt=keepcache=1 \
      --downloaddir=nms-nap-compiler \
      "$LATEST_COMPILER_VERSION"
  rm -rf "${INSTALLROOT}"
  tar -czf compiler.tar.gz nms-nap-compiler/
  mv compiler.tar.gz "${TEMP_DIR}/${TARGET_DISTRIBUTION}/"
  rm -rf nms-nap-compiler
}

package_deb_compiler_dependencies(){
  echo "Creating NMS NAP Compiler deb offline package"
  # detect whether this is Ubuntu or Debian
  local FLAVOUR
  if grep -Eiq '^ID=ubuntu' /etc/os-release; then
    FLAVOUR="ubuntu"
  elif grep -Eiq '^ID=debian' /etc/os-release; then
    FLAVOUR="debian"
  else
    echo "Error: unsupported Debian-based distribution" >&2
    return
  fi

  mkdir -p /etc/ssl/nginx/
  cp "${NGINX_CERT_PATH}" /etc/ssl/nginx/
  cp "${NGINX_CERT_KEY_PATH}" /etc/ssl/nginx/

  apt-get install -y gnupg wget

  wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key \
      | gpg --dearmor \
      | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

  printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/nms/%s %s nginx-plus\n" \
    "${FLAVOUR}" "$(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/nms.list

  wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx
  local START_DIR
  START_DIR=$(pwd)
  mkdir -p nms-nap-compiler && cd nms-nap-compiler || return
  apt-get -y update
  LATEST_COMPILER_VERSION=$(apt-cache search nms-nap-compiler | awk '{print $1}' | sort -V | tail -1)
  if [ -z "$LATEST_COMPILER_VERSION" ]; then
    echo "Warning: No nms-nap-compiler package found. Skipping WAF compiler packaging."
    cd "${START_DIR}" || return
    rm -rf nms-nap-compiler
    return
  fi
  echo "Packaging NAP compiler version - $LATEST_COMPILER_VERSION"
  apt-get download "$LATEST_COMPILER_VERSION"
  cd "${START_DIR}" || return
  mkdir -p nms-nap-compiler/compiler.deps
  mkdir -p nms-nap-compiler/compiler.deps/partial
  # Use an empty dpkg status file so apt thinks nothing is installed. This forces
  # it to emit download URIs for the full dependency tree including Pre-Depends
  # (e.g., libarchive-tools). Without this, apt skips packages already installed
  # on the packaging machine, causing dpkg failures on clean offline targets.
  EMPTY_STATUS=$(mktemp)
  source /etc/os-release 2>/dev/null || true
  if [[ "$ID" == "debian" && "${VERSION_ID%%.*}" =~ ^(12|13)$ ]]; then
    apt-get install --download-only --reinstall --yes \
      -o Dir::Cache::archives=./nms-nap-compiler/compiler.deps \
      -o Dir::State::status="${EMPTY_STATUS}" \
      "$LATEST_COMPILER_VERSION"
  else
    apt-get install --download-only --reinstall --yes --print-uris \
        -o Dir::State::status="${EMPTY_STATUS}" \
        -o Debug::NoLocking=true \
        "$LATEST_COMPILER_VERSION" \
      | grep ^\' | cut -d\' -f2 | xargs -n 1 wget -P ./nms-nap-compiler/compiler.deps
  fi
  rm -f "${EMPTY_STATUS}"
  tar -czf compiler.tar.gz nms-nap-compiler/
  mv compiler.tar.gz "${TEMP_DIR}/${TARGET_DISTRIBUTION}/"
  rm -rf nms-nap-compiler
}

check_for_cross_os_packaging(){
  # Detect current OS and compare with TARGET_DISTRIBUTION.
  # NAP compiler dependency resolution only works when packager OS == target OS.
  local current_os=""
  sleep 1
  if cat /etc/*-release | grep -iq 'ubuntu'; then
    local ubuntu_version
    ubuntu_version=$(lsb_release -rs 2>/dev/null)
    case "$ubuntu_version" in
      "22.04") current_os="${UBUNTU_2204}" ;;
      "24.04") current_os="${UBUNTU_2404}" ;;
    esac
  elif cat /etc/*-release | grep -iq 'debian'; then
    local debian_version
    debian_version=$(cut -d'.' -f1 </etc/debian_version 2>/dev/null)
    case "$debian_version" in
      "11") current_os="${DEBIAN_11}" ;;
      "12") current_os="${DEBIAN_12}" ;;
      "13") current_os="${DEBIAN_13}" ;;
    esac
  elif cat /etc/*-release | grep -iq 'rocky'; then
    local rocky_version
    rocky_version=$(grep -o 'release [0-9]\+' /etc/*-release | head -1 | awk '{print $2}')
    case "$rocky_version" in
      "8")  current_os="${ROCKY_8}" ;;
      "9")  current_os="${ROCKY_9}" ;;
      "10") current_os="${ROCKY_10}" ;;
    esac
  elif cat /etc/*-release | grep -iq 'oracle'; then
    local oracle_version
    oracle_version=$(grep -o 'release [0-9]\+' /etc/*-release | head -1 | awk '{print $2}')
    case "$oracle_version" in
      "8") current_os="${ORACLE_8}" ;;
    esac
  elif cat /etc/*-release | grep -iq 'rhel\|red hat'; then
    local rhel_version
    rhel_version=$(grep -o 'release [0-9]\+' /etc/*-release | head -1 | awk '{print $2}')
    case "$rhel_version" in
      "8")  current_os="${REDHAT_8}" ;;
      "9")  current_os="${REDHAT_9}" ;;
      "10") current_os="${REDHAT_10}" ;;
    esac
  fi

  if [[ -n "${current_os}" && -n "${TARGET_DISTRIBUTION}" && "${current_os}" != "${TARGET_DISTRIBUTION}" ]]; then
    CROSS_OS_PACKAGING="true"
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
        if [[ ${RPM_OS[*]} =~ ${TARGET_DISTRIBUTION} ]]; then
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

        if [[ "${INSTALL_WAF_COMPILER}" == "true" ]]; then
            check_for_cross_os_packaging
            if [[ "${CROSS_OS_PACKAGING}" == "true" ]]; then
                YELLOW='\033[1;33m'
                NC='\033[0m'
                echo -e "\n${YELLOW}WARNING: Cross-OS packaging detected (host != ${TARGET_DISTRIBUTION}). Skipping NAP compiler packaging.${NC}"
            else
                if [[ "${PKG_EXTENSION}" == "rpm" ]]; then
                    package_rpm_compiler_dependencies
                else
                    package_deb_compiler_dependencies
                fi
            fi
        fi

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
        if [[ "${INSTALL_WAF_COMPILER}" == "true" && "${CROSS_OS_PACKAGING}" == "true" ]]; then
          YELLOW='\033[1;33m'
          NC='\033[0m'
          echo -e "\n${YELLOW}WARNING: Cross-OS packaging detected!${NC}"
          echo -e "${YELLOW}Skipped NAP compiler packaging; it won't be installed on the target system.${NC}"
          echo -e "${YELLOW}For best compatibility, create packages on the same OS as the target deployment environment.${NC}"
          echo -e "${YELLOW}To install NAP compiler on the target manually, see: https://docs.nginx.com/nginx-instance-manager/nginx-app-protect/setup-waf-config-management/#install-or-update-the-waf-compiler-in-a-disconnected-environment${NC}"
        fi
        echo -e "\nSuccessfully created the NGINX Instance Manager bundle - ${NIM_ARCHIVE_FILE_NAME}"
        rm -rf "${TEMP_DIR}" || echo "failed to delete the temporary directory ${TEMP_DIR}"
        curl -s -o /dev/null --connect-timeout 10 --max-time 30 --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} "https://pkgs.nginx.com/nms/?using_install_script=true&app=nim&mode=offline" || echo "Telemetry report skipped (disconnected environment)."
}

install_nim_offline_from_file(){
      echo "Installing NGINX Instance Manager bundle from the path ${INSTALL_PATH}"
      if [ -f "${INSTALL_PATH}" ]; then
        if [ ! -f "${TEMP_DIR}" ]; then
          mkdir -p "${TEMP_DIR}"
        fi
        tar xvf "${INSTALL_PATH}" -C "${TEMP_DIR}"
        # CWE fix: NGINX-nginx-instance-manager-A585B675 — Restrict temp dir permissions to root-only to prevent local package replacement
        chmod -R 700 "${TEMP_DIR}"
        chown -R "${USER}" "${TEMP_DIR}"
        sleep 1
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

          # Ensure rsyslog is installed — Debian 13+ does not include it by default
          # but nms-instance-manager declares it as a hard dependency.
          if ! dpkg -l rsyslog 2>/dev/null | grep -q "^ii"; then
              echo "Installing rsyslog dependency (not present on this system)..."
              DEBIAN_FRONTEND=noninteractive apt-get update -y
              DEBIAN_FRONTEND=noninteractive apt-get install -y rsyslog
          fi

          for pkg_nim in "${TEMP_DIR}"/nms-instance-manager*.deb; do
              echo "Installing NGINX Instance Manager from ${pkg_nim}"
              DEBIAN_FRONTEND=noninteractive dpkg -i "$pkg_nim"
              check_last_command_status "dpkg -i \"$pkg_nim\"" $?
          done
          if [[ "${INSTALL_WAF_COMPILER}" == "true" && -f "${TEMP_DIR}/compiler.tar.gz" ]]; then
              echo "Installing NAP compiler from ${TEMP_DIR}/compiler.tar.gz"
              mkdir -p /etc/nms-nap-compiler /opt/nms-nap-compiler
              chown -R ${NIM_USER}:${NIM_GROUP} /etc/nms-nap-compiler /opt/nms-nap-compiler
              tar -xzf "${TEMP_DIR}/compiler.tar.gz" -C "${TEMP_DIR}"
              if compgen -G "${TEMP_DIR}/nms-nap-compiler/compiler.deps/*.deb" > /dev/null; then
                  DEBIAN_FRONTEND=noninteractive dpkg -i "${TEMP_DIR}"/nms-nap-compiler/compiler.deps/*.deb || true
              fi
              DEBIAN_FRONTEND=noninteractive dpkg -i "${TEMP_DIR}"/nms-nap-compiler/nms-nap-compiler*.deb
              check_last_command_status "dpkg -i nms-nap-compiler*.deb" $?
          fi
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

        elif cat /etc/*-release | grep -iq 'centos\|fedora\|rhel\|Amazon Linux\|rocky'; then
          echo "Skipping 'yum update' for offline installation on disconnected system."
          for pkg_nginx in "${TEMP_DIR}"/nginx*.rpm; do
            echo "Installing nginx from ${pkg_nginx}"
            yum localinstall -y -v --disableplugin=subscription-manager --disablerepo="*" --skip-broken "$pkg_nginx"
          done
          if [[ ${SKIP_CLICKHOUSE_INSTALL} == "false" ]]; then
              for pkg_clickhouse in "${TEMP_DIR}"/clickhouse-common*.rpm; do
                echo "Installing clickhouse dependencies from ${pkg_clickhouse}"
                yum localinstall -y -v --disableplugin=subscription-manager --disablerepo="*" --skip-broken "$pkg_clickhouse"
              done
              for pkg_clickhouse_srv in "${TEMP_DIR}"/clickhouse-server*.rpm; do
                echo "Installing clickhouse-server from ${pkg_clickhouse_srv}"
                yum localinstall -y -v --disableplugin=subscription-manager --disablerepo="*" --skip-broken "$pkg_clickhouse_srv"
              done
          fi
          for pkg_nim in "${TEMP_DIR}"/nms-instance-manager*.rpm; do
            echo "Installing NGINX Instance Manager from ${pkg_nim}"
            yum localinstall -y -v --disableplugin=subscription-manager --disablerepo="*" --skip-broken "$pkg_nim"
          done

          if [[ "${INSTALL_WAF_COMPILER}" == "true" && -f "${TEMP_DIR}/compiler.tar.gz" ]]; then
              echo "Installing NAP compiler from ${TEMP_DIR}/compiler.tar.gz"
              mkdir -p /etc/nms-nap-compiler /opt/nms-nap-compiler
              chown -R ${NIM_USER}:${NIM_GROUP} /etc/nms-nap-compiler /opt/nms-nap-compiler
              tar -xzf "${TEMP_DIR}/compiler.tar.gz" -C "${TEMP_DIR}"
              # Collect RPMs into an array with nullglob so a missing *.rpm does
              # not pass the literal string to yum (which produces a confusing
              # "Could not open: *.rpm" error).
              shopt -s nullglob
              compiler_rpms=("${TEMP_DIR}"/nms-nap-compiler/*.rpm)
              shopt -u nullglob
              if [ ${#compiler_rpms[@]} -eq 0 ]; then
                  echo "Error: no RPMs found in compiler bundle at ${TEMP_DIR}/nms-nap-compiler/"
                  exit 1
              fi
              sudo yum localinstall -y --disablerepo=* "${compiler_rpms[@]}"
              check_last_command_status "yum localinstall nms-nap-compiler" $?
          fi

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
      curl -s -o /dev/null --connect-timeout 10 --max-time 30 --cert ${NGINX_CERT_PATH} --key ${NGINX_CERT_KEY_PATH} "https://pkgs.nginx.com/nms/?using_install_script=true&app=nim&mode=offline" || echo "Telemetry report skipped (disconnected environment)."
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
  printf "\n      [ubuntu22.04,ubuntu24.04,debian11,debian12,debian13,rhel8,rhel9,rhel10,oracle8,rocky8,rocky9,rocky10]\n"
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
  printf "\n  -w  Install WAF compiler (nms-nap-compiler) for App Protect policy compilation. \n"
  printf "\n  -y  Install Nginx Instance Manager if all the requirements are passed. \n"
  exit 0
}

printSupportedOS(){
  printf "This script can be run on the following operating systems"
  printf "\n  1. ubuntu22.04(jammy)"
  printf "\n  2. ubuntu24.04(noble)"
  printf "\n  3. debian11(bullseye)"
  printf "\n  4. debian12(bookworm)"
  printf "\n  5. debian13(trixie)"
  printf "\n  6. rhel8(Redhat Enterprise Linux Version 8)"
  printf "\n  7. rhel9(Redhat Enterprise Linux Version 9)"
  printf "\n  8. rhel10(Redhat Enterprise Linux Version 10)"
  printf "\n  9. oracle8(Oracle Linux Version 8)"
  printf "\n  10. rocky8(Rocky Linux Version 8)"
  printf "\n  11. rocky9(Rocky Linux Version 9)"
  printf "\n  12. rocky10(Rocky Linux Version 10)\n"
  exit 0
}

OPTS_STRING="a:c:d:f:hi:j:k:lm:prsv:wy"

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
    w)
      INSTALL_WAF_COMPILER="true"
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

validate_nginx_paths

if [ "${MODE}" == "online" ]; then
  validate_nim_installation
  install_nim_online
  check_nim_dashboard_status
else
  if [ -z "${INSTALL_PATH}" ]; then
    package_nim_offline
  else
    install_nim_offline_from_file
  fi
fi
