resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "web-${count.index + 1}" 
  platform_id = "standard-v2"
  zone        = "ru-central1-a"
  depends_on  = [yandex_compute_instance.db] 

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd84np9sg3hrgaoisfnj"
      type     = "network-ssd"
    }
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.public_ssh_key}"
  }
}