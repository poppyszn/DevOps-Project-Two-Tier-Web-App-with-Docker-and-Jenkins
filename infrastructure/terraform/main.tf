resource "aws_security_group" "app_server" {
  name        = "${var.project}-${var.environment}-sg"
  description = "Security group for the Flask app server"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "Flask app"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your IP in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-sg"
  }
}

resource "aws_key_pair" "app_server" {
  key_name   = "${var.project}-${var.environment}-server-key"
  public_key = file(var.public_key_path)
}

module "app_server" {
  source = "./modules/ec2"

  instance_name      = "${var.project}-${var.environment}-server"
  ami_id             = var.app_server_ami_id
  instance_type      = "t3.micro"
  key_name           = aws_key_pair.app_server.key_name
  subnet_id          = data.aws_subnets.default.ids[0]
  security_group_ids = [aws_security_group.app_server.id]
  user_data          = base64encode(file("${path.module}/scripts/init_script.sh"))
}