#!/bin/bash

set -e

source $(dirname $0)/helpers.sh

it_can_sync_bucket_remote_path() {

  local source
  source=$(mktemp -d $TMPDIR_ROOT/in-source.XXXXXX)

  jq -n "{
    source: {
      bucket: $(echo $BUCKET_NAME | jq -R .),
      remote_path: $(echo $REMOTE_PATH | jq -R .),
      json_key: $(cat $GCP_SERVICE_ACCOUNT_KEY)
    }
  }" | $resource_dir/in "$source" | tee /dev/stderr
}

it_can_delete_extra_files_in_destination() {

  local source
  source=$(mktemp -d $TMPDIR_ROOT/in-source.XXXXXX)

  local extra_file
  extra_file="$source/extra.file"
  touch "$source/extra.file"

  jq -n "{
    source: {
      bucket: $(echo $BUCKET_NAME | jq -R .),
      remote_path: $(echo $REMOTE_PATH | jq -R .),
      json_key: $(cat $GCP_SERVICE_ACCOUNT_KEY)
    }
  }" | $resource_dir/in "$source" | tee /dev/stderr

  if [ -e "$extra_file" ]; then
    echo "Failed" > /dev/stderr
  fi
}

run it_can_sync_bucket_remote_path
run it_can_delete_extra_files_in_destination
