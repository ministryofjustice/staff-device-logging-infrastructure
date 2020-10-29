data "template_file" "syslog_client" {
  template = "${file("${path.module}/syslog_client.py")}"

  vars = {
    load_balancer_ip = var.load_balancer_ip
  }
}

data "aws_ami" "amazon_linux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20200617.0-x86_64-gp2"]
  }

  owners = ["137112412989"]
}

resource "aws_instance" "syslog_client" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = "t2.small"
  vpc_security_group_ids = list(aws_security_group.syslog_client.id)
  subnet_id              = var.subnet
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.syslog_client.name

  tags = {
    Name = "${var.prefix}-syslog-test-client"
  }

  user_data = <<EOF
#!/bin/bash -xe

yum -y update
yum install python3 awslogs -y

systemctl start awslogsd

mkdir ~/syslog_client
echo '${data.template_file.syslog_client.rendered}' >> ~/syslog_client/syslog_client.py
cd ~/syslog_client

count=0
while true; do
  python -c "import syslog_client; s = syslog_client.Syslog(); s.send({\"count\": \"$count\", \"host\": \"Staff-Device-Syslog-Host\", \"ident\": \"1\", \"message\": \"Hello Syslogs\", \"pri\": \"134\"}, syslog_client.Level.WARNING);"
  sleep 1
  ((count=count+1))
done
EOF
}

resource "aws_security_group" "syslog_client" {
  name = "${var.prefix}-syslog-client-instance-security-group"

  egress {
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.syslog_endpoint_vpc
}
