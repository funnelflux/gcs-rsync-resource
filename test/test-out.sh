#!/bin/bash

set -e

source $(dirname $0)/helpers.sh

it_can_sync_bucket_remote_path() {

  local source
  source=$(mktemp -d $TMPDIR_ROOT/out-source.XXXXXX)

  jq -n "{
    source: {
      bucket: $(echo $BUCKET_NAME | jq -R .),
      remote_path: $(echo $REMOTE_PATH | jq -R .),
      json_key: $(cat $GCP_SERVICE_ACCOUNT_KEY)
    },
    params: {
      dry_run: true
    }
  }" | $resource_dir/out "$source" | tee /dev/stderr
}

run it_can_sync_bucket_remote_path
