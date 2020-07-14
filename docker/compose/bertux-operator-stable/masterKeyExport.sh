#!/bin/bash

CONTAINERS=$(docker-compose ps -q)
EXPORT_DIR="master_keys_$(date +'%Y%m%d%H%M%S')"

mkdir $EXPORT_DIR

for c in $CONTAINERS; do
    compose_service_name=$(docker inspect $c --format '{{ index .Config.Labels "com.docker.compose.service" }}') 
    docker_key_file=$(docker exec $c witnet node masterKeyExport --write | grep -Po '(Private key written to )\K.*')
    storage_path=$(docker inspect $c --format '{{ range .Mounts }}{{ if eq .Destination "/.witnet" }}{{ .Source }}{{ end }}{{ end }}') 
    local_key_file="${storage_path}/${docker_key_file#*/*/}"
    output_dir="${EXPORT_DIR}/${compose_service_name}"
    
    mkdir $output_dir
    mv "$local_key_file" "$output_dir"
done;

tar -czf "${EXPORT_DIR}".tar "$EXPORT_DIR" && rm -rf "$EXPORT_DIR"
