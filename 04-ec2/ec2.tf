module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
   name = "${local.ec2_name}-mongodb"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.security_group_id.value]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-mongodb"
    }
  )
}