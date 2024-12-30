resource "docker_image" "nginx" {
  name         = "nginx:${local.nginx_version}"
  keep_locally = true
}