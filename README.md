# GCS Sync Resource

Synchronize content of two buckets/directories

## Source Configuration

* `bucket`: *Required.* The name of the bucket.

* `json_key`: *Required.* The contents of your GCS Account JSON Key file to use when accessing the bucket. Example:
  ```
  json_key: |
    {
      "private_key_id": "...",
      "private_key": "...",
      "client_email": "...",
      "client_id": "...",
      "type": "service_account"
    }
  ```

## Behavior

### `check`: Extract versions from the bucket.

The `bucket`'s long listing (including non-current object versions / generations) is used as version.

### `in`: Fetch the content of the bucket.

Makes the contents of the input directory the same as the contents `bucket`'s root by copying any missing or changed files/objects, and deleting any extra files/objects.

#### Parameters

* `base_dir`: *Optional.* Base directory in which to place the artifacts.
* `dry_run`: *Optional.* Causes rsync to run in "dry run" mode, i.e., just outputting what would be copied or deleted without actually doing any copying/deleting.

### `out`: Upload content to the bucket.

Makes the contents to root of remote bucket the same as the contents of the input directory by copying any missing or changed files/objects, and deleting any extra files/objects.

#### Parameters

* `base_dir`: *Optional.* Base directory in which to take the artifacts.
* `dry_run`: *Optional.* Causes rsync to run in "dry run" mode, i.e., just outputting what would be copied or deleted without actually doing any copying/deleting.

## Example Configuration

```yaml
resource_types:
  - name: gcs-rsync-resource
    type: docker-image
    source:
      repository: energumen/gcs-rsync-resource

resources:
  - name: bucket-folder
    type: gcs-rsync-resource
    source:
      bucket: mybucket
      json_key: <GCS-ACCOUNT-JSON-KEY-CONTENTS>

jobs:
- name: sync-bucket-folder
  plan:
  - get: bucket-folder
  - put: bucket-folder
    params:
      dry_run: false
      base_dir: bucket-folder
    get_params:
      base_dir: bucket-folder
```
