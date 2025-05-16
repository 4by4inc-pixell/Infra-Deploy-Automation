resource "aws_security_group" "ray_cluster_sg" {
  name        = "${var.cluster_name}-${var.namespace}-${var.ray_cluster_name}-sg"
  description = "Example security group"
  vpc_id      = var.vpc_id  # VPC ID는 외부에서 변수로 받을 수 있습니다

  ingress {
    description      = "Allow Dashboard"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["221.148.0.129/32", "121.166.82.33/32"] 
  }

  ingress {
    description      = "Allow Metric"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["221.148.0.129/32", "121.166.82.33/32"] 
  }
  
  ingress {
    description      = "Allow RayClient"
    from_port        = 10001
    to_port          = 10001
    protocol         = "tcp"
    cidr_blocks      = ["221.148.0.129/32", "121.166.82.33/32"] 
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name        = "${var.cluster_name}-${var.namespace}-${var.ray_cluster_name}-sg"
    generator = "terraform"
    cluster-target = var.cluster_name
    author = "HyoengSeok Kim"
  }
}