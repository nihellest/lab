resource "ssh_resource" "configs" {
  for_each = local.configs

  triggers = {
    config_changed = filebase64("${local.config_dir}/${each.key}")
  }
  host        = data.terraform_remote_state.meta.outputs.ssh_config.remote_host
  user        = data.terraform_remote_state.meta.outputs.ssh_config.remote_user
  private_key = data.terraform_remote_state.meta.outputs.ssh_config.ssh_private_key

  file {
    source = "${local.config_dir}/${each.key}"
    destination = format(
      "%s/config/%s",
      data.terraform_remote_state.meta.outputs.ssh_config.remote_data_dir,
      each.key
    )
    permissions = "0770"
  }
}

resource "ssh_resource" "vault-tls" {
  host        = data.terraform_remote_state.meta.outputs.ssh_config.remote_host
  user        = data.terraform_remote_state.meta.outputs.ssh_config.remote_user
  private_key = data.terraform_remote_state.meta.outputs.ssh_config.ssh_private_key

  file {
    content = tls_private_key.vault.private_key_pem
    destination = format(
      "%s/tls/vault/private-key.pem",
      data.terraform_remote_state.meta.outputs.ssh_config.remote_data_dir
    )
  }

  file {
    content = tls_self_signed_cert.vault.cert_pem
    destination = format(
      "%s/tls/vault/cert.pem",
      data.terraform_remote_state.meta.outputs.ssh_config.remote_data_dir
    )
  }
}
