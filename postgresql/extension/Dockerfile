FROM postgresql AS pgvector

USER root

ENV BUILD_DEPS="gcc git libc6-dev make" 

RUN install_packages ${BUILD_DEPS} && \
    DIR="/pgvector" && mkdir ${DIR} && cd ${DIR} && \
    git clone https://github.com/pgvector/pgvector.git ${DIR} && \
    git checkout $(git describe --abbrev=0 --tags) && \
    make OPTFLAGS="" && \
    make install && \
    rm -rf ${DIR} && \
    apt-get remove -y ${BUILD_DEPS} && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

FROM scratch

COPY --from=pgvector /opt/bitnami/postgresql/lib/vector.so /export/lib/
COPY --from=pgvector /opt/bitnami/postgresql/share/extension/vector* /export/extension/
