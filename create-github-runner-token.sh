#!/bin/bash

set -eu -o pipefail

if [[ $# != 2 ]]; then
  echo "usage: $(basename $0) GITHUB_REPO API_KEY"
  echo ""
  echo "Example: $(basename $0) stonemaster/test api_test123"
  echo ""
  echo "Returns Github Runner creation token for specified repository."
  exit 1
fi

github_repo=${1}
api_key=${2}

url="https://api.github.com/repos/${github_repo}/actions/runners/registration-token"

curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${api_key}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  ${url} | jq -r .token
