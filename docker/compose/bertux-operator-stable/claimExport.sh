#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.
set -u  # considers substituting empty variables as an error
#set -x

## HELP function
Usage()
{
    echo "Insufficient number of arguments - There must at least WIT_ID"
		echo "Usage : $0 [WIT_ID]"
}

if [ "$#" -lt 1 ]
then
		Usage
		exit 1
fi

## VARIABLES SETTINGS
WIT_ID=$1
CONTAINERS=$(docker-compose ps -q)
EXPORT_DIR="claim-$WIT_ID"

mkdir -p $EXPORT_DIR

for c in $CONTAINERS; do
    compose_service_name=$(docker inspect $c --format '{{ index .Config.Labels "com.docker.compose.service" }}')
    docker_key_file=$(docker exec $c witnet node claim --identifier $WIT_ID --write | grep -Po '(Signed claiming data written to )\K.*')
    storage_path=$(docker inspect $c --format '{{ range .Mounts }}{{ if eq .Destination "/.witnet" }}{{ .Source }}{{ end }}{{ end }}')
    local_key_file="${storage_path}/${docker_key_file#*/*/}"
    output_dir="${EXPORT_DIR}/${compose_service_name}"

    mkdir -p $output_dir
    mv -f "$local_key_file" "$output_dir"
done;

rm -f "${EXPORT_DIR}".tar.gz
tar -czf "${EXPORT_DIR}".tar.gz "$EXPORT_DIR"
