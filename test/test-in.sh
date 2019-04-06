#!/bin/bash

set -e

source $(dirname $0)/helpers.sh

it_can_sync_bucket_remote_path() {

  local destination
  destination=$(mktemp -d $TMPDIR_ROOT/in-destination.XXXXXX)

  jq -n "{
    source: {
      bucket: $(echo $BUCKET_NAME | jq -R .),
      remote_path: $(echo $REMOTE_PATH | jq -R .),
      json_key: $(cat $GCP_SERVICE_ACCOUNT_KEY)
    },
    params: {
      local_path:  $(echo $LOCAL_PATH | jq -R .)
    }
  }" | $resource_dir/in "$destination" | tee /dev/stderr
}

it_can_delete_extra_files_in_destination() {

  local destination
  destination=$(mktemp -d $TMPDIR_ROOT/in-destination.XXXXXX)

  local extra_file
  extra_file="$destination/$LOCAL_PATH/extra.file"

  mkdir -p "$destination/$LOCAL_PATH"
  touch "$destination/$LOCAL_PATH/extra.file"

  jq -n "{
    source: {
      bucket: $(echo $BUCKET_NAME | jq -R .),
      remote_path: $(echo $REMOTE_PATH | jq -R .),
      json_key: $(cat $GCP_SERVICE_ACCOUNT_KEY)
    },
    params: {
      local_path:  $(echo $LOCAL_PATH | jq -R .)
    }
  }" | $resource_dir/in "$destination" | tee /dev/stderr

  if [ -e "$extra_file" ]; then
    echo "Failed" > /dev/stderr
  fi
}

run it_can_sync_bucket_remote_path
run it_can_delete_extra_files_in_destination
