# GCS Sync Resource

Synchronize content of two buckets/directories

## Source Configuration

* `bucket`: *Required.* The name of the bucket.

* `remote_path`: *Required.*

* `local_path`: *Required.*

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

-n Causes rsync to run in "dry run" mode, i.e., just outputting what would be copied or deleted without actually doing any copying/deleting.

### `in`: Fetch the content of the bucket.

Makes the contents under `local_path` the same as the contents under `remote_path` by copying any missing or changed files/objects, and deleting any extra files/objects.

### `out`: Upload content to the bucket.

Makes the contents under `remote_path` the same as the contents under `local_path` by copying any missing or changed files/objects, and deleting any extra files/objects.

## Example Configuration

### Resource Type

```yaml
resource_types:
  - name: gcs-rsync-resource
    type: docker-image
    source:
      repository: energumen/gcs-rsync-resource
```

### Resource

``` yaml
resources:
  - name: release
    type: gcs-rsync-resource
    source:
      bucket: mybucket
      remote_path: terraform/state
      local_path: state
      json_key: <GCS-ACCOUNT-JSON-KEY-CONTENTS>
```
