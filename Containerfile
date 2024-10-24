ARG ARCHITECTURE
ARG ALPINE_VERSION=3.20
ARG ARGOCD_VERSION=2.12.6
ARG HELM_VERSION=3.16.2
ARG KFILT_VERSION=0.0.8
ARG KREW_VERSION=0.4.4
ARG KUBECTL_VERSION=1.31.2
ARG KUSTOMIZE_VERSION=5.0.1
ARG YQ_VERSION=4.44.3

FROM alpine:${ALPINE_VERSION} AS build-base

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

FROM build-base AS argocd

ARG ARGOCD_VERSION

RUN source .env \
    && curl -fsSL https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-${ARCHITECTURE} -o argocd \
    && chmod +x argocd

FROM build-base AS helm

ARG HELM_VERSION

RUN source .env \
    && curl -fsSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCHITECTURE}.tar.gz \
    | tar xzOf - linux-${ARCHITECTURE}/helm > helm \
    && chmod +x helm

FROM build-base AS kfilt

ARG KFILT_VERSION

RUN source .env \
    && curl -fsSL https://github.com/ryane/kfilt/releases/download/v${KFILT_VERSION}/kfilt_${KFILT_VERSION}_linux_${ARCHITECTURE} -o kfilt \
    && chmod +x kfilt

FROM build-base AS krew

ARG KREW_VERSION

RUN source .env \
    && apk add --virtual .krew-build-deps \
        git \
    && curl -fsSL https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew-linux_${ARCHITECTURE}.tar.gz \
    | tar xzOf - ./krew-linux_${ARCHITECTURE} > krew \
    && chmod +x krew \
    && export KREW_ROOT=/opt/krew \
    && ./krew install --manifest-url=https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew.yaml \
    && rm krew \
    && apk del .krew-build-deps

FROM build-base AS kubectl

ARG KUBECTL_VERSION

RUN source .env \
    && curl -fsSL https://dl.k8s.io/v${KUBECTL_VERSION}/kubernetes-client-linux-${ARCHITECTURE}.tar.gz \
    | tar xzOf - kubernetes/client/bin/kubectl > kubectl \
    && chmod +x kubectl

FROM build-base AS kustomize

ARG KUSTOMIZE_VERSION

RUN source .env \
    && curl -fsSL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_${ARCHITECTURE}.tar.gz \
    | tar xzOf - kustomize > kustomize \
    && chmod +x kustomize

FROM build-base AS yq

ARG YQ_VERSION

RUN source .env \
    && curl -fsSL https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${ARCHITECTURE}.tar.gz \
    | tar xzOf - ./yq_linux_${ARCHITECTURE} > yq \
    && chmod +x yq

FROM alpine:${ALPINE_VERSION}

COPY --link --from=argocd /build/argocd /usr/local/bin/argocd
COPY --link --from=helm /build/helm /usr/local/bin/helm
COPY --link --from=kfilt /build/kfilt /usr/local/bin/kfilt
COPY --link --from=krew /opt/krew /opt/krew
COPY --link --from=kubectl /build/kubectl /usr/local/bin/kubectl
COPY --link --from=kustomize /build/kustomize /usr/local/bin/kustomize
COPY --link --from=yq /build/yq /usr/local/bin/yq

COPY --link rootfs /

ENV ENV=/etc/profile
