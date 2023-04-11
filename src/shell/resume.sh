#!/bin/bash

# Usage: ./resume.sh --i=<ID>

POSITIONAL_ARGS=()
for i in "$@"; do
        case $i in
                --id=*)
                ID="${i#*=}"
                shift
                ;;
        esac
done

API_TOKEN=$(cat /root/shell/config)

while true
do
        RESPONSE=$(curl -X POST \
        -H "Content-Type: application/json" \
	-H "X-API-Key: $API_TOKEN" \
        -d '{"action": "resume"}' \
        https://core.aeza.net/api/services/$ID/ctl)

        ORDER_ERROR=$(echo $RESPONSE | jq -r '.error')
        if [[ ! -z "$ORDER_ERROR" ]]; then
        IP=$(echo $SERVICE_RESPONSE_DATA | jq -r '.data.items[0].ip')
                if [[ $IP != "null" ]]; then
			echo "OK"
			break
		fi
	fi
	sleep 20
done