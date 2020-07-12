
resource "aws_instance" "jump_server" {
  ami           = "ami-052652af12b58691f" # Amazon Linux 2
  instance_type = "t2.micro"
  # key_name      = var.key_name
  # # associate_public_ip_address = "true"

  subnet_id              = aws_subnet.private_a.id
  vpc_security_group_ids = [aws_security_group.jump.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data            = data.template_file.user_data.rendered

  tags = {
    Name = "${var.name}-jump_server"
  }
}

data "template_file" "user_data" {
  template = "${file("userdata.sh")}"
}

output "jump_server-id" {
  value = aws_instance.jump_server.id
}
