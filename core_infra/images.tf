resource "docker_image" "consul" {
  name         = "hashicorp/consul:${local.consul_version}"
  keep_locally = true
}

resource "docker_image" "vault" {
  name         = "hashicorp/vault:${local.vault_version}"
  keep_locally = true
}