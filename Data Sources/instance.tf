resource "aws_instance" "MyFirstInstnace" {
  ami           = data.aws_ami.latest-amazon-linux.id
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.avilable.names[1]
  security_groups = [aws_security_group.webservers_sg.id]
  provisioner "local-exec" {
    command = "echo ${aws_instance.MyFirstInstnace.private_ip} >> my_private_ips.txt"
  }

  tags = {
    Name = "custom_instance"
  }
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip 
}