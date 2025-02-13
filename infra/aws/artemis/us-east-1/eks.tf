module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.6"

  cluster_name    = "${var.eks_cluster_name}-${var.env}"
  cluster_version = "1.31"

  vpc_id                         = var.create_vpc == true ? module.vpc[0].vpc_id : var.vpc_id
  subnet_ids                     = var.create_vpc == true ? module.vpc[0].private_subnets : var.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }

  eks_managed_node_groups = {
    one = {
      name = "ng-1-${var.eks_cluster_name}-${var.env}"

      instance_types = ["t3.small"]

      block_device_mappings = [{
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 40
          volume_type           = "gp3"
          encrypted             = true
          delete_on_termination = true
        }
      }]

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }

    two = {
      name = "ng-2-${var.eks_cluster_name}-${var.env}"

      instance_types = ["t3.small"]

      block_device_mappings = [{
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 40
          volume_type           = "gp3"
          encrypted             = true
          delete_on_termination = true
        }
      }]

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }

  # create_kms_key = false

  # Cluster access entry
  # To add the current caller identity as an administrator
  # enable_cluster_creator_admin_permissions = true
  authentication_mode = "API"
}

# IRSA for EBS CS
# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}