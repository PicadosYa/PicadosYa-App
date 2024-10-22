module "instances" {
  source       = "./ec2"
  ec2_tag_name = "picados-ya"
}