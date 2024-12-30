resource "docker_container" "nginx" {
  name         = "nginx"
  image        = docker_image.nginx.image_id
  network_mode = "bridge"

  networks_advanced {
    name = "proxy-net"
  }

  ports {
    internal = 80
    external = 80
    protocol = "tcp"
  }

  ports {
    internal = 443
    external = 443
    protocol = "tcp"
  }

  volumes {
    host_path = format(
      "%s/web/",
      data.terraform_remote_state.meta.outputs.ssh_config.remote_data_dir
    )
    container_path = "/etc/nginx/conf.d/"
  }

  volumes {
    host_path = format(
      "%s/ssl/",
      data.terraform_remote_state.meta.outputs.ssh_config.remote_data_dir
    )
    container_path = "/ssl/"
  }

  depends_on = [
    module.service
  ]
}
