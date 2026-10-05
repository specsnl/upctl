# Docker upctl

[![Build Images](https://github.com/specsnl/upctl/actions/workflows/main.yml/badge.svg)](https://github.com/specsnl/upctl/actions/workflows/main.yml)

A upctl image.

Pulling image from GitHub Container Registry:

```bash
docker pull ghcr.io/specsnl/upctl:latest
```

Interactive shell and mounting the current directory:

```bash
docker run -it -v $(pwd):/workspace --rm ghcr.io/specsnl/upctl:latest
```

Default workspace: `/workspace`

## Task

This project uses [Task](https://taskfile.dev) (a task runner / build tool).

Available tasks for this project:

```sh
* build:               Build the upctl image
* check-updates:       Check for newer versions of the pinned tools
* lint:                Apply a Dockerfile linter (https://github.com/hadolint/hadolint)
* shell:               Interactive shell
```
