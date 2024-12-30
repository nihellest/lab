resource "docker_container" "consul" {
  name         = "consul"
  image        = docker_image.consul.image_id
  network_mode = "bridge"

  networks_advanced {
    name = docker_network.core.name
  }

  networks_advanced {
    name = docker_network.proxy.name
  }

  command = [
    "consul",
    "agent",
    "-config-file=/etc/consul/consul.hcl",
  ]

  ports {
    internal = 8600
    external = 53
    protocol = "udp"
  }

  ports {
    internal = 8300
    external = 8300
    protocol = "tcp"
  }

  volumes {
    host_path = format(
      "%s/config/consul.hcl",
      data.terraform_remote_state.meta.outputs.ssh_config.remote_data_dir
    )
    container_path = "/etc/consul/consul.hcl"
  }

  volumes {
    host_path = format(
      "%s/data/consul/",
      data.terraform_remote_state.meta.outputs.ssh_config.remote_data_dir
    )
    container_path = "/opt/consul/"
  }

  depends_on = [
    ssh_resource.configs
  ]
}

resource "docker_container" "vault" {
  name         = "vault"
  image        = docker_image.vault.image_id
  network_mode = "bridge"

  networks_advanced {
    name = docker_network.core.name
  }

  networks_advanced {
    name = docker_network.proxy.name
  }

  command = [
    "vault",
    "server",
    "-config=/etc/vault/vault.hcl",
  ]

  ports {
    internal = 8200
    external = 8200
    protocol = "tcp"
  }

  volumes {
    host_path = format(
      "%s/config/vault.hcl",
      data.terraform_remote_state.meta.outputs.ssh_config.remote_data_dir
    )
    container_path = "/etc/vault/vault.hcl"
  }

  volumes {
    host_path = format(
      "%s/tls/vault/",
      data.terraform_remote_state.meta.outputs.ssh_config.remote_data_dir
    )
    container_path = "/tls"
  }

  depends_on = [
    ssh_resource.configs,
    docker_container.consul
  ]
}
