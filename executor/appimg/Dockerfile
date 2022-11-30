FROM jenkins/inbound-agent:4.10-3

USER root

RUN apt-get update && apt install -y --no-install-recommends apt-utils dialog \
    make git curl wget gradle \
# install awscli v2 + remove unnecessary files
RUN curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/current/dist/aws_completer \
        /usr/local/aws-cli/v2/current/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/current/dist/awscli/examples \
    && find /usr/local/aws-cli/v2/current/dist/awscli/botocore/data -name examples-1.json -delete \
    && rm -rf /var/cache/apk/*
RUN apt-get install -y gettext-base jq

# install git & git-lfs
RUN apk add bash sed git git-lfs && \
    git lfs install --skip-repo

# install argcd cli
ARG ARGO_VERSION=v2.3.4
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/${ARGO_VERSION}/argocd-linux-amd64 && \ 
    chmod +x /usr/local/bin/argocd