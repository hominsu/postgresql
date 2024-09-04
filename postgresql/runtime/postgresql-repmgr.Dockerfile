FROM extension AS extension

FROM postgresql

COPY --from=extension /export/lib/* /opt/bitnami/postgresql/lib/
COPY --from=extension /export/extension/* /opt/bitnami/postgresql/share/extension/
