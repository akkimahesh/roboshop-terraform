module "openvpn_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.ec2_name}-openvpn"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.openvpn_sg_id.value]
  subnet_id              = data.aws_subnet.selected.id
  user_data              = file("openvpn.sh")

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-openvpn"
    }
  )
}

resource "null_resource" "openvpn_provisioners" {

  depends_on = [module.openvpn_instance]

  provisioner "local-exec" {
    command = "echo The server's IP address is ${module.openvpn_instance.public_ip}"
  }

  connection {
    type        = "ssh"
    user        = "centos"
    host        = module.openvpn_instance.public_ip
    password = "DevOps321"
  }

  provisioner "remote-exec" {
    inline = [
      "echo Hello, World! > /home/centos/hello.txt",
      "curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh",
      "chmod +x openvpn-install.sh",
      "sudo ./openvpn-install.sh install"

    ]
  }
}
