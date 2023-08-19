data "aws_subnets" "nametags" {
  filter {
    name   = "tag:Name"
    values = var.dbsubnet_groups
  }
  depends_on = [aws_subnet.subnets]
}


resource "aws_db_subnet_group" "dbsubgroup" {
  name       = "dbsubnetgrp"
  subnet_ids = data.aws_subnets.nametags.ids
  tags = {
    Name = "dbsubnetgrp"
  }

  depends_on = [aws_subnet.subnets, data.aws_subnets.nametags]


}

resource "aws_db_instance" "dbinst" {
  allocated_storage      = 20
  db_name                = "emp"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "ysp"
  password               = "yspqt12345"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.dbsubgroup.name
  identifier             = "thisismydbfromtf"
  vpc_security_group_ids = [aws_security_group.db.id]
}