resource "azurerm_resource_group" "network" {
  name     = "staging"
  location = "France Central"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "network" {
  name                = "staging-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.network.location}"
  resource_group_name = "${azurerm_resource_group.network.name}"

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
  }

  subnet {
    name           = "subnet3"
    address_prefix = "10.0.3.0/24"
  }
}

data "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  resource_group_name  = "${azurerm_resource_group.network.name}"
}

resource "azurerm_network_interface" "OracleLinuxNI" {
  name                = "OracleLinuxNI"
  location            = "${azurerm_resource_group.network.location}"
  resource_group_name = "${azurerm_resource_group.network.name}"

  ip_configuration {
    name                          = "OracleLinuxNI"
    subnet_id                     = "${data.azurerm_subnet.subnet1.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.OracleLinuxPublicIp.id}"
  }
}

resource "azurerm_network_security_group" "OracleLinuxSecurityGroup" {
  name                = "OracleLinuxSecurityGroup"
  location            = "${azurerm_resource_group.network.location}"
  resource_group_name = "${azurerm_resource_group.network.name}"

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Staging"
  }
}

resource "azurerm_public_ip" "OracleLinuxPublicIp" {
  name                         = "OracleLinuxPublicIp"
  location                     = "${azurerm_resource_group.network.location}"
  resource_group_name          = "${azurerm_resource_group.network.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "staging"
  }
}
