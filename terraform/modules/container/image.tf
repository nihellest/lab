resource "docker_image" "image" {
  name         = var.image
  keep_locally = true
}
