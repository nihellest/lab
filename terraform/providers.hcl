locals {
  default_provider = {
    comment_prefix    = "# "
    disable           = false
    disable_signature = false
    if_disabled       = "skip"
    if_exists         = "overwrite_terragrunt"
  }
  docker_config = {
    path     = "docker_provider.tf"
    contents = file("providers/docker.tf")
  }
  vault_config = {
    path     = "vault_provider.tf"
    contents = file("providers/vault.tf")
  }
  postgres_config = {
    path     = "postgres_provider.tf"
    contents = file("providers/postgres.tf")
  }
  docker   = merge(local.default_provider, local.docker_config)
  vault    = merge(local.default_provider, local.vault_config)
  postgres = merge(local.default_provider, local.postgres_config)
}