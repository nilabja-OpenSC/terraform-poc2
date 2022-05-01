data "aws_ip_ranges" "us_east_ip_range" {
    regions = ["us-east-1","us-east-2"]
    services = ["ec2"]
}

data "aws_ip_ranges" "us_west_ip_range" {
    regions = ["us-west-1","us-west-2"]
    services = ["ec2"]
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "latest-amazon-linux" {
  most_recent = true
  owners = ["137112412989"]
#  platform = "Amazon Linux"

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
      name = "name"
      values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220419.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "user_data_nginx" {
  template = <<EOF
#!/bin/bash -xe
yum -y install net-tools nginx
sudo systemctl start nginx
MYIP=`ifconfig | grep -E '(inet).*(broadcast)' | awk '{ print $2 }' | cut -d ':' -f2`
echo 'Hello Team\nThis is my IP: '$MYIP > /usr/share/nginx/html/index.html
EOF
}