#!/usr/bin/env bash
# This script is used to fetch external packages that are not available in standard Linux distribution

# Example: ./fetch-external-dependencies ubuntu18.04 nginx-repo.crt nginx-repo.key
# Script will create devportal-dependencies-ubuntu18.04.tar.gz in local directory which can be copied
# into target machine and packages inside can be installed manually

set -eo pipefail

PACKAGE_PATH="."

mkdir -p $PACKAGE_PATH

declare -A NGINXPLUS_REPO
NGINXPLUS_REPO['ubuntu18.04']="https://pkgs.nginx.com/plus/ubuntu/pool/nginx-plus/n/nginx-plus"
NGINXPLUS_REPO['ubuntu20.04']="https://pkgs.nginx.com/plus/ubuntu/pool/nginx-plus/n/nginx-plus"
NGINXPLUS_REPO['ubuntu22.04']="https://pkgs.nginx.com/plus/ubuntu/pool/nginx-plus/n/nginx-plus"
NGINXPLUS_REPO['debian10']="https://pkgs.nginx.com/plus/debian/pool/nginx-plus/n/nginx-plus"
NGINXPLUS_REPO['debian11']="https://pkgs.nginx.com/plus/debian/pool/nginx-plus/n/nginx-plus"
NGINXPLUS_REPO['centos7']="https://pkgs.nginx.com/plus/centos/7/x86_64/RPMS"
NGINXPLUS_REPO['rhel7']="https://pkgs.nginx.com/plus/rhel/7/x86_64/RPMS"
NGINXPLUS_REPO['rhel8']="https://pkgs.nginx.com/plus/rhel/8/x86_64/RPMS"
NGINXPLUS_REPO['rhel9']="https://pkgs.nginx.com/plus/rhel/9/x86_64/RPMS"
NGINXPLUS_REPO['amzn2']="https://pkgs.nginx.com/plus/amzn2/2/x86_64/RPMS"

declare -A NJS_REPO
NJS_REPO['ubuntu18.04']="https://pkgs.nginx.com/plus/ubuntu/pool/nginx-plus/n/nginx-plus-module-njs"
NJS_REPO['ubuntu20.04']="https://pkgs.nginx.com/plus/ubuntu/pool/nginx-plus/n/nginx-plus-module-njs"
NJS_REPO['ubuntu22.04']="https://pkgs.nginx.com/plus/ubuntu/pool/nginx-plus/n/nginx-plus-module-njs"
NJS_REPO['debian10']="https://pkgs.nginx.com/plus/debian/pool/nginx-plus/n/nginx-plus-module-njs"
NJS_REPO['debian11']="https://pkgs.nginx.com/plus/debian/pool/nginx-plus/n/nginx-plus-module-njs"
NJS_REPO['centos7']="https://pkgs.nginx.com/plus/centos/7/x86_64/RPMS"
NJS_REPO['rhel7']="https://pkgs.nginx.com/plus/rhel/7/x86_64/RPMS"
NJS_REPO['rhel8']="https://pkgs.nginx.com/plus/rhel/8/x86_64/RPMS"
NJS_REPO['rhel9']="https://pkgs.nginx.com/plus/rhel/9/x86_64/RPMS"
NJS_REPO['amzn2']="https://pkgs.nginx.com/plus/amzn2/2/x86_64/RPMS"

declare -A NGINXPLUS_PACKAGES
NGINXPLUS_PACKAGES['ubuntu18.04']="nginx-plus_29-1~bionic_amd64.deb"
NGINXPLUS_PACKAGES['ubuntu20.04']="nginx-plus_29-1~focal_amd64.deb"
NGINXPLUS_PACKAGES['ubuntu22.04']="nginx-plus_29-1~jammy_amd64.deb"
NGINXPLUS_PACKAGES['debian10']="nginx-plus_29-1~buster_amd64.deb"
NGINXPLUS_PACKAGES['debian11']="nginx-plus_29-1~bullseye_amd64.deb"
NGINXPLUS_PACKAGES['centos7']="nginx-plus-29-1.el7.ngx.x86_64.rpm"
NGINXPLUS_PACKAGES['rhel7']="nginx-plus-29-1.el7.ngx.x86_64.rpm"
NGINXPLUS_PACKAGES['rhel8']="nginx-plus-29-1.el8.ngx.x86_64.rpm"
NGINXPLUS_PACKAGES['rhel9']="nginx-plus-29-1.el9.ngx.x86_64.rpm"
NGINXPLUS_PACKAGES['amzn2']="nginx-plus-29-1.amzn2.ngx.x86_64.rpm"

