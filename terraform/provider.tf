provider "aws" {
  region                   = var.region_default
  shared_credentials_files = [var.credentials_path]
}