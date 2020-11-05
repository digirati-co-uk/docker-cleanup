# Docker Cleanup

[![Build Status](https://travis-ci.com/digirati-co-uk/docker-cleanup.svg?branch=master)](https://travis-ci.com/digirati-co-uk/docker-cleanup)

When deployed, this image will periodically remove stopped containers,
images without at least one container associated with them, and unused
local volumes.

Essentially, it executes the following commands:

- `docker container prune --force`
- `docker image prune --all --force`
- `docker volume prune --force`

**WARNING: This image has the potential to irrecoverably delete
containers, images and volumes. Ensure the mapped `/var/lib/docker` is
correct before running.**

## Environment Variables

| Variable Name      | Description                                                                                                             | Default Value |
|:-------------------|:------------------------------------------------------------------------------------------------------------------------|:--------------|
| `CLEAN_DELAY`      | The amount of time, in seconds, to sleep between cleanup runs.                                                          | 60            |
| `CLEAN_CONTAINERS` | If set to anything other than `false`, then stopped containers will be deleted.                                         | `true`        |
| `CLEAN_IMAGES`     | If set to anything other than `false`, then images without at least one container associated with them will be deleted. | `true`        |
| `CLEAN_VOLUMES`    | If set to anything other than `false`, then unused local volumes will be deleted.                                       | `true`        |

## Deployment

```
docker run \
    --env CLEAN_DELAY=60 \
    --env CLEAN_CONTAINERS=true \
    --env CLEAN_IMAGES=true \
    --env CLEAN_VOLUMES=true \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    digirati/docker-cleanup:latest
```
