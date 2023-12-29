# kubernetes-tools-docker

Utilities to work with Kubernetes manifests. The images come in two flavors: Alpine and scratch.

## Usage

#### From alpine

```dockerfile
ARG TOOLS_VERSION=latest

FROM ghcr.io/nedix/kubernetes-tools-docker:${TOOLS_VERSION}
```

or

```dockerfile
ARG TOOLS_VERSION=latest
ARG ALPINE_VERSION # optional

FROM ghcr.io/nedix/kubernetes-tools-docker:${TOOLS_VERSION}-alpine${ALPINE_VERSION}
```

#### From scratch

```dockerfile
ARG TOOLS_VERSION=latest
ARG ALPINE_VERSION=3.18

FROM ghcr.io/nedix/kubernetes-tools-docker:${TOOLS_VERSION}-scratch as tools

FROM alpine:${ALPINE_VERSION}

COPY --chown=nobody --from=tools / /

ENV ENV /etc/profile
```

<hr>

## Attribution

Powered by [Argo CD], [Helm], [kfilt], [krew], [kubectl], [kustomize] and [yq].

[Argo CD]: https://github.com/argoproj/argo-cd
[Helm]: https://github.com/helm/helm
[kfilt]: https://github.com/ryane/kfilt
[krew]: https://github.com/kubernetes-sigs/krew
[kubectl]: https://github.com/kubernetes/kubectl
[kustomize]: https://github.com/kubernetes-sigs/kustomize
[yq]: https://github.com/mikefarah/yq
