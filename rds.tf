resource "aws_db_instance" "MYSQL-RDS-INSTANCE" {
  allocated_storage    = 20
  db_name              = "MyRDSDB1"
  engine               = "mysql"
  engine_version       = "8.0.32"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "admin1234"
  db_subnet_group_name = aws_db_subnet_group.MYSQL-RDS-INSTANCE-SUBGRP.name


  vpc_security_group_ids = [aws_security_group.RDSSG.id]

  final_snapshot_identifier = "false"

  depends_on = [
    aws_db_subnet_group.MYSQL-RDS-INSTANCE-SUBGRP
  ]
}

resource "aws_db_subnet_group" "MYSQL-RDS-INSTANCE-SUBGRP" {
  name       = "mysql-rds-instance-subgrp"
  subnet_ids = [aws_subnet.PrivateSubnet.id, aws_subnet.PrivateSubnet2.id]

}