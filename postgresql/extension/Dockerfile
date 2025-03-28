FROM postgresql AS pgvector

USER root

ENV PGVECTOR_VERSION=0.8.0  \
    BUILD_DEPS="curl gcc libc6-dev make"

RUN install_packages ${BUILD_DEPS} && \
    DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/pgvector/pgvector/archive/refs/tags/v${PGVECTOR_VERSION}.tar.gz | \
    tar -zx --strip-components=1 && \
    make OPTFLAGS="" -j $(nproc) && \
    make install && \
    rm -rf ${DIR} && \
    apt-get remove -y ${BUILD_DEPS} && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

FROM scratch

ARG EXPORT=/export

COPY --from=pgvector /opt/bitnami/postgresql/lib/vector.so ${EXPORT}/lib/
COPY --from=pgvector /opt/bitnami/postgresql/share/extension/vector* ${EXPORT}/extension/
