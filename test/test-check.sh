#!/bin/bash

set -e

source $(dirname $0)/helpers.sh

export BUCKET_NAME=infrastructure.energumen.io
export REMOTE_PATH=control-plane/state
export GCP_SERVICE_ACCOUNT_KEY=~/.config/gcloud/bbl-testbed.key.json

it_can_list_bucket_files_on_remote_path() {

  jq -n "{
    source: {
      bucket: $(echo $BUCKET_NAME | jq -R .),
      remote_path: $(echo $REMOTE_PATH | jq -R .),
      json_key: $(cat $GCP_SERVICE_ACCOUNT_KEY)
    }
  }" | $resource_dir/check | tee /dev/stderr
}

run it_can_list_bucket_files_on_remote_path
