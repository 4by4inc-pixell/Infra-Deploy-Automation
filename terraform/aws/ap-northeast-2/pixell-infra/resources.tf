resource "aws_efs_file_system" "infra" {
  creation_token   = "infra-efs"
  performance_mode = "generalPurpose"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS" # 30일 후 비활성 데이터를 IA로 전환
  }
  tags = {
    Name = "infra-efs"
  }
}

resource "aws_security_group" "efs_sg" {
  name_prefix = "efs-sg-"
  description = "EFS Security Group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-security-group"
  }
}

resource "aws_efs_mount_target" "infra" {
  count           = length(module.vpc.private_subnets)
  file_system_id  = aws_efs_file_system.infra.id
  subnet_id       = element(module.vpc.private_subnets, count.index)
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_iam_role" "aws_load_balancer_controller_role" {
  name               = "aws-load-balancer-controller-role"
  assume_role_policy = data.aws_iam_policy_document.lb_controller_assume_role_policy.json
}

resource "kubernetes_service_account" "aws_load_balancer_controller_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_load_balancer_controller_role.arn
    }
  }

  depends_on = [
    module.eks,                         # EKS 클러스터가 생성된 후
    aws_iam_role.aws_load_balancer_controller_role # IAM Role이 준비된 후
  ]
}

resource "aws_iam_role_policy_attachment" "aws_lb_controller_policy_attach" {
  policy_arn = aws_iam_policy.aws_lb_controller_policy.arn
  role       = aws_iam_role.aws_load_balancer_controller_role.name
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.7.1" # Replace with the desired version
  values = [
    <<EOF
clusterName: ${var.cluster_name}
serviceAccount:
  create: false
  name: aws-load-balancer-controller
EOF
  ]
  depends_on = [kubernetes_service_account.aws_load_balancer_controller_sa]
}


resource "kubectl_manifest" "secrets" {
  for_each = fileset("${path.module}/kubectl-secrets", "**/*.yaml")
  yaml_body = templatefile("${path.module}/kubectl-secrets/${each.value}", {
  })
  depends_on = [
    module.karpenter
  ]
  
}