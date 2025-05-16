data "aws_iam_openid_connect_provider" "oidc" {
  url = var.cluster_oidc_issuer_url
}

resource "aws_iam_policy" "alb_controller_policy" {
  name   = "${var.cluster_name}-alb-controller-policy"
  tags = {
    "generator" = "terraform"
    "cluster-target" = var.cluster_name
    "author" = "HyoengSeok Kim"
  }
  policy = file("${path.module}/alb_policy.json")
}

resource "aws_iam_role" "alb_controller_role" {
  name   = "${var.cluster_name}-alb-controller-role"
  tags = {
    "generator" = "terraform"
    "cluster-target" = var.cluster_name
    "author" = "HyoengSeok Kim"
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.oidc.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${data.aws_iam_openid_connect_provider.oidc.url}:sub" = "system:serviceaccount:${var.namespace}:${var.k8s_service_account_name}"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "alb_policy_attach" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}