FROM --platform=$BUILDPLATFORM alpine:3.18 as build-env

ARG ARCHITECTURE

WORKDIR /build

RUN test -n "$ARCHITECTURE" || case $(uname -m) in \
        aarch64) ARCHITECTURE=arm64; ;; \
        amd64) ARCHITECTURE=amd64; ;; \
        arm64) ARCHITECTURE=arm64; ;; \
        armv8b) ARCHITECTURE=arm64; ;; \
        armv8l) ARCHITECTURE=arm64; ;; \
        x86_64) ARCHITECTURE=amd64; ;; \
        *) echo "Unsupported architecture, exiting..."; exit 1; ;; \
    esac \
    && echo "ARCHITECTURE=$ARCHITECTURE" >> .env \
    && apk add --virtual .build-deps \
        curl

FROM build-env as argocd

ARG ARGOCD_VERSION=2.8.2

RUN source .env \
    && curl -sSL https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-${ARCHITECTURE} -o argocd \
    && chmod +x argocd

FROM build-env as helm

ARG HELM_VERSION=3.11.2

RUN source .env \
    && curl -sSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCHITECTURE}.tar.gz \
    | tar xzOf - linux-${ARCHITECTURE}/helm > helm \
    && chmod +x helm

FROM build-env as kfilt

ARG KFILT_VERSION=0.0.8

RUN source .env \
    && curl -sSL https://github.com/ryane/kfilt/releases/download/v${KFILT_VERSION}/kfilt_${KFILT_VERSION}_linux_${ARCHITECTURE} -o kfilt \
    && chmod +x kfilt

FROM build-env as kubectl

ARG KUBECTL_VERSION=1.28.1

RUN source .env \
    && curl -sSL https://dl.k8s.io/v${KUBECTL_VERSION}/kubernetes-client-linux-${ARCHITECTURE}.tar.gz \
    | tar xzOf - kubernetes/client/bin/kubectl > kubectl \
    && chmod +x kubectl

FROM build-env as kustomize

ARG KUSTOMIZE_VERSION=5.0.1

RUN source .env \
    && curl -sSL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_${ARCHITECTURE}.tar.gz \
    | tar xzOf - kustomize > kustomize \
    && chmod +x kustomize

FROM build-env as yq

ARG YQ_VERSION=4.35.1

RUN source .env \
    && curl -sSL https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${ARCHITECTURE}.tar.gz \
    | tar xzOf - ./yq_linux_${ARCHITECTURE} > yq \
    && chmod +x yq

FROM --platform=$BUILDPLATFORM alpine:3.18

COPY --link --from=argocd /build/argocd /usr/local/bin/argocd
COPY --link --from=helm /build/helm /usr/local/bin/helm
COPY --link --from=kfilt /build/kfilt /usr/local/bin/kfilt
COPY --link --from=kubectl /build/kubectl /usr/local/bin/kubectl
COPY --link --from=kustomize /build/kustomize /usr/local/bin/kustomize
COPY --link --from=yq /build/yq /usr/local/bin/yq

WORKDIR /
