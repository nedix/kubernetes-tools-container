# kubernetes-tools-docker

Commandline tools to work with Kubernetes resources.

## Usage

**Run the container**

```shell
docker run --pull always --rm --name kubernetes-tools \
    --mount type=bind,source=<path to kubeconfig>,target=/mnt/kubeconfig.yaml,ro \
    ghcr.io/nedix/kubernetes-tools-docker
```

**Use any of the commands**

- `argocd`
- `helm`
- `kfilt`
- `kubectl`
- `kubectl export`
- `kubectl krew`
- `kustomize`
- `yq`

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
