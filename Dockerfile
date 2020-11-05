FROM alpine:3.12.1
LABEL maintainer="Daniel Grant <daniel.grant@digirati.com>"

ENV CLEAN_DELAY="60" \
    CLEAN_IMAGES="true" \
    CLEAN_VOLUMES="true" \
    CLEAN_CONTAINERS="true"

RUN apk add --no-cache bash=5.0.17-r0 docker=19.03.12-r0 \
    && rm -rf /var/cache/apk/*

COPY usr/local/bin/docker-cleanup.sh /usr/local/bin/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENTRYPOINT ["/usr/local/bin/docker-cleanup.sh"]
