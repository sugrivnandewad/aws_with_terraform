terraform {
	backend "s3" {
		bucket       = "aws-with-terraform-state"
		key          = "prod/terraform.tfstate"
		region       = "ap-south-1"
		encrypt      = true
		use_lockfile = true
	}
}
