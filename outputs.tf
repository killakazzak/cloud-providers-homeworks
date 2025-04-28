# output "external_ip_address_public" {
#   value = yandex_compute_instance.public-instance.network_interface.0.nat_ip_address
# }

# output "external_ip_address_nat" {
#   value = yandex_compute_instance.nat-instance.network_interface.0.nat_ip_address
# }

# output "internal_ip_address_private" {
#   value = yandex_compute_instance.private-instance.network_interface.0.ip_address
# }

output "bucket_domain_name" {
  description = "Полный URL изображения в Object Storage"
  value = "http://${yandex_storage_bucket.tenda-bucket.bucket_domain_name}/picture.jpg"
}

output "external_load_balancer_ip" {
  description = "Публичный URL Network Load Balancer"
  value = yandex_lb_network_load_balancer.load-balancer-tenda.listener.*.external_address_spec[0].*.address[0]
}

output "application_lb_url" {
  description = "Публичный URL Application Load Balancer"
  value       = "http://${tolist(yandex_alb_load_balancer.tenda-alb.listener)[0].endpoint[0].address[0].external_ipv4_address[0].address}"
}
