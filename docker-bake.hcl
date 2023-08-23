variable "REGISTRY" {
  default = "gcr.io/lemmyworld"
}

variable "LEMMY_VERSION" {
  default = "0.18.4"
}

target "base" {
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/lemmyworld/containers"
  }
}

target "lemmy-base" {
  args = {
    LEMMY_VERSION = "${LEMMY_VERSION}"
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
