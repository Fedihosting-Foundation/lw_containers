variable "REGISTRY" {
  default = "ghcr.io/lemmyworld"
}

variable "LEMMY_VERSION" {
  default = "0.18.4"
}

target "base" {
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.authors" = "Lemmy World <sysadmin@lemmy.world>"
    "org.opencontainers.image.url" = "https://github.com/lemmyworld/containers"
    "org.opencontainers.image.source" = "https://github.com/lemmyworld/containers"
    "org.opencontainers.image.created" = "${timestamp()}"
  }
}

target "lemmy-base" {
  args = {
    LEMMY_VERSION = "${LEMMY_VERSION}"
  }
  labels = {
    "org.opencontainers.image.version" = "${LEMMY_VERSION}"
  }
}

group "default" {
  targets = ["lemmy", "lemmy-ui"]
}

target "lemmy" {
  context = "lemmy"
  tags = ["${REGISTRY}/lemmy:${LEMMY_VERSION}"]
  inherits = ["base", "lemmy-base"]
}

target "lemmy-ui" {
  context = "lemmy-ui"
  tags = ["${REGISTRY}/lemmy-ui:${LEMMY_VERSION}"]
  inherits = ["base", "lemmy-base"]
}
