resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

# Подсеть для зоны A (веб-серверы)
resource "yandex_vpc_subnet" "develop_a" {
  name           = "${var.vpc_name}-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

# Подсеть для зоны D (базы данных)
resource "yandex_vpc_subnet" "develop_d" {
  name           = "${var.vpc_name}-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}