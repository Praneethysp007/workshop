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
   depends_on = [ aws_vpc.vpc1,aws_subnet.subnets,aws_key_pair.idrsa,aws_internet_gateway.websg_itgw,aws_route.theroute,aws_security_group.app,aws_db_subnet_group.dbsubgroup,aws_db_instance.dbinst ]

  provisioner "local-exec" {

    when = create

    command = "terraform output -raw nop_url > hosts"
    
  }
  provisioner "local-exec" {

    when = create

    command = "ansible-playbook -i hosts nopcommerce.yml"
 
  }

  
}

