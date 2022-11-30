FROM jenkins/inbound-agent:4.10-3

USER root

RUN apt-get update && apt install -y --no-install-recommends apt-utils dialog \
    make git curl wget gradle

# install argcd cli
ARG ARGO_VERSION=v2.3.4
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/${ARGO_VERSION}/argocd-linux-amd64 && \ 
    chmod +x /usr/local/bin/argocd