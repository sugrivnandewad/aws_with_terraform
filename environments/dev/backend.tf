backend "s3" {
  bucket       = "aws-with-terraform-state-466417121067-eu-north-1-an"
  key          = "eks-project/vpc/terraform.tfstate"
  region       = "eu-north-1"
  encrypt      = true
  use_lockfile = true
}
