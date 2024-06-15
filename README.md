# kubernetes-tools-docker

A docker layer that contains tools to work with Kubernetes manifests.

## Usage

### Copy the Docker layer

```dockerfile
ARG TOOLS_VERSION=latest

FROM ghcr.io/nedix/kubernetes-tools-docker:${TOOLS_VERSION} as tools

FROM alpine

COPY --chown=nobody --from=tools / /

ENV ENV /etc/profile
```

## Attribution

- [Argo CD] ([License](https://raw.githubusercontent.com/argoproj/argo-cd/master/LICENSE))
- [Helm] ([License](https://raw.githubusercontent.com/helm/helm/main/LICENSE))
- [kfilt] ([License](https://raw.githubusercontent.com/ryane/kfilt/main/LICENSE))
- [krew] ([License](https://raw.githubusercontent.com/kubernetes-sigs/krew/master/LICENSE))
- [kubectl] ([License](https://raw.githubusercontent.com/kubernetes/kubectl/master/LICENSE))
- [kustomize] ([License](https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/LICENSE))
- [yq] ([License](https://raw.githubusercontent.com/mikefarah/yq/master/LICENSE))

[Argo CD]: https://github.com/argoproj/argo-cd
[Helm]: https://github.com/helm/helm
[kfilt]: https://github.com/ryane/kfilt
[krew]: https://github.com/kubernetes-sigs/krew
[kubectl]: https://github.com/kubernetes/kubectl
[kustomize]: https://github.com/kubernetes-sigs/kustomize
[yq]: https://github.com/mikefarah/yq
