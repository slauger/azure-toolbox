FROM registry.access.redhat.com/ubi9/ubi

# renovate: datasource=github-tags depName=helm/helm
ARG HELM_VERSION=3.10.1

# renovate: datasource=github-tags depName=kubernetes/kubernetes
ARG KUBECTL_VERSION=1.25.3

# renovate: datasource=github-tags depName=ahmetb/kubectx
ARG KUBECTX_VERSION=0.9.4

RUN yum install -y \
      sudo \
      which \
      make \
      hostname \
      git \
      rsync \
      jq \
      unzip \
      ca-certificates \
      openssh \
      openssl-libs \
      make && \
    yum clean all && \
    rm -rf /var/cache/dnf/*

# helm
RUN curl -fsSL -o helm-linux-amd64.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar vxzf helm-linux-amd64.tar.gz linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm helm-linux-amd64.tar.gz && \
    rm -rf linux-amd64

# kubectl
RUN curl -fsSL -o /usr/local/bin/kubectl https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

# kubectx
RUN curl -fsSL -o kubectx_linux_x86_64.tar.gz https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_linux_x86_64.tar.gz && \
    tar vxzf kubectx_linux_x86_64.tar.gz kubectx && \
    mv kubectx /usr/local/bin/kubectx && \
    rm -f kubectx_linux_x86_64.tar.gz

# kubens
RUN curl -fsSL -o kubens_linux_x86_64.tar.gz https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubens_v${KUBECTX_VERSION}_linux_x86_64.tar.gz && \
    tar vxzf kubens_linux_x86_64.tar.gz kubens && \
    mv kubens /usr/local/bin/kubens && \
    rm -f kubens_linux_x86_64.tar.gz

# azure-cli
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm && \
    dnf install azure-cli -y
