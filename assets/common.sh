#!/bin/bash

set -e

function check_version() {
  echo "${json_key}" > $TMPDIR/google_service_account.json
  gcloud auth activate-service-account --key-file="$TMPDIR/google_service_account.json" --no-user-output-enabled
  gsutil ls -l "gs://$bucket/$remote_path/**" &> $TMPDIR/check.log
  cat $TMPDIR/check.log \
   | grep -v "$(cat $TMPDIR/check.log | tail -n -1)" \
   | awk '{print $1,$2,$3}' \
   | jq  -R -s '. | split("\n") | del(.[] | select(. == "")) | map(split(" ") | {size: .[0], timestamp: .[1], name: .[2]}) | {files: .} | {version: .}'
}
