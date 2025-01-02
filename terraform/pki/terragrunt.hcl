include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  providers = read_terragrunt_config(find_in_parent_folders("providers.hcl")).locals
}

generate = {
  vault_provider = local.providers.vault
}

dependency "core" {
  config_path = "../core"
}

inputs = {
  vault_root_token   = dependency.core.outputs.vault.root_token
  vault_unseal_token = dependency.core.outputs.vault.unseal_token
}