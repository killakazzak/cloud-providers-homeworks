# resource "yandex_compute_instance" "nat-instance" {
#   name     = "nat-instance"
#   hostname = "nat-instance"
#   zone     = var.yc_zone

#   resources {
#     cores  = 2
#     memory = 2
#   }

#   boot_disk {
#     initialize_params {
#       image_id = "fd80mrhj8fl2oe87o4e1"
#     }
#   }

#   network_interface {
#     subnet_id  = yandex_vpc_subnet.public.id
#     ip_address = "192.168.10.254"
#     nat        = true
#   }

#   metadata = {
#     ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
#   }
# }

# resource "yandex_compute_instance" "public-instance" {
#   name     = "public-instance"
#   hostname = "public-instance"
#   zone     = var.yc_zone

#   resources {
#     cores  = 2
#     memory = 2
#   }

#   boot_disk {
#     initialize_params {
#       image_id = "fd85b6k7esmsatsjb6fr"
#     }
#   }

#   network_interface {
#     subnet_id = yandex_vpc_subnet.public.id
#     nat       = true
#   }

#   metadata = {
#     ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
#   }
# }

# resource "yandex_compute_instance" "private-instance" {
#   name     = "private-instance"
#   hostname = "private-instance"
#   zone     = var.yc_zone

#   resources {
#     cores  = 2
#     memory = 2
#   }

#   boot_disk {
#     initialize_params {
#       image_id = "fd85b6k7esmsatsjb6fr"
#     }
#   }

#   network_interface {
#     subnet_id = yandex_vpc_subnet.private.id
#   }

#   metadata = {
#     ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
#   }
# }
