resource "azurerm_automation_account" "simpleAutomationAccount" {
  name                = "simpleAutomationAccount"
  location            = "${azurerm_resource_group.network.location}"
  resource_group_name = "${azurerm_resource_group.network.name}"

  sku {
    name = "Basic"
  }

  tags {
    environment = "staging"
  }
}

resource "azurerm_automation_credential" "simpleCredential" {
  name                = "simpleCredential"
  resource_group_name = "${azurerm_resource_group.network.name}"
  account_name        = "${azurerm_automation_account.simpleAutomationAccount.name}"
  username            = "oracle"
  password            = "${var.password}"
}

resource "azurerm_automation_runbook" "simpleRunbook" {
  name                = "Pull-PluggableDatabase"
  location            = "${azurerm_resource_group.network.location}"
  resource_group_name = "${azurerm_resource_group.network.name}"
  account_name        = "${azurerm_automation_account.simpleAutomationAccount.name}"
  log_verbose         = "true"
  log_progress        = "true"
  description         = "This is an example runbook to provision a Pluggable Database"
  runbook_type        = "Script"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/fbouteruche/oracle-env/feature/automation/terraform/shell.sh"
  }
}
