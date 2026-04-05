# Use a lightweight and secure Alpine Linux base
# Pinned to 3.20.0 with SHA256 for reproducibility
ARG ALPINE_IMAGE_TAG=3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659

FROM alpine:${ALPINE_IMAGE_TAG}

# Install core dependencies and security updates
# - git: Required for sync operations
# - bash: git-sync is a bash script
# - openssh-client: For SSH-based sync
# - inotify-tools: For git-sync-on-inotify support
# - curl: To fetch the script
RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    bash \
    git \
    openssh-client \
    inotify-tools \
    curl && \
    rm -rf /var/cache/apk/*

# Download and install git-sync scripts
# renovate: datasource=github-commits depName=simonthum/git-sync
ARG GIT_SYNC_VERSION=b991840c5533c010adda58015de44ba36d6bc1d0
RUN curl -sSL https://raw.githubusercontent.com/simonthum/git-sync/${GIT_SYNC_COMMIT}/git-sync -o /usr/local/bin/git-sync && \
    curl -sSL https://raw.githubusercontent.com/simonthum/git-sync/${GIT_SYNC_COMMIT}/contrib/git-sync-on-inotify -o /usr/local/bin/git-sync-on-inotify && \
    chmod +x /usr/local/bin/git-sync /usr/local/bin/git-sync-on-inotify

# Create a non-root user for security
RUN addgroup -S gitsync && adduser -S gitsync -G gitsync && \
    mkdir -p /home/gitsync/.ssh && \
    chmod 700 /home/gitsync/.ssh && \
    chown -R gitsync:gitsync /home/gitsync/.ssh

USER gitsync

# Set the default working directory
WORKDIR /git

# Metadata
LABEL org.opencontainers.image.description="Lightweight and secure git-sync image based on Alpine Linux"

ENTRYPOINT ["git-sync"]
