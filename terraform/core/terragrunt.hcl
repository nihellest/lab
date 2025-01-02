include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  providers = read_terragrunt_config(find_in_parent_folders("providers.hcl")).locals
}

generate = {
  docker_provider = local.providers.docker
}