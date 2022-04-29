resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = data.aws_ami.latest-amazon-linux.id
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.avilable.names[1]
  vpc_security_group_ids = [aws_security_group.webservers_sg.id]
  key_name      = aws_key_pair.levelup_key.key_name
  user_data = file("install_nginx.sh")

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