resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#resource "aws_instance" "MyFirstInstnace" {
#  ami           = data.aws_ami.latest-amazon-linux.id
#  instance_type = "t2.micro"
#  availability_zone = data.aws_availability_zones.avilable.names[1]
#  vpc_security_group_ids = [aws_security_group.webservers_sg.id]
#  key_name      = aws_key_pair.levelup_key.key_name
#  user_data = file("install_nginx.sh")

#  provisioner "local-exec" {
#    command = "echo ${aws_instance.MyFirstInstnace.private_ip} >> my_private_ips.txt"
#  }

#  tags = {
#    Name = "custom_instance"
#  }
#}


resource "aws_launch_template" "launch_template_webserver" {
  name   = "launch_template_webserver"
  image_id      = data.aws_ami.latest-amazon-linux.id
# image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = var.INSTANCE_TYPE
  user_data = base64encode("install_nginx.sh")
  vpc_security_group_ids = [aws_security_group.webservers_sg.id]
  key_name = aws_key_pair.levelup_key.key_name
  
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_type = "gp2"
      volume_size = 20
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "webserver"
    }
  }

}

resource "aws_autoscaling_group" "project_webserver" {
  name                      = "project_WebServers"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 30
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true
  launch_template {
    id      = aws_launch_template.launch_template_webserver.id
    version = "$Latest"
  }
# vpc_zone_identifier       = ["${var.vpc_public_subnet1}", "${var.vpc_public_subnet2}"]
  target_group_arns         = [aws_lb_target_group.load-balancer-target-group.arn]
}

#output "public_ip" {
#  value = aws_instance.MyFirstInstnace.public_ip 
#}