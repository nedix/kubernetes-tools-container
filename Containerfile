ARG ALPINE_VERSION=3.24.1
ARG ARGO_CD_VERSION=3.4.5
ARG HELM_VERSION=4.2.3
ARG KFILT_VERSION=1.0.0
ARG KREW_VERSION=0.5.0
ARG KUBECTL_VERSION=1.36.3
ARG KUSTOMIZE_VERSION=5.0.1
ARG YQ_VERSION=4.53.3

FROM ghcr.io/nedix/alpine-base-container:${ALPINE_VERSION} AS base

FROM base AS build-base

RUN case "$(uname -m)" in \
        aarch64|arm*) \
            ARCHITECTURE="arm64" \
        ;; x86_64) \
            ARCHITECTURE="amd64" \
        ;; *) echo "Unsupported architecture: $(uname -m)"; exit 1; ;; \
    esac \
    && echo "ARCHITECTURE=$ARCHITECTURE" >> /.env

FROM build-base AS argocd

WORKDIR /build/argocd/

ARG ARGO_CD_VERSION

RUN . /.env \
    && wget -qo argocd "https://github.com/argoproj/argo-cd/releases/download/v${ARGO_CD_VERSION}/argocd-linux-${ARCHITECTURE}" \
    && chmod +x argocd

FROM build-base AS helm

WORKDIR /build/helm/

ARG HELM_VERSION

RUN . /.env \
    && wget -qO- "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCHITECTURE}.tar.gz" \
    | tar xzOf - linux-${ARCHITECTURE}/helm > helm \
    && chmod +x helm

FROM build-base AS kfilt

WORKDIR /build/kfilt/

ARG KFILT_VERSION

RUN . /.env \
    && wget -qo kfilt "https://github.com/ryane/kfilt/releases/download/v${KFILT_VERSION}/kfilt_linux_${ARCHITECTURE}" \
    && chmod +x kfilt

FROM build-base AS krew

WORKDIR /build/krew/

ENV KREW_ROOT="/opt/krew"

ARG KREW_VERSION

RUN . /.env \
    && apk add --virtual .krew-build-deps \
        git \
    && wget -qO- "https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew-linux_${ARCHITECTURE}.tar.gz" \
    | tar xzOf - ./krew-linux_${ARCHITECTURE} > krew \
    && chmod +x krew \
    && ./krew install --manifest-url="https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew.yaml" \
    && rm krew \
    && apk del .krew-build-deps

FROM build-base AS kubectl

WORKDIR /build/kubectl/

ARG KUBECTL_VERSION

RUN . /.env \
    && wget -qO- "https://dl.k8s.io/v${KUBECTL_VERSION}/kubernetes-client-linux-${ARCHITECTURE}.tar.gz" \
    | tar xzOf - kubernetes/client/bin/kubectl > kubectl \
    && chmod +x kubectl

FROM build-base AS kustomize

WORKDIR /build/kustomize/

ARG KUSTOMIZE_VERSION

RUN . /.env \
    && wget -qO- "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_${ARCHITECTURE}.tar.gz" \
    | tar xzOf - kustomize > kustomize \
    && chmod +x kustomize

FROM build-base AS yq

WORKDIR /build/yq/

ARG YQ_VERSION

RUN . /.env \
    && wget -qO- "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${ARCHITECTURE}.tar.gz" \
    | tar xzOf - ./yq_linux_${ARCHITECTURE} > yq \
    && chmod +x yq

FROM alpine:${ALPINE_VERSION}

RUN apk add \
        inotify-tools

COPY --link --from=argocd /build/argocd/argocd /usr/local/bin/argocd
COPY --link --from=helm /build/helm/helm /usr/local/bin/helm
COPY --link --from=kfilt /build/kfilt/kfilt /usr/local/bin/kfilt
COPY --link --from=krew /opt/krew /opt/krew
COPY --link --from=kubectl /build/kubectl/kubectl /usr/local/bin/kubectl
COPY --link --from=kustomize /build/kustomize/kustomize /usr/local/bin/kustomize
COPY --link --from=yq /build/yq/yq /usr/local/bin/yq

COPY --link /rootfs/ /

ENV ENV="/etc/profile"
ENV KREW_ROOT="/opt/krew"

RUN kubectl krew install neat

WORKDIR /project/
