resource "null_resource" "dirs" {
  for_each = var.dirs

  connection {
    type        = "ssh"
    host        = var.ssh_config.host
    user        = var.ssh_config.user
    private_key = var.ssh_config.key
  }

  provisioner "remote-exec" {
    inline = [ 
      "mkdir -p ${var.host_dir}/data/${var.name}/${each.key}",
    ]
  }
}

resource "null_resource" "config_dir" {
  connection {
    type        = "ssh"
    host        = var.ssh_config.host
    user        = var.ssh_config.user
    private_key = var.ssh_config.key
  }

  provisioner "remote-exec" {
    inline = [ 
      "mkdir -p ${var.host_dir}/config/${var.name}"
    ]
  }
}

resource "ssh_resource" "configs" {
  for_each = var.configs

  host        = var.ssh_config.host
  user        = var.ssh_config.user
  private_key = var.ssh_config.key

  file {
    content     = each.value.content
    destination = "${var.host_dir}/config/${var.name}/${each.key}"
    permissions = "0770"
  }

  depends_on = [
    null_resource.config_dir
  ]
}
