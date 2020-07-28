resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.appname}-shared"
  location = var.location
  tags     = var.tags
}

resource "azurerm_container_registry" "acr" {
  name                     = var.appshort
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Premium"
  admin_enabled            = true  
  tags     = var.tags
}

data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "keyvault" {
  name                = "kv-${var.appname}-shared"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"
  enabled_for_deployment = true
  enabled_for_template_deployment = true

  tags     = var.tags
}

resource "azurerm_key_vault_access_policy" "keyvault_default_policy" {
  key_vault_id = azurerm_key_vault.keyvault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
      "create",
      "get",
  ]

  secret_permissions = [
      "set",
      "get",
      "delete",
  ]
}

resource "azurerm_key_vault_access_policy" "keyvault_default_developer" {
  key_vault_id = azurerm_key_vault.keyvault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = var.devgroupid

  key_permissions = [
      "create",
      "get",
      "list"
  ]

  secret_permissions = [
      "set",
      "get",
      "delete",
      "list"
  ]
}

resource "azurerm_key_vault_secret" "keyvault_acruser" {
  name         = "ACRUSER"
  value        = azurerm_container_registry.acr.admin_username
  key_vault_id = azurerm_key_vault.keyvault.id

  depends_on = [
    azurerm_key_vault_access_policy.keyvault_default_policy
  ]

  tags     = var.tags
}

resource "azurerm_key_vault_secret" "keyvault_acrpassword" {
  name         = "ACRPASSWORD"
  value        = azurerm_container_registry.acr.admin_password
  key_vault_id = azurerm_key_vault.keyvault.id

  depends_on = [
    azurerm_key_vault_access_policy.keyvault_default_policy
  ]

  tags     = var.tags
}


resource "azurerm_storage_account" "storage1" {
 name                   = "st${var.appshort}001"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name

  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  tags = {
    environment = "staging"
  }
}


resource "azurerm_key_vault_secret" "keyvault_storage1_connectionstring" {
  name         = "STORAGEACCOUNTCONNECTIONSTRING"
  value        = azurerm_storage_account.storage1.primary_connection_string
  key_vault_id = azurerm_key_vault.keyvault.id

  depends_on = [
    azurerm_key_vault_access_policy.keyvault_default_policy,
    azurerm_storage_account.storage1
  ]

  tags     = var.tags
}
