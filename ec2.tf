data "aws_key_pair" "gettingkeypair" {
  key_name = "keypair2"
}


resource "aws_instance" "DBInstance" {
  ami                         = "ami-02396cdd13e9a1257"
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  availability_zone           = "us-east-1a"
  subnet_id                   = aws_subnet.PublicSubnet.id
  security_groups             = [aws_security_group.EC2SG.id]
  key_name                    = data.aws_key_pair.gettingkeypair.key_name
  user_data = "${file("ec2.sh")}"


  depends_on = [
    aws_security_group.EC2SG, data.aws_key_pair.gettingkeypair
  ]
}

resource "aws_security_group" "EC2SG" {
  name   = "EC2SG"
  vpc_id = aws_vpc.DB-VPC.id
  ingress {
    description = "SSH from World"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "RDSSG" {
  vpc_id = aws_vpc.DB-VPC.id
  ingress {
    description     = "From EC2 Port"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.EC2SG.id]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}