module "mongodb" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.ec2_name}-mongodb"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-mongodb"
    }
  )
}

module "redis" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.ec2_name}-redis"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-redis"
    }
  )
}

module "mysql" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.ec2_name}-mysql"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-mysql"
    }
  )
}

module "rabbitmq" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.ec2_name}-rabbitmq"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-rabbitmq"
    }
  )
}

module "catalogue" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.ec2_name}-catalogue"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-catalogue"
    }
  )
}

module "cart" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.ec2_name}-cart"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.cart_sg_id.value]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-cart"
    }
  )
}

module "user" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.ec2_name}-user"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.user_sg_id.value]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-user"
    }
  )
}

module "shipping" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.ec2_name}-shipping"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.shipping_sg_id.value]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-shipping"
    }
  )
}

module "payments" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.ec2_name}-payments"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.payments_sg_id.value]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-payments"
    }
  )
}

module "ratings" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.ec2_name}-ratings"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.ratings_sg_id.value]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-ratings"
    }
  )
}

module "web" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.ec2_name}-web"
  ami                    = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.ratings_sg_id.value]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    var.ec2_tags,
    {
      Name = "${local.ec2_name}-web"
    }
  )
}

module "records" {
  source  = "terraform-aws-modules/route53/aws"
  version = "~> 6.4"

  create_zone = false

  records = {
    mongodb = {
      zone_id = var.zone_id
      name    = "mongodb"
      type    = "A"
      ttl     = 1
      records = [
        module.mongodb.private_ip
      ]
    },
    mysql = {
      zone_id = var.zone_id
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [
        module.mysql.private_ip
      ]
    },
    redis = {
      zone_id = var.zone_id
      name    = "redis"
      type    = "A"
      ttl     = 1
      records = [
        module.redis.private_ip
      ]
    },
    rabbitmq = {
      zone_id = var.zone_id
      name    = "rabbitmq"
      type    = "A"
      ttl     = 1
      records = [
        module.rabbitmq.private_ip
      ]
    },
    catalogue = {
      zone_id = var.zone_id
      name    = "catalogue"
      type    = "A"
      ttl     = 1
      records = [
        module.catalogue.private_ip
      ]
    },
    cart = {
      zone_id = var.zone_id
      name    = "cart"
      type    = "A"
      ttl     = 1
      records = [
        module.cart.private_ip
      ]
    },
    user = {
      zone_id = var.zone_id
      name    = "user"
      type    = "A"
      ttl     = 1
      records = [
        module.user.private_ip
      ]
    },
    shipping = {
      zone_id = var.zone_id
      name    = "shipping"
      type    = "A"
      ttl     = 1
      records = [
        module.shipping.private_ip
      ]
    },
    payments = {
      zone_id = var.zone_id
      name    = "payments"
      type    = "A"
      ttl     = 1
      records = [
        module.payments.private_ip
      ]
    },
    ratings = {
      zone_id = var.zone_id
      name    = "ratings"
      type    = "A"
      ttl     = 1
      records = [
        module.ratings.private_ip
      ]
    },
    root = {
      zone_id = var.zone_id
      name = null
      type    = "A"
      ttl     = 1
      records = [
        module.web.public_ip
      ]
    }
  }
}






# resource "aws_route53_record" "mysql" {
#   zone_id = var.zone_id
#   name    = "mysql.maheshakki.shop"
#   type    = "A"
#   ttl     = 1
#   records = [module.web.public_ip]
# }

# output "private_ip" {
#     value = module.ec2_instance.private_ip

# }