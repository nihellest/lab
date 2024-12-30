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
