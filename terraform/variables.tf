variable "region_default" {
  type    = string
  default = "us-east-1"
}

variable "credentials_path" {
  type    = string
  default = "$HOME/.aws/credentials"
}

variable "credentials_profile" {
  type    = string
  default = "terraform"
}