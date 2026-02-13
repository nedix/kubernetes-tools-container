# [kubernetes-tools-container][project]

Commandline tools to work with Kubernetes resources such as Helm charts and Kustomize manifests.


## Usage


### 1. Prepare the Kubernetes config file

```shell
KUBERNETES_CONFIG_PATH="${HOME}/.kube/config"
```

OR

```shell
KUBERNETES_CONFIG_PATH="${PWD}/kubeconfig.yaml"
```


### 2. Start a shell session

```shell
docker run \
    --mount "type=bind,source=${KUBERNETES_CONFIG_PATH},target=/mnt/kubeconfig.yaml,ro" \
    --name kubernetes-tools \
    --pull always \
    --rm \
    -i \
    -t \
    -v "${PWD}:/project/" \
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
