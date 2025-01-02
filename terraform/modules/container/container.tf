resource "docker_container" "container" {
  name         = var.name
  image        = docker_image.image.image_id
  command      = var.command == [] ? null : var.command
  network_mode = var.network_mode
  user         = var.user == "" ? null : var.user
  restart      = var.restart
  log_driver   = var.logs.driver
  log_opts     = var.logs.opts
  env          = var.env
  
  dynamic "networks_advanced" {
    for_each = var.networks
    content {
      name = networks_advanced.value
    }
  }

  dynamic "ports" {
    for_each = local.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
      protocol = ports.value.protocol
    }
  }

  dynamic "volumes" {
    for_each = var.configs
    content {
      host_path      = "${var.host_dir}/config/${var.name}/${volumes.key}"
      container_path = volumes.value.path
    }
  }

  dynamic "volumes" {
    for_each = var.dirs
    content {
      host_path      = "${var.host_dir}/data/${var.name}/${volumes.key}/"
      container_path = volumes.value
    }
  }

  depends_on = [
    docker_image.image,
    ssh_resource.configs,
    null_resource.dirs,
  ]
}
