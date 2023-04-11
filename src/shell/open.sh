#!/bin/bash

AUTO=true
OS=940
PRODUCT_ID=974
TERM="month"
NAME='YOUNAME'

# Usage: ./open.sh --name=<NAME>
# Usage: ./open.sh --name=<NAME> --os=<OS> --product=<PRODUCT> --term=hour --auto

POSITIONAL_ARGS=()
for i in "$@"; do
	case $i in
		--auto=*)
		AUTO="${i#*=}"
		shift
		;;
		--name=*)
		NAME="${i#*=}"
		shift
		;;
		--os=*)
		OS="${i#*=}"
		shift
		;;
		--product=*)
		PRODUCT_ID="${i#*=}"
		shift
		;;
		--term=*)
		TERM="${i#*=}"
		shift
		;;
	esac
done

API_TOKEN=$(cat /root/shell/config)
RESPONSE=$(curl -X POST \
	-H "Content-Type: application/json" \
	-H "X-API-Key: $API_TOKEN" \
	-d '{"autoProlong": '$AUTO', "name": "'$NAME'", "parameters": {"recipe": null, "os": '$OS', "isoUrl": ""}, "productId": '$PRODUCT_ID', "term": "'$TERM'", "count": 1, "method": "balance"}' \
	https://core.aeza.net/api/services/orders)

ORDER_ID=$(echo $RESPONSE | jq -r '.data.items[0].id')

while true
do
	ORDER_RESPONSE_DATA=$(curl -H "X-API-Key: $API_TOKEN" https://core.aeza.net/api/services/orders/$ORDER_ID)
	ORDER_ERROR=$(echo $ORDER_RESPONSE_DATA | jq -r '.error')

	if [[ ! -z "$ORDER_ERROR" ]]; then
		SERVICE_ID=$(echo $ORDER_RESPONSE_DATA | jq -r '.data.items[0].createdServiceIds[0]')
		SERVICE_RESPONSE_DATA=$(curl -H "X-API-Key: $API_TOKEN" https://core.aeza.net/api/services/$SERVICE_ID)

		IP=$(echo $SERVICE_RESPONSE_DATA | jq -r '.data.items[0].ip')
		USERNAME=$(echo $SERVICE_RESPONSE_DATA | jq -r '.data.items[0].parameters.username')
		PASSWORD=$(echo $SERVICE_RESPONSE_DATA | jq -r '.data.items[0].secureParameters.data.password')

		if [[ $IP != "null" ]]; then
			echo "OK --id=$SERVICE_ID --plid=$SERVICE_ID --login=$USERNAME --passwd=$PASSWORD ipaddr=$IP"
			break
		fi
	fi
	sleep 20
done




