output "ssh_config" {
  value = {
    remote_host     = "lab.local"
    remote_user     = "dk"
    remote_data_dir = "/mnt/storage"
    ssh_private_key = file("/home/dk/.ssh/id_rsa")
  }
  sensitive = true
}