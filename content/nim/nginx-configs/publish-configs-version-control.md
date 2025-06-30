---
nd-docs: DOCS-1348
title: Publish NGINX configs with version control
toc: true
weight: 3
---

## Overview

With F5 NGINX Instance Manager, you can easily edit and publish NGINX configurations to your NGINX Open Source and NGINX Plus instances. This guide explains how to set up your version control system as the source of truth for maintaining NGINX configurations and how to publish modified configurations to any instance or instance group managed by NGINX Instance Manager.

The documentation includes examples of how to publish configurations from GitLab or [GitHub](https://github.com/nginxinc/git-automation) as the version control system to manage your configurations.

---

## Before you begin

To complete the instructions in this guide, ensure:

- NGINX Instance Manager is installed, licensed, and running.
- You have one or more NGINX data plane instances or instance groups.
- A version control system maintains your configuration files for at least one instance or instance group.
- A Docker base [image](https://github.com/nginxinc/git-automation/blob/main/dockerfile) is available to run in the pipeline.

---

## Publishing configurations from version control system

### Set up the pipeline

To set up the pipeline to push configuration changes upstream to an instance or instance group, you will define variables for sending API requests to NGINX Instance Manager, prepare the payload for the requests, and define rules to trigger the action using [CI/CD Pipelines](https://docs.gitlab.com/ee/ci/pipelines/).

Add a `.gitlab-ci.yaml` file at the root directory of your repository to manage the configuration files. You can define variables to reference in the pipeline for various purposes, such as sending [curl](https://curl.se/) requests to NGINX Instance Manager.

Here are some example variables you might define:

- **CTRL_IP**: System IP of NGINX Instance Manager. Example: `198.51.100.1`.
- **AUTH_TOKEN**: Authorization token for connecting to NGINX Instance Manager. Example: `YWRtaW46VGVzdGVudjEyIw==`.
- **SYSTEM_UID**: System UID of the instance to push configuration changes. Example: `fbf7a63f-a394-34b7-8775-93d7d6aceb82`.
- **NGINX_UID**: NGINX UID of the instance to push configuration changes. Example: `98961494-c999-515c-ae1b-1dd949f78b6e`.
- **GROUP_UID**: Instance Group UID of the instance group to push configuration changes. Example: `0ba1d2c3-ce36-44da-a786-94fb65425a30`.

You can introduce rules in the `.gitlab-ci.yaml` file to trigger the pipelines when changes are detected in the configuration files. Here’s an example repository structure:

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

To run the pipeline only when changes are detected in the instance directory, you could use the following rule:

```yaml
._run_only_when_change_in_instance_directory:  &_run_only_when_change_in_instance_directory
 changes:
 -  instance/nginx.conf
 -  instance/*
```

### Define pipeline stages

We need to add different pipeline [stages](https://docs.gitlab.com/ee/ci/yaml/?query=stages#stages), define when the actions will be triggered using rules, and what to run in the pipeline:

```yaml
stages:
  - publish

publish-config-to-instance:
  image: ${BUILD_IMAGE}
  stage: publish
  script:
    # Run the script that prepares the payload with config changes and required variables
    # ./prepare-payload.sh ${CTRL_IP} ${AUTH_TOKEN} ${SYSTEM_UID} ${NGINX_UID}
  only:
    <<: *_run_only_when_change_in_instance_directory
  needs: []
```

### Prepare the payload

We use a bash script to create a valid payload and send it via `POST` to NGINX Instance Manager for the instance or instance group. To prepare the payload, encode the file contents of `nginx.conf`, get the current time in the format `Year-Month-DayTHour:Minute:SecondZ`, and assign the commit SHA to `externalId`.

You can find sample scripts for preparing payloads for [instances](https://github.com/nginxinc/git-automation/blob/main/prepare-payload.sh) and [instance groups](https://github.com/nginxinc/git-automation/blob/main/prepare-instGroup-payload.sh).

#### Example bash script

```bash
#!/bin/bash
set  -o  pipefail

DEFAULT_INSTANCE_CONFIG_FILE_PATH="./instance/nginx.conf"
DEFAULT_MIME_TYPES_FILE_PATH="./instance/mime.types"

publish_config_to_instance() {
	local ctrl_ip=$1
	local auth_token=$2
	local system_uid=$3
	local nginx_uid=$4

	if [ -z "${ctrl_ip}" ] || [ -z "${auth_token}" ] || [ -z "${system_uid}" ] || [ -z "${nginx_uid}" ]; then
		echo "Missing required variable"
		exit 1
	fi

	ic_base64=$(base64 < "${DEFAULT_INSTANCE_CONFIG_FILE_PATH}" | tr -d '\n')
	mime_base64=$(base64 < "${DEFAULT_MIME_TYPES_FILE_PATH}" | tr -d '\n')
	update_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
	version_hash="${CI_COMMIT_SHA}"

	payload=$(jq -n --arg versionHash "${version_hash}" --arg updateTime "${update_time}" --arg config "${ic_base64}" --arg mime "${mime_base64}" '{
		"auxFiles": { "files": [], "rootDir": "/" },
		"configFiles": {
			"rootDir": "/etc/nginx",
			"files": [
				{ "contents": $config, "name": "/etc/nginx/nginx.conf" },
				{ "contents": $mime, "name": "/etc/nginx/mime.types" }
			]
		},
		"updateTime": $updateTime,
		"externalId": $versionHash,
		"externalIdType": "git"
	}')

	echo "${payload}" | curl -k -H 'Content-Type: application/json' -H "Authorization: Bearer <access token>" --data-binary @- -X POST "https://$ctrl_ip/api/platform/v1/systems/$system_uid/instances/$nginx_uid/config"
}

publish_config_to_instance "$@"
```

---

### Publish config changes from version control system

To publish configuration changes, modify the configuration files (`nginx.conf`) and push your changes upstream to trigger the pipeline. The process is the same whether you are pushing changes to individual instances or to instance groups. You can modify the script and pipeline rules based on whether you're targeting instances or instance groups.

{{< note >}}You can find a sample template to modify as required in our [public repository](https://github.com/nginxinc/git-automation/).{{</note>}}
