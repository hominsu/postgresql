FROM pgvector AS pgvector
FROM pg_search AS pg_search

FROM postgresql

ENV POSTGRESQL_SHARED_PRELOAD_LIBRARIES="pgaudit,pg_stat_statements,pg_search"

COPY --from=pgvector /export/lib/* /opt/bitnami/postgresql/lib/
COPY --from=pgvector /export/extension/* /opt/bitnami/postgresql/share/extension/
COPY --from=pg_search /export/lib/* /opt/bitnami/postgresql/lib/
COPY --from=pg_search /export/extension/* /opt/bitnami/postgresql/share/extension/
