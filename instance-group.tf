# Создание Service Account для Object Storage
resource "yandex_iam_service_account" "sa-tenda-ig" {
  name = "sa-tenda-ig"
}

# Назначение основных ролей для работы с Compute, Network и Load Balancer
resource "yandex_resourcemanager_folder_iam_member" "roles" {
  for_each = toset([
    "editor",
    "vpc.user",
    "load-balancer.admin",
    "iam.serviceAccounts.user"
  ])

  folder_id = var.yc_folder_id
  role      = each.key
  member    = "serviceAccount:${yandex_iam_service_account.sa-tenda-ig.id}"
}


# Создание Instance Group
resource "yandex_compute_instance_group" "ig-1" {
  name               = "fixed-ig-with-balancer"
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.sa-tenda-ig.id

  instance_template {
    resources {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }
    boot_disk {
      initialize_params {
        image_id = var.lamp-instance-image-id
      }
    }
    network_interface {
      network_id = yandex_vpc_network.network-netology.id
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = true
    }
    scheduling_policy {
      preemptible = true // Прерываемая
    }
    metadata = {
      ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
      user-data = <<EOF
#!/bin/bash
apt install httpd -y
cd /var/www/html
echo '<html><img src="http://${yandex_storage_bucket.tenda-bucket.bucket_domain_name}/picture.jpg"/></html>' > index.html
service httpd start
EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.yc_zone]
  }

  deploy_policy {
    max_unavailable  = 1
    max_creating     = 3
    max_expansion    = 1
    max_deleting     = 1
    startup_duration = 3
  }

  health_check {
    http_options {
      port = 80
      path = "/"
    }
  }

  # depends_on = [
  #   yandex_storage_bucket.tenda-bucket,
  #   yandex_resourcemanager_folder_iam_member.roles
  # ]
  load_balancer {
    target_group_name = "target-group"
  }
}
