ARG VERSION

FROM pgvector/pgvector:pg${VERSION} AS pgvector

FROM scratch

COPY --from=pgvector /usr/lib/postgresql/16/lib/vector.so /export/lib/
COPY --from=pgvector /usr/share/postgresql/16/extension/vector* /export/extension/
