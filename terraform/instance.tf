# resource "azurerm_managed_disk" "OracleLinuxVirtualDisk" {
#   name                 = "datadisk_existing"
#   location             = "${azurerm_resource_group.network.location}"
#   resource_group_name  = "${azurerm_resource_group.network.name}"
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = "1023"
# }

resource "azurerm_virtual_machine" "OracleLinuxVM" {
  name                  = "acctvm"
  location              = "${azurerm_resource_group.network.location}"
  resource_group_name   = "${azurerm_resource_group.network.name}"
  network_interface_ids = ["${azurerm_network_interface.OracleLinuxNI.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Oracle"
    offer     = "Oracle-Linux"
    sku       = "7.4"
    version   = "latest"
  }

  os_profile {
    computer_name  = "oracle74"
    admin_username = "oracle"
    admin_password = "${var.password}"
  }

  storage_os_disk {
    name              = "OracleLinuxDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile_linux_config {
    ssh_keys = {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFiDLWSBFRww+0xt8lURUxVtTgZCFoj5zctK7GJ6zqNBQ6Yd5d1JDoGf6o6qC+tmwAobMSU8kPT+1JJRQV4uOrZTLnGhbeRlcydaf9GMzKYHdTSpBYf1+cQJ+wgz6AU9hZQYgbVTlOX/1bdrZlgOuOz5BETXeOmd4P9ZQuRexyiSGSQKq76ydde49T0dhlB/g2DfEU0UbogH/QTQQ7I5QoJ4Myg5twHR0dGpx/DG1ZeuvG+XVTC7GK7EMIwXmmnL1/8S74ir+6BwlfiGWJDUhqwwF34+vJYjOErLt1NIAKigYpXhtf8Nd7bROYa4sGSxKGAMMJ6HkFEU0P3SUjkHt3 pink"
      path     = "/home/oracle/.ssh/authorized_keys"
    }

    disable_password_authentication = false
  }

  delete_data_disks_on_termination = true
}
