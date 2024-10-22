module "instances" {
  source       = "./ec2"
  ec2_tag_name = "ec2-scheduled"
}