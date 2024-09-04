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

target "extension" {
  contexts = {
    "postgresql" = "docker-image://bitnami/postgresql:${target.metadata.args.DOCKER_META_VERSION}"
  }
  dockerfile = "postgresql/extension/Dockerfile"
}

target "postgresql" {
  inherits = [ "metadata", "cross" ]
  contexts = {
    "extension"   = "target:extension"
    "postgresql"  = "docker-image://bitnami/postgresql:${target.metadata.args.DOCKER_META_VERSION}"
  }
  dockerfile = "postgresql/runtime/postgresql.Dockerfile"
}

target "postgresql-repmgr" {
  inherits = [ "metadata", "cross" ]
  contexts = {
    "extension"   = "target:extension"
    "postgresql"  = "docker-image://bitnami/postgresql-repmgr:${target.metadata.args.DOCKER_META_VERSION}"
  }
  dockerfile = "postgresql/runtime/postgresql-repmgr.Dockerfile"
  args = {
    DOCKER_META_IMAGES = replace(target.metadata.args.DOCKER_META_IMAGES, "postgresql", "postgresql-repmgr")
  }
  tags = [ for tag in target.metadata.tags : replace(tag, "postgresql", "postgresql-repmgr") ]
}
