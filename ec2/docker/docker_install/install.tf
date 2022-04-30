resource "null_resource" "ssh_target" {

  connection {
    type        = "ssh"
    private_key = var.pem
    user        = var.ssh_user_name
    host        = var.ec2_instance.public_ip
    port        = 22
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker",
      "sudo apt-get install -y docker-compose",
      "sudo docker --version",
      "sudo docker-compose --version"
    ]
  }

}
