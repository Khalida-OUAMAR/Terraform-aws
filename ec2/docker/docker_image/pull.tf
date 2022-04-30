resource "null_resource" "pull_image" {

  connection {
    type        = "ssh"
    private_key = var.pem
    user = var.ssh_user_name
    host = var.ec2_instance.public_ip
    port        = 22
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker pull mockserver/mockserver",
      "sudo docker run -d --rm -P mockserver/mockserver",
      "sudo docker ps",
      "sudo systemctl enable docker",
      "sudo systemctl start docker"
    ]
  }

}