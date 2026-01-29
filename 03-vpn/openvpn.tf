module "openvpn_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
   name = "${local.ec2_name}-openvpn"
  ami                    = data.aws_ami.rhel.id
  instance_type          = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [data.aws_ssm_parameter.openvpn_sg_id.value]
  subnet_id              = data.aws_subnet.selected.id
  user_data = file("openvpn.sh")

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

module "vpn" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name                   = "${local.ec2_name}-vpn"
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = data.aws_subnet.selected.id
  user_data = file("openvpn.sh")
  tags = merge(
    var.common_tags,
    {
      Component = "vpn"
    },
    {
      Name = "${local.ec2_name}-vpn"
    }
  )
}