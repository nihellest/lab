resource "null_resource" "vault_init" {  
  provisioner "local-exec" {
    command = <<EOF
      sleep 30;
      curl -X POST --data '{"secret_shares":1,"secret_threshold":1}' \
      http://${var.ssh_config.host}:8200/v1/sys/init > ../sensitive/vault.json
    EOF
  }

  provisioner "local-exec" {
    when = destroy
    command = "rm -rf ../sensitive/vault.json"
  }
  depends_on = [ module.vault ]
}

resource "terraform_data" "vault_unseal" {
  provisioner "local-exec" {
    command = <<EOF
      curl -X POST --data '{"key": "${terraform_data.vault.output.unseal_token}"}' \
      http://${var.ssh_config.host}:8200/v1/sys/unseal
    EOF
  } 
  depends_on = [ 
    null_resource.vault_init,
    terraform_data.vault,
  ]
}

resource "terraform_data" "vault" {
  input = {
    root_token   = jsondecode(file("../sensitive/vault.json")).root_token
    unseal_token = jsondecode(file("../sensitive/vault.json")).keys[0]
  }

  depends_on = [ null_resource.vault_init ]
}

output "vault" {
  value = terraform_data.vault.output
}
