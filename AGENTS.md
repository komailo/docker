# Project Overview: Image Registry

This repository serves as a centralized registry for a wide variety of container images. It contains Dockerfiles and GitHub Actions workflows for building, maintaining, and distributing standardized, multi-platform images for various use cases.

## Main Technologies
- **Docker**: Containerization and multi-stage builds.
- **GitHub Actions**: Automated image building, tagging, and pushing to GitHub Container Registry (GHCR).
- **Alpine Linux & Ubuntu**: Common base distributions for images.
- **DevOps & Specialized Tools**: A wide range of utilities pinned to specific versions for reproducibility.

## Project Architecture
Images are organized by their directory structure, which directly maps to their name in the registry.

### 1. Grouped Structure (Recommended for multiple variants)
Organize images by a common group and specific type.
- **Structure**: `<image-group>/<image-type>/Dockerfile`
- **Example**: `github-runner/general-purpose/Dockerfile`
- **Workflow Config**: `image_paths: github-runner/general-purpose`
- **Resulting Image**: `ghcr.io/repo/github-runner/general-purpose`

### 2. Flat Structure (Recommended for single-purpose images)
Place the Dockerfile directly within the group folder.
- **Structure**: `<image-group>/Dockerfile`
- **Example**: `my-tool/Dockerfile`
- **Workflow Config**: `image_paths: my-tool`
- **Resulting Image**: `ghcr.io/repo/my-tool`

### Infrastructure
- `.github/workflows/`: Centralized build logic using a reusable workflow (`reusable-image-build.yaml`).
- All workflows use `image_paths` (comma-separated for multiple images) to define what to build.

## Building and Running

### CI/CD Build Process
Images are automatically built and pushed to `ghcr.io` under the following conditions:
- **Push to `main`**: Builds and tags as `latest`.
- **Tag creation**: Builds and tags according to SemVer patterns (e.g., `v1`, `v1.2`, `v1.2.3`).
- **Pull Requests**: Triggers a build to validate changes (does not push).

### Manual Build
To build an image locally for testing:
```bash
# Example: Building the job-executor image
docker build -t job-executor:local -f job-executor/general-purpose/Dockerfile .
```
*Note: The GitHub Action uses the specific image directory (e.g., `./job-executor/general-purpose`) as the build context.*

## Development Conventions

### Image Definitions
- **Multi-platform**: All images must support both `linux/amd64` and `linux/arm64` architectures.
- **Reproducibility**: Use `ARG` for version pinning and include `sha256` digests for all base images.
- **Layer Optimization**: Combine `RUN` commands where possible to minimize image layers and use `--no-cache` for package managers.
- **Metadata Labels**: Do **NOT** add `org.opencontainers.image.source` label in Dockerfiles; the CI workflow automatically adds this with the correct repository URL.

### Workflow Integration
- New images should be integrated by creating a group-specific workflow in `.github/workflows/` that calls the `reusable-image-build.yaml` workflow.
- Pass the relative path to the image directory in the `image_paths` input.

### Versioning
- This project follows Semantic Versioning for tags.
- Base image updates should be tracked via PRs to ensure compatibility and security.
