#!/usr/bin/env bash
# This script is used to fetch external packages that are not available in standard Linux distribution

# Example: ./fetch-external-dependencies ubuntu22.04
# Script will create nms-dependencies-ubuntu22.04.tar.gz in local directory which can be copied
# into target machine and packages inside can be installed manually

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

set -o pipefail

# current dir
PACKAGE_PATH="."
CLICKHOUSE_VERSION=22.3.15.33

mkdir -p $PACKAGE_PATH

fetch() {
    url=$1
    output=$2
    if ! http_code=$(curl -fs "${url}" --output "${output}" --write-out '%{http_code}'); then
      echo "   -- Failed to download $url with HTTP code $http_code. Exiting."
      exit 1
    fi
}

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

declare -A NGINX_REPO
NGINX_REPO['ubuntu22.04']="https://nginx.org/packages/mainline/ubuntu/pool/nginx/n/nginx/"
NGINX_REPO['ubuntu24.04']="https://nginx.org/packages/mainline/ubuntu/pool/nginx/n/nginx/"
NGINX_REPO['debian11']="https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx/"
NGINX_REPO['debian12']="https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx/"
NGINX_REPO['debian13']="https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx/"
NGINX_REPO['rhel8']="https://nginx.org/packages/mainline/rhel/8/x86_64/RPMS/"
NGINX_REPO['rhel9']="https://nginx.org/packages/mainline/rhel/9/x86_64/RPMS/"
NGINX_REPO['rhel10']="https://nginx.org/packages/mainline/rhel/10/x86_64/RPMS/"
NGINX_REPO['oracle8']="https://nginx.org/packages/mainline/rhel/8/x86_64/RPMS/"
NGINX_REPO['rocky8']="https://nginx.org/packages/mainline/rhel/8/x86_64/RPMS/"
NGINX_REPO['rocky9']="https://nginx.org/packages/mainline/rhel/9/x86_64/RPMS/"
NGINX_REPO['rocky10']="https://nginx.org/packages/mainline/rhel/10/x86_64/RPMS/"

CLICKHOUSE_KEY="https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key"
NGINX_KEY="https://nginx.org/keys/nginx_signing.key"

declare -A CLICKHOUSE_PACKAGES
# for Clickhouse package names are static between distributions
# we use ubuntu/centos entries as placeholders
CLICKHOUSE_PACKAGES['ubuntu']="
clickhouse-server_${CLICKHOUSE_VERSION}_amd64.deb
clickhouse-common-static_${CLICKHOUSE_VERSION}_amd64.deb"

CLICKHOUSE_PACKAGES['centos']="
clickhouse-server-${CLICKHOUSE_VERSION}.x86_64.rpm
clickhouse-common-static-${CLICKHOUSE_VERSION}.x86_64.rpm"

CLICKHOUSE_PACKAGES['ubuntu22.04']=${CLICKHOUSE_PACKAGES['ubuntu']}
CLICKHOUSE_PACKAGES['ubuntu24.04']=${CLICKHOUSE_PACKAGES['ubuntu']}
CLICKHOUSE_PACKAGES['debian11']=${CLICKHOUSE_PACKAGES['ubuntu']}
CLICKHOUSE_PACKAGES['debian12']=${CLICKHOUSE_PACKAGES['ubuntu']}
CLICKHOUSE_PACKAGES['debian13']=${CLICKHOUSE_PACKAGES['ubuntu']}
CLICKHOUSE_PACKAGES['rhel8']=${CLICKHOUSE_PACKAGES['centos']}
CLICKHOUSE_PACKAGES['rhel9']=${CLICKHOUSE_PACKAGES['centos']}
CLICKHOUSE_PACKAGES['rhel10']=${CLICKHOUSE_PACKAGES['centos']}
CLICKHOUSE_PACKAGES['oracle8']=${CLICKHOUSE_PACKAGES['centos']}
CLICKHOUSE_PACKAGES['rocky8']=${CLICKHOUSE_PACKAGES['centos']}
CLICKHOUSE_PACKAGES['rocky9']=${CLICKHOUSE_PACKAGES['centos']}
CLICKHOUSE_PACKAGES['rocky10']=${CLICKHOUSE_PACKAGES['centos']}

