#!/bin/bash
set -eux

declare -r HOST="${COMPASS_PROTOCOL}://${COMPASS_SERVER}:${COMPASS_PORT}"

wait-for-url() {
    echo "Testing $1"
    timeout -s TERM ${COMPASS_TIMEOUT} bash -c \
    'while [[ "$(curl -s -k -o /dev/null -L -w ''%{http_code}'' ${0})" != "200" ]];\
    do echo "Waiting for ${0}" && sleep 2;\
    done' ${1}
    echo "OK!"
    curl -k -I $1
}

wait-for-url ${HOST}

echo $HOSTNAME

# Nothing below the exec line
exec ${COMPASS_SYSTEMD}
