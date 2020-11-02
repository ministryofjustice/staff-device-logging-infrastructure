variable "instance_count" {
  type = number
}

variable "prefix" {
  type = string
}

variable "syslog_endpoint_vpc" {
  type = string
}

variable "subnet" {
  type = string
}

variable "load_balancer_ip" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_cidr_block" {
  type = string
}

variable "heartbeat_script" {
  default = <<EOF
count=0
while true; do
  python -c "import syslog_client; s = syslog_client.Syslog(); s.send({\"count\": \"$count\", \"host\": \"Staff-Device-Syslog-Host\", \"ident\": \"1\", \"message\": \"Hello Syslogs\", \"pri\": \"134\"}, syslog_client.Level.WARNING);"
  sleep 1
  ((count=count+1))
done
EOF
}
