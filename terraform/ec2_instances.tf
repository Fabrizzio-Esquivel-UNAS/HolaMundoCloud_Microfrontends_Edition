# Create an ECS cluster using EC2
resource "aws_ecs_cluster" "node_app_cluster" {
  name = "HolaMundoCloud-cluster"
}

# IAM role for the ECS task execution
resource "aws_iam_role" "ecs_role" {
  name = "ecs_role_HolaMundoCloud"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS instance profile
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile_HolaMundoCloud"
  role = aws_iam_role.ecs_instance_role.name
}

# IAM role for ECS EC2 instances
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name               = "ecsInstanceRole_HolaMundoCloud"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

### ecs_instance_1
resource "aws_instance" "ecs_instance_1" {
  ami                    = "ami-0e593d2b811299b15" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  key_name               = var.aws_key_name
  iam_instance_profile   = aws_iam_instance_profile.ecs_instance_profile.name
  security_groups        = [aws_security_group.ecs_sg.id]
  subnet_id              = aws_subnet.public_a.id
  associate_public_ip_address = true
  tags = {
    Name = "ecs_instance_1"
  }
  
  user_data = base64encode(<<-EOF
                #!/bin/bash
                # Update the instance
                sudo yum update -y

                # Install Docker
                sudo amazon-linux-extras install docker -y
                sudo service docker start
                sudo usermod -a -G docker ec2-user

                # Install Git
                sudo yum install -y git

                # Install Docker Compose
                sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                sudo chmod +x /usr/local/bin/docker-compose
                sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
                EOF
  )
}

# Outputs for EC2 public IPs
output "instance_1_public_ip" {
  value = aws_instance.ecs_instance_1.public_ip
}