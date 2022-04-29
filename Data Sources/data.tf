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
    name   = "virtualization-type"
    values = ["hvm"]
  }
}