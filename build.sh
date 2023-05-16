#!/bin/bash

set -xeuo pipefail

SITE_NAME="$SITE_NAME"

if [[ -z "${SITE_NAME}" ]] ; then
    echo "No SITE_NAME variable set. Unable to continue."
    exit 1 ;

elif [[ "${SITE_NAME}" == 'docs-nginx-com' ]] ; then 
    make all 
    ret=$?
    echo "Command exited with $ret" ;
elif [[ "${SITE_NAME}" == 'docs-staging-nginx' ]] ; then 
    make all-staging 
    ret=$?
    echo "Command exited with $ret" ; 
elif [[ "${SITE_NAME}" == 'docs-dev-nginx' ]] ; then 
    make all-dev 
    ret=$?
    echo "Command exited with $ret" ; 
else 
    echo "Not running in production context on docs, docs-staging, or docs-dev. Check the build settings for the current Netlify context: $CONTEXT"
    ret="1"
    echo "Command exited with $ret" ; 
fi 