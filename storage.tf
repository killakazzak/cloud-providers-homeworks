# Создание Service Account для Object Storage
resource "yandex_iam_service_account" "sa-tenda-storage" {
  name = "sa-tenda-storage"
}

# Назначение роли storage.editor
resource "yandex_resourcemanager_folder_iam_member" "bucket-editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-tenda-storage.id}"
}

# Создание статических ключей доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-tenda-storage.id
}

# Создание бакета
resource "yandex_storage_bucket" "tenda-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "tenda2025"
  acl        = "public-read"
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
