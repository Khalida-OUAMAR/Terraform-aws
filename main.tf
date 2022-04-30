
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.13.0"
}

provider "aws" {
  profile = "default"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}

data "http" "machine_ip" {
  url = "https://ifconfig.me"
}

module "ec2_instance" {
  source = "./ec2/instance"
  aws_ec2_ami = var.aws_ec2_ami   
  key_name = "khalida_key"

  ip = var.host_ip != "None" ? var.host_ip : format("%s/%s",data.http.machine_ip.body, 32)
}

module "s3" {
  source = "./s3"
  bucket_name = "doctolibkobucketkhalida"  
  ip = var.host_ip != "None" ? var.host_ip : format("%s",data.http.machine_ip.body)
}

module "ec2_docker_installation" {
  source = "./ec2/docker/docker_install"
  ec2_instance = module.ec2_instance.aws_instance
  pem = module.ec2_instance.pem
}

module "ec2_docker_pull_image" {
  source = "./ec2/docker/docker_image"
  ec2_instance = module.ec2_instance.aws_instance
  pem = module.ec2_instance.pem
}





