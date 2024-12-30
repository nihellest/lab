locals {
  # Configs
  config_dir = "./config"
  configs    = fileset(local.config_dir, "*.*")

  # Image tags
  consul_version = "1.20.1"
  vault_version  = "1.18.3"
}
