target "metadata" {}

group "default" {
  targets = [
    "postgresql",
    "postgresql-repmgr"
  ]
}

target "cross" {
  platforms = [
    "linux/arm64",
    "linux/amd64"
  ]
}

group "extension" {
  targets = ["pgvector", "pg_search"]
}

target "pgvector" {
  inherits = [ "cross" ]
  contexts = {
    "postgresql" = "docker-image://bitnamilegacy/postgresql:${target.metadata.args.DOCKER_META_VERSION}"
  }
  dockerfile = "postgresql/extension/pgvector.Dockerfile"
}

target "pg_search" {
  inherits = [ "cross" ]
  contexts = {
    "postgresql" = "docker-image://bitnamilegacy/postgresql:${target.metadata.args.DOCKER_META_VERSION}"
  }
  dockerfile = "postgresql/extension/pg_search.Dockerfile"
}

target "postgresql" {
  inherits = [ "metadata", "cross" ]
  contexts = {
    "pgvector"    = "target:pgvector"
    "pg_search"    = "target:pg_search"
    "postgresql"  = "docker-image://bitnamilegacy/postgresql:${target.metadata.args.DOCKER_META_VERSION}"
  }
  dockerfile = "postgresql/runtime/postgresql.Dockerfile"
}

target "postgresql-repmgr" {
  inherits = [ "metadata", "cross" ]
  contexts = {
    "pgvector"    = "target:pgvector"
    "pg_search"    = "target:pg_search"
    "postgresql"  = "docker-image://bitnamilegacy/postgresql-repmgr:${target.metadata.args.DOCKER_META_VERSION}"
  }
  dockerfile = "postgresql/runtime/postgresql-repmgr.Dockerfile"
  args = {
    DOCKER_META_IMAGES = replace(target.metadata.args.DOCKER_META_IMAGES, "postgresql", "postgresql-repmgr")
  }
  tags = [ for tag in target.metadata.tags : replace(tag, "postgresql", "postgresql-repmgr") ]
}
