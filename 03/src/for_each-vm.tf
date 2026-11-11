resource "yandex_compute_instance" "db" {
  for_each    = { for vm in var.each_vm : vm.vm_name => vm }
  name        = each.value.vm_name
  platform_id = "standard-v2"
  zone        = "ru-central1-d"

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd84np9sg3hrgaoisfnj" 
      size     = each.value.disk_volume
      type     = "network-hdd"
    }
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_d.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.public_ssh_key}"
  }
}