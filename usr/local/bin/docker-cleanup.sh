#!/bin/bash

log() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [$1] $2"
}

log_info() {
  log "INFO" "$1"
}

log_error() {
  log "ERROR" "$1"
}

exec_cmd() {
  log "EXEC" ">> $1"
  eval "$1"
}

validate_docker() {
  if [ ! -e "/var/run/docker.sock" ]; then
    log_error "Docker socket [/var/run/docker.sock] does not exist"
    exit 1
  fi

  if ! command -v docker &> /dev/null; then
    echo "Docker command [docker] does not exist"
    exit 1
  fi
}

process_env_vars() {

  if ! [[ "${CLEAN_DELAY}" =~ ^[0-9]+$ ]]; then
    log_error "[CLEAN_DELAY] is not numerical, got value [${CLEAN_DELAY}]"
    exit 1
  fi
  log_info "Got [CLEAN_DELAY] = ${CLEAN_DELAY}"

  if [ "${CLEAN_CONTAINERS}" != "false" ]; then
    CLEAN_CONTAINERS="true"
  fi
  log_info "Got [CLEAN_CONTAINERS] = ${CLEAN_CONTAINERS}"

  if [ "${CLEAN_IMAGES}" != "false" ]; then
    CLEAN_IMAGES="true"
  fi
  log_info "Got [CLEAN_IMAGES] = ${CLEAN_IMAGES}"

  if [ "${CLEAN_VOLUMES}" != "false" ]; then
    CLEAN_VOLUMES="true"
  fi
  log_info "Got [CLEAN_VOLUMES] = ${CLEAN_VOLUMES}"
}

print_usage() {
  log_info "Executing docker-cleanup.sh..."
  log_info "$1 Docker usage:"
  exec_cmd "docker system df --verbose"
}

prune_containers() {
  log_info "Removing all stopped containers..."
  exec_cmd "docker container prune --force"
}

prune_images() {
  log_info "Removing all images without at least one container associated to them..."
  exec_cmd "docker image prune --all --force"
}

prune_volumes() {
  log_info "Removing all unused local volumes..."
  exec_cmd "docker volume prune --force"
}

process_env_vars
validate_docker

log_info "Running docker-cleanup.sh every ${CLEAN_DELAY} seconds..."

trap "{ log_error \"Detected SIGINT, exiting...\"; exit 1; }" SIGINT
trap "{ log_info \"Detected SIGTERM, exiting...\"; exit 0; }" SIGTERM

while true; do
  print_usage "Before"

  if [ "${CLEAN_CONTAINERS}" == "true" ]; then
    prune_containers
  fi

  if [ "${CLEAN_IMAGES}" == "true" ]; then
    prune_images
  fi

  if [ "${CLEAN_VOLUMES}" == "true" ]; then
    prune_volumes
  fi

  print_usage "After"

  log_info "Sleeping for [$CLEAN_DELAY] seconds before next loop..."
  sleep "${CLEAN_DELAY}" & wait
done
