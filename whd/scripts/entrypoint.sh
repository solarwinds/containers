#!/usr/bin/env bash

# Copyright 2016 SolarWinds Worldwide, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

declare -r WHD_DEFAULT_CONFIG='65f2437f7fcd3a233beeea1a1f209f7d  -'
declare -r WHD_API='http://localhost:8081/helpdesk'
declare -r WHD_API_DBTEST='WebObjects/Helpdesk.woa/ra/configuration/database/test.json'
declare -r WHD_API_CONFIG='WebObjects/Helpdesk.woa/ra/configuration.json?uniqueId='
declare -r WHD_API_STARTUP='system/appManager/getState?uniqueId='

declare -r WHD_DB_PROBE='{"vendor":"postgresql","host":"db","port":"5432","databaseName":"postgres","userName":"postgres","password":"","embedded":false}'

declare -r WHD_ALREADY_UP='Initialization actions are not permitted once the application is accepting login requests.'

declare -r WHD_SCRIPTS='/usr/local/webhelpdesk/scripts'
declare -r WHD_BIN='/usr/local/webhelpdesk/whd'
declare -r WHD_ARTIFACT="${WHD_SCRIPTS}/.setup-complete"

declare -r CLEAR='\033[0m'
declare -r RED='\033[0;31m'
declare -r YELLOW='\033[0;33m'

declare -ri MAX_TRIES=10
declare -ri TRY_DELAY=1

declare PROBE_RES
declare PROBE_ERR
declare PROBE_DONE
declare CONFIG_HASH
declare CONFIG_CONTENT
declare PROBE_TIME
declare PROBE_STATUS
declare PROBE_DESC
declare PROBE_RUNNING

function whd::check_dependencies() {
  for p in "${@}"; do
    hash "${p}" 2>&- || \
      whd::error "Required program \"${p}\" not installed or in search PATH."
  done
}

function whd::cstatus() {
  echo -e "${YELLOW}[${0} - $(date +%R)]${CLEAR} $1";
}

function whd::error() {
  if [ -n "$1" ]; then
    echo -e "${RED}[${0} - $(date +%R)] ERROR${CLEAR}: ${1}\n";
  fi
  exit 1
}

function whd::cleanup() {
  whd::cstatus "Done."
}

function whd::warn_default_config() {
  CONFIG_HASH=$(md5sum "${WHD_SCRIPTS}/config.json")

  if [ "${CONFIG_HASH}" = "${WHD_DEFAULT_CONFIG}" ]; then
    whd::cstatus "Caution! Default configuration used! Please the default values as soon as the application in running!"
  fi
}

function whd::probe_db() {
  whd::cstatus "WHD is starting up..."
  sleep 5

  for i in $(seq 1 $MAX_TRIES); do
    PROBE_RES=$(curl -Ls -X PUT -H "Content-Type: application/json" -d "${WHD_DB_PROBE}" "${WHD_API}/${WHD_API_DBTEST}")
    PROBE_ERR=$(echo "${PROBE_RES}" | jq '.errorMessage')
    PROBE_DONE=$(echo "${PROBE_RES}" | jq '.connectionEstablished')
    
    if [[ "${PROBE_ERR}" == *"${WHD_ALREADY_UP}"* ]]; then
      whd::alread_setup
    fi

    if [[ ! "${PROBE_ERR}" = "null" ]]; then
      whd::error "Unknown error: ${PROBE_ERR}"
    fi

    if [[ "${PROBE_DONE}" = "true" ]]; then 
      whd::cstatus "Database reachable from WHD. Proceeding with setup."
      break
    fi

    whd::cstatus "DB probe not successful yet (current status: ${PROBE_DONE}). Retrying (${i}/${MAX_TRIES}) ..."

    sleep $TRY_DELAY
  done

  if (( MAX_TRIES == i )); then
    whd::error "Could not probe database from WHD. Please file a bug."
  fi
}

