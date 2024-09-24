---
description: Learn how to edit and publish NGINX configuration files with a version
  control system using F5 NGINX Management Suite Instance Manager.
docs: DOCS-1348
title: Publish Configuration Files with Version Control System
toc: true
weight: 250
---

## Overview

With F5 NGINX Instance Manager, you can easily edit and publish NGINX configurations to your NGINX and NGINX Plus instances. Follow the steps in this guide to setup your version control system as the source of truth for maintaining your NGINX configurations and publish your modified configurations to any instance or instance group managed by NGINX Instance Manager.

This documentation provides examples of how to publish configurations to your NGINX Instance Manager from Gitlab or [Github](https://github.com/nginxinc/git-automation) as the version control system to manage configurations.

## Before You Begin

To complete the instructions in this guide, you need the following:

- Instance Manager is installed, licensed, and running
- One or more NGINX data plane instances or instance groups
- A version control system maintaining your configuration files for at least one instance or instance group
- A docker base [image](https://github.com/nginxinc/git-automation/blob/main/dockerfile) to run in the pipeline.

## Publishing Configurations from version control system

### Setup the pipeline

To setup the pipeline to push configurations changes upstream to an instance or instance groups, we will be defining the variables needed to send API requests to NGINX Instance Manager, prepare the payload for the requests, and define rules to trigger the action using [CI/CD Pipelines](https://docs.gitlab.com/ee/ci/pipelines/)

Add a [.gitlab-ci.yaml](https://docs.gitlab.com/ee/ci/yaml/)  file at the root directory of your repository to manage the configuration files. You can define variables to reference in the pipeline for various purposes, for example to send [curl](https://curl.se/) requests to NGINX Instance Manager.  Below are some of the variables I defined:

```yaml
variables:
 # System IP of the Nginx Instance Manager.
 CTRL_IP:  34.213.65.15

 #Authorization token for connecting to Nginx Instance Manager.
 AUTH_TOKEN:  YWRtaW46VGVzdGVudjEyIw==

 # System UID of the instance to push configuration changes.
 SYSTEM_UID:  fbf7a63f-a394-34b7-8775-93d7d6aceb82

 # Nginx UID of the instance to push configuration changes.
 NGINX_UID:  98961494-c999-515c-ae1b-1dd949f78b6e

 # Instance Group UID of the instance group to push configuration changes.
 GROUP_UID:  0ba1d2c3-ce36-44da-a786-94fb65425a30
```


You can introduce rules in the `.gitlab-ci.yaml` file to trigger the pipelines when changes are detected in the configuration files. Use the rule examples below depending on your repository structure:

The example repository structure is:

```none
git-automation:
	-> instances
		-> nginx.conf
		-> mime.types
	-> instance-group
		-> nginx.conf
		-> mime.types
	.gitlab-ci.yaml
```

```yaml
._run_only_when_change_in_instance_directory:  &_run_only_when_change_in_instance_directory
 changes:
 -  instance/nginx.conf
 -  instance/*
```

We use a bash script to create a valid payload to send via `POST` to NGINX Instance Manager for the instance or instance group. To prepare the payload, we encode the file contents of `nginx.conf` , get the current time in format of `Year-Month-DayTHour:Minute:SecondZ` and assign the commit SHA to `externalId`.
The script can be modified to follow your repository structure to create valid payload requests for [instances](https://github.com/nginxinc/git-automation/blob/main/prepare-payload.sh) and [instance groups](https://github.com/nginxinc/git-automation/blob/main/prepare-instGroup-payload.sh)

<details closed>
<summary><i class="fa-solid fa-file"></i> Example bash script </summary>

```shell
#!/bin/bash
set  -o  pipefail

DEFAULT_INSTANCE_CONFIG_FILE_PATH="./instance/nginx.conf"
DEFAULT_MIME_TYPES_FILE_PATH="./instance/mime.types"

print_help() {
	echo  "Script to publish a config to instance managed by NIM."
	printf  "\n"
	echo  "Usage: $0 CTRL_IP AUTH_TOKEN SYSTEM_UID NGINX_UID"
	echo  "param CTRL_IP: NIM Public IP"
	echo  "param AUTH_TOKEN: Base-64 encoded auth token"
	echo  "param SYSTEM_UID: UUID of system managed by NIM"
	echo  "param NGINX_UID: UUID of NGINX instance on the system"
}

######
# Create payload for instances
######
publish_config_to_instance() {
	local  ctrl_ip=$1
	local  auth_token=$2
	local  system_uid=$3
	local  nginx_uid=$4

    # add checks for variables needed
	if [ -z  "${ctrl_ip}" ]; then
	echo  " * variable CTRL_IP not set"
	exit  1
	fi

	if [ -z  "${auth_token}" ]; then
	echo  " * variable AUTH_TOKEN not set"
	exit  1
	fi

	if [ -z  "${system_uid}" ]; then
	echo  " * variable SYSTEM_UID not set"
	exit  1
	fi

	if [ -z  "${nginx_uid}" ]; then
	echo  " * variable NGINX_UID not set"
	exit  1
	fi

	if [ !  -f  "${DEFAULT_INSTANCE_CONFIG_FILE_PATH}" ]; then
	echo  "${DEFAULT_INSTANCE_CONFIG_FILE_PATH} file doesn't exist."
	exit  1
	fi

	if [ !  -f  "${DEFAULT_MIME_TYPES_FILE_PATH}" ]; then
	echo  "${DEFAULT_MIME_TYPES_FILE_PATH} file doesn't exist."
	exit  1
	fi

	if [ -z  "${CI_COMMIT_SHA}" ]; then
	echo  " * GIT environment variable CI_COMMIT_SHA not set"
	exit  1
	fi

	local  ic_base64
	local  mime_base64
	local  update_time
	local  version_hash="${CI_COMMIT_SHA}"
	local  payload


	ic_base64=$(base64  < "${DEFAULT_INSTANCE_CONFIG_FILE_PATH}" |  tr -d '\n')
	mime_base64=$(base64  < "${DEFAULT_MIME_TYPES_FILE_PATH}" |  tr -d '\n')
	update_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

	payload=$(jq -n \
				--arg versionHash "${version_hash}" \
				--arg updateTime "${update_time}" \
				--arg config "${ic_base64}" \
				--arg mime "${mime_base64}" \
				'{
					"auxFiles": {
					"files": [],
					"rootDir": "/"
					},
					"configFiles": {
						"rootDir": "/etc/nginx",
						"files": [
							{
							"contents": $config,
							"name": "/etc/nginx/nginx.conf"
							},
							{
							"contents": $mime,
							"name": "/etc/nginx/mime.types"
							}
						]
					},
					"updateTime": $updateTime,
					"externalId": $versionHash,
					"externalIdType": "git"
				}'
	)

	echo  $payload
	echo  "################### Publish the config..."

	# want to do this in the pipeline after updating externalId and type
	echo  -e  "${payload}"  |  curl  -k  \
	-H  'Content-Type: application/json'  \
	-H  "Authorization: Bearer <access token>"  \
	--data-binary  @-  -X  POST  "https://$ctrl_ip/api/platform/v1/systems/$system_uid/instances/$nginx_uid/config"
}

#MAIN
if [[ $#  -lt  4 ]]; then
print_help
exit  1
fi

publish_config_to_instance  "$@"
```

</details>

We need to add different pipeline [stages](https://docs.gitlab.com/ee/ci/yaml/?query=stages#stages), define when the actions will be triggered using rules, and what to run in the pipeline:

```yaml
stages:
  - publish


publish-config-to-instance:
  image: ${BUILD_IMAGE}
  stage: publish
  script:
    # Run the script that prepares the payload with config changes with required variables
    # - ./prepare-payload.sh ${CTRL_IP} ${AUTH_TOKEN} ${SYSTEM_UID} ${NGINX_UID}
 # use the predefined rule here to match condition for trigerring the pipeline
  only:
    <<: *_run_only_when_change_in_instance_directory
  needs: []
```


### Publish Config Changes to instances from version control system

To add configuration changes to instances, modify the configuration files (`instances/nginx.conf`) and push your changes upstream to trigger the pipeline.

### Publish Config Changes to instance groups from version control system

To add configuration changes to instance groups, modify the configuration files (`instance-groups/nginx.conf`)  and push your changes upstream to trigger the pipeline.

{{< note >}}You can find a sample template to modify as required in our [public repository](https://github.com/nginxinc/git-automation/).{{< /note >}}
