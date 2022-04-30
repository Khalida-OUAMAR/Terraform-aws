variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {
    default = "us-east-1"
}

variable "aws_ec2_ami" {
    default = "ami-0c4f7023847b90238"
}

variable host_ip {
    default = "None"
}