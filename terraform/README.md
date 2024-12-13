# tf.aws.us-west-2.pms-dev

k8s로 Ray Cluster와 관련 서비스를 구성하는데 필요한 인프라를 Terraform으로 정의합니다.

## Usage

To provision the provided configurations you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

## Regist

```bash
aws eks update-kubeconfig --region <REGION> --name <CLUSTER_NAME>
```