resource "aws_instance" "temp_ec2" {
  ami                    = "ami-0c94855ba95c71c99"
  instance_type          = "t2.micro"

  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "temp-ad-hoc-test-instance"
  }
}
