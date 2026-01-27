module "openvpn_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
   name = "${local.ec2_name}-openvpn"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.openvpn_sg_id.value]
  subnet_id              = data.aws_subnet.selected.id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-openvpn"
    }
  )
}

output "public_ip" {
    value = module.openvpn_instance.public_ip
  
}