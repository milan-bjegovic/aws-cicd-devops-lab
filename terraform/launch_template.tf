resource "aws_launch_template" "app" {
  name_prefix   = "devops-lab-"
  image_id      = "ami-0303e2e4a29f041a3"
  instance_type = "t3.micro"

  key_name = "devops-lab-key"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  user_data = base64encode(file("${path.module}/user_data.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "devops-lab-asg"
      ManagedBy = "Terraform"
    }
  }

  tags = {
    Name      = "devops-lab-launch-template"
    ManagedBy = "Terraform"
  }
}