function whd::init_db() {
  CONFIG_CONTENT=$(cat "${WHD_SCRIPTS}/config.json")
  
  PROBE_TIME=$(date +%s)
  PROBE_RES=$(curl -Ls -X POST -H "Content-Type: application/json" -d "${CONFIG_CONTENT}" "${WHD_API}/${WHD_API_CONFIG}${PROBE_TIME}")
  PROBE_STATUS=$(echo "${PROBE_RES}" | jq '.status')

  if [[ "${PROBE_STATUS}" = "Initializing Database..." ]]; then 
    whd::error "Unexpected response: ${PROBE_STATUS}. Please file a bug."
  fi

  for i in {1..60}; do
    PROBE_TIME=$(date +%s)
    PROBE_RES=$(curl -Ls -X GET "${WHD_API}/${WHD_API_CONFIG}${PROBE_TIME}")
    PROBE_STATUS=$(echo "${PROBE_RES}" | jq -r '.status')
    PROBE_DESC=$(echo "${PROBE_RES}" | jq -r '."configuration step description"')

    if [[ "${PROBE_DESC}" = "Done" ]]; then 
      whd::cstatus "Setup complete, now waiting for AppMan to start the service."
      break
    fi

    whd::cstatus "Setup in progress. ${PROBE_DESC}: ${PROBE_STATUS}"

    sleep $TRY_DELAY
  done

  if (( 60 == i )); then
    whd::error "Setup timeout. Left in unknown state. Please file a bug."
  fi
}

function whd::wait_on_startup() {
  whd::cstatus "Starting WHD once to verify proper configuration..."

  for i in {1..120}; do
    PROBE_TIME=$(date +%s)
    PROBE_RES=$(curl -Ls -X GET "${WHD_API}/${WHD_API_STARTUP}${PROBE_TIME}")
    PROBE_STATUS=$(echo "${PROBE_RES}" | jq -r '.state')
    PROBE_RUNNING=$(echo "${PROBE_RES}" | jq '.running')

    if [[ "${PROBE_RUNNING}" = "true" ]]; then 
      whd::cstatus "Setup complete, you can now use the application."
      break
    fi

    whd::cstatus "Startup in progress: ${PROBE_STATUS}"

    sleep 5
  done

  if (( 120 == i )); then
    whd::error "Setup timeout. Left in unknown state. Please file a bug."
  fi
}

function whd::success_message() {
  FIN_URL="${WHD_API}"
  FIN_USER=$(echo "${CONFIG_CONTENT}" | jq -r '.admin.userName')
  FIN_MAIL=$(echo "${CONFIG_CONTENT}" | jq -r '.admin.email')

  touch "${WHD_ARTIFACT}"

  whd::cstatus "After a few seconds, you'll be able to login to your new WHD instance:\nURL:      ${FIN_URL}\nUser:     ${FIN_USER} (${FIN_MAIL})\nPassword: see config"
}

function whd::start_whd() {
  if ! "${WHD_BIN}" restart 8081 ; then
    whd::error "Could not (re)start WHD."
  fi
}

function whd::stop() {
  if ! "${WHD_BIN}" stop ; then
    whd::error "Could stop test WHD instance."
  fi
}

function whd::daemonize() {
  supervisord --nodaemon -c "${WHD_SCRIPTS}/supervisord.conf"
}

function whd::alread_setup() {
  whd::cstatus "This instance is already configured. Starting..."
  whd::daemonize
  exit 0
}

function main() {
  whd::check_dependencies jq curl md5sum
  whd::warn_default_config

  if [ -f "${WHD_ARTIFACT}" ]; then
    whd::alread_setup
  fi

  whd::start_whd
  whd::probe_db
  whd::init_db
  whd::wait_on_startup
  whd::success_message
  
  whd::cleanup
  whd::stop
  whd::daemonize
  exit 0
}

trap "whd::cleanup; exit 1" SIGHUP SIGINT SIGQUIT SIGPIPE SIGTERM

main "$@"

