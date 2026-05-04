# Use nixos/nix as the base for a reproducible and extensible environment.
FROM nixos/nix:latest@sha256:bf1d938835ab96312f098fa6c2e9cab367728e0aad0646ee3e02a787c80d8fb8

# Metadata
LABEL org.opencontainers.image.title="Nanobot" \
      org.opencontainers.image.description="An ultra-lightweight personal AI assistant and agent framework"

# 1. System Setup
# Enable experimental Nix features (Flakes) and fix seccomp issues in Docker/CI
RUN mkdir -p /etc/nix && \
    echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf && \
    echo "filter-syscalls = false" >> /etc/nix/nix.conf && \
    echo "sandbox = false" >> /etc/nix/nix.conf

# Prepare application directory
# We use UID 1000 (standard for the first non-root user)
RUN mkdir -p /opt/nanobot /home/nanobot && \
    chown -R 1000:1000 /opt/nanobot /home/nanobot

# 2. Toolchain Installation
WORKDIR /opt/nanobot
COPY flake.nix ./

# Install the toolchain defined in flake.nix into a globally readable profile
# We use --impure because our flake.nix uses a custom import nixpkgs config
RUN mkdir -p /usr/local && \
    nix profile install --impure --profile /usr/local/nix-profile .#default

# Add the toolchain to the system PATH
ENV PATH="/usr/local/nix-profile/bin:${PATH}"

# 3. Application Installation
# Switch to UID 1000 (no named user needed in /etc/passwd for most apps)
USER 1000
WORKDIR /opt/nanobot

# Copy requirements file (for Python dependencies)
COPY --chown=1000:1000 requirements.txt ./

# Build Python environment
# We set CMAKE_POLICY_VERSION_MINIMUM to 3.5 to fix compatibility with python-olm
# We set UV_CACHE_DIR to a writable location
RUN UV_CACHE_DIR=/opt/nanobot/.uv_cache uv venv .venv && \
    UV_CACHE_DIR=/opt/nanobot/.uv_cache CMAKE_POLICY_VERSION_MINIMUM=3.5 uv pip install -r requirements.txt

# Add the virtualenv to the PATH
ENV PATH="/opt/nanobot/.venv/bin:${PATH}"

# 4. Runtime Configuration
WORKDIR /home/nanobot
RUN mkdir -p /home/nanobot/.nanobot
ENV HOME=/home/nanobot
ENV PYTHONUNBUFFERED=1

# Expose default API port
EXPOSE 8000

# Entrypoint to start the agent
ENTRYPOINT ["nanobot"]
CMD ["agent"]
