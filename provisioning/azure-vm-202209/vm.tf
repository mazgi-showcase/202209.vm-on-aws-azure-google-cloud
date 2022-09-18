resource "azurerm_public_ip" "vm-1" {
  name                = "${var.project_unique_id}-vm-1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "vm-1" {
  name                = "vm-1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_configuration {
    name                          = "default"
    subnet_id                     = azurerm_subnet.vms.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-1.id
  }
}

resource "azurerm_linux_virtual_machine" "vm-1" {
  name                = "${var.project_unique_id}-vm-1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = "Standard_B1s"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.vm-1.id,
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # You can list Ubuntu images by the following command.
  # az vm image list --all --architecture=x64 --offer=Ubuntu --publisher=Canonical --sku=22_04-lts --output=table
  # See also:
  #   - https://learn.microsoft.com/en-us/cli/azure/vm/image#az-vm-image-list
  source_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
