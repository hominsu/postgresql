FROM postgresql AS builder

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PARADEDB_VERSION=0.24.2
ARG RUST_TOOLCHAIN=stable
ARG BUILD_DEPS="ca-certificates curl git gcc libc6-dev make clang libclang-dev jq pkg-config libssl-dev"

ENV HOME="/root" \
    CARGO_HOME="/root/.cargo" \
    RUSTUP_HOME="/root/.rustup" \
    PATH="/root/.cargo/bin:${PATH}"

RUN pg_config="$(command -v pg_config)" && \
    pg_version="$("${pg_config}" --version)" && \
    pg_major="$(printf '%s\n' "${pg_version}" | sed -E 's/^PostgreSQL ([0-9]+).*$/\1/')" && \
    case "${pg_major}" in \
        ''|*[!0-9]*) echo "Unable to determine PostgreSQL major version from ${pg_version}" >&2; exit 1 ;; \
    esac && \
    install_packages ${BUILD_DEPS} && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain "${RUST_TOOLCHAIN}" && \
    workdir=$(mktemp -d) && cd ${workdir} && \
    curl -fsSL https://github.com/paradedb/paradedb/archive/refs/tags/v${PARADEDB_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    pgrx_version="$(cargo metadata --locked --format-version=1 | jq -er '.packages[] | select(.name == "pgrx") | .version' | head -n1)" && \
    cargo install --locked cargo-pgrx --version "${pgrx_version}" && \
    cargo pgrx init "--pg${pg_major}=${pg_config}" && \
    cargo pgrx install --package pg_search --release --pg-config="${pg_config}" && \
    rm -rf ${workdir} && \
    apt-get purge -y --auto-remove ${BUILD_DEPS} && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

FROM scratch

ARG EXPORT=/export

COPY --from=builder /opt/bitnami/postgresql/lib/pg_search.so ${EXPORT}/lib/
COPY --from=builder /opt/bitnami/postgresql/share/extension/pg_search* ${EXPORT}/extension/
