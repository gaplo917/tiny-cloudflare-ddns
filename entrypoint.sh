#!/bin/sh

# Inspired by
# https://github.com/ellerbrock/docker-collection/blob/master/dockerfiles/alpine-cloudflare-dyndns/entrypoint.sh

function getZoneID() {
  CF_ZONEID=$(curl -s \
    -X GET "https://api.cloudflare.com/client/v4/zones?name=${CF_ZONE_NAME}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_API_KEY}" \
    -H "Content-Type: application/json" | \
    jq -r .result[0].id)
}

function getDomainID() {
  CF_DOMAINID=$(curl -s \
    -X GET "https://api.cloudflare.com/client/v4/zones/${CF_ZONEID}/dns_records?name=${CF_DOMAIN_NAME}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_API_KEY}" \
    -H "Content-Type: application/json" | \
  jq -r .result[0].id)
}

function updateDomain() {
  PROXIED=${PROXIED:-"false"}

  local PAYLOAD='{"type":"A","name":"'${CF_DOMAIN_NAME}'","content":"'${EXTERNAL_IP}'","ttl":1,"proxied":'${PROXIED}'}'
 
  local JSON=$(curl -s \
    -X PUT "https://api.cloudflare.com/client/v4/zones/${CF_ZONEID}/dns_records/${CF_DOMAINID}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_API_KEY}" \
    -H "Content-Type: application/json" \
    --data "${PAYLOAD}")

 local RESULT=$(echo "${JSON}" | jq .success)

 if [[ ${RESULT} == "true" ]]; then
    echo "Cloudflare Setting updated successful ..."
    echo "DNS: ${CF_DOMAIN_NAME} => ${EXTERNAL_IP}"
    echo "PROXIED: ${PROXIED}"
  else
    echo "ERROR: Something went wrong :("
    echo "Cloudflare Result:"
    echo "------------------"
    echo ${JSON} | jq
  fi
}


# lets run it!
function main() {
  EXTERNAL_IP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com| awk -F'"' '{ print $2}')

  if [[ ${EXTERNAL_IP} ]] && \
   [[ ${CF_EMAIL} ]] && \
   [[ ${CF_API_KEY} ]] && \
   [[ ${CF_ZONE_NAME} ]] && \
   [[ ${CF_DOMAIN_NAME} ]]; then
    getZoneID
    getDomainID
    updateDomain
  else
    echo "ERROR: Missing parameter:"
      [[ -z ${EXTERNAL_IP} ]] && echo "Cannot Resolve External IP"
      [[ -z ${CF_EMAIL} ]] && echo "  - CF_EMAIL"
      [[ -z ${CF_API_KEY} ]] && echo "  - CF_API_KEY"
      [[ -z ${CF_ZONE_NAME} ]] && echo "  - CF_ZONE_NAME"
      [[ -z ${CF_DOMAIN_NAME} ]] && echo "  - CF_DOMAIN_NAME"
  fi
}

# default 60s
INTERVAL=${INTERVAL:-60}

while true; do main; sleep ${INTERVAL}; done