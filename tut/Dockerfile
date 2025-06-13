FROM bitnami/minideb:stretch
LABEL maintainer="Author"
LABEL email="author_email@email.com"

## Install the os packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    cowsay \
  && rm -rf /var/lib/apt/lists/*
