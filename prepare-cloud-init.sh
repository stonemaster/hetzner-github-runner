#!/bin/bash

set -eu -o pipefail

if [[ $# != 3 ]]; then
  echo "usage: $(basename $0) GITHUB_REPO_URL RUNNER_TOKEN HETZNER_API_KEY"
  exit 1
fi

export GITHUB_REPO_URL=${1}
export RUNNER_TOKEN=${2}
export HETZNER_API_KEY=${3}

export PRE_JOB_SCRIPT=$(echo 'echo Hetzner runner has been started.' | base64)
# GitHub Actions internal binary name, is killed after job execution
export POST_JOB_SCRIPT=$(echo 'killall Runner.Listener' | base64)
# Configure server delete script to be called when runner is stopped. This stops
# and removed the Hetzner cloud instance.
export SHUTDOWN_RUNNER_SCRIPT=$(sed "s/hetzner_key=/hetzner_key=${HETZNER_API_KEY}/" $(dirname $0)/delete-me.sh | base64)

template_file=$(dirname $0)/cloud-init.yml.tmpl

envsubst < ${template_file}
