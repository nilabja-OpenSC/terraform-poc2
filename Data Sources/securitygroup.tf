#resource "aws_security_group" "sg-custom_us_east" {
#    name = "custom_us_east"

#    ingress {
#        from_port = "443"
#        to_port = "443"
#        protocol = "tcp"
#        cidr_blocks = slice(data.aws_ip_ranges.us_east_ip_range.cidr_blocks, 0, 50)
#    }

#    tags = {
#        CreateDate = data.aws_ip_ranges.us_east_ip_range.create_date
#        SyncToken = data.aws_ip_ranges.us_east_ip_range.sync_token
#    }
#}


resource "aws_security_group" "webservers_sg"{
  tags = {
    Name = "${var.ENVIRONMENT}-webservers-sg"
  }
  
  name          = "${var.ENVIRONMENT}-webservers-sg"
  description   = "Created by Levelup"
  vpc_id        = aws_vpc.test_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.SSH_CIDR_WEB_SERVER}"]

  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "webservers_alb-sg" {
  tags = {
    Name = "${var.ENVIRONMENT}-webservers-ALB-sg"
  }
  name = "${var.ENVIRONMENT}-webservers-ALB-sg"
  description = "Created by levelup"
  vpc_id      = aws_vpc.test_vpc.id 

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}