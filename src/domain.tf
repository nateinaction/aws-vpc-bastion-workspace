resource "cloudflare_record" "bastion_ipv4" {
  count = var.number_of_instances

  zone_id = var.cloudflare_zone_id
  name    = "bastion"
  #name    = "bastion-${count.index}"
  value = aws_instance.bastion_server[count.index].public_ip
  type  = "A"
}

resource "cloudflare_record" "bastion_ipv6" {
  count = var.number_of_instances

  zone_id = var.cloudflare_zone_id
  name    = "bastion"
  #name    = "bastion-${count.index}"
  value = aws_instance.bastion_server[count.index].ipv6_addresses[0]
  type  = "AAAA"
}

resource "cloudflare_record" "execution_ipv4" {
  count = var.number_of_instances

  zone_id = var.cloudflare_zone_id
  name    = "workspace"
  #name    = "workspace-${count.index}"
  value = aws_instance.execution_server[count.index].private_ip
  type  = "A"
}

resource "cloudflare_record" "execution_ipv6" {
  count = var.number_of_instances

  zone_id = var.cloudflare_zone_id
  name    = "workspace"
  #name    = "workspace-${count.index}"
  value = aws_instance.execution_server[count.index].ipv6_addresses[0]
  type  = "AAAA"
}
