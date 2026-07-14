FROM postgresql AS builder

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PGVECTOR_VERSION=0.8.5
ARG BUILD_DEPS="curl gcc libc6-dev make"

RUN pg_config="$(command -v pg_config)" && \
    install_packages ${BUILD_DEPS} && \
    workdir=$(mktemp -d) && cd ${workdir} && \
    curl -fsSL https://github.com/pgvector/pgvector/archive/refs/tags/v${PGVECTOR_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    make PG_CONFIG="${pg_config}" OPTFLAGS="" -j $(nproc) && \
    make PG_CONFIG="${pg_config}" install && \
    rm -rf ${workdir} && \
    apt-get purge -y --auto-remove ${BUILD_DEPS} && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

FROM scratch

ARG EXPORT=/export

COPY --from=builder /opt/bitnami/postgresql/lib/vector.so ${EXPORT}/lib/
COPY --from=builder /opt/bitnami/postgresql/share/extension/vector* ${EXPORT}/extension/
