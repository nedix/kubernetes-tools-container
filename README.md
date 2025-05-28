# [kubernetes-tools-container][project]

Commandline tools to work with Kubernetes resources such as Helm charts and Kustomize manifests.


## Usage


### 1. Prepare the Kubernetes config file

```shell
CONFIG_PATH="${HOME}/.kube/config"
```

OR

```shell
CONFIG_PATH="${PWD}/kubeconfig.yaml"
```


### 2. Start a shell session

```shell
docker run --rm -it --pull always --name kubernetes-tools \
    --mount "type=bind,source=${CONFIG_PATH},target=/mnt/kubeconfig.yaml,ro" \
    -v ${PWD}:/project/ \
    nedix/kubernetes-tools
```


### 3. Use any of the commands

- `argocd`
- `helm`
- `kfilt`
- `kubectl`
- `kubectl export`
- `kubectl krew`
- `kustomize`
- `yq`


[project]: https://hub.docker.com/r/nedix/kubernetes-tools
