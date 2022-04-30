resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.pk.public_key_openssh
}


variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22]
}

resource "aws_security_group" "doctolib_group" {
  name        = "DataOps_Technical_Test"
  description = "Allow ssh and standard http/https ports inbound and everything outbound"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = [var.ip]
    }
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "doctolib_server_technical_test" {
  ami                    = var.aws_ec2_ami
  instance_type          = var.aws_instance_type
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.doctolib_group.id]

  lifecycle {
    ignore_changes = [key_name]
  }

  tags = {
    Name = var.aws_instance_tag
  }
  depends_on = [
    aws_security_group.doctolib_group,
  ]
}

output "aws_instance" {
  value = aws_instance.doctolib_server_technical_test
}

output "public_ip" {
  value = aws_instance.doctolib_server_technical_test.public_ip
}

output "pem" {
  value = tls_private_key.pk.private_key_pem
}
