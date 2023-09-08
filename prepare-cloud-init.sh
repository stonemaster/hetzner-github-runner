#!/bin/bash

set -eu -o pipefail

if [[ $# != 2 ]]; then
  echo "usage: $(basename $0) GITHUB_REPO_URL RUNNER_TOKEN"
  exit 1
fi

export GITHUB_REPO_URL=${1}
export RUNNER_TOKEN=${2}

export PRE_JOB_SCRIPT=$(echo 'echo Hetzner runner has been started.' | base64)
export POST_JOB_SCRIPT=$(echo 'killall config.sh' | base64)
export SHUTDOWN_RUNNER_SCRIPT=$(echo 'echo Bye world' | base64)

template_file=$(dirname $0)/cloud-init.yml.tmpl

envsubst < ${template_file}
