resource "aws_key_pair" "idrsa" {
  key_name   = "wrkshop"
  public_key = file(var.myidrsa)
  tags = {
    Createdby = "terraform"
  }

}
data "aws_subnet" "app" {
  filter {
    name   = "tag:Name"
    values = [var.appsubname]
  }

  depends_on = [
    aws_subnet.subnets
  ]

}
resource "aws_instance" "appserver" {
  ami                         = var.ubuntu_ami_id
  associate_public_ip_address = true
  instance_type               = var.app_ec2_size
  key_name                    = aws_key_pair.idrsa.key_name
  vpc_security_group_ids      = [aws_security_group.app.id]
  subnet_id                   = data.aws_subnet.app.id
  tags = {
    Name = "appserver"
  }

  depends_on = [
    aws_subnet.subnets
  ]
}