output "EC2PublicIP" {
  value = aws_instance.DBInstance.public_ip
}

output "RDSEndPoint" {
  value = aws_db_instance.MYSQL-RDS-INSTANCE.endpoint
}

output "RDSPort" {
  value = aws_db_instance.MYSQL-RDS-INSTANCE.port
}

