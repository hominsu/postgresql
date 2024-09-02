variable "REPO" {
  default = "hominsu"
}

variable "VERSION" {
  default = "16"
}

group "default" {
  targets = [
    "extension",
    "postgresql",
  ]
}

target "extension" {
  dockerfile = "postgresql/extension/Dockerfile"
  args       = {
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
  }
  tags = [
    "${REPO}/postgresql:${VERSION}-extension",
  ]
  platforms = [
    "linux/arm64", "linux/amd64", "linux/arm"
  ]
}

target "postgresql" {
  contexts = {
    "${REPO}/postgresql:${VERSION}-extension" = "target:extension"
  }
  dockerfile = "postgresql/runtime/Dockerfile"
  args       = {
    REPO           = "${REPO}"
    VERSION        = "${VERSION}"
  }
  tags = [
    "${REPO}/postgresql:${VERSION}",
  ]
  platforms = [
    "linux/arm64", "linux/amd64", "linux/arm"
  ]
}
