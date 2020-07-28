provider "azurerm" { 
  version = "=2.20.0"
  features {}
}


module "app-shared" {
  source = "./.."

  appname = "tb-example1"
  appshort = "tbexample1"
}

