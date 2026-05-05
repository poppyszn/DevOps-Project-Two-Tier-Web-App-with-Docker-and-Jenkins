module "ec2_complete" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name = var.instance_name

  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  create_eip             = var.create_eip

  hibernation = true

  user_data_base64            = var.user_data
  user_data_replace_on_change = false

  enable_volume_tags = false
  root_block_device = {
    encrypted  = true
    type       = "gp3"
    throughput = 200
    size       = var.root_volume_size
    tags = {
      Name = "${var.instance_name}-root-block"
    }
  }

  force_destroy = var.force_destroy
}