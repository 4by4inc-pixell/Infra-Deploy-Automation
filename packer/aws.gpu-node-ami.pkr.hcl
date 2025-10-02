packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "eks-gpu-node-ami"
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "eks-gpu" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "g5.2xlarge"
  region        = "${var.aws_region}"
  source_ami_filter {
    filters = {
      name                = "amazon-eks-gpu-node-1.31-v2025*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  launch_block_device_mappings {
    device_name           = "/dev/xvda"
    volume_size           = 50
    volume_type           = "gp3"
    delete_on_termination = true
  }
  ssh_username = "ec2-user"
}

build {
  name    = "eks-gpu-node-packer"
  sources = [
    "source.amazon-ebs.eks-gpu"
  ]

  provisioner "shell" {
    environment_vars = [
    ]
    inline = [  
      "sudo crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock",
      "sudo systemctl restart containerd",
	    "sudo crictl pull ghcr.io/4by4inc-pixell/pms-ray-cluster:1.4.2-trt",
	    "sudo crictl pull nvcr.io/nvidia/k8s-device-plugin:v0.17.0",
    ]
  }
}