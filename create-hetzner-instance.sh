#!/bin/bash

set -eu -o pipefail

if [[ $# < 5 ]]; then
  echo "usage: $(basename $0) HETZNER_API_KEY INSTANCE_TYPE LOCATION_TYPE NAME_PREFIX CLOUD_INIT_YML_FILE [SSH_KEY_ID]"
  exit 1
fi

hetzner_api_key=${1}
instance_type=${2}
location=${3}
name_prefix=${4}
cloud_init_yml_file=${5}
ssh_key_id=${6:-}

template_file=$(dirname $0)/hetzner-server-create-template.jq

json=$(jq -n --arg location ${location} \
  --arg server_type ${instance_type} \
  --arg name "$name_prefix-$RANDOM" \
  --arg cloud_init_yml "$(cat $cloud_init_yml_file)" \
  -f ${template_file})

if [ "$ssh_key_id" != "" ]; then
  json=$(echo $json | jq ".ssh_keys += [$ssh_key_id]")
fi

curl \
  -X POST \
  --fail-with-body \
  -H "Authorization: Bearer ${hetzner_api_key}" \
  -H "Content-Type: application/json" \
  -d "${json}" \
 'https://api.hetzner.cloud/v1/servers' >/dev/null

