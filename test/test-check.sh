#!/bin/bash

set -e

it_can_list_files_with_on_remote_path() {

  echo $resource_dir

  jq -n "{
    source: {
      bucket: ...,
      remote_path: ...,
      json_key: ...
    }
  }" | $resource_dir/check | tee /dev/stderr
}
