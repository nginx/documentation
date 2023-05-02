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

# Launch nginx
echo "starting nginx ..."
/usr/sbin/nginx -g "daemon off;" &

nginx_pid=$!

cat /etc/nginx-agent/nginx-agent.conf

# start nginx-agent, pass args
echo "starting nginx-agent ..."
/usr/bin/nginx-agent "$@" &

agent_pid=$!

wait_term()
{
    wait ${agent_pid}
    trap '' EXIT INT TERM
    kill -QUIT "${nginx_pid}" 2>/dev/null
    echo "waiting for nginx to stop..."
    wait ${nginx_pid}
    kill -TERM "${agent_pid}" 2>/dev/null
    echo "terminating nginx-agent..."
}

wait_term

echo "nginx-agent process has stopped, exiting."