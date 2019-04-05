#!/bin/bash

set -e

function print_version() {
  authenticate_cli

  gsutil ls -l "gs://${BUCKET}/${REMOTE_PATH}/**" &> $TMPDIR/check.log
  cat $TMPDIR/check.log \
   | grep -v "$(cat $TMPDIR/check.log | tail -n -1)" \
   | awk '{print $1,$2,$3}' \
   | jq  -R -s '. | split("\n") | del(.[] | select(. == "")) | map(split(" ") | {size: .[0], timestamp: .[1], name: .[2]}) | {files: .} | {version: .}'
}

function rsync() {
  local src_url dst_url
  src_url=$1
  dst_url=$2

  authenticate_cli
  pushd "${DESTINATION_DIR}/${LOCAL_PATH}" > /dev/null
    gsutil -m rsync -d -r ${src_url} ${dst_url} &> /dev/null
  popd
}

function authenticate_cli() {
  gcloud auth activate-service-account --key-file="${GCP_SERVICE_ACCOUNT_KEY}" --no-user-output-enabled
}

function parse_payload() {
  local payload
  payload=$1

  export BUCKET=$(jq -r '.source.bucket' < $payload)
  if [ -z "$BUCKET" ]; then
    echo "invalid payload (missing bucket)"
    exit 1
  fi
  export REMOTE_PATH=$(jq -r '.source.remote_path' < $payload)
  if [ -z "$REMOTE_PATH" ]; then
    echo "invalid payload (missing remote_path)"
    exit 1
  fi

  export LOCAL_PATH=$(jq -r '.source.local_path' < $payload)
  if [ -z "$LOCAL_PATH" ]; then
    echo "invalid payload (missing local_path)"
    exit 1
  fi
  mkdir -p "${LOCAL_PATH}"

  export GCP_SERVICE_ACCOUNT_KEY=$(jq -r '.source.json_key' < $payload)
  if [ -f "${GCP_SERVICE_ACCOUNT_KEY}" ]; then
    cp "${GCP_SERVICE_ACCOUNT_KEY}" "$TMPDIR/google_service_account.json"
  else
    echo "${GCP_SERVICE_ACCOUNT_KEY}" > "$TMPDIR/google_service_account.json"
  fi
  export GCP_SERVICE_ACCOUNT_KEY="$TMPDIR/google_service_account.json"
}
