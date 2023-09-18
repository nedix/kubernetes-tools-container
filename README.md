# kubernetes-tools-docker

## Examples

**From alpine**

```dockerfile
ARG TOOLS_VERSION=v2.0.1

FROM ghcr.io/nedix/kubernetes-tools-docker:${TOOLS_VERSION}
```

or

```dockerfile
ARG TOOLS_VERSION=v2.0.1
ARG ALPINE_VERSION # optional

FROM ghcr.io/nedix/kubernetes-tools-docker:${TOOLS_VERSION}-alpine${ALPINE_VERSION}
```

**From scratch**

```dockerfile
ARG TOOLS_VERSION=v2.0.1
ARG ALPINE_VERSION=3.18

FROM ghcr.io/nedix/kubernetes-tools-docker:${TOOLS_VERSION}-scratch as tools

FROM alpine:${ALPINE_VERSION}

COPY --chown=nobody --from=tools / /

ENV ENV /etc/profile
```
