## ALB Target Group с динамическим добавлением инстансов из Instance Group
#resource "yandex_alb_target_group" "alb-tg" {
#  name = "alb-target-group"
#
#  dynamic "target" {
#    for_each = yandex_compute_instance_group.ig-1.instances
#    content {
#      subnet_id  = yandex_vpc_subnet.public.id
#      ip_address = target.value.network_interface[0].ip_address
#    }
#  }
#
#  depends_on = [yandex_compute_instance_group.ig-1]
#}
#
## HTTP Router для маршрутизации запросов
#resource "yandex_alb_http_router" "tenda-router" {
#  name = "tenda-http-router"
#}
#
## Backend Group с проверкой состояния
#resource "yandex_alb_backend_group" "tenda-backend-group" {
#  name = "tenda-backend-group"
#
#  http_backend {
#    name             = "backend-http"
#    weight           = 1
#    port             = 80
#    target_group_ids = [yandex_alb_target_group.alb-tg.id]
#    
#    healthcheck {
#      timeout  = "10s"
#      interval = "2s"
#      http_healthcheck {
#        path = "/"
#      }
#    }
#  }
#}
#
## Virtual Host для обработки запросов
#resource "yandex_alb_virtual_host" "tenda-virtual-host" {
#  name           = "tenda-virtual-host"
#  http_router_id = yandex_alb_http_router.tenda-router.id
#  
#  route {
#    name = "route"
#    http_route {
#      http_route_action {
#        backend_group_id = yandex_alb_backend_group.tenda-backend-group.id
#        timeout          = "3s"
#      }
#    }
#  }
#}
#
## Application Load Balancer
#resource "yandex_alb_load_balancer" "tenda-alb" {
#  name        = "tenda-alb"
#  network_id  = yandex_vpc_network.network-netology.id
#
#  allocation_policy {
#    location {
#      zone_id   = var.yc_zone
#      subnet_id = yandex_vpc_subnet.public.id
#    }
#  }
#
#  listener {
#    name = "alb-listener"
#    endpoint {
#      address {
#        external_ipv4_address {}
#      }
#      ports = [80]
#    }
#    http {
#      handler {
#        http_router_id = yandex_alb_http_router.tenda-router.id
#      }
#    }
#  }
#
#  depends_on = [
#    yandex_alb_virtual_host.tenda-virtual-host
#  ]
#}
