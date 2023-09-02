#!/bin/bash

set -eu -o pipefail

if [[ $# != 2 ]]; then
  echo "usage: $(basename $0) GITHUB_REPO_URL RUNNER_TOKEN"
  exit 1
fi

export GITHUB_REPO_URL=${1}
export RUNNER_TOKEN=${2}

template_file=$(dirname $0)/cloud-init.yml.tmpl

envsubst < ${template_file}
