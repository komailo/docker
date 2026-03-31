ARG ALPINE_VERSION=3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659
ARG ANSIBLE_LINT_VERSION=25.11.1-r0
ARG ANSIBLE_VERSION=13.0.0-r0
ARG BASH_VERSION=5.3.3-r1
ARG JQ_VERSION=1.8.1-r1
ARG OPENSSH_VERSION=10.2_p1-r0
ARG TF_VERSION=1.12.2
ARG TRIVY_VERSION=0.69.3@sha256:bcc376de8d77cfe086a917230e818dc9f8528e3c852f7b1aff648949b6258d1c

FROM alpine:${ALPINE_VERSION} as terraform

ARG TF_VERSION
ARG HASHI_CORP_PRODUCT=terraform

RUN apk add --update --virtual .deps --no-cache gnupg && \
    cd /tmp && \
    ARCH=$(uname -m) \
    && case "$ARCH" in \
    x86_64) PLATFORM="linux_amd64";; \
    aarch64) PLATFORM="linux_arm64";; \
    *) echo "** Unsupported architecture: $ARCH"; exit 1;; \
    esac && \
    wget https://releases.hashicorp.com/${HASHI_CORP_PRODUCT}/${TF_VERSION}/${HASHI_CORP_PRODUCT}_${TF_VERSION}_${PLATFORM}.zip && \
    wget https://releases.hashicorp.com/${HASHI_CORP_PRODUCT}/${TF_VERSION}/${HASHI_CORP_PRODUCT}_${TF_VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/${HASHI_CORP_PRODUCT}/${TF_VERSION}/${HASHI_CORP_PRODUCT}_${TF_VERSION}_SHA256SUMS.sig && \
    wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import && \
    gpg --verify ${HASHI_CORP_PRODUCT}_${TF_VERSION}_SHA256SUMS.sig ${HASHI_CORP_PRODUCT}_${TF_VERSION}_SHA256SUMS && \
    grep ${HASHI_CORP_PRODUCT}_${TF_VERSION}_${PLATFORM}.zip ${HASHI_CORP_PRODUCT}_${TF_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip /tmp/${HASHI_CORP_PRODUCT}_${TF_VERSION}_${PLATFORM}.zip -d /tmp && \
    mv /tmp/${HASHI_CORP_PRODUCT} /usr/local/bin/${HASHI_CORP_PRODUCT} && \
    rm -f /tmp/${HASHI_CORP_PRODUCT}_${TF_VERSION}_${PLATFORM}.zip ${HASHI_CORP_PRODUCT}_${TF_VERSION}_SHA256SUMS ${TF_VERSION}/${HASHI_CORP_PRODUCT}_${TF_VERSION}_SHA256SUMS.sig && \
    apk del .deps

FROM ghcr.io/aquasecurity/trivy:${TRIVY_VERSION} as trivy

FROM alpine:${ALPINE_VERSION}

ARG ANSIBLE_LINT_VERSION
ARG ANSIBLE_VERSION
ARG BASH_VERSION
ARG JQ_VERSION
ARG OPENSSH_VERSION

RUN apk update --no-cache && apk upgrade --no-cache && rm -rf /var/cache/apk/*

# Install Ansible
RUN apk add --no-cache \
    ansible-lint=${ANSIBLE_LINT_VERSION} \
    ansible=${ANSIBLE_VERSION} \
    bash=${BASH_VERSION} \
    jq=${JQ_VERSION} \
    openssh=${OPENSSH_VERSION}


COPY --from=terraform /usr/local/bin/terraform /usr/local/bin/terraform
COPY --from=trivy /usr/local/bin/trivy /usr/local/bin/trivy
