terraform {
  backend "s3" {
    bucket       = "aws-cicd-devops-lab-terraform-state-303974373642"
    key          = "aws-cicd-devops-lab/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}