declare -A NJS_PACKAGES
NJS_PACKAGES['ubuntu18.04']="nginx-plus-module-njs_29+0.7.12-1~bionic_amd64.deb"
NJS_PACKAGES['ubuntu20.04']="nginx-plus-module-njs_29+0.7.12-1~focal_amd64.deb"
NJS_PACKAGES['ubuntu22.04']="nginx-plus-module-njs_29+0.7.12-1~jammy_amd64.deb"
NJS_PACKAGES['debian10']="nginx-plus-module-njs_29+0.7.12-1~buster_amd64.deb"
NJS_PACKAGES['debian11']="nginx-plus-module-njs_29+0.7.12-1~bullseye_amd64.deb"
NJS_PACKAGES['centos7']="nginx-plus-module-njs-29+0.7.12-1.el7.ngx.x86_64.rpm"
NJS_PACKAGES['rhel7']="nginx-plus-module-njs-29+0.7.12-1.el7.ngx.x86_64.rpm"
NJS_PACKAGES['rhel8']="nginx-plus-module-njs-29+0.7.12-1.el8.ngx.x86_64.rpm"
NJS_PACKAGES['rhel9']="nginx-plus-module-njs-29+0.7.12-1.el9.ngx.x86_64.rpm"
NJS_PACKAGES['amzn2']="nginx-plus-module-njs-29+0.7.12-1.amzn2.ngx.x86_64.rpm"

download_packages() {
    local target_distribution=$1
    local nginx_repo_cert=$2
    local nginx_repo_key=$3
    if [ -z $target_distribution ] ||  [ -z $nginx_repo_cert ] ||  [ -z $nginx_repo_key ]; then
        echo "$0 - missing parameter"
        exit 1
    fi

    mkdir -p "${PACKAGE_PATH}/${target_distribution}"
    # just in case delete all files in target dir
    rm -f "${PACKAGE_PATH}/${target_distribution}/*"

    readarray -t nginxplus_files <<<"${NGINXPLUS_PACKAGES[${target_distribution}]}"
    readarray -t njs_files <<<"${NJS_PACKAGES[${target_distribution}]}"

    for package_file in "${nginxplus_files[@]}"; do
        if [ -z $package_file ]; then
            continue
        fi
        file_url="${NGINXPLUS_REPO[$target_distribution]}/$package_file"
        save_file="${PACKAGE_PATH}/${target_distribution}/$package_file"
        echo "Fetching $file_url"
        curl --cert ${nginx_repo_cert} --key ${nginx_repo_key} -fs $file_url --output $save_file
    done

    for package_file in "${njs_files[@]}"; do
        if [ -z $package_file ]; then
            continue
        fi
        file_url="${NJS_REPO[$target_distribution]}/$package_file"
        save_file="${PACKAGE_PATH}/${target_distribution}/$package_file"
        echo "Fetching $file_url"
        curl --cert ${nginx_repo_cert} --key ${nginx_repo_key} -fs $file_url --output $save_file
    done

    bundle_file="${PACKAGE_PATH}/acm-dataplane-dependencies-${target_distribution}.tar.gz"
    tar -zcf $bundle_file -C "${PACKAGE_PATH}/${target_distribution}" .
    echo "Bundle file saved as $bundle_file"

}

target_distribution=$1
nginx_repo_cert=$2
nginx_repo_key=$3

if [ -z $target_distribution ]; then
    echo "Usage: $0 target_distribution nginxrepo_cert nginxrepo_key"
    echo "Supported target distributions: ${!NGINXPLUS_REPO[@]}"
    exit 1
fi

if [ -z $nginx_repo_cert ] || [ -z $nginx_repo_key ]; then
    echo "Usage: $0 target_distribution nginxrepo_cert nginxrepo_key"
    echo "Specify the location for your nginx-repo.crt and nginx-repo.key files as parameters"
    exit 1
fi

# check if target distribution is supported
if [ -z ${NGINXPLUS_REPO[$target_distribution]} ]; then
    echo "Target distribution $target_distribution is not supported."
    echo "Supported distributions: ${!NGINXPLUS_REPO[@]}"
    exit 1
fi

download_packages "${target_distribution}" "${nginx_repo_cert}" "${nginx_repo_key}"
