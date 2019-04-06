#!/bin/bash

set -e

source $(dirname $0)/helpers.sh

it_can_check_version() {

  jq -n "{
    source: {
      bucket: $(echo $BUCKET_NAME | jq -R .),
      remote_path: $(echo $REMOTE_PATH | jq -R .),
      json_key: $(cat $GCP_SERVICE_ACCOUNT_KEY)
    }
  }" | $resource_dir/check | tee /dev/stderr
}

run it_can_check_version
