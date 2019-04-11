#!/bin/bash

set -e

source $(dirname $0)/helpers.sh

it_can_sync_bucket_remote_path() {

  local source base_dir
  source=$(mktemp -d $TMPDIR_ROOT/out-source.XXXXXX)
  base_dir=$(mktemp -d $source/base_dir.XXXXXX)

  jq -n "{
    source: {
      bucket: $(echo $BUCKET_NAME | jq -R .),
      remote_path: $(echo $REMOTE_PATH | jq -R .),
      json_key: $(cat $GCP_SERVICE_ACCOUNT_KEY)
    },
    params: {
      base_dir: $(echo $base_dir | jq -R .)
    }
  }" | $resource_dir/in "$source" | tee /dev/stderr

  jq -n "{
    source: {
      bucket: $(echo $BUCKET_NAME | jq -R .),
      remote_path: $(echo $REMOTE_PATH | jq -R .),
      json_key: $(cat $GCP_SERVICE_ACCOUNT_KEY)
    },
    params: {
      base_dir: $(echo $base_dir | jq -R .),
      dry_run: true
    }
  }" | $resource_dir/out "$source" | tee /dev/stderr
}

run it_can_sync_bucket_remote_path
