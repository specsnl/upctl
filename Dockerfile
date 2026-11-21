# syntax=docker/dockerfile:1
# check=error=true

# Latest version of yq: https://hub.docker.com/r/mikefarah/yq/tags
FROM mikefarah/yq:4.54.3 AS yq

# Latest version of Alpine image: https://hub.docker.com/_/alpine/tags
FROM alpine:3.24.4 AS upctl

# Latest version of upctl: https://github.com/UpCloudLtd/upcloud-cli/releases
ARG UPCTL_VERSION=3.37.0
# Checksums can be found in the checksums.txt file attached to the release
ARG UPCTL_CHECKSUM_AMD64=ce2d381bdf49ce74a74582f390490542c49957079d7e606303e1426138b7e3d6
ARG UPCTL_CHECKSUM_ARM64=33c0d4b87631d5f4fdfd3bb63dd6564452e807a5dbbd95ea126d1ed121e77268
ARG TARGETARCH

WORKDIR /tmp/upctl

RUN case "${TARGETARCH}" in \
            amd64) arch=x86_64; checksum="${UPCTL_CHECKSUM_AMD64}" ;; \
            arm64) arch=arm64; checksum="${UPCTL_CHECKSUM_ARM64}" ;; \
            *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
        esac \
    && archive="upcloud-cli_${UPCTL_VERSION}_linux_${arch}.tar.gz" \
    && wget -q "https://github.com/UpCloudLtd/upcloud-cli/releases/download/v${UPCTL_VERSION}/${archive}" \
    && echo "${checksum}  ${archive}" > checksum.txt \
    && sha256sum -c checksum.txt \
    && tar -xzf "${archive}" upctl \
    && install -m 0755 upctl /usr/local/bin/upctl

FROM alpine:3.24.4

RUN apk add --no-cache --upgrade --no-progress \
        'ca-certificates>=20260909' \
        bash~=5.3 \
        jq~=1.8

COPY --from=upctl /usr/local/bin/upctl /usr/local/bin/upctl
COPY --from=yq /usr/bin/yq /usr/local/bin/yq

WORKDIR /workspace

CMD ["/bin/bash"]
