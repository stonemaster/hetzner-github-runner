#!/bin/bash

hetzner_key=

my_ip=$(curl -4 -s https://ifconfig.me)

my_id=$(curl \
 -H "Authorization: Bearer $hetzner_key" \
 'https://api.hetzner.cloud/v1/servers' | jq -c ".servers[] | select(.public_net.ipv4.ip == \"${my_ip}\") | .id")

curl \
	-X DELETE \
	-H "Authorization: Bearer $hetzner_key" \
	"https://api.hetzner.cloud/v1/servers/${my_id}"
