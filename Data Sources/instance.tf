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
  disable_api_termination = true
  image_id      = data.aws_ami.latest-amazon-linux.id
# image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = var.INSTANCE_TYPE
  instance_initiated_shutdown_behavior = "terminate"
  #user_data = base64encode("install_nginx.sh")
  user_data = "${base64encode(data.template_file.user_data_nginx.rendered)}"
  vpc_security_group_ids = [aws_security_group.webservers_sg.id]
  key_name = aws_key_pair.levelup_key.key_name
  
  iam_instance_profile {
    name = "profile-1"
  }

  placement {
    availability_zone = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}"]
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
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
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_template {
    id      = aws_launch_template.launch_template_webserver.id
    version = "$Latest"
  }
  vpc_zone_identifier       = ["${aws_subnet.test_vpc_public_subnet_1.id}", "${aws_subnet.test_vpc_public_subnet_2.id}"]
  target_group_arns         = [aws_lb_target_group.load-balancer-target-group.arn]
}

#output "public_ip" {
#  value = aws_instance.MyFirstInstnace.public_ip 
#}