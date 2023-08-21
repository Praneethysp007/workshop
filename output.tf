output "nop_url" {
  value = format("%s ansible_user=ubuntu", aws_instance.appserver.private_ip)
}