#!/bin/bash

set -euxo pipefail

handle_term()
{
    echo "received TERM signal"
    echo "stopping nginx-agent ..."
    kill -TERM "${agent_pid}" 2>/dev/null
    echo "stopping nginx ..."
    kill -TERM "${nginx_pid}" 2>/dev/null
}

trap 'handle_term' TERM

if [ -z "${CONTROL_PLANE_IP}" ]; then
    echo "ERROR CONTROL_PLANE_IP environment variable needs to be set."
    exit 1
fi

if [ -z "${INSTANCE_GROUP}" ]; then
    echo "ERROR INSTANCE_GROUP environment variable needs to be set."
    exit 1
fi

# Launch nginx
echo "starting nginx ..."
nginx -g "daemon off;" &

nginx_pid=$!

# start nginx-agent, pass args
echo "starting nginx-agent ..."
nginx-agent --instance-group "${INSTANCE_GROUP}" --server-host "${CONTROL_PLANE_IP}" &

agent_pid=$!

wait_term()
{
    wait ${agent_pid}
    trap - TERM
    kill -QUIT "${nginx_pid}" 2>/dev/null
    echo "waiting for nginx to stop..."
    wait ${nginx_pid}
}

wait_term

echo "nginx-agent process has stopped, exiting."
