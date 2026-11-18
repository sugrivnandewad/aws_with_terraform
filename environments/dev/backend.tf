terraform {
	backend "s3" {
		bucket       = "aws-with-terraform-state-466417121067-eu-north-1-an"
		key          = "dev/terraform.tfstate"
		region       = "ap-south-1"
		encrypt      = true
		use_lockfile = true
	}
}
