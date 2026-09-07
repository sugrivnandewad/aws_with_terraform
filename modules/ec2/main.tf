# Looked up only when var.ami_id is not supplied
data "aws_ami" "amazon_linux" {
  count = var.ami_id == null ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami_id        = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux[0].id
  instance_keys = keys(var.instances)
  tags          = var.tags
}

resource "aws_security_group" "this" {
  name_prefix = "${var.name_prefix}-sg-"
  description = "Security group for ${var.name_prefix} EC2 instances"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${var.name_prefix}-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "this" {
  for_each = var.instances

  ami           = local.ami_id
  instance_type = coalesce(each.value.instance_type, var.instance_type)

  # Explicit subnet_id per instance wins; otherwise distribute round-robin
  # across var.subnet_ids so instances spread across AZs automatically.
  subnet_id = coalesce(
    each.value.subnet_id,
    element(var.subnet_ids, index(local.instance_keys, each.key) % length(var.subnet_ids))
  )

  key_name                    = var.key_name
  vpc_security_group_ids      = concat([aws_security_group.this.id], var.additional_security_group_ids)
  associate_public_ip_address = var.associate_public_ip
  iam_instance_profile        = var.iam_instance_profile

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type            = var.root_volume_type
    encrypted              = true
    delete_on_termination  = true
  }

  tags = merge(local.tags, each.value.tags, {
    Name = "${var.name_prefix}-${each.key}"
  })
}