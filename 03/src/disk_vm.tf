# 1. Создаем 3 одинаковых диска по 1 ГБ
resource "yandex_compute_disk" "data_disks" {
  count = 3
  name  = "data-disk-${count.index + 1}"
  type  = "network-hdd"
  zone  = "ru-central1-a" # Создаем в зоне А, чтобы наверняка хватило квоты
  size  = 1
}

# 2. Создаем ВМ storage и подключаем диски
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd84np9sg3hrgaoisfnj"
      type     = "network-hdd" # Используем HDD, чтобы не тратить SSD квоту
    }
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_a.id # Подсеть из зоны А
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.public_ssh_key}"
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.data_disks
    content {
      disk_id = secondary_disk.value.id
    }
  }
}