FROM pgvector AS pgvector
FROM pg_search AS pg_search

FROM postgresql

COPY --from=pgvector /export/lib/* /opt/bitnami/postgresql/lib/
COPY --from=pgvector /export/extension/* /opt/bitnami/postgresql/share/extension/
COPY --from=pg_search /export/lib/* /opt/bitnami/postgresql/lib/
COPY --from=pg_search /export/extension/* /opt/bitnami/postgresql/share/extension/
