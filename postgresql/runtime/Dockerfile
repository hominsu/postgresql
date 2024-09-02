ARG VERSION REPO

FROM ${REPO}/postgresql:${VERSION}-extension AS extension

FROM bitnami/postgresql:${VERSION}

COPY --from=extension /export/lib/* /opt/bitnami/postgresql/lib/
COPY --from=extension /export/extension/* /opt/bitnami/postgresql/share/extension/
