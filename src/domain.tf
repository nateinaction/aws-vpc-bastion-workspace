resource "cloudflare_record" "bastion" {
  count = var.number_of_instances

  zone_id = var.cloudflare_zone_id
  name    = "bastion"
  #name    = "bastion${count.index}"
  value   = aws_instance.bastion_server[count.index].public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "execution" {
  count = var.number_of_instances

  zone_id = var.cloudflare_zone_id
  name    = "workspace"
  #name    = "workspace${count.index}"
  value = aws_instance.execution_server[count.index].private_ip
  type  = "A"
}
