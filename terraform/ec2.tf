resource "aws_instance" "app" {
  ami           = "ami-0303e2e4a29f041a3"
  instance_type = "t3.micro"

  subnet_id              = "subnet-04850d54d813e20cf"
  vpc_security_group_ids = [aws_security_group.app.id]

  key_name             = "devops-lab-key"
  iam_instance_profile = aws_iam_instance_profile.ec2.name

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
    encrypted             = false
    delete_on_termination = true
  }

  tags = {
    Name = "devops-lab-01"
  }
}