#!/bin/bash

set -eu -o pipefail

if [[ $# -lt 5 ]]; then
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

temp_json=$(mktemp)
jq -n \
  --arg server_type ${instance_type} \
  --arg name "$name_prefix-$RANDOM" \
  --rawfile cloud_init_yml $cloud_init_yml_file \
  -f ${template_file} > $temp_json

if [ "$ssh_key_id" != "" ]; then
  temp_json2=$(mktemp)
  cat $temp_json | jq ".ssh_keys += [$ssh_key_id]" > $temp_json2
  mv $temp_json2 $temp_json
fi

if [ "$location" != "auto" ]; then
  temp_json2=$(mktemp)
  cat $temp_json | jq ".location = \"$location\"" > $temp_json2
  mv $temp_json2 $temp_json
fi

curl \
  -X POST \
  --fail-with-body \
  -H "Authorization: Bearer ${hetzner_api_key}" \
  -H "Content-Type: application/json" \
  -d @$temp_json \
 'https://api.hetzner.cloud/v1/servers'