declare -A NGINX_PACKAGES
NGINX_PACKAGES['ubuntu22.04']="nginx_1.31.1-1~jammy_amd64.deb"
NGINX_PACKAGES['ubuntu24.04']="nginx_1.31.1-1~noble_amd64.deb"
NGINX_PACKAGES['debian11']="nginx_1.31.1-1~bullseye_amd64.deb"
NGINX_PACKAGES['debian12']="nginx_1.31.1-1~bookworm_amd64.deb"
NGINX_PACKAGES['debian13']="nginx_1.31.1-1~trixie_amd64.deb"
NGINX_PACKAGES['rhel8']="nginx-1.31.1-1.el8.ngx.x86_64.rpm"
NGINX_PACKAGES['rhel9']="nginx-1.31.1-1.el9.ngx.x86_64.rpm"
NGINX_PACKAGES['rhel10']="nginx-1.31.1-1.el10.ngx.x86_64.rpm"
NGINX_PACKAGES['oracle8']="nginx-1.31.1-1.el8.ngx.x86_64.rpm"
NGINX_PACKAGES['rocky8']="nginx-1.31.1-1.el8.ngx.x86_64.rpm"
NGINX_PACKAGES['rocky9']="nginx-1.31.1-1.el9.ngx.x86_64.rpm"
NGINX_PACKAGES['rocky10']="nginx-1.31.1-1.el10.ngx.x86_64.rpm"

download_packages() {
    local target_distribution=$1
    if [ -z "$target_distribution" ]; then
        echo "$0 - no target distribution specified"
        exit 1
    fi

    mkdir -p "${PACKAGE_PATH}/${target_distribution}"
    # just in case delete all files in target dir
    rm -f "${PACKAGE_PATH}/${target_distribution}/*"

    readarray -t clickhouse_files <<<"${CLICKHOUSE_PACKAGES[${target_distribution}]}"
    readarray -t nginx_files <<<"${NGINX_PACKAGES[${target_distribution}]}"

    echo -n "Downloading Clickhouse signing keys ... "
    fetch ${CLICKHOUSE_KEY} "${PACKAGE_PATH}/${target_distribution}/clickhouse-key.gpg"
    echo "done"
    echo -n "Downloading Nginx signing keys ... "
    fetch ${NGINX_KEY} "${PACKAGE_PATH}/${target_distribution}/nginx-key.gpg"
    echo "done"

    for package_file in "${clickhouse_files[@]}"; do
        if [ -z "$package_file" ]; then
            continue
        fi
        file_url="${CLICKHOUSE_REPO[$target_distribution]}/$package_file"
        save_file="${PACKAGE_PATH}/${target_distribution}/$package_file"
        echo -n "Downloading ${package_file} ... "
        fetch "$file_url" "$save_file"
        echo "done"
    done

    for package_file in "${nginx_files[@]}"; do
        if [ -z "$package_file" ]; then
            continue
        fi
        file_url="${NGINX_REPO[$target_distribution]}/$package_file"
        save_file="${PACKAGE_PATH}/${target_distribution}/$package_file"
        echo -n "Downloading ${package_file} ... "
        fetch "$file_url" "$save_file"
        echo "done"
    done

    bundle_file="${PACKAGE_PATH}/nms-dependencies-${target_distribution}.tar.gz"
    echo -n "Creating bundle ... "
    tar -zcf "$bundle_file" -C "${PACKAGE_PATH}/${target_distribution}" .
    echo "done"
    echo "Bundle file saved as $bundle_file"

}

target_distribution=$1

if [ -z "$target_distribution" ]; then
    echo "Usage: $0 target_distribution"
    echo "Supported target distributions: " "${!CLICKHOUSE_REPO[@]}"
    exit 1
fi

# check if target distribution is supported

if [ -z ${CLICKHOUSE_REPO[$target_distribution]} ]; then
    echo "Target distribution is not supported."
    echo "Supported distributions: " "${!CLICKHOUSE_REPO[@]}"
    exit 1
fi

download_packages "${target_distribution}"
