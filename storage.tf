# Создание Service Account для Object Storage
resource "yandex_iam_service_account" "sa-tenda-storage" {
  name = "sa-tenda-storage"
}

# Назначение роли storage.editor
resource "yandex_resourcemanager_folder_iam_member" "storage-editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-tenda-storage.id}"
}

# Назначение роли admin
resource "yandex_resourcemanager_folder_iam_member" "admin" {
  folder_id = var.yc_folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-tenda-storage.id}"
}

# Создание статических ключей доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-tenda-storage.id
}

# Загрузка изображения в бакет
resource "yandex_storage_object" "bucket-image" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.tenda-bucket.bucket
  key        = "picture.jpg"
  source     = "picture.jpg"
  acl        = "public-read"
}

# Создание KMS-ключа
resource "yandex_kms_symmetric_key" "tenda-kms-key" {
  name              = "tenda-kms-key"
  default_algorithm = "AES_256"
}

# Права на использование ключа KMS
resource "yandex_kms_symmetric_key_iam_binding" "kms-encryptor" {
  symmetric_key_id = yandex_kms_symmetric_key.tenda-kms-key.id
  role             = "kms.keys.encrypterDecrypter"
  members          = [
    "serviceAccount:${yandex_iam_service_account.sa-tenda-storage.id}",
  ]
}

# Модифицированный бакет с шифрованием
resource "yandex_storage_bucket" "tenda-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "tenda-netology-bucket"
  acl        = "public-read"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = yandex_kms_symmetric_key.tenda-kms-key.id
      }
    }
  }
}
