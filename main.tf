# EC2 instance
module "ec2_instance" {
  source ="git::https://github.com/tejasacharekar1/ec2_modules.git//modules/ec2"
  region = var.region
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.subnet_id
  Name = var.Name
  Owner  = var.Owner
  Purpose = var.Purpose 
}
