#!/bin/bash

# Usage: ./close.sh --id=<ID>

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
        RESPONSE=$(curl -X DELETE \
        -H "Content-Type: application/json" \
	-H "X-API-Key: $API_TOKEN" \
        https://core.aeza.net/api/services/$ID)

        ORDER_ERROR=$(echo $RESPONSE | jq -r '.error')
        if [[ ! -z "$ORDER_ERROR" ]]; then
                echo "OK"
                break
	fi
	sleep 20
done