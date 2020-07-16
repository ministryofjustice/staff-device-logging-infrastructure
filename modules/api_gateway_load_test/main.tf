locals {
  enabled = var.enable_load_testing ? 1 : 0
}

data "template_file" "foo" {
  template = "${file("${path.module}/api_load_test.yml")}"

  vars = {
    api_url = var.api_url
    api_key = var.api_key
    arrival_rate = var.arrival_rate
    duration = var.duration
  }
}

resource "aws_default_vpc" "default" {
  count                  = local.enabled

  tags = {
    Name = "Default VPC"
  }
}

resource "aws_instance" "web" {
  count                  = local.enabled * var.instance_count
  ami                    = "ami-04122be15033aa7ec"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example[0].id]

  tags = {
    Name = "${var.prefix}-load-testing-instance"
  }

  user_data = <<EOF
#!/bin/bash

curl --silent --location https://rpm.nodesource.com/setup_12.x | bash -
yum -y install nodejs
npm install -g artillery --allow-root --unsafe-perm=true
touch /etc/api_load_test.yml 
echo '${data.template_file.foo.rendered}' >> /etc/api_load_test.yml
artillery run /etc/api_load_test.yml
EOF
}

resource "aws_security_group" "example" {
  name = "${var.prefix}-load-test-security-group"

  count                  = local.enabled

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    # To keep this example simple, we allow incoming SSH requests from any IP. In real-world usage, you should only
    # allow SSH requests from trusted servers, such as a bastion host or VPN server.
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_default_vpc.default[0].id}"
}
