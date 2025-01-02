include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  providers = read_terragrunt_config(find_in_parent_folders("providers.hcl")).locals
}

generate = {
  vault_provider    = local.providers.vault
  docker_provider   = local.providers.docker
  postgres_provider = local.providers.postgres
}

dependency "core" {
  config_path = "../core"
}

dependency "pki" {
  config_path = "../pki"
}

inputs = {
  vault_root_token   = dependency.core.outputs.vault.root_token
  vault_unseal_token = dependency.core.outputs.vault.unseal_token


  cert_params = {
    issuer_ref = dependency.pki.outputs.params.issuer_ref
    backend    = dependency.pki.outputs.params.backend
    name       = dependency.pki.outputs.params.name
  }
